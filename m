Return-Path: <linux-kernel-owner+w=401wt.eu-S1761136AbXGZFVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761136AbXGZFVo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 01:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751319AbXGZFVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 01:21:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51520 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752605AbXGZFVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 01:21:34 -0400
Date: Wed, 25 Jul 2007 22:20:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: dougthompson@xmission.com
Cc: greg@kroah.com, ralf@linux-mips.org, egor@pasemi.com,
       alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] drivers edac fix reset edac_mc pollmsec
Message-Id: <20070725222019.a8e3cc00.akpm@linux-foundation.org>
In-Reply-To: <46a7b87d.9iKovb4wybPFkLX6%dougthompson@xmission.com>
References: <46a7b87d.9iKovb4wybPFkLX6%dougthompson@xmission.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jul 2007 14:54:21 -0600 dougthompson@xmission.com wrote:

> +void edac_mc_reset_delay_period(int value)
>  {
> -	/* cancel the current workq request */
> -	edac_mc_workq_teardown(mci);
> +	struct mem_ctl_info *mci;
> +	struct list_head *item;
> +
> +	mutex_lock(&mem_ctls_mutex);
> +
> +	/* scan the list and turn off all workq timers, doing so under lock
> +	 */
> +	list_for_each(item, &mc_devices) {
> +		mci = list_entry(item, struct mem_ctl_info, link);
> +
> +		if (mci->op_state == OP_RUNNING_POLL)
> +			cancel_delayed_work(&mci->work);
> +	}
> +
> +	mutex_unlock(&mem_ctls_mutex);

cancel_delayed_work() on its own looks a bit racy.  The work could
presently be running on another CPU.

So generally we'll run flush_workqueue() or cancel_work_sync() after the
cancel_delayed_work() to make sure that it has really gone away.

Beware however that you're holding a lock here.  If any of the work
functions which can be at mci->work also take mem_ctls_mutex then it is
deadlocky to run flush_workqueue() or cancel_work_sync() while holding that
lock.

