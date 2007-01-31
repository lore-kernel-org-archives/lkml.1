Return-Path: <linux-kernel-owner+w=401wt.eu-S1030235AbXAaQ1O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030235AbXAaQ1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 11:27:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030238AbXAaQ1O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 11:27:14 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:47188 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030235AbXAaQ1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 11:27:13 -0500
Date: Wed, 31 Jan 2007 11:27:12 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.osdl.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] question on resume()
In-Reply-To: <200701311713.04104.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0701311124200.3803-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Jan 2007, Oliver Neukum wrote:

> Am Mittwoch, 31. Januar 2007 16:54 schrieb Alan Stern:
> > On Wed, 31 Jan 2007, Pavel Machek wrote:
> 
> > > "cease IO"? No, I believe it is enough not to start new I/O. Userspace
> > > is frozen at that point, it can't ask you to do I/O.
> > 
> > There may be I/O requests sitting in a queue, already submitted by
> > userspace.  The suspend method should wait for existing I/O to complete
> > and stop processing new entries from the queue.
> 
> As far as I understand it now, a frozen process will be in the refrigerator.
> Thus it cannot be blocking somewhere else in kernel space. Yet we cannot
> be sure there's no queued IO, as theres aio.

Or the driver may maintain its own I/O queue, like the HID driver does.

> > > > On resume():
> > > > 
> > > > 1. Don't worry about TASK_UNINTERRUPTIBLE
> > > > 2. Do not restart IO that may call wake_up_interruptible()
> > > > 
> > > > When do we restart such IO?
> > > 
> > > We reuse signal handling code to do that for us. It is same situation
> > > as when someone signals task doing I/O.
> > 
> > Again you misunderstood the question.  The driver must start queued I/O
> > when its resume() method is called.  It should then be okay for the driver
> > to call wake_up_interruptible(), even before tasks are unfrozen.
> 
> Isn't there some code in usbfs that'll do homegrown aio and deliver a
> signal to a process if io is completed?

That's right.  There's also code in the hub driver to call wake_up() on 
the khubd thread when certain I/O operations complete; nevertheless khubd 
_should_ remain frozen along with all the other tasks.

Alan Stern

