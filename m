Return-Path: <linux-kernel-owner+w=401wt.eu-S1760867AbYFSSXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760867AbYFSSXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 14:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756250AbYFSSX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 14:23:28 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:42158 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbYFSSX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 14:23:27 -0400
Date: Thu, 19 Jun 2008 12:23:10 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       dsd@gentoo.org, mdharm-usb@one-eyed-alien.net,
       linux-usb@vger.kernel.org, vegardno@ifi.uio.no,
       James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
       Greg KH <greg@kroah.com>
Subject: Re: [RFC/PATCH] usb-storage: wait for device scanning before mounting root
Message-ID: <20080619182310.GA30833@parisc-linux.org>
References: <Pine.LNX.4.44L0.0804241704220.14840-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0804250022160.1209@sbz-30.cs.Helsinki.FI> <48118DDD.8010507@s5r6.in-berlin.de> <Pine.LNX.4.64.0804251110400.758@sbz-30.cs.Helsinki.FI> <20080425091122.GA14990@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080425091122.GA14990@parisc-linux.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This discussion seemed to die off ... did anything ever come of it?

On Fri, Apr 25, 2008 at 03:11:23AM -0600, Matthew Wilcox wrote:
> On Fri, Apr 25, 2008 at 11:15:36AM +0300, Pekka J Enberg wrote:
> > On Fri, 25 Apr 2008, Stefan Richter wrote:
> > > Besides, can't you use the generic async scan facility of the SCSI stack for
> > > your purpose?  If not, can it be extended to make it usable?
> > 
> > So you mean drivers/scsi/scsi_scan.c, right? We probably can and 
> > should so I'll take a look.
> 
> The problem is that USB has one scsi_host per device (rather than, say,
> having one scsi_host and adding new devices to it as they're found on
> the USB bus).
> 
> I'm certainly open to ideas of hooking into the mechanism -- it's just a
> list of completions after all.  Something like this:
> 
> void *scsi_insert_into_scan_list(void)
> {
> 	return scsi_prep_async_scan(NULL);
> }
> 
> void scsi_scan_completed(void *cookie)
> {
> 	struct async_scan_data *data = cookie;
> 	wait_for_completion(&data->prev_finished);
> 	spin_lock(&async_scan_lock);
> 	list_del(&data->list);
> 	if (!list_empty(&scanning_hosts)) {
> 		struct async_scan_data *next = list_entry(scanning_hosts.next,
> 				struct async_scan_data, list);
> 		complete(&next->prev_finished);
> 	}
> 	spin_unlock(&async_scan_lock);
> 
> 	kfree(data);
> }
> 
> Perhaps refactor a little -- everything inside the async_scan_lock would
> be common to scsi_scan_completed() and scsi_finish_async_scan().
> 
> with appropriate checks for shost being NULL in scsi_prep_async_scan:
> 
> +++ b/drivers/scsi/scsi_scan.c
> @@ -1698,7 +1698,7 @@ static struct async_scan_data *scsi_prep_async_scan(struct
>         if (strncmp(scsi_scan_type, "sync", 4) == 0)
>                 return NULL;
>  
> -       if (shost->async_scan) {
> +       if (shost && shost->async_scan) {
>                 printk("%s called twice for host %d", __FUNCTION__,
>                                 shost->host_no);
>                 dump_stack();
> @@ -1708,16 +1708,19 @@ static struct async_scan_data *scsi_prep_async_scan(stru
>         data = kmalloc(sizeof(*data), GFP_KERNEL);
>         if (!data)
>                 goto err;
> -       data->shost = scsi_host_get(shost);
> -       if (!data->shost)
> -               goto err;
>         init_completion(&data->prev_finished);
>  
> -       mutex_lock(&shost->scan_mutex);
> -       spin_lock_irqsave(shost->host_lock, flags);
> -       shost->async_scan = 1;
> -       spin_unlock_irqrestore(shost->host_lock, flags);
> -       mutex_unlock(&shost->scan_mutex);
> +       if (shost) {
> +               data->shost = scsi_host_get(shost);
> +               if (!data->shost)
> +                       goto err;
> +
> +               mutex_lock(&shost->scan_mutex);
> +               spin_lock_irqsave(shost->host_lock, flags);
> +               shost->async_scan = 1;
> +               spin_unlock_irqrestore(shost->host_lock, flags);
> +               mutex_unlock(&shost->scan_mutex);
> +       }
>  
>         spin_lock(&async_scan_lock);
>         if (list_empty(&scanning_hosts))
> 
> Would that work for you?
> 
> -- 
> Intel are signing my paycheques ... these opinions are still mine
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
