Return-Path: <linux-kernel-owner+w=401wt.eu-S1757893AbYBHWod@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757893AbYBHWod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:44:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763429AbYBHWgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:36:13 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59435 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762608AbYBHWgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:36:10 -0500
Date: Fri, 8 Feb 2008 14:35:32 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Harvey Harrison <harvey.harrison@gmail.com>, viro@ZenIV.linux.org.uk,
       linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] fix sparse warning from include/linux/mmzone.h
In-Reply-To: <alpine.LFD.1.00.0802081401410.2896@woody.linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0802081421590.2896@woody.linux-foundation.org>
References: <1202417543.31361.5.camel@brick> <20080208135154.ccdac0c1.akpm@linux-foundation.org> <alpine.LFD.1.00.0802081401410.2896@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 8 Feb 2008, Linus Torvalds wrote:
> 
> It would probably make more sense to just write it as something like
> 
> 	struct zone *base = zone->zone_pgdat->node_zones;
> 
> 	if (zone == base + ZONE_HIGHMEM ||
> 		(zone == base + ZONE_MOVABLE && zone_movable_is_highmem());

Side note: while the above is more readable, gcc still isn't smart enough 
to notice that the two compares could be done more efficiently as a 
subtraction. But using an actual pointer subtraction does involve that 
nasty divide (well, it's nasty only for certain sizes of "struct zone"), 
so writing it as such is not very nice either, even if it's the most 
obvious way from a source code standpoint.

Here's an example:

	/* 12-byte (non-power-of-two) example struct */
	struct example {
	        int a, b, c;
	};
	
	#define ptrcmp1(ptr, base, index) \
	        ((ptr) == (base) + (index))
	#define ptrcmp2(ptr, base, index) \
	        ((ptr) - (base) == (index))
	#define ptrcmp3(ptr, base, index) \
	        ((char *)(ptr) - (char *)(base) == (index)*sizeof(*ptr))

	#define test(cmp) \
	        if (cmp(ptr, base, 1) || cmp(ptr, base, 3)) \
	                printf("success\n")

	int test1(struct example *ptr, struct example *base) { test(ptrcmp1); }
	int test2(struct example *ptr, struct example *base) { test(ptrcmp2); }
	int test3(struct example *ptr, struct example *base) { test(ptrcmp3); }

and the results for me are:

	test1:
	        leaq    12(%rsi), %rax
	        cmpq    %rdi, %rax
	        je      .L15
	        leaq    36(%rsi), %rax
	        cmpq    %rdi, %rax
	        je      .L15

	test2:
	        subq    %rsi, %rdi
	        leaq    -12(%rdi), %rax
	        cmpq    $11, %rax
	        jbe     .L11
	        leaq    -36(%rdi), %rax
	        cmpq    $11, %rax
	        jbe     .L11

	test3:
	        subq    %rsi, %rdi
	        cmpq    $12, %rdi
	        je      .L4
	        cmpq    $36, %rdi
	        je      .L4

ie the only way to get the *nice* code generation is that ugly third 
alternative.

YMMV depending on compiler, of course.

			Linus
