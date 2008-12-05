Return-Path: <linux-kernel-owner+w=401wt.eu-S1757897AbYLEX22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757897AbYLEX22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 18:28:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757450AbYLEX2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 18:28:07 -0500
Received: from fmmailgate02.web.de ([217.72.192.227]:36282 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757282AbYLEX2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 18:28:04 -0500
From: Christian Lamparter <chunkeey@web.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] p54usb: fix usb_kill_urb hang with slub_debug=P
Date: Sat, 6 Dec 2008 00:28:01 +0100
User-Agent: KMail/1.10.0 (Linux/2.6.28-rc6-wl; KDE/4.1.0; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, linux-wireless@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>,
       John W Linville <linville@tuxdriver.com>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
References: <200812051547.45790.chunkeey@web.de> <20081205155356.GC28030@suse.de> <4939B6AF.2060901@lwfinger.net>
In-Reply-To: <4939B6AF.2060901@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812060028.01715.chunkeey@web.de>
X-Provags-ID: V01U2FsdGVkX18Yko9w1atRHGyb2otpITEdX3ndPHfjv6cHW3jE
	/LImrC3fypsV0IzIU0Fuy/iR9EtIJHjEiAt+cTiinNXOaZxQXj
	F4Di+XStI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 06 December 2008 00:18:07 Larry Finger wrote:
> Greg KH wrote:
> > On Fri, Dec 05, 2008 at 03:47:45PM +0100, Christian Lamparter wrote:
> >> This patch fixes a problem identified by Johannes Berg.
> > 
> > No, it only papers over the real problem here, let's work on a correct
> > patch please.
> 
> I can contribute a little info. If SLUB debugging is enabled, and the boot
> command includes 'slub_debug=P', I get a GPF in kref_get(), which is called from
> kobject_get() with the following code:
> 
>         if (kobj)
>                 kref_get(&kobj->kref);
> 
> From the dump, &kobj->kref is 0x6b6b6b6b6b6b6dbb, a poisoned value.
> 
> Somewhere, the "struct urb" has been freed, but kobj has not been set to NULL.
> 
> As everything I've found is a symptom, I'm still looking for the real cause.
> 
> Larry
> 

This is from a different thread... unfortunately I forgot to add you to the CC.
It looks like rtl8187 is affected as well.

So let's make new patches and drop the "temporary workaround". (see comment)

Regards,
	Chr

----------  Forwarded Message  ----------

Subject: Re: usb_kill_urb hangs with slub_debug=P (Poision) aka usb-slXbdebug-crash-v2
Date: Friday 05 December 2008
From: Alan Stern <stern@rowland.harvard.edu>
To: Christian Lamparter <chunkeey@web.de>

On Fri, 5 Dec 2008, Christian Lamparter wrote:

> > The real problem is that this outline driver accesses skb's in multiple
> > places without any sort of mutual exlusion.  If the driver used
> > spinlocks properly then it wouldn't be possible for usbtest_stop() to
> > try killing an URB that dummy_cb() has just freed.
> >
> yes, yes can you please tell me exactly where?
> 
> as all skb_queue function are taking & releasing spin_lock_irqsave 
> (see net/skbuff.c...) e.g: 
> ###
> void skb_queue_tail(struct sk_buff_head *list, struct sk_buff *newsk)
> {
>         unsigned long flags;
> 
>         spin_lock_irqsave(&list->lock, flags);
>         __skb_queue_tail(list, newsk);
>         spin_unlock_irqrestore(&list->lock, flags);
> }
> [...]
> struct sk_buff *skb_dequeue(struct sk_buff_head *list)
> {
>         unsigned long flags;
>         struct sk_buff *result;
> 
>         spin_lock_irqsave(&list->lock, flags);
>         result = __skb_dequeue(list);
>         spin_unlock_irqrestore(&list->lock, flags);
>         return result;
> }
> ###
> The only exception is __skb_unlink(skb, &rx_queue);
> But this is "dead" code, since in our test case we don't plan to receive anything.
> Of course p54usb uses skb_unlink(skb, &rx_queue) and it freeze too...
> 
> So please please; tell me where the problems are and not that they exists...
> I know that already ;-) 

I have to apologize...  The problem isn't related to lack of spinlocks.

The problem is that usb_kill_urb() and similar routines do not expect
an URB's completion routine to deallocate it.  This is almost obvious 
-- if the URB is deallocated before the completion routine returns then 
there's no way for usb_kill_urb to detect when the URB actually is 
complete.

One solution is always to deallocate URBs in the stop method rather
than in the completion routine.  But your driver doesn't work that way,
so what you need to do is use an anchor.  Anchors were specifically 
designed to support a "fire and forget" approach, which is what you 
want.

Create and initialize a usb_anchor structure, and each time you create
a new URB, call usb_anchor_urb().  Then you can free the URB as soon as
it is submitted; the anchor will keep it pinned until it completes, and
it is automatically removed from the anchor when the completion routine
is called.

See the kerneldoc for usb_anchor_urb and related routines (such as
urb_kill_anchored_urb) in drivers/usb/core/urb.c, and the anchor
declarations in include/linux/usb.h.


This doesn't mean you should forget about using spinlocks.  Let's look
at the source code:

static void dummy_cb(struct urb *urb)
{
	struct sk_buff *skb = (struct sk_buff *) urb->context;
	struct rx_info *info = (struct rx_info *) skb->cb;

	dev_info(&udev->dev, "dummy cb urb:%p skb:%p status:%d\n",
		 urb, skb, urb->status);

	if (unlikely(urb->status)) {
		info->urb = NULL;
		usb_free_urb(urb);
		return;
	}

	__skb_unlink(skb, &rx_queue);
	dev_kfree_skb(skb);
	usb_free_urb(urb);
}

static void usbtest_stop(void)
{
	struct rx_info *info;
	struct sk_buff *skb;

	while ((skb = skb_dequeue(&rx_queue))) {
		info = (struct rx_info *) skb->cb;
		dev_info(&udev->dev, "Free entry urb:%p skb:%p queue_len:%d\n",
			info->urb, skb, skb_queue_len(&rx_queue));

		if (!info->urb)
			continue;

		usb_kill_urb(info->urb);
		kfree_skb(skb);
	}
}

So there's nothing to stop this sort of thing from happening:

	Thread 0			Thread 1
	--------			--------
	Call usbtest_stop()
	info->urb is not NULL
					Call dummy_cb()
					urb->status is nonzero
					info->urb = NULL;
					usb_free_urb(urb);
	usb_kill_urb(info->urb);
	But info->urb has just been set to NULL!

My original point was that two different routines,
dummy_cb() and usbtest_stop(), both accessed info->urb with no
protection.  Of course, if you use anchors then you won't have to worry 
about this scenario.

Alan Stern
