Return-Path: <linux-kernel-owner+w=401wt.eu-S1758556AbYFKW4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758556AbYFKW4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 18:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbYFKW4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 18:56:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33847 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752770AbYFKW4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 18:56:07 -0400
Date: Wed, 11 Jun 2008 15:55:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: righi.andrea@gmail.com
Cc: balbir@linux.vnet.ibm.com, linux-mm@kvack.org, skumar@linux.vnet.ibm.com,
       yamamoto@valinux.co.jp, menage@google.com, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, xemul@openvz.org,
       kamezawa.hiroyu@jp.fujitsu.com
Subject: Re: [-mm][PATCH 2/4] Setup the memrlimit controller (v5)
Message-Id: <20080611155530.099a54d6.akpm@linux-foundation.org>
In-Reply-To: <485055FF.9020500@gmail.com>
References: <20080521152921.15001.65968.sendpatchset@localhost.localdomain>
	<20080521152948.15001.39361.sendpatchset@localhost.localdomain>
	<4850070F.6060305@gmail.com>
	<20080611121510.d91841a3.akpm@linux-foundation.org>
	<485032C8.4010001@gmail.com>
	<20080611134323.936063d3.akpm@linux-foundation.org>
	<485055FF.9020500@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jun 2008 00:47:27 +0200
Andrea Righi <righi.andrea@gmail.com> wrote:

> Andrew Morton wrote:
> >> At least we could add something like:
> >>
> >> #ifdef CONFIG_32BIT
> >> #define PAGE_ALIGN64(addr) (((((addr)+PAGE_SIZE-1))>>PAGE_SHIFT)<<PAGE_SHIFT)
> >> #else
> >> #define PAGE_ALIGN64(addr) PAGE_ALIGN(addr)
> >> #endif
> >>
> >> But IMHO the single PAGE_ALIGN64() implementation is more clear.
> > 
> > No, we should just fix PAGE_ALIGN.  It should work correctly when
> > passed a long-long.  Otherwse it's just a timebomb.
> > 
> > This:
> > 
> > #define PAGE_ALIGN(addr) ({				\
> > 	typeof(addr) __size = PAGE_SIZE;		\
> > 	typeof(addr) __mask = PAGE_MASK;		\
> > 	(addr + __size - 1) & __mask;			\
> > })
> > 
> > (with a suitable comment) does what we want.  I didn't check to see
> > whether this causes the compiler to generate larger code, but it
> > shouldn't.
> > 
> 
> No, it doesn't work. The problem seems to be in the PAGE_MASK definition
> (from include/asm-x86/page.h for example):
> 
> /* PAGE_SHIFT determines the page size */
> #define PAGE_SHIFT      12
> #define PAGE_SIZE       (_AC(1,UL) << PAGE_SHIFT)
> #define PAGE_MASK       (~(PAGE_SIZE-1))
> 
> The "~" is performed on a 32-bit value, so everything in "and" with
> PAGE_MASK greater than 4GB will be truncated to the 32-bit boundary.

OK, I oversimplified my testcase.

> What do you think about the following?
> 
> #define PAGE_SIZE64 (1ULL << PAGE_SHIFT)
> #define PAGE_MASK64 (~(PAGE_SIZE64 - 1))
> 
> #define PAGE_ALIGN(addr) ({					\
> 	typeof(addr) __size = PAGE_SIZE;			\
> 	typeof(addr) __ret = (addr) + __size - 1;		\
> 	__ret > -1UL ? __ret & PAGE_MASK64 : __ret & PAGE_MASK;	\
> })

Complex.  And I'd worry about added code overhead.

What about

#define PAGE_ALIGN(addr) ALIGN(addr, PAGE_SIZE)

?

afaict ALIGN() tries to do the right thing, and if it doesn't, we
should fix ALIGN().

