Return-Path: <linux-kernel-owner+w=401wt.eu-S1752031Ab0ABX3M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab0ABX3M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 18:29:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446Ab0ABX3M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 18:29:12 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:49590 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751212Ab0ABX3L convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 18:29:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
Subject: Re: [suspend/resume] Re: userspace notification from module
Date: Sun, 3 Jan 2010 00:29:22 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: Andy Walls <awalls@radix.net>,
       Daniel Borkmann <danborkmann@googlemail.com>,
       linux-kernel@vger.kernel.org,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <201001022201.04281.rjw@sisk.pl> <7cf4f51f.5fc2a5cd.4b3fc3ad.c849c@o2.pl>
In-Reply-To: <7cf4f51f.5fc2a5cd.4b3fc3ad.c849c@o2.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001030029.22449.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 January 2010, Bartłomiej Zimoń wrote:
> 
> Dnia 2 stycznia 2010 22:01 "Rafael J. Wysocki" <rjw@sisk.pl> napisał(a):
> 
> > On Saturday 02 January 2010, Bartłomiej Zimoń wrote:
> > > Dnia 2 stycznia 2010 16:56 	Daniel Borkmann <danborkmann@googlemail.com> napisał(a):
> > > > Hi Andy,
> > > > 
> > > > 2010/1/2 Andy Walls <awalls@radix.net>:
> > > > > Why not:
> > > > >
> > > > > a. write a module that implements a device node that supports poll(),
> > > > > and
> > > > >
> > > > > b. have a user space process select() on the fd for read or exception
> > > > > notification
> > > > >
> > > > > ?
> > > > 
> > > > This is, of course, another possible solution that is more "cleaner"
> > > > than the one with the signals.
> > > > Then, your userspace program would have another thread polling for the
> > > > device node. Question is which timeout would be appropriate to be "CPU
> > > > friendly" and to keep notification latency short?
> > > > 
> > > 
> > > Just need as fast as possible solution and on the other hand acceptable for kernel sources.
> > > Usually programs needs just to disconnect something or set one flag.
> > > Even if program will have no time for this it could be enough just to send this precious info.
> > 
> > Perhaps I don't understand correctly what you're trying to achieve, but at the
> > moment suspend is always started from user space, this way or another, and on
> > the majority (all?) of the modern distros pm-utils is involved in that.
> > So, why don't you provide a pm-utils hook for your process (like, for example,
> > NetworkManager)?
> > 
> 
> Thanks for Your answare.
> Some points of my idea:
> - don't think everyone want to use pm-utils (didn't say it is bad)

That certainly is true, but I think these people won't have a problem setting
up their suspend scripts to trigger the notification anyway. :-)

Point is, suspend hooks are used anyway by almost everyone (due to graphics,
networking, faulty drivers), so I think you could just use this mechanism, be it
pm-utils or something else.

To put it in a different way, you apparently want the kernel to notify the user
space of an event originating from the user space and my question is why not
to set up the user space to generate the notification without relying on the
kernel to do that.

> - this code is standard for all implementation of suspend/hibernate/resume

I guess you mean the existing kernel-side suspend/hibernate code.

Sure, it is, but your module is going to export the kernel's internal interface
outside the kernel, turning it into a real API and that is a _big_ _deal_.  The
reason why it is a big deal is that while we often change the kernel's internal
interfaces, we don't change APIs.  Once created, an API (I mean a real
userland-kernel interface) is very difficult to change, because that most often
leads to regressions which are quite nasty from the user's point of view.

So, basically, you want us to declare that the kernel's internal
suspend/hibernate notification mechanism won't change in the future, which is
not something I'm going to do at this point.  Moreover, it hasn't been designed
as an API and I don't think it's really suitable for this purpose.

At least, that requires some more discussion, so please tell us why you need
the kernel to notify the user space about suspend/hibernation.  IOW, what's the
final purpose of this?  [Added some CCs.]

> - it is small
> - it have less overhead, dont need dbus and all rest services.

That could have been a good argument if those services had not been used
already, but that's not the case.

> - could be even used partialy by pm-utils
> - it is perfect just to notify about event

OK, but why exactly do _you_ need that to happen?

There's one important drawback of making the kernel generate the notification.
Namely, even if your userspace task is notified by the kernel of a PM event,
that doesn't mean it'll have the time to act upon that, because the kernel will
attempt to freeze it right after the notification has been sent.  This means
you'd need a way to make the kernel wait for your user space process to finish
it's job before continuing the suspend/hibernate process.  Otherwise it's not
going to be very useful.

Rafael
