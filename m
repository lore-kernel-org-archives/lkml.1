Return-Path: <linux-kernel-owner+w=401wt.eu-S1759356AbYDAV7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759356AbYDAV7R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 17:59:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbYDAV7D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 17:59:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59752 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753079AbYDAV7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 17:59:01 -0400
Date: Tue, 1 Apr 2008 14:57:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: linux-kernel@vger.kernel.org, dwmw2@infradead.org, davej@redhat.com,
       sam@ravnborg.org, greg@kroah.com, randy.dunlap@oracle.com
Subject: Re: [PATCH 1/7] LinuxPPS core support.
Message-Id: <20080401145714.6c3c86e5.akpm@linux-foundation.org>
In-Reply-To: <20080401214522.GL7279@enneenne.com>
References: <12048053463198-git-send-email-giometti@linux.it>
	<12048053473401-git-send-email-giometti@linux.it>
	<20080320130356.69ab65fe.akpm@linux-foundation.org>
	<20080325144400.GG8959@enneenne.com>
	<20080327202531.a924e5d9.akpm@linux-foundation.org>
	<20080401084214.GY7279@enneenne.com>
	<20080401015555.f267d970.akpm@linux-foundation.org>
	<20080401214522.GL7279@enneenne.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Apr 2008 23:45:22 +0200
Rodolfo Giometti <giometti@enneenne.com> wrote:

> On Tue, Apr 01, 2008 at 01:55:55AM -0700, Andrew Morton wrote:
> > 
> > This can all be handled with suitable locking and refcounting.  The device
> > which is delivering PPS interrupts has a reference on the PPS data
> > structures.  If userspace has PPS open then it also has a reference.
> > 
> > The thread of control which releases the last reference to the PPS data
> > structures also frees them all up.  This may require a schedule_work() if
> > we need to support release-from-interrupt (as it appears that we do), but
> > that's OK - we just need to be able to make the PPS data structures
> > ineligible for new lookups while the schedule_work() is pending.
> > 
> > There should be no need for any thread of control to wait for any other thread
> > of control to do anything.  Get the refcounting right and everything
> > can be done synchronously.
> 
> Here my solution by using get/put functions:

That's looking promising.

> diff --git a/drivers/pps/kapi.c b/drivers/pps/kapi.c
> index d75c8c8..61c1569 100644
> --- a/drivers/pps/kapi.c
> +++ b/drivers/pps/kapi.c
> @@ -59,6 +59,62 @@ static void pps_add_offset(struct pps_ktime *ts, struct pps_ktime *offset)
>   * Exported functions
>   */
>  
> +/* pps_get_source - find a PPS source
> + *
> + * 	source: the PPS source ID.
> + *
> + * This function is used to find an already registered PPS source into the
> + * system.
> + *
> + * The function returns NULL if found nothing, otherwise it returns a pointer
> + * to the PPS source data struct (the refcounter is incremented by 1).
> + */
> +
> +struct pps_device *pps_get_source(int source)
> +{
> +	struct pps_device *pps;
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&pps_idr_lock, flags);
> +
> +	pps = idr_find(&pps_idr, source);
> +	if (pps != NULL)
> +		atomic_inc(&pps->usage);
> +
> +	spin_unlock_irqrestore(&pps_idr_lock, flags);
> +
> +	return pps;
> +}
> +
> +/* pps_put_source - free the PPS source data
> + *
> + *	pps: a pointer to the PPS source.
> + *
> + * This function is used to free a PPS data struct if its refcount is 0.
> + */
> +
> +void pps_put_source(struct pps_device *pps)
> +{
> +	unsigned long flags;
> +
> +	spin_lock_irqsave(&pps_idr_lock, flags);
> +
> +        BUG_ON(atomic_read(&pps->usage) == 0);

Please don't forget to use checkpatch.

> +	if (!atomic_dec_and_test(&pps->usage))
> +		goto exit;
> +
> +	/* No more reference to the PPS source. We can safely remove the
> +	 * PPS data struct.
> +	 */
> +	idr_remove(&pps_idr, pps->id);
> +
> +	kfree(pps);
> +
> +exit:
> +	spin_unlock_irqrestore(&pps_idr_lock, flags);
> +}

It'd be slightly moer efficient to move the kfree outside the spinlock:

	if (!atomic_dec_and_test(&pps->usage)) {
		pps = NULL;
		goto exit;
	}

	/* No more reference to the PPS source. We can safely remove the
	 * PPS data struct.
	 */
	idr_remove(&pps_idr, pps->id);
exit:
	spin_unlock_irqrestore(&pps_idr_lock, flags);
	kfree(pps);
}


