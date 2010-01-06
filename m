Return-Path: <linux-kernel-owner+w=401wt.eu-S932145Ab0AFLGQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932145Ab0AFLGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 06:06:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932107Ab0AFLGP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 06:06:15 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:56685 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab0AFLGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 06:06:14 -0500
Date: Wed, 6 Jan 2010 03:06:05 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33-rc2: Xen/Guest switching to user mode with no user page
 tables
In-Reply-To: <4B4405B5.9040205@goop.org>
Message-ID: <alpine.DEB.2.01.1001060240010.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.1001051649100.3483@bogon.housecafe.de> <4B4405B5.9040205@goop.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+Y5+XkkwzZhjdCn+WSQ9hvuj3hv2EP2pBCJGj
 tkkDkImVx2lc0ce/O8rxi1C9EEjMUKUFX8uO26JyZawtzGriEk
 AGcsPV85S5+b4mbHfPjtg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Jan 2010 at 14:38, Jeremy Fitzhardinge wrote:
> this message before, even during development.  I'd suspect either a compiler
> bug, a miscompile, or some bad interaction with another patch.

I'm using the same compiler (gcc-4.4.2-8, binutils-2.20) for the 
(working) 2.6.32 (Linus' git tree) and did a "make 
distclean" to double check, but 2.6.33-rc2/3 just wouldn't boot.

> A bisection would be useful.

I'm *almost* there, only 1 or 2 revisions revisions left, I attached the 
bisect log below. However, now this happens during "xm create" on the 
DomU console:

------------[ cut here ]------------
WARNING: at /mnt/d1/linux-2.6-git/arch/x86/kernel/apic/apic_noop.c:130 
noop_apic_write+0x40/0x50()
Modules linked in:Pid: 0, comm: swapper Not tainted 2.6.32 #1
Call Trace:
 [<ffffffff81032563>] ? warn_slowpath_common+0x73/0xb0
 [<ffffffff8101a7c0>] ? noop_apic_write+0x40/0x50
 [<ffffffff81334160>] ? init_hw_perf_events+0x33d/0x3dd
 [<ffffffff8100622f>] ? xen_restore_fl_direct_end+0x0/0x1
 [<ffffffff81333cab>] ? identify_boot_cpu+0x15/0x3e
 [<ffffffff81333dfe>] ? check_bugs+0x9/0x2e
 [<ffffffff8132ec6e>] ? start_kernel+0x324/0x334
---[ end trace a7919e7f17c0a725 ]---


Then the DomU panics with:

[    0.012307] Freeing SMP alternatives: 24k freed
[    0.012398] general protection fault: 0000 [#1] SMP 


Note: there's nothing in "xm dmesg" (dom0) this time, the DomU is 
"running" (panicked, so unusable, but I still have to "xm destroy" it).


Also, I see the domU now crashes with "general protection fault": in the 
(old) posting from xen-devel[0] they were talking about GFP as well. So 
maybe it's related after all.


I've put the full dmesg on: http://nerdbynature.de/bits/2.6.33-rc2/xen/bisect/

 - 3bd95dfb182969dc6d2a317c150e0df7107608d3.txt, that's what "git log"  
   currently says (with the git bisect log below). 

 - f443ff4201dd25cd4dec183f9919ecba90c8edc2.txt - this happened a few git 
   bisect iterations earlier, with a similar picture: "xm dmesg" was 
   empty, the domU panicked. Back then I did "git bisect skip", because
   I had ~20 or so revisions left and it worked. The next "bad" revision
   (and all the other bad revisions during the bisection) had the same 
   picture as my initial report.


I'm not sure how to mark the current revision and I don't know if I can 
"skip" again, because I might have only one revision left.

Given that the DomU panics just after "Freeing SMP alternatives" as
v2.6.33-rc3 does it may seem that it's "bad".

I'll try to get the bisection over to a box with X11, so that 
I can use "git bisect visualize" to see what revisions are left (or is 
there an easier way to find out?)


But maybe that's close enough to get an idea what's going on here?

Christian.

[0] http://lists.xensource.com/archives/html/xen-devel/2008-02/msg00861.html


git-bisect start
# bad: [74d2e4f8d79ae0c4b6ec027958d5b18058662eea] Linux 2.6.33-rc3
git-bisect bad 74d2e4f8d79ae0c4b6ec027958d5b18058662eea
# good: [22763c5cf3690a681551162c15d34d935308c8d7] Linux 2.6.32
git-bisect good 22763c5cf3690a681551162c15d34d935308c8d7
# good: [6825fbc4cb219f2c98bb7d157915d797cf5cb823] Merge branch 'next-i2c' of git://git.fluff.org/bjdooks/linux
git-bisect good 6825fbc4cb219f2c98bb7d157915d797cf5cb823
# good: [471452104b8520337ae2fb48c4e61cd4896e025d] const: constify remaining dev_pm_ops
git-bisect good 471452104b8520337ae2fb48c4e61cd4896e025d
# bad: [288f02bbb6e9609cbaf1eb7a9cb97ae45ce090b2] Merge branch 'release' of git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6
git-bisect bad 288f02bbb6e9609cbaf1eb7a9cb97ae45ce090b2
# good: [60d9aa758c00f20ade0cb1951f6a934f628dd2d7] Merge git://git.infradead.org/mtd-2.6
git bisect good 60d9aa758c00f20ade0cb1951f6a934f628dd2d7
# good: [525995d77ca08dfc2ba6f8e606f93694271dbd66] Merge branch 'for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/vapier/blackfin
git bisect good 525995d77ca08dfc2ba6f8e606f93694271dbd66
# bad: [8aedf8a6ae98d5d4df3254b6afb7e4432d9d8600] Merge branch 'perf-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad 8aedf8a6ae98d5d4df3254b6afb7e4432d9d8600
# bad: [bac5e54c29f352d962a2447d22735316b347b9f1] Merge branch 'master' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs-2.6
git bisect bad bac5e54c29f352d962a2447d22735316b347b9f1
# bad: [61ecdb84c1f05ad445db4584ae375a15c0e8ae47] Merge branch 'x86-fixes-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip
git bisect bad 61ecdb84c1f05ad445db4584ae375a15c0e8ae47
# good: [e36c54582c6f14adc9e10473e2aec2cc4f0acc03] tracing: Fix return of trace_dump_stack()
git bisect good e36c54582c6f14adc9e10473e2aec2cc4f0acc03
# skip: [e840227c141116171c89ab1abb5cc9fee6fdb488] x86, 32-bit: Use same regs as 64-bit for kernel_thread_helper
git bisect skip e840227c141116171c89ab1abb5cc9fee6fdb488
# good: [27f59559d63375a4d59e7c720a439d9f0b47edad] x86: Merge sys_iopl
git bisect good 27f59559d63375a4d59e7c720a439d9f0b47edad
# bad: [f443ff4201dd25cd4dec183f9919ecba90c8edc2] x86: Sync 32/64-bit kernel_thread
git bisect bad f443ff4201dd25cd4dec183f9919ecba90c8edc2
# good: [ce9119ad90b1caba550447bfcc0a21850558ca49] x86-32: Avoid pipeline serialization in PTREGSCALL1 and 2
git bisect good ce9119ad90b1caba550447bfcc0a21850558ca49
-- 
BOFH excuse #204:

Just pick up the phone and give modem connect sounds. "Well you said we should get more lines so we don't have voice lines."
