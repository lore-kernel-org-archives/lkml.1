Return-Path: <linux-kernel-owner+w=401wt.eu-S937223AbXFGVp5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937223AbXFGVp5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 17:45:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764304AbXFGVpt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 17:45:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50515 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764544AbXFGVps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 17:45:48 -0400
Date: Thu, 7 Jun 2007 14:45:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Doug Thompson <norsk5@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 16/36] drivers edac mod move mc to use workq
Message-Id: <20070607144540.59baa9ef.akpm@linux-foundation.org>
In-Reply-To: <346998.83220.qm@web50104.mail.re2.yahoo.com>
References: <346998.83220.qm@web50104.mail.re2.yahoo.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2007 07:41:35 -0700 (PDT)
Doug Thompson <norsk5@yahoo.com> wrote:

> From:	Dave Jiang <djiang@mvista.com>
> 
> Move the memory controller object to work queue based implementation
> from the
> kernel thread based. 
> 
> ...
>
> +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))

Please avoid doing this in the mainline kernel.

It'll diverge anyway.  It is all-round better for people to carry (small)
backport patches outside the kernel.org tree if needed.

> +/*
> + * handler for EDAC to check if NMI type handler has asserted
> interrupt
> + */
> +static int edac_mc_assert_error_check_and_clear(void)
> +{
> +	int vreg;
> +
> +	if(edac_op_state == EDAC_OPSTATE_POLL)
> +		return 1;

To quote Linus "`if' is not a function".  Se we use "if (" (multiple
instances).

> +	vreg = atomic_read(&edac_err_assert);
> +	if(vreg) {
> +		atomic_set(&edac_err_assert, 0);
> +		return 1;
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * edac_mc_workq_function
> + *	performs the operation scheduled by a workq request
> + */
> +#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
> +static void edac_mc_workq_function(struct work_struct *work_req)
> +{
> +	struct delayed_work *d_work = (struct delayed_work*) work_req;
> +	struct mem_ctl_info *mci = to_edac_mem_ctl_work(d_work);
> +#else
> +static void edac_mc_workq_function(void *ptr)
> +{
> +	struct mem_ctl_info *mci = (struct mem_ctl_info *) ptr;

Unneeded (and undesirable) cast.

> +#endif
> +
> +	mutex_lock(&mem_ctls_mutex);
> +
> +	/* Only poll controllers that are running polled and have a check */
> +	if (edac_mc_assert_error_check_and_clear() && (mci->edac_check !=
> NULL))
> +		mci->edac_check(mci);
> +
> +	/*
> +	 * FIXME: temp place holder for PCI checks,
> +	 * goes away when we break out PCI
> +	 */
> +	edac_pci_do_parity_check();
> +
> +	mutex_unlock(&mem_ctls_mutex);
> +
> +	/* Reschedule */
> +	queue_delayed_work(edac_workqueue, &mci->work,
> edac_mc_get_poll_msec());
> +}
> +	}
> +}
> +
> +/*
> + * edac_reset_delay_period
> + */
> +
> +void edac_reset_delay_period(struct mem_ctl_info *mci, unsigned long
> value)
> +{
> +	mutex_lock(&mem_ctls_mutex);
> +
> +	/* cancel the current workq request */
> +	edac_mc_workq_teardown(mci);
> +
> +	/* restart the workq request, with new delay value */
> +	edac_mc_workq_setup(mci, value);
> +
> +	mutex_unlock(&mem_ctls_mutex);
> +}

I suspect this is deadlocky, for the reasons described earlier.

>  /* Return 0 on success, 1 on failure.
>   * Before calling this function, caller must
>   * assign a unique value to mci->mc_idx.
> @@ -351,6 +454,16 @@ int edac_mc_add_mc(struct mem_ctl_info *
>  		goto fail1;
>  	}
>  
> +	/* If there IS a check routine, then we are running POLLED */
> +	if (mci->edac_check != NULL) {
> +		/* This instance is NOW RUNNING */
> +		mci->op_state = OP_RUNNING_POLL;
> +
> +		edac_mc_workq_setup(mci, edac_mc_get_poll_msec());
> +	} else {
> +		mci->op_state = OP_RUNNING_INTERRUPT;
> +	}
> +

