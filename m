Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbZKKUSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbZKKUSj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 15:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757358AbZKKUSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 15:18:38 -0500
Received: from senator.holtmann.net ([87.106.208.187]:50167 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757315AbZKKUSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 15:18:37 -0500
Subject: Re: GPF in run_workqueue()/list_del_init(cwq->worklist.next) on
 resume (was: Re: Help needed: Resume problems in 2.6.32-rc, perhaps related
 to preempt_count leakage in keventd)
From: Marcel Holtmann <marcel@holtmann.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Thomas Gleixner <tglx@linutronix.de>,
       Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>, Greg KH <gregkh@suse.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Oliver Neukum <oliver@neukum.org>,
       linux-bluetooth@vger.kernel.org
In-Reply-To: <alpine.LFD.2.01.0911111142340.31845@localhost.localdomain>
References: <200911091250.31626.rjw@sisk.pl>
	 <200911100119.38019.rjw@sisk.pl>
	 <alpine.LFD.2.01.0911101343590.31845@localhost.localdomain>
	 <200911111252.48214.rjw@sisk.pl>
	 <alpine.LFD.2.01.0911111142340.31845@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Nov 2009 21:18:39 +0100
Message-ID: <1257970719.21467.4.camel@violet>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

> > I thought that the problem was somehow related to user space, because it only
> > happens after we've thawed tasks.  At least, all of the call traces I was able
> > to collect indicated so.
> > 
> > Moreover, in a few cases I got
> > 
> > kernel: PM: Finishing wakeup.
> > kernel: Restarting tasks ...
> > kernel: usb 5-2: USB disconnect, address 2
> > kernel: done.
> > bluetoothd[3445]: HCI dev 0 unregistered
> > bluetoothd[3445]: Unregister path: /org/bluez/3445/hci0
> > bluetoothd[3445]: Unregistered interface org.bluez.NetworkPeer on path /org/bluez/3445/hci0
> > bluetoothd[3445]: Unregistered interface org.bluez.NetworkHub on path /org/bluez/3445/hci0
> > bluetoothd[3445]: Unregistered interface org.bluez.NetworkRouter on path /org/bluez/3445/hci0
> > kernel: Slab corruption: size-512 start=ffff88007f1182b0, len=512
> > 
> > and so on (of course, the bluetoothd PID was different each time), so I thought
> > that the problem might be related to Bluetooth.
> 
> Hmm. Sounds reasonable. It's still that 'size-512', but if the sound 
> subsystem and the bluetooth code both happen to use that size, that would 
> explain why there was sound data in the slab.
> 
> > So, I've disabled the Bluetooth subsystem in the kernel config and I'm not able
> > to reproduce the problem any more (at least not within 50 consecutive
> > suspend-resume and hibernate-resume cycles).  Thus Bluetooth seems to be
> > at least necessary to reproduce the issue and perhaps it's also the cause of
> > it.
> 
> Which BT driver are you using? Maybe it's specific to the low-level 
> driver?
> 
> For example, I could imagine that (say) a USB bluetooth dongle (I think 
> they are common for for mice, and are sometimes built-in on the 
> motherboard) could get the USB "disconnect" event, and get freed while 
> some work from the resume is still pending.
> 
> I'm looking at btusb_disconnect(), for example. It's one of the few BT 
> drivers that seem to use workqueues, and I'm not seeing a 
> cancel_work_sync() in the disconnect routine - but maybe the btusb_close() 
> routine is called indirectly some way that I just don't see.

so the btusb_close() should be called before btusb_destruct() and the
destruct() callback is only when the last reference count gets dropped
and we do have to free the memory. So it seems we are doing something
wrong in btusb_close(). The close() callback is triggered via
hci_unregister_dev() from btusb_disconnect().

As it seems the btusb_close() only cancels the work workqueue and not
the waker workqueue. Could that be the problem.

Oliver, what do you think?

Regards

Marcel


