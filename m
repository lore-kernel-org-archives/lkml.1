Return-Path: <linux-kernel-owner+w=401wt.eu-S1423110AbXD3HbM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423110AbXD3HbM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 03:31:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423113AbXD3HbM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 03:31:12 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:36094 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423110AbXD3HbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 03:31:10 -0400
Date: Mon, 30 Apr 2007 00:30:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Miguel Figueiredo <elmig@debianpt.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21 frozen for a few minutes, swapping to disk
Message-Id: <20070430003031.2e89fbc1.akpm@linux-foundation.org>
In-Reply-To: <46347335.7080601@debianpt.org>
References: <46347335.7080601@debianpt.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Apr 2007 11:28:05 +0100 Miguel Figueiredo <elmig@debianpt.org> wrote:

> Hi all,
> 
> today, with 2.6.21, my laptop had a really odd behaviour. It started 
> writing to disk for a few minutes with no interactivity at all (no 
> redraw on screen, only hdd led on). It's the first time i noticed 
> OOM-killer started do kill programs.
> 
> It was totally unresponsive for minutes, after back to life it had a 
> load of ~19.0, and 300+ MB on swap (first time i saw this).
> 
> It's an HP pavillon core duo 2.0 GHz, 1 GB RAM
> 
> kern.log details: 
> http://www.debianpt.org/~elmig/pool/kernel/20070429/kern.log
> .config: http://www.debianpt.org/~elmig/pool/kernel/20070429/2.6.21.config
> dmesg: http://www.debianpt.org/~elmig/pool/kernel/20070429/dmesg
> 
> As this is the first time it happened and it felt odd i am reporting.
> 
> If aditional info is needed please CC me as i am not on the list.
> 

hm, a genuine oom on an all-ext3 data=ordered i386 system, just like a
million other people.  How very weird.

I assume all those pages on the LRU are pagecache pages which for some
reason we're unable to reclaim.

If some privileged application went berzerk mlock()ing everything then that
might explain it.  It sounds improbable, but then, something improbable has
happened.

We cleverly managed to not display the pagecache totals in the oom-killer
output.  Could you please take a copy of /proc/meminfo after an
oom-killing, send that?  And /proc/vmstat, I guess.

If you're keen, we could eliminate the mlock possibility by adding this:

--- a/mm/mlock.c~a
+++ a/mm/mlock.c
@@ -127,6 +127,8 @@ asmlinkage long sys_mlock(unsigned long 
 	unsigned long lock_limit;
 	int error = -ENOMEM;
 
+	return 0;
+
 	if (!can_do_mlock())
 		return -EPERM;
 
@@ -151,6 +153,8 @@ asmlinkage long sys_munlock(unsigned lon
 {
 	int ret;
 
+	return 0;
+
 	down_write(&current->mm->mmap_sem);
 	len = PAGE_ALIGN(len + (start & ~PAGE_MASK));
 	start &= PAGE_MASK;
_

