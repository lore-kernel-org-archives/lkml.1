Return-Path: <linux-kernel-owner+w=401wt.eu-S1757309AbYENVpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757309AbYENVpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 17:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751479AbYENVpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 17:45:17 -0400
Received: from vena.lwn.net ([206.168.112.25]:50018 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbYENVpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 17:45:16 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [announce] "kill the Big Kernel Lock (BKL)" tree 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Wed, 14 May 2008 19:49:55 +0200."
             <20080514174955.GA515@elte.hu> 
Date: Wed, 14 May 2008 15:45:15 -0600
Message-ID: <6457.1210801515@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sez Ingo:

> This task is not easy at all. 12 years after Linux has been converted to 
> an SMP OS we still have 1300+ legacy BKL using sites. There are 400+ 
> lock_kernel() critical sections and 800+ ioctls.

There's also every char device open() method - a rather long list in its
own right.  I'd be surprised if one in ten of them really needs it, but
one has to look...

I've been looking at the chrdev code anyway, and pondering on how this
might be addressed.  Here's some thoughts on alternatives, I'd be
curious what people think:

1: We could add an unlocked_open() to the file_operations structure;
   drivers could be converted over as they are verified not to need the
   BKL on open.  Disadvantages are that it grows this structure for a
   relatively rare case - most open() calls already don't need the BKL.
   But it's a relatively easy path without flag days.

2: Create a char_dev_ops structure for char devs and use it instead of
   file_operations.  I vaguely remember seeing Al mutter about that a
   while back.  Quite a while back.  This mirrors what was done with
   block devices, and makes some sense - there's a lot of stuff in
   struct file_operations which is not really applicable to char devs.
   Then struct char_dev_ops could have open() and locked_open(), with
   the latter destined for removal sometime around 2015 or so.

   Advantages are that it's cleaner and separates out some things which
   perhaps shouldn't be mixed anyway.  Disadvantage is...well...a fair
   amount of code churn.  It would also require chrdev-specific wrappers
   to map straight file_operations calls in the VFS to the new
   callbacks.

3: Provide a new form of cdev_add() which lets the driver indicate
   that the BKL is not needed on open (or anything else?).  At a
   minimum, it could just be a new parameter on cdev_add which has a
   value of zero or FIXME_I_STILL_NEED_BKL.  Still some churn but easier
   to script and smaller because a lot of drivers are still using
   register_chrdev() - something else worth fixing.

   A more involved form might provide a new chardev_add() which takes
   the new char_dev_ops structure too.  Mapping between new and old
   operations vectors would be done internally to avoid breaking older
   drivers before they can be fixed.

4: Just find every char dev open() function and shove in lock_kernel()
   calls, then remove the call from chrdev_open().  The disadvantage
   here is that, beyond lots of work and churn, there's no way to know
   which ones you missed.

I kind of like the combination of 2 and 3, done in such a way that
there's no "every driver must change" flag day.  This could be an
interesting project, even...  Thoughts?

jon
