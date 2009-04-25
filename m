Return-Path: <linux-kernel-owner+w=401wt.eu-S1754129AbZDYWQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129AbZDYWQj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 18:16:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752852AbZDYWQa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 18:16:30 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:32096 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752150AbZDYWQ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 18:16:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oSCJLow1067wpJWncU3aWZP4dxIRr7wehv4rLV5yTxDYfp/nGIecZ7ItXEGbQZXdRq
         AMXq8Z8av8xNHL/0mPkte1tvDlXvnsG3FGDzlDCaMTUWEknlgNGAfMDM9gE/ZSf9R4pX
         qM6qQYRUqkDgfG+LaQtvT6jpTa0uWdW6H0doU=
MIME-Version: 1.0
In-Reply-To: <49D0361C.3060901@goop.org>
References: <3e8340490903252341u55abbc3aree9afc1b0a7703e6@mail.gmail.com>
	 <49D0361C.3060901@goop.org>
Date: Sat, 25 Apr 2009 18:10:28 -0400
Message-ID: <3e8340490904251510r5938b773r7b313555c91e214a@mail.gmail.com>
Subject: Re: Bug: ptrace issues under x86_64 Xen kernel 2.6.29
From: Bryan Donlan <bdonlan@gmail.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: LKML <linux-kernel@vger.kernel.org>, xen-devel@lists.xensource.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 29, 2009 at 11:01 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Bryan Donlan wrote:
>>
>> Using 2.6.29 or 2.6.28 as a 64-bit Xen domU, a number of ptrace()
>> users seem to have issues with unexpected breakpoints. ltrace and gdb
>> both seem to be affected, under both 64-bit and 32-bit userspace.
>> 32-bit kernels do not seem to be affected. Typical symptoms look like:
>>
>
> It looks like this is because the kernel sets up int3 (breakpoint) and debug
> (watchpoints, etc) to be on a separate debug stack in the tss.  Xen doesn't
> do this (and doesn't appear to have a mechanism to do so), so I guess the
> on-stack format isn't what the kernel expects.  Does the patch below work?

Hi,

Sorry for the late reply; this message never made it to my inbox for
some reason...
I did try the patch, and saw similar results to Mark; ptrace works,
but lots of warnings:
------------[ cut here ]------------
WARNING: at arch/x86/xen/enlighten.c:447 cvt_gate_to_trap+0xe6/0xf0()
Modules linked in:
Pid: 0, comm: swapper Tainted: G        W
2.6.30-rc3-ptracefix-00330-g6d03473 #4
Call Trace:
 [<ffffffff8075e9b0>] ? stack_segment+0x0/0x30
 [<ffffffff8075e9b0>] ? stack_segment+0x0/0x30
 [<ffffffff8023ec4a>] ? warn_slowpath+0xea/0x160
 [<ffffffff8020dd79>] ? xen_force_evtchn_callback+0x9/0x10
 [<ffffffff8020e512>] ? check_events+0x12/0x20
 [<ffffffff8020dd79>] ? xen_force_evtchn_callback+0x9/0x10
 [<ffffffff8020e512>] ? check_events+0x12/0x20
 [<ffffffff8020e512>] ? check_events+0x12/0x20
 [<ffffffff8020e4ff>] ? xen_restore_fl_direct_end+0x0/0x1
 [<ffffffff8023f86f>] ? vprintk+0x1df/0x3f0
 [<ffffffff8020bb49>] ? __raw_callee_save_xen_pmd_val+0x11/0x1e
 [<ffffffff8020d928>] ? make_lowmem_page_readonly+0x28/0x40
 [<ffffffff8075e9b0>] ? stack_segment+0x0/0x30
 [<ffffffff8020a996>] ? cvt_gate_to_trap+0xe6/0xf0
 [<ffffffff8020a9f9>] ? xen_convert_trap_info+0x59/0xa0
 [<ffffffff8020b0cf>] ? xen_load_idt+0x3f/0x70
 [<ffffffff809b3b3f>] ? cpu_init+0xf0/0x2da
 [<ffffffff809b19a6>] ? cpu_bringup_and_idle+0x6/0x71
---[ end trace 4eaa2a86a8e2da36 ]---

Thanks,

Bryan Donlan
