Return-Path: <linux-kernel-owner+w=401wt.eu-S1757221AbYD2MeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757221AbYD2MeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 08:34:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbYD2MeO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 08:34:14 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49567
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752626AbYD2MeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 08:34:13 -0400
Date: Tue, 29 Apr 2008 05:34:12 -0700 (PDT)
Message-Id: <20080429.053412.15412725.davem@davemloft.net>
To: tglx@linutronix.de
Cc: torvalds@linux-foundation.org, harvey.harrison@gmail.com, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bitops: remove "optimizations"
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080429.030332.88897602.davem@davemloft.net>
References: <alpine.LFD.1.10.0804281233090.3119@woody.linux-foundation.org>
	<alpine.LFD.1.10.0804291141580.3261@apollo.tec.linutronix.de>
	<20080429.030332.88897602.davem@davemloft.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Tue, 29 Apr 2008 03:03:32 -0700 (PDT)

> From: Thomas Gleixner <tglx@linutronix.de>
> Date: Tue, 29 Apr 2008 12:01:02 +0200 (CEST)
> 
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> Acked-by: David S. Miller <davem@davemloft.net>

Ironically, I just bisected sparc64 bootup failures to the following
changeset.  It's very late here, and I haven't looked into the
details, but it seems to wedge in free_area_init_nodes() on a non-NUMA
system with CONFIG_NUMA disabled.

Isn't it funny that this optimization not only was useless, but also
broke things. :-/

64970b68d2b3ed32b964b0b30b1b98518fde388e is first bad commit
commit 64970b68d2b3ed32b964b0b30b1b98518fde388e
Author: Alexander van Heukelum <heukelum@mailshack.com>
Date:   Tue Mar 11 16:17:19 2008 +0100

    x86, generic: optimize find_next_(zero_)bit for small constant-size bitmaps
    
    This moves an optimization for searching constant-sized small
    bitmaps form x86_64-specific to generic code.
    
    On an i386 defconfig (the x86#testing one), the size of vmlinux hardly
    changes with this applied. I have observed only four places where this
    optimization avoids a call into find_next_bit:
    
    In the functions return_unused_surplus_pages, alloc_fresh_huge_page,
    and adjust_pool_surplus, this patch avoids a call for a 1-bit bitmap.
    In __next_cpu a call is avoided for a 32-bit bitmap. That's it.
    
    On x86_64, 52 locations are optimized with a minimal increase in
    code size:
    
    Current #testing defconfig:
        146 x bsf, 27 x find_next_*bit
       text    data     bss     dec     hex filename
       5392637  846592  724424 6963653  6a41c5 vmlinux
    
    After removing the x86_64 specific optimization for find_next_*bit:
        94 x bsf, 79 x find_next_*bit
       text    data     bss     dec     hex filename
       5392358  846592  724424 6963374  6a40ae vmlinux
    
    After this patch (making the optimization generic):
        146 x bsf, 27 x find_next_*bit
       text    data     bss     dec     hex filename
       5392396  846592  724424 6963412  6a40d4 vmlinux
    
    [ tglx@linutronix.de: build fixes ]
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

:040000 040000 c0407f7df7dc5333c78c300780931a269ae0dedd 2f6ef634a35b6dd46e40ea70128c39a742e60501 M      include
:040000 040000 556ee6ccb15cdbb1aa5a690c732a5492d58dfe6f 937d05977f46056c12b5da64ca62959c06a912c0 M      lib
