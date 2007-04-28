Return-Path: <linux-kernel-owner+w=401wt.eu-S1161130AbXD1Rqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161130AbXD1Rqb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 13:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1163270AbXD1Rqb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 13:46:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33995 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161130AbXD1Rqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 13:46:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Back to the future.
Date: Sat, 28 Apr 2007 19:50:29 +0200
User-Agent: KMail/1.9.5
Cc: Pavel Machek <pavel@ucw.cz>, Nigel Cunningham <nigel@nigel.suspend2.net>,
       Pekka J Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>
References: <1177567481.5025.211.camel@nigel.suspend2.net> <20070428085000.GA3293@elf.ucw.cz> <alpine.LFD.0.98.0704280926140.9964@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0704280926140.9964@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704281950.30405.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 28 April 2007 18:28, Linus Torvalds wrote:
> 
> On Sat, 28 Apr 2007, Pavel Machek wrote:
> > 
> > We do not want kernel threads running:
> > 
> > a) they may hold some locks and deadlock suspend
> > 
> > b) they may do some writes to disk, leading to corruption
> 
> You're really just making both of those up.
> 
> If a kernel thread holds a lock and deadlocks suspend, that would deadlock 
> anythign else _too_. Suspend isn't *that* special. Everything it does are 
> things other people do too.
> 
> And no, kernel threads do not write to disk on their own. Name one.

xfssyncd , or at least it seems so at a quick look.

> They help *others* write to disk, but those disk writes need to happen.
> 
> The freezer has *caused* those deadlocks (eg by stopping threads that were 
> needed for the suspend writeouts to succeed!), not solved them.

I can't remember anything like this, but I believe you have a specific test
case in mind.

> So stop making these totally bogus arguments up.

Well, they may be bogus, but there's something else.

I have reviewed some kernel threads used by device drivers that currently are
frozen to see if it would be safe not to freeze them, and I'm worried.

What, for example, if such a thread schedules a timeout and waits for
something to happen (eg. the airo driver does something like this), but instead
the hibernation/suspend happens and the device is frozen/suspended under it?

Shouldn't the thread be notified by the driver's freeze/suspend callback?

Moreover, what if after the restore the device is not present (for example, it
may be a pcmcia card that the user has removed) and the thread is scheduled
before the device's unfreeze callback has a chance to run?  Shouldn't the
thread check that the device is present?  In that case it would have to be
notified by someone that the check is necessary, but who can do that?

Greetings,
Rafael
