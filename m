Return-Path: <linux-kernel-owner+w=401wt.eu-S1753548AbZLAPLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548AbZLAPLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 10:11:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753463AbZLAPLc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 10:11:32 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:34360 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753080AbZLAPLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 10:11:32 -0500
Date: Tue, 1 Dec 2009 10:11:36 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Ondrej Zary <linux@rainbow-software.org>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
In-Reply-To: <200912011106.12027.linux@rainbow-software.org>
Message-ID: <Pine.LNX.4.44L0.0912011005140.2983-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Dec 2009, Ondrej Zary wrote:

> On Monday 30 November 2009, Alan Stern wrote:
> > On Mon, 30 Nov 2009, Ondrej Zary wrote:
> > > It does not make much sense to me but I think that it crashes iside this
> > > list manipulation:
> > >
> > >         prev = ehci->async;
> > >         while (prev->qh_next.qh != qh)
> > >                 prev = prev->qh_next.qh;
> >
> > Yes, it's crashing in the "while" test because prev is NULL.  This
> > means the code is looking for qh in the async list but not finding it.
> > That's supposed to be impossible.
> >
> > The assembly code is peculiar because it includes stuff that isn't in
> > the source code!  For example, right at this point (after the end of
> > the loop) there's a test to see whether prev is NULL.  Where could that
> > have come from?  Do you have any idea?
> 
> I'm not sure, I might did something wrong and left it there from my previous
> debugging attempt.

Okay.  But it was part of the reason you had difficulty matching up the 
ehci-hcd.s file with the crash code dump.

> > >         prev->hw_next = qh->hw_next;
> > >         prev->qh_next = qh->qh_next;
> > >         wmb ();
> >
> > These lines aren't reached.
> >
> > Does this happen every time you disconnect the Nexio?
> 
> The crash happens almost always when disconnecting the touchscreen.
> When booted without X, it often survives the first disconnect.

Then it will be easy to recreate the problem.  :-)

> > You can try patching that loop.  If prev is NULL then print an error
> > message in the log, including the value of qh and the value of
> > ehci->async, and jump past the following three statements.
> >
> > With that change the system shouldn't crash, although khubd might hang.
> > But we still need to find out how this could have happened.  Try
> > collecting a usbmon trace while running the test; then let's compare
> > the usbmon output with the error messages in the log.
> 
> gcc version is: gcc (Debian 4.3.4-6) 4.3.4
> 
> Tried something like that before but it did not help at all.
> The check is not triggered and it still oopses. Now it looks like this:
> 
>         qh->qh_state = QH_STATE_UNLINK;
>         ehci->reclaim = qh = qh_get (qh);
> 
>         prev = ehci->async;
>         if (!prev) {
>                 printk("prev is NULL, qh=%p, ehci->async=%p\n", qh, ehci->async);
>                 goto after;
>         }
[*] >         while (prev->qh_next.qh != qh) {
>                 if (!prev) {
>                         printk("prev is NULL, qh=%p, ehci->async=%p\n", qh, ehci->async);
>                         goto after;
>                 }
>                 prev = prev->qh_next.qh;
>         }
> 
>         prev->hw_next = qh->hw_next;
>         prev->qh_next = qh->qh_next;
>         wmb ();
> 
> after:

No, that is wrong.  The [*] line can still perform an invalid
dereference.  You need to move the inside test to the end of the loop,
after the assignment statement.  Or else do this:

	prev = ehci->async;
	for (;;) {
		if (!prev) {
			printk(KERN_ERR "prev is NULL, qh=%p, "
					"ehci->async=%p\n", qh, ehci->async);
			goto after;
			}
		if (prev->qh_next.qh == qh)
			break;
		prev = prev->qh_next.qh;
	}

Alan Stern

