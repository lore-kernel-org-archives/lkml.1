Return-Path: <linux-kernel-owner+w=401wt.eu-S1422754AbXCNX4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422754AbXCNX4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 19:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422756AbXCNX4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 19:56:05 -0400
Received: from ozlabs.org ([203.10.76.45]:47569 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422754AbXCNX4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 19:56:03 -0400
Subject: Re: [PATCH 0/8] x86 boot, pda and gdt cleanups
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
In-Reply-To: <45F70E25.7050704@goop.org>
References: <1173184747.4644.23.camel@localhost.localdomain>
	 <45F70E25.7050704@goop.org>
Content-Type: text/plain
Date: Thu, 15 Mar 2007 10:55:41 +1100
Message-Id: <1173916541.19022.47.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-03-13 at 13:48 -0700, Jeremy Fitzhardinge wrote:
>     * init_gdt should always use write_gdt_entry when touching the gdt;
>       if it doesn't and it ends up touching an already-installed gdt
>       under Xen, it will get a write fault.  This happens because
>       init_gdt ends up getting called twice in SMP (see below).

Hmm, this invalidated my assumption that write_gdt_entry is always a
write to this cpu's active gdt.  Better fix is not to call it twice
anyway...

>     * init_gdt should always be called before bringing up the cpu,
>       rather than by the cpu itself (and therefore, cpu_init() shouldn't
>       call it).  Obviously the the boot cpu is an exception.

Makes sense.

>     * secondary_cpu_init stops being necessary.

Indeed.

>     * On SMP, init_gdt can get called twice: first time in
>       smp_prepare_boot_cpu, and a second time in  trap_init.  On UP,
>       trap_init is the only caller.

Getting rid of the call in smp_prepare_boot_cpu currently works, but
it's fragile:  __get_cpu_var(x) && per_cpu(x, smp_processor_id()) will
differ, and changes made to __get_cpu_var(x) will vanish...

Fortunately, UP doesn't have to call init_gdt at all, so I think it's
better to place it in smp_prepare_boot_cpu only and then clean up the UP
code.  I'll try now...

Rusty.

