Return-Path: <linux-kernel-owner+w=401wt.eu-S1753108Ab0ACVsx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab0ACVsx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 16:48:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753036Ab0ACVsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 16:48:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50867 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907Ab0ACVsw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 16:48:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: =?utf-8?q?Bart=C5=82omiej_Zimo=C5=84?= <uzi18@o2.pl>
Subject: Re: [suspend/resume] Re: userspace notification from module
Date: Sun, 3 Jan 2010 22:49:11 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.33-rc2-tst; KDE/4.3.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Andy Walls <awalls@radix.net>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       Stefan Seyfried <stefan.seyfried@googlemail.com>
References: <686edb2c.6263643a.4b3f4a3b.b60b3@o2.pl> <4B406C14.2070907@gmail.com> <43bd3f9d.71702a8b.4b407900.b542@o2.pl>
In-Reply-To: <43bd3f9d.71702a8b.4b407900.b542@o2.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001032249.11510.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 03 January 2010, Bartłomiej Zimoń wrote:
> Dnia 3 stycznia 2010 11:06 	Daniel Borkmann <danborkmann@googlemail.com> napisał(a):
> > Daniel Borkmann wrote:
> > > Bartłomiej Zimoń wrote:
> > >> What about this discusion:
> > >> http://lists.freedesktop.org/archives/devkit-devel/2009-December/000617.html
> > >>
> > >> I will perform some tests to know what amount of time is usualy needed to disconnect
> > >> nicely client or something.
> > > 
> > > Actually I think this is what signals are there for and bringing this
> > > information via signals would have least overhead, problem is that this
> > > is not POSIX compliant, but may be you could have a try at this?!
> > 
> > I'm not quite sure how this is implemented within the kernel, but if you
> > have lots of processes doing their suspend routines, I think it is not
> > guaranteed that all of this finishes before doing the suspend, so you
> > will have some unknown states, processes could stuck at (and later [at
> > some unintended point of time] resume on).
> > Or, on the other hand you will have to block the kernel notification
> > chain until all the procs have signaled that they're done doing their
> > jobs. Regarding this, the kernel suspend would depend on the correctness
> > / termination of userspace routines which is a _very_ bad thing.
> > You will have to introducte some timeouts... see where this is going? I
> > think a file interface might be too simple... just some thoughts about this.
> > 
> 
> mhm, why not to create kernel based pm event messaging for processes?
> How it is implemented on other platforms?
> Because on MacOsX looks like program registers callback for such event.
> 
> I dont know if every pm_notifier blocks suspend until return from callback.
> 
> If we cant do it simple we can do it better.
> Rafael what do You think about it?

I've just said, roughly, in a message I sent to you a while back.

You need a power manager, but not necessarily in the kernel.  The role of the
power manager would be to:
(1) pass suspend requests from different sources in the user space (a GUI for
    one example) to the kernel,
(2) notify processes which registered for that when it's going to pass a
    suspend (or hibernate) request to the kernel,
(3) wait for the notified processes to complete the pre-suspend preparations
    they require.

There are a few more things to consider here.  For example, what if one of the
registered processes becomes unresponsive?  Are we going to suspend anyway
or notify the user and wait for him to resolve the problem?  In the latter
case, what to do if that is, for example, an emergency hibernation started
because we're running out of battery power?  Etc.

Some time ago openSUSE had a daemon called powersaved used for this purpose,
but then it was replaced by pm-utils, apparently because everybody else was
using pm-utils and it just wasn't worth maintaining a different solution for
one distro only.  Maybe it's time to rethink this idea?

Rafael
