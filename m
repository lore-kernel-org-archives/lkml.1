Return-Path: <linux-kernel-owner+w=401wt.eu-S1758282AbXELSRT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbXELSRT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2007 14:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754754AbXELSRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 May 2007 14:17:12 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35886 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754562AbXELSRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2007 14:17:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>, Gautham R Shenoy <ego@in.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>
Subject: [RFD] Freezing of kernel threads
Date: Sat, 12 May 2007 20:17:31 +0200
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705122017.32792.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Having considered the issue of freezing (or not freezing) kernel threads for a
longer while I tend to agree with Linus that we shouldn't be freezing as many
kernel threads as we currently freeze, but there's one thing that he doesn't
seem to take into account.  Namely, there may be some kernel threads that
actually *want* (or need) to be frozen. :-)

For the suspend they may be kernel threads that otherwise would need some
special synchronization with some device drivers' .suspend() and .resume()
callbacks or fs-related kernel threads.  For the CPU hotplug they might be
kernel threads that otherwise would interfere with the removal or addition of
CPUs.  Still, in each case there seems to be a limited group of kernel threads
that may want to be frozen and the remaining kernel threads that shouldn't be
involved in any freezer-related actions at all.  However, we currently require
all kernel threads to take part in the freezing mechanism, which doesn't seem to
be correct.

It seems to me that, instead of asking *all* kernel threads to either set
PF_NOFREEZE or call try_to_freeze() in a suitable place, we should introduce
some mechanism allowing the kernel threads that *want* to freeze to register
with the freezer.  For example, we can use a per-task flag, say PF_FREEZABLE,
to indicate that given task is a kernel thread which wants (or needs) to be
frozen (for simplicity, I'll call it a 'freezable thread' from now on).
Alternatively, we can use a list of freezable kernel threads.  Regardless of
what actual mechanism is used, the freezer will only set TIF_FREEZE for
freezable kernel threads and these threads will be expected to call
try_to_freeze().  The remaining kernel threads (I'll call them 'normal') won't
need to do anything.

If this approach is used, the entire freezing-related complexity will only
affect the freezable kernel threads.  Moreover, it seems that we can precisely
define and document the rules to be followed by the freezable kernel threads
(for example, IMO it's reasonable to require a freezable kernel thread to
unregister from the freezer before it stops etc.) while the normal kernel
threads can be left in peace.

It also seems that we can transition from the current apporach to the one
outlined above in a quite straightforward way.  Namely, for this purpose we
need to identify the kernel threads that should be freezable, make them use the
new interface, and remove PF_NOFREEZE and try_to_freeze() from the remaining
kernel threads.  Later, if testing shows that we've overlooked some kernel
threads which need to be made freezable, we'll be able to add the "ability to
freeze" to these threads quite easily.

Of course, that would also require us to rewrite the freezer itself quite a
bit, but IMO it's worthy of doing.

Thoughts?

Rafael
