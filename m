Return-Path: <linux-kernel-owner+w=401wt.eu-S1755705AbYJPJ6R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755705AbYJPJ6R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 05:58:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752941AbYJPJ6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 05:58:04 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:10752 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656AbYJPJ6C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 05:58:02 -0400
Message-Id: <48F72C7A.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 Beta 
Date: Thu, 16 Oct 2008 10:58:50 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       "Chris Lalancette" <clalance@redhat.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH]: Fix Xen domU boot with batched	
	 mprotect
References: <48F5CE10.3060403@redhat.com> <48F6274D.76E4.0078.0@novell.com>
 <48F61919.2050005@goop.org>
In-Reply-To: <48F61919.2050005@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Jeremy Fitzhardinge <jeremy@goop.org> 15.10.08 18:23 >>>
>virt_addr_valid() is supposed to be usable in this circumstace.  The 
>comment says "virt_to_page(kaddr) returns a valid pointer if and only if 
>virt_addr_valid(kaddr) returns true", which implies that 
>virt_addr_valid() returns a meaningful result on all addresses - and if 
>not, it should be fixed.

Where did you find this comment? I had no luck grep-ing for it...

In any case, if that's the expectation, then on i386 virt_addr_valid()
must be implemented as something like

#define virt_addr_valid(kaddr) ((kaddr) >= PAGE_OFFSET && (kaddr) < high_memory && pfn_valid(__pa(kaddr) >> PAGE_SHIFT))

x86-64 would need something similar, except that high_memory obviously
must be replaced (or that part could perhaps be left out altogether), and
the un-mapped addresses above the kernel mapping would need to be
filtered out.

Btw., if you look at other architectures, you'll see that most of them use
the same (as you say broken) construct.

Otoh, if that cited statement really holds, then virt_addr_valid() isn't
really expected to do what its name implies: In particular, there are
valid address ranges in kernel space which it wouldn't be permitted to
return true on without significantly complicating the virt_to_page()
implementation (e.g. x86-64's vmalloc and modules areas).

As to the original issue - as long as domains are given enough memory
(i.e. the range of valid pfn-s is large enough), with the current state of
virt_addr_valid() the patch presented ought to not help at all:

This code

static inline void _check_virt(const char*msg, void *v) {
 unsigned long pfn = __pa(v) >> PAGE_SHIFT;
 printk("%s: %p %08lx %d:%d\n", msg, v, pfn, pfn_valid(pfn), virt_addr_valid(v));
}
static int __init check_virt(void) {
 _check_virt("null", NULL);
 _check_virt("half", (void *)LONG_MAX);
 _check_virt("hm-p", high_memory - PAGE_SIZE);
 _check_virt("hm-1", high_memory - 1);
 _check_virt("hm", high_memory);
 _check_virt("hm+1", high_memory + 1);
 _check_virt("hm+p", high_memory + PAGE_SIZE);
 _check_virt("km", (void *)__fix_to_virt(FIX_KMAP_BEGIN));
 _check_virt("hv", (void *)HYPERVISOR_VIRT_START);
 return 0;
}
late_initcall(check_virt);

yields a positive indication from virt_addr_valid() on all tested addresses:

<4>null: 00000000 00040000 1:1
<4>half: 7fffffff 000bffff 1:1
<4>hm-p: ed7ff000 0002d7ff 1:1
<4>hm-1: ed7fffff 0002d7ff 1:1
<4>hm: ed800000 0002d800 1:1
<4>hm+1: ed800001 0002d800 1:1
<4>hm+p: ed801000 0002d801 1:1
<4>km: f56fa000 000356fa 1:1
<4>hv: f5800000 00035800 1:1

Jan

