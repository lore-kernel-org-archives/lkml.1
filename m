Return-Path: <linux-kernel-owner+w=401wt.eu-S933305AbZGPUY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933305AbZGPUY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 16:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933284AbZGPUY5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 16:24:57 -0400
Received: from www84.your-server.de ([213.133.104.84]:45964 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933283AbZGPUY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 16:24:56 -0400
Subject: Re: 2.6.31-rc1-mmotm0702 - ps command hangs inside kernel
From: Stefani Seibold <stefani@seibold.net>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
In-Reply-To: <46776.1247771564@turing-police.cc.vt.edu>
References: <47423.1247518491@turing-police.cc.vt.edu>
	 <20090713143810.5e17bbdb.akpm@linux-foundation.org>
	 <1247549479.30711.8.camel@wall-e>
	 <46776.1247771564@turing-police.cc.vt.edu>
Content-Type: text/plain
Date: Thu, 16 Jul 2009 22:24:47 +0200
Message-Id: <1247775887.10888.17.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009, 15:12 -0400 Valdis.Kletnieks@vt.edu said:
> On Tue, 14 Jul 2009 07:31:19 +0200, Stefani Seibold said:
> > Am Montag, den 13.07.2009, 14:38 -0700 schrieb Andrew Morton:
> > > On Mon, 13 Jul 2009 16:54:51 -0400
> > > Valdis.Kletnieks@vt.edu wrote:
> > > 
> > > > Several times recently, I've had the 'ps' command hang inside the kernel
> > > > for extended periods of time - usually around 1100 seconds, but today I
> > > > had one that hung there for 2351 seconds.
> 
> > i am the author of the get_stack_usage_bytes(). Because i have currently
> > no 64bit machine running, i am not able to analyse your problem. Does it
> > only happen on 32bit application on a 64bit kernel? Is it only affected
> > to pcsd?
> 
> I've only seen it happen to pcscd.  However, most of the time it's one of
> the very few 32-bit apps running on my laptop (I've got exactly *one* legacy
> app for a secure-token that is stuck in 32-bit land).  So I can't tell if it's
> a generic 32-bit issue.
> 
> It's possible that one of the two follow_page() entries is stale and just
> happened to be left on the stack.  A large chunk of proc_pid_status() is
> inlined, so it's possible that two calls were made and left their return
> addresses in different locations on the stack.
> 
> I am pretty sure that follow_page+0x28 is the correct one, as I see it
> in 2 more tracebacks today (see below)...

The stack trace looks like you there is a old version included in the
2.6.31-rc1-mmotm0702 patches.

I switch to walk_page_range() function since patch version V0.9 dated
from Jun 10 2009. Here is the link to the lkml patchwork:
 
http://patchwork.kernel.org/patch/32210/

I do the map examination exactly in the same way like the function used
for /proc/<pid>/smaps. So i think this version should do it without side
effects.

Can you tell me were you downloaded the 2.6.31-rc1-mmotm0702 patch?

> ps            R  running task     3936 45836  45832 0x00000080
>  ffff88004dc09b98 ffffffff81065f3f 0000000000000001 00000388525af000
>  ffff88004dc09bb8 ffffffff81065f3f 0000000000000000 000003886bc2b000
>  ffff88004dc09ce8 ffffffff8149b2a6 0000000000000000 ffff88000212cf68
> Call Trace:
>  [<ffffffff81065f3f>] ? trace_hardirqs_on_caller+0x1f/0x145
>  [<ffffffff81065f3f>] trace_hardirqs_on_caller+0x1f/0x145
>  [<ffffffff8149b2a6>] trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff81065f3f>] ? trace_hardirqs_on_caller+0x1f/0x145
>  [<ffffffff8149b2a6>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>  [<ffffffff8101f76b>] ? smp_apic_timer_interrupt+0x81/0x8f
>  [<ffffffff810b8222>] ? IS_ERR+0x25/0x2c
>  [<ffffffff810b8f22>] ? follow_page+0x28/0x2e3
>  [<ffffffff811219d8>] proc_pid_status+0x5e0/0x694
>  [<ffffffff81066072>] ? trace_hardirqs_on+0xd/0xf
>  [<ffffffff8111e42c>] proc_single_show+0x57/0x74
>  [<ffffffff810e90b4>] seq_read+0x249/0x49b
>  [<ffffffff8116c840>] ? security_file_permission+0x11/0x13
>  [<ffffffff810d05e1>] vfs_read+0xe0/0x141
>  [<ffffffff810d8191>] ? path_put+0x1d/0x21
>  [<ffffffff810d06f8>] sys_read+0x45/0x69
>  [<ffffffff8100b2ab>] system_call_fastpath+0x16/0x1b


