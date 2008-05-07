Return-Path: <linux-kernel-owner+w=401wt.eu-S1757410AbYEGRMQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbYEGRMQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 13:12:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbYEGRL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 13:11:57 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:41051 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbYEGRLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 13:11:55 -0400
Subject: Re: [Cbe-oss-dev] [PATCH] Updated: Reworked Cell OProfile: SPU
	mutex lock fix
From: Carl Love <cel@us.ibm.com>
To: jroth@linux.vnet.ibm.com
Cc: linuxppc-dev@ozlabs.org, cbe-oss-dev@ozlabs.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>
In-Reply-To: <4821DEB0.7050308@linux.vnet.ibm.com>
References: <1209587712.7531.42.camel@carll-linux-desktop>
	 <4821DEB0.7050308@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 07 May 2008 10:09:26 -0700
Message-Id: <1210180166.7726.19.camel@carll-linux-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-05-07 at 18:54 +0200, Jochen Roth wrote:
> Carl,
> 
> I applied your patch on Jeremy's latest kernel.org spufs tree.
> 
>  > +void oprofile_add_value(unsigned long value, int cpu) {
>  > +	struct oprofile_cpu_buffer * cpu_buf = &cpu_buffer[cpu];
> 
> Shouldn't it be
> 	struct oprofile_cpu_buffer *cpu_buf = &per_cpu(cpu_buffer, cpu);

No, I don't think so.  Take a look at the other functions in
drivers/oprofile/cpu_buffer.c.  For example oprofile_add_trace().  You
will see that the cpu_buffer is not accessed using the per_cpu
construct.  Not sure why the compiler would complain about the
oprofile_add_value() function but not one of the other functions like
oprofile_add_trace().

What was the compiler error that you saw?

I will try getting Jeremy's kernel and applying the patch there to see
if it works.


> 
> At least my compiler complained about that.
> 
> I booted a kernel with your patches applied and the system locked up 
> anyway:
> 
> Unable to handle kernel paging request for data at address 
> 0xd0000000004fe9a8
> Faulting instruction address: 0xd000000000330ad8
> cpu 0x0: Vector: 300 (Data Access) at [c00000003c337680]
>      pc: d000000000330ad8: .alloc_cpu_buffers+0x7c/0x12c [oprofile]
>      lr: d000000000330abc: .alloc_cpu_buffers+0x60/0x12c [oprofile]
>      sp: c00000003c337900
>     msr: 9000000000009032
>     dar: d0000000004fe9a8
>   dsisr: 42000000
>    current = 0xc00000003e128600
>    paca    = 0xc0000000005b3480
>      pid   = 2356, comm = oprofiled
> enter ? for help
> [c00000003c3379a0] d0000000003302ac .oprofile_setup+0x2c/0x134 [oprofile]
> [c00000003c337a30] d00000000033176c .event_buffer_open+0x7c/0xc8 [oprofile]
> [c00000003c337ac0] c0000000000d6ca8 .__dentry_open+0x190/0x308
> [c00000003c337b70] c0000000000e7a5c .do_filp_open+0x3c4/0x8e8
> [c00000003c337d00] c0000000000d6a1c .do_sys_open+0x80/0x14c
> [c00000003c337db0] c0000000001192f4 .compat_sys_open+0x24/0x38
> [c00000003c337e30] c0000000000076b4 syscall_exit+0x0/0x40
> --- Exception: c01 (System Call) at 000000000ff006f8
> SP (ffc6f6a0) is in userspace
> 

