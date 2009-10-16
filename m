Return-Path: <linux-kernel-owner+w=401wt.eu-S1758649AbZJPJtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758649AbZJPJtf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 05:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758581AbZJPJte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 05:49:34 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:54124 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758579AbZJPJtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 05:49:32 -0400
Subject: Re: kmemleak errors
From: Catalin Marinas <catalin.marinas@arm.com>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>
In-Reply-To: <804dabb00910152239m735708fai520abf6a39ab77e2@mail.gmail.com>
References: <804dabb00910142027r7f771ee4n2855fef7dcffbacc@mail.gmail.com>
	 <tnxfx9l9c0t.fsf@pc1117.cambridge.arm.com>
	 <804dabb00910152239m735708fai520abf6a39ab77e2@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 16 Oct 2009 10:48:36 +0100
Message-Id: <1255686516.3008.15.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Oct 2009 09:48:37.0415 (UTC) FILETIME=[D5711B70:01CA4E45]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-16 at 13:39 +0800, Peter Teoh wrote:
> sorry, i have overwritten the kernel image to follow up on another
> kernel bugzilla report.   but on another (32bit Fedora Core10) the
> following is the kmemleak output (scan > /sys/kernel/debug/kmemleak is
> done at least thrice) and the following output remained exactly not
> changed - not even a single byte modified:
> 
> unreferenced object 0xf70320a0 (size 32):
>   comm "swapper", pid 0, jiffies 4294667388
>   hex dump (first 32 bytes):
>     01 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
>     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<c08aa375>] kmemleak_alloc+0x100/0x13e
>     [<c0525ea9>] __kmalloc_track_caller+0x29f/0x315
>     [<c04ff1a8>] kmemdup+0x22/0x5a
>     [<c0624ad2>] selinux_cred_prepare+0x18/0x41
>     [<c0613437>] security_prepare_creds+0x15/0x18
>     [<c047af05>] prepare_creds+0xc4/0xeb
>     [<c047b537>] copy_creds+0x8a/0x2c5
>     [<c044eff6>] copy_process+0x31e/0x17bf
>     [<c04506ed>] do_fork+0x256/0x556
>     [<c04024d1>] kernel_thread+0x85/0x8d
>     [<c08a85ea>] rest_init+0x1e/0x5a
>     [<c0d34b5c>] start_kernel+0x383/0x388
>     [<c0d340ae>] i386_start_kernel+0xae/0xb3
>     [<ffffffff>] 0xffffffff

Possibly real leak. I cc'ed David Howells since he seems to be touching
this code more frequently.

> unreferenced object 0xf7253200 (size 32):
>   comm "swapper", pid 1, jiffies 4294669642
>   hex dump (first 32 bytes):
>     a0 36 25 f7 00 00 00 00 00 00 00 00 00 00 00 00  .6%.............
>     00 00 00 00 44 5f 25 f6 72 b7 47 c0 00 00 00 00  ....D_%.r.G.....
>   backtrace:
>     [<c08aa375>] kmemleak_alloc+0x100/0x13e
>     [<c0525147>] kmem_cache_alloc+0x184/0x20a
>     [<c0d5cb39>] kmemleak_test_init+0x25/0x6e8
>     [<c040116a>] do_one_initcall+0x78/0x1fb
>     [<c0d343e6>] kernel_init+0x160/0x1dd
>     [<c0404e33>] kernel_thread_helper+0x7/0x10
>     [<ffffffff>] 0xffffffff

Please disable the kmemleak testing module as it introduces leaks
explicitly for testing kmemleak.

> unreferenced object 0xf5c16270 (size 16):
>   comm "swapper", pid 1, jiffies 4294673952
>   hex dump (first 16 bytes):
>     01 00 00 00 01 00 00 00 03 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<c08aa375>] kmemleak_alloc+0x100/0x13e
>     [<c0525147>] kmem_cache_alloc+0x184/0x20a
>     [<c0620df4>] selinux_file_alloc_security+0x34/0xdd
>     [<c06132ed>] security_file_alloc+0x14/0x16
>     [<c0530b97>] get_empty_filp+0x10d/0x21d
>     [<c053f964>] do_filp_open+0x15d/0xebc
>     [<c052c10e>] do_sys_open+0x93/0x16a
>     [<c052c231>] sys_open+0x23/0x2b
>     [<c0401322>] init_post+0x35/0x18f
>     [<c0d34459>] kernel_init+0x1d3/0x1dd
>     [<c0404e33>] kernel_thread_helper+0x7/0x10
>     [<ffffffff>] 0xffffffff

Some of these could be triggered by an earlier leak, so resolving the
first one would automatically make the rest disappear. It could also be
that they are just false positive - pointers to them are stored in an
area not scanned by kmemleak (like the one below).

> unreferenced object 0xf58067c0 (size 32):
>   comm "modprobe", pid 2123, jiffies 4294698474
>   hex dump (first 32 bytes):
>     34 7e 60 f8 c0 6f 80 f5 50 d5 da f5 60 d5 da f5  4~`..o..P...`...
>     00 00 00 00 00 00 00 00 02 00 00 00 00 00 00 00  ................
>   backtrace:
>     [<c08aa375>] kmemleak_alloc+0x100/0x13e
>     [<c0525147>] kmem_cache_alloc+0x184/0x20a
>     [<c04d3973>] trace_define_field+0x23/0x192
>     [<c04d3aff>] trace_define_common_fields+0x1d/0x12a
>     [<f85d3c7e>] ftrace_define_fields_i915_ring_wait_end+0x10/0x67 [i915]
>     [<c04d3069>] event_create_dir+0x3d7/0x45a
>     [<c04d33f3>] trace_module_notify+0x307/0x568
>     [<c08c89d8>] notifier_call_chain+0x30/0x7f
>     [<c0479958>] __blocking_notifier_call_chain+0x52/0x67
>     [<c047997e>] blocking_notifier_call_chain+0x11/0x13
>     [<c0493009>] sys_init_module+0xd9/0x273
>     [<c04041d8>] sysenter_do_call+0x12/0x2d
>     [<ffffffff>] 0xffffffff

These look like false positives since kmemleak doesn't scan all the
sections in a module. I proposed a patch here:

http://lkml.org/lkml/2009/10/15/155

But it doesn't seem to fix it. I'll send another.

-- 
Catalin

