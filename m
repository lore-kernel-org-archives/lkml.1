Return-Path: <linux-kernel-owner+w=401wt.eu-S1753087Ab0ACV3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab0ACV3r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 16:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752936Ab0ACV3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 16:29:46 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50804 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab0ACV3q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 16:29:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
Subject: Re: [suspend/resume] Re: userspace notification from module
Date: Sun, 3 Jan 2010 22:29:53 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Andy Walls <awalls@radix.net>,
       Daniel Borkmann <danborkmann@googlemail.com>,
       linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <201001030029.22449.rjw@sisk.pl> <65e5aef6.33251eb4.4b3fecf4.a2f99@o2.pl>
In-Reply-To: <65e5aef6.33251eb4.4b3fecf4.a2f99@o2.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001032229.53221.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 January 2010, Bartłomiej Zimoń wrote:
> Dnia 3 stycznia 2010 0:29 "Rafael J. Wysocki" <rjw@sisk.pl> napisał(a):
> > > Thanks for Your answare.
> > > Some points of my idea:
> > > - don't think everyone want to use pm-utils (didn't say it is bad)
> > 
> > That certainly is true, but I think these people won't have a problem setting
> > up their suspend scripts to trigger the notification anyway. :-)
> > 
> 
> But it means almoust always create dbus interface and send message by script.

Of course you don't need to do that.  For example, you can use a UNIX domain
socket for sending the notification from one user space process (a power
manager) to another one (application wanting to be notified) and the
confirmation that's safe to suspend the other way around.  Generally, arbitrary
message-passing interface between two processes would be fine IMO.

...
> > To put it in a different way, you apparently want the kernel to notify the user
> > space of an event originating from the user space and my question is why not
> > to set up the user space to generate the notification without relying on the
> > kernel to do that.
> 
> Because now kernel know better what is going on.

That's because it's just been told by the user space about that.

Basically, you want something like this to happen:

process A ->(suspend) kernel
kernel ->(suspending) process B

where the kernel won't wait for process B to do whatever it has to do before
suspending.  In my opinion it'd be better to do something like this

process A ->(suspending) process B
process B ->(ack) process A
process A ->(suspend) kernel

... 
> > At least, that requires some more discussion, so please tell us why you need
> > the kernel to notify the user space about suspend/hibernation.  IOW, what's the
> > final purpose of this?  [Added some CCs.]
> 
> Yes, it is only first step.
> Have created different point of view, not all linux boxes are desktops/laptops.
> What about embedeed solutions?
> Why app must implement all other to know about resume/suspend?
> Why not open file and know this easily?

And why not to open a socket?

Really, what I think you want is a standard way of notifying applications that
suspend or hibernation is going to happen, but you don't need the kernel to
take part in that directly.

Putting things into the kernel is not the only way to avoid overheads IMO.

... 
> First of all i want to start discussion about this topic and looks like started :)
> 
> So what was in my mind? There are lots of small devices today with linux.
> Lots of them has got unstandardized suspend/resume detection.

OK, so we need a standard here.  I can't agree more.  However, does that mean
the kernel has to be directly involved in that?  If it does, then why exactly?

> It could be too much info exposed from kernel by this module/propose i understand
> for program info about pm_post_resume event could be anought.
> 
> We have now 3types of suspend implementation and 1 kernel API inside.
> App typicaly need just 2-3 event types - suspending, resumming, idle.
> I dont want to slow down kernel suspend, block or something, just perform 
> some actions in apps - typicaly try to reconnect.
> It could be new kernel standard to easy adept some actions.
> 
> Why not pm-utils connect to such module and gather data?
> Then It could work as hal service.
> But hook on kernel like /sbin/init but for suspend and resume, looks like other solution.
> IOW sending event to kernel to perform action and launch userspace once 
> more just before pm-event chain ... check return_val, sounds like other 
> solution/ other kind of module.

Again, you don't need a kernel module for that.  Moreover, using a kernel
module for that is actually inconvenient.

> What about this discusion:
> http://lists.freedesktop.org/archives/devkit-devel/2009-December/000617.html

Well, it would be nice if the desktop people sent CCs of such discussions to
linux-pm.  Talking about the kernel without involving people who actually work
on it is not exactly productive IMO.

Rafael
