Return-Path: <linux-kernel-owner+w=401wt.eu-S1759411AbYEMIlr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411AbYEMIlr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 04:41:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758013AbYEMIlj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 04:41:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51751 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756701AbYEMIli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 04:41:38 -0400
Date: Tue, 13 May 2008 01:40:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: arges@linux.vnet.ibm.com
Cc: Maynard Johnson <maynardj@us.ibm.com>, Gianni Tedesco <gxt@cs.nott.ac.uk>,
       Vegard Nossum <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org,
       oprofile-list@lists.sourceforge.net, Mike Travis <travis@sgi.com>
Subject: Re: oprofile BUG() in current kernel.
Message-Id: <20080513014010.e0723e01.akpm@linux-foundation.org>
In-Reply-To: <1210610283.7218.4.camel@snuffleupagus>
References: <1210593756.3708.7.camel@dao.KWGR614>
	<19f34abd0805120519t12fceef9u7870006a904c85b2@mail.gmail.com>
	<1210599105.3479.1.camel@dao.KWGR614>
	<48285002.9080702@us.ibm.com>
	<1210610283.7218.4.camel@snuffleupagus>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 May 2008 11:38:03 -0500 Chris J Arges <arges@linux.vnet.ibm.com> wrote:
> 
> > >>>
> > >>>       
> > >> This looks similar to:
> > >>
> > >> http://www.uwsg.iu.edu/hypermail/linux/kernel/0805.0/2845.html
> > >>     
> > >
> > > Yes, remarkably similar ;)
> > >
> > >   
> > >> Does reverting 608dfddd845da5ab6accef70154c8910529699f7 fix it for you too?
> > >>     
> > Has this fix been officially reverted?
>
> Let me know if this change is going to be reverted, as I have a patch
> ready to support cpu hotplug for oprofile based on code post
> DEFINE_PER_CPU patch. 

Please don't top-post.  I repaired it so that I could reply sensibly.

In trying to reprocude this on a uniprocessor machine, it seems that
someone broke oprofile:

/usr/bin/opcontrol: line 911: /dev/oprofile/0/enabled: No such file or directory
/usr/bin/opcontrol: line 911: /dev/oprofile/0/event: No such file or directory
/usr/bin/opcontrol: line 911: /dev/oprofile/0/count: No such file or directory
/usr/bin/opcontrol: line 911: /dev/oprofile/0/kernel: No such file or directory
/usr/bin/opcontrol: line 911: /dev/oprofile/0/user: No such file or directory
/usr/bin/opcontrol: line 911: /dev/oprofile/0/unit_mask: No such file or directo

sony:/home/akpm> l /dev/oprofile
total 0
drwxr-xr-x 1 root root 0 May 13 01:25 1
-rw-r--r-- 1 root root 0 May 13 01:25 backtrace_depth
-rw-r--r-- 1 root root 0 May 13 01:25 buffer
-rw-r--r-- 1 root root 0 May 13 01:25 buffer_size
-rw-r--r-- 1 root root 0 May 13 01:25 buffer_watershed
-rw-r--r-- 1 root root 0 May 13 01:25 cpu_buffer_size
-rw-r--r-- 1 root root 0 May 13 01:25 cpu_type
-rw-rw-rw- 1 root root 0 May 13 01:25 dump
-rw-r--r-- 1 root root 0 May 13 01:25 enable
-rw-r--r-- 1 root root 0 May 13 01:25 pointer_size
drwxr-xr-x 1 root root 0 May 13 01:25 stats

Looks like the "0" got renamed to "1".  Who did that?



So then I try it on the old 2-way:

No event named GLOBAL_POWER_EVENTS is available.
No event named GLOBAL_POWER_EVENTS is available.
No event named GLOBAL_POWER_EVENTS is available.
No event named GLOBAL_POWER_EVENTS is available.
No event named GLOBAL_POWER_EVENTS is available.

so that got broken too.

I queued the revert of 608dfddd845da5ab6accef70154c8910529699f7,
although that doesn't fix these regressions.

I see no oops.  And I don't see what's wrong with the fairly simple
per-cpu conversion, so I'd rather not revert what appears to be a good
patch when we don't understand what's going wrong.


Grasping at straws, we have had problems with per-cpu variable
initialisation in the past.  Does this

--- a/drivers/oprofile/cpu_buffer.c~a
+++ a/drivers/oprofile/cpu_buffer.c
@@ -27,7 +27,7 @@
 #include "buffer_sync.h"
 #include "oprof.h"
 
-DEFINE_PER_CPU_SHARED_ALIGNED(struct oprofile_cpu_buffer, cpu_buffer);
+DEFINE_PER_CPU_SHARED_ALIGNED(struct oprofile_cpu_buffer, cpu_buffer) = { };
 
 static void wq_sync_buffer(struct work_struct *work);
 
_

fix anything for anyone?

