Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbYKNSNb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbYKNSNb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 13:13:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbYKNSNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 13:13:22 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:49304 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752363AbYKNSNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 13:13:21 -0500
Date: Fri, 14 Nov 2008 18:13:23 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Ingo Molnar <mingo@elte.hu>
cc: Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, linux-kernel@vger.kernel.org
Subject: CONFIG_OPTIMIZE_INLINING fun
Message-ID: <Pine.LNX.4.64.0811141804030.29883@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm wondering whether we need this patch: though perhaps it doesn't
matter, since OPTIMIZE_INLINING is already under kernel hacking and
defaulted off and there expressly for gathering feedback...

--- 2.6.28-rc4/arch/x86/Kconfig.debug	2008-10-24 09:27:47.000000000 +0100
+++ linux/arch/x86/Kconfig.debug	2008-11-14 16:26:15.000000000 +0000
@@ -302,6 +302,7 @@ config CPA_DEBUG
 
 config OPTIMIZE_INLINING
 	bool "Allow gcc to uninline functions marked 'inline'"
+	depends on !CC_OPTIMIZE_FOR_SIZE
 	help
 	  This option determines if the kernel forces gcc to inline the functions
 	  developers have marked 'inline'. Doing so takes away freedom from gcc to

I've been building with CC_OPTIMIZE_FOR_SIZE=y and OPTIMIZE_INLINING=y
for a while, but I've now taken OPTIMIZE_INLINING off, after noticing
the 83 " Page" and 202 constant_test_bit functions in my System.map:
it appears that the functions in include/linux/page-flags.h (perhaps
others I've not noticed) make OPTIMIZE_INLINING behave very stupidly
when CC_OPTIMIZE_FOR_SIZE is on (and somewhat even when off).

Those constant_test_bit()s show up noticeably in the profile of my
swapping load on an oldish P4 Xeon 2*HT: the average system time for an
iteration is 63.3 seconds when running a kernel built with both options
on, but 49.2 seconds when kernel is built with only CC_OPTIMIZE_FOR_SIZE.
Not put much effort into timing my newer machines: I think there's a
visible but lesser effect.

That was with the gcc 4.2.1 from openSUSE 10.3.  I've since tried the
gcc 4.3.2 from Ubuntu 8.10: which is much better on the " Page"s, only
6 of them - PageUptodate() reasonable though PagePrivate() mysterious;
but still 130 constant_test_bits, which I'd guess are the worst of it,
containing an idiv.  Hmm, with the 4.3.2, I get 77 constant_test_bits
with OPTIMIZE_INLINING on but CC_OPTIMIZE_FOR_SIZE off: that's worse
than 4.2.1, which only gave me 5 of them.  So, the patch above won't
help much then.

You'll be amused to see the asm for this example from mm/swap_state.c
(I was intending to downgrade these BUG_ONs to VM_BUG_ONs anyway, but
this example makes that seem highly desirable):

void __delete_from_swap_cache(struct page *page)
{
	BUG_ON(!PageLocked(page));
	BUG_ON(!PageSwapCache(page));
	BUG_ON(PageWriteback(page));
	BUG_ON(PagePrivate(page));

	radix_tree_delete(&swapper_space.page_tree, page_private(page));
and let's break it off there.

Here's the nice asm 4.2.1 gives with just CONFIG_CC_OPTIMIZE_FOR_SIZE=y
(different machine, this one a laptop with CONFIG_VMSPLIT_2G_OPT=y):

78173430 <__delete_from_swap_cache>:
78173430:	55                   	push   %ebp
78173431:	89 e5                	mov    %esp,%ebp
78173433:	53                   	push   %ebx
78173434:	89 c3                	mov    %eax,%ebx
78173436:	8b 00                	mov    (%eax),%eax
78173438:	a8 01                	test   $0x1,%al
7817343a:	74 45                	je     78173481 <__delete_from_swap_cache+0x51>
7817343c:	66 85 c0             	test   %ax,%ax
7817343f:	79 53                	jns    78173494 <__delete_from_swap_cache+0x64>
78173441:	f6 c4 10             	test   $0x10,%ah
78173444:	75 4a                	jne    78173490 <__delete_from_swap_cache+0x60>
78173446:	f6 c4 08             	test   $0x8,%ah
78173449:	75 3a                	jne    78173485 <__delete_from_swap_cache+0x55>
7817344b:	8b 53 0c             	mov    0xc(%ebx),%edx
7817344e:	b8 a4 9b 51 78       	mov    $0x78519ba4,%eax
78173453:	e8 f8 83 0d 00       	call   7824b850 <radix_tree_delete>

And here is what you get when you add in CONFIG_OPTIMIZE_INLINING=y:

7815eda4 <constant_test_bit>:
7815eda4:	55                   	push   %ebp
7815eda5:	b9 20 00 00 00       	mov    $0x20,%ecx
7815edaa:	89 e5                	mov    %esp,%ebp
7815edac:	53                   	push   %ebx
7815edad:	89 d3                	mov    %edx,%ebx
7815edaf:	99                   	cltd   
7815edb0:	f7 f9                	idiv   %ecx
7815edb2:	8b 04 83             	mov    (%ebx,%eax,4),%eax
7815edb5:	89 d1                	mov    %edx,%ecx
7815edb7:	5b                   	pop    %ebx
7815edb8:	5d                   	pop    %ebp
7815edb9:	d3 e8                	shr    %cl,%eax
7815edbb:	83 e0 01             	and    $0x1,%eax
7815edbe:	c3                   	ret    

7815edbf <PageLocked>:
7815edbf:	55                   	push   %ebp
7815edc0:	89 c2                	mov    %eax,%edx
7815edc2:	89 e5                	mov    %esp,%ebp
7815edc4:	31 c0                	xor    %eax,%eax
7815edc6:	e8 d9 ff ff ff       	call   7815eda4 <constant_test_bit>
7815edcb:	5d                   	pop    %ebp
7815edcc:	c3                   	ret    

7815edcd <PagePrivate>:
7815edcd:	55                   	push   %ebp
7815edce:	89 c2                	mov    %eax,%edx
7815edd0:	89 e5                	mov    %esp,%ebp
7815edd2:	b8 0b 00 00 00       	mov    $0xb,%eax
7815edd7:	e8 c8 ff ff ff       	call   7815eda4 <constant_test_bit>
7815eddc:	5d                   	pop    %ebp
7815eddd:	c3                   	ret    

7815edde <PageSwapCache>:
7815edde:	55                   	push   %ebp
7815eddf:	89 c2                	mov    %eax,%edx
7815ede1:	89 e5                	mov    %esp,%ebp
7815ede3:	b8 0f 00 00 00       	mov    $0xf,%eax
7815ede8:	e8 b7 ff ff ff       	call   7815eda4 <constant_test_bit>
7815eded:	5d                   	pop    %ebp
7815edee:	c3                   	ret    

[ unrelated functions ]

7815eecf <__delete_from_swap_cache>:
7815eecf:	55                   	push   %ebp
7815eed0:	89 e5                	mov    %esp,%ebp
7815eed2:	53                   	push   %ebx
7815eed3:	89 c3                	mov    %eax,%ebx
7815eed5:	e8 e5 fe ff ff       	call   7815edbf <PageLocked>
7815eeda:	85 c0                	test   %eax,%eax
7815eedc:	75 04                	jne    7815eee2 <__delete_from_swap_cache+0x13>
7815eede:	0f 0b                	ud2a   
7815eee0:	eb fe                	jmp    7815eee0 <__delete_from_swap_cache+0x11>
7815eee2:	89 d8                	mov    %ebx,%eax
7815eee4:	e8 f5 fe ff ff       	call   7815edde <PageSwapCache>
7815eee9:	85 c0                	test   %eax,%eax
7815eeeb:	75 04                	jne    7815eef1 <__delete_from_swap_cache+0x22>
7815eeed:	0f 0b                	ud2a   
7815eeef:	eb fe                	jmp    7815eeef <__delete_from_swap_cache+0x20>
7815eef1:	89 da                	mov    %ebx,%edx
7815eef3:	b8 0c 00 00 00       	mov    $0xc,%eax
7815eef8:	e8 a7 fe ff ff       	call   7815eda4 <constant_test_bit>
7815eefd:	85 c0                	test   %eax,%eax
7815eeff:	74 04                	je     7815ef05 <__delete_from_swap_cache+0x36>
7815ef01:	0f 0b                	ud2a   
7815ef03:	eb fe                	jmp    7815ef03 <__delete_from_swap_cache+0x34>
7815ef05:	89 d8                	mov    %ebx,%eax
7815ef07:	e8 c1 fe ff ff       	call   7815edcd <PagePrivate>
7815ef0c:	85 c0                	test   %eax,%eax
7815ef0e:	74 04                	je     7815ef14 <__delete_from_swap_cache+0x45>
7815ef10:	0f 0b                	ud2a   
7815ef12:	eb fe                	jmp    7815ef12 <__delete_from_swap_cache+0x43>
7815ef14:	8b 53 0c             	mov    0xc(%ebx),%edx
7815ef17:	b8 04 16 49 78       	mov    $0x78491604,%eax
7815ef1c:	e8 6a 09 0b 00       	call   7820f88b <radix_tree_delete>

Fun, isn't it?  I particularly admire the way it's somehow managed
not to create a function for PageWriteback - aah, that'll be because
there are no other references to PageWriteback in that unit.  The
4.3.2 asm is much less amusing, but calling constant_test_bit()
each time from __delete_from_swap_cache().

The numbers I've given are all for x86_32: similar story on x86_64,
though I've not spent as much time on that, just noticed all the
" Page"s there and hurried to switch off its OPTIMIZE_INLINING too.

I do wonder whether there's some tweak we could make to page-flags.h
which would stop this nonsense.  Change the inline functions back to
macros?  I suspect that by itself wouldn't work, and my quick attempt
to try it failed abysmally to compile, I've not the cpp foo needed.

A part of the problem may be that test_bit() etc. are designed for
arrays of unsigned longs, but page->flags is only the one unsigned long:
maybe gcc loses track of the optimizations available for that case when
CONFIG_OPTIMIZE_INLINING=y.

Hah, I've just noticed the defaults in arch/x86/configs -
you might want to change those...

Hugh
