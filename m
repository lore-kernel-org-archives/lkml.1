Return-Path: <linux-kernel-owner+w=401wt.eu-S1752157AbZDVETJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbZDVETJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 00:19:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750865AbZDVESz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 00:18:55 -0400
Received: from ozlabs.org ([203.10.76.45]:35670 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750732AbZDVESy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 00:18:54 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: Fix quilt merge error in acpi-cpufreq.c
Date: Wed, 22 Apr 2009 13:48:40 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Jonathan Corbet <corbet@lwn.net>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Dave Jones <davej@redhat.com>, Theodore Tso <tytso@mit.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>
References: <200904140159.n3E1x1K1014705@hera.kernel.org> <200904201744.22572.rusty@rustcorp.com.au> <20090420103805.GA29891@elte.hu>
In-Reply-To: <20090420103805.GA29891@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200904221348.42677.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Apr 2009 08:08:05 pm Ingo Molnar wrote:
> Can you integrate these two into a single summary line? The obvious 
> solution would be to append them:
> 
>      tracing/ring-buffer: add unlock recursion protection on discard to fix spurious warning triggering tracing shutdown
> 
> but 121 characters width is _way_ too long for a summary.

No, if I'm reading this commit correctly, the commit message is well written,
just really bad.

    tracing/ring-buffer: Add unlock recursion protection on discard

-- This helps the patch reviewer, but noone else.  And the patch reviewer
   should be reading the entire thing anyway.  This is a fix, but you have
   to read to the bottom to know that.

    The pair of helpers trace_recursive_lock() and trace_recursive_unlock()
    have been introduced recently to provide generic tracing recursion
    protection.

    They are used in a symetric way:

     - trace_recursive_lock() on buffer reserve
     - trace_recursive_unlock() on buffer commit

-- Err, why is this verbiage in this patch at all?

    However sometimes, we don't commit but discard on entry
    to the buffer, ie: in case of filter checking.

    Then we must also unlock the recursion protection on discard time,
    otherwise the tracing gets definitely deactivated and a warning
    is raised spuriously, such as:

-- So, the problem is that tracing gets deactivated permanently?  Also a
   warning is raised (in which case is it really spurious?).   Since I have
   no idea what this code does, is it common?  When was this problem
   introduced?  

    111.119821] ------------[ cut here ]------------
    [  111.119829] WARNING: at kernel/trace/ring_buffer.c:1498 ring_buffer_lock_reserve+0x1b7/0x1d0()
    [  111.119835] Hardware name: AMILO Li 2727
    [  111.119839] Modules linked in:
    [  111.119846] Pid: 5731, comm: Xorg Tainted: G        W  2.6.30-rc1 #69
    [  111.119851] Call Trace:
    [  111.119863]  [<ffffffff8025ce68>] warn_slowpath+0xd8/0x130
    [  111.119873]  [<ffffffff8028a30f>] ? __lock_acquire+0x19f/0x1ae0
    [  111.119882]  [<ffffffff8028a30f>] ? __lock_acquire+0x19f/0x1ae0
    ...

-- Good, a backtrace is nice.

   [ Impact: fix spurious warning triggering tracing shutdown ]

-- Hidden away here, I don't think I like this.  Not an improvement.

    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

The patch itself basically adds trace_recursive_unlock() to event discard.
Seems like it should always have done that, and it's a simple bug that it
didn't.  But I had to work hard to figure that out.

Rusty.
