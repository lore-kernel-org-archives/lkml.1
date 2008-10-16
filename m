Return-Path: <linux-kernel-owner+w=401wt.eu-S1756234AbYJPQKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756234AbYJPQKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 12:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756064AbYJPQKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 12:10:33 -0400
Received: from gw.goop.org ([64.81.55.164]:49252 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756043AbYJPQKc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 12:10:32 -0400
Message-ID: <48F76773.2090700@goop.org>
Date: Thu, 16 Oct 2008 09:10:27 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Chris Lalancette <clalance@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH]: Fix Xen domU boot with batched		 mprotect
References: <48F5CE10.3060403@redhat.com> <48F6274D.76E4.0078.0@novell.com> <48F61919.2050005@goop.org> <48F72C7A.76E4.0078.0@novell.com>
In-Reply-To: <48F72C7A.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>>>> Jeremy Fitzhardinge <jeremy@goop.org> 15.10.08 18:23 >>>
>>>>         
>> virt_addr_valid() is supposed to be usable in this circumstace.  The 
>> comment says "virt_to_page(kaddr) returns a valid pointer if and only if 
>> virt_addr_valid(kaddr) returns true", which implies that 
>> virt_addr_valid() returns a meaningful result on all addresses - and if 
>> not, it should be fixed.
>>     
>
> Where did you find this comment? I had no luck grep-ing for it...
>   

It's in tip.git, which has quite a few changes in this area.

http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=blob;f=include/asm-x86/page.h;h=d4f1d5791fc186f29a9a60d4fe182d80f05038e4;hb=HEAD
http://git.kernel.org/?p=linux/kernel/git/x86/linux-2.6-tip.git;a=blob;f=arch/x86/mm/ioremap.c;h=ae71e11eb3e5e4ddeceadc9128d3afea564f27e0;hb=HEAD

> In any case, if that's the expectation, then on i386 virt_addr_valid()
> must be implemented as something like
>
> #define virt_addr_valid(kaddr) ((kaddr) >= PAGE_OFFSET && (kaddr) < high_memory && pfn_valid(__pa(kaddr) >> PAGE_SHIFT))
>
> x86-64 would need something similar, except that high_memory obviously
> must be replaced (or that part could perhaps be left out altogether), and
> the un-mapped addresses above the kernel mapping would need to be
> filtered out.
>
> Btw., if you look at other architectures, you'll see that most of them use
> the same (as you say broken) construct.
>
> Otoh, if that cited statement really holds, then virt_addr_valid() isn't
> really expected to do what its name implies: In particular, there are
> valid address ranges in kernel space which it wouldn't be permitted to
> return true on without significantly complicating the virt_to_page()
> implementation (e.g. x86-64's vmalloc and modules areas).
>   

The current x86-64 implementation is:

bool __virt_addr_valid(unsigned long x)
{
	if (x >= __START_KERNEL_map) {
		x -= __START_KERNEL_map;
		if (x >= KERNEL_IMAGE_SIZE)
			return false;
		x += phys_base;
	} else {
		if (x < PAGE_OFFSET)
			return false;
		x -= PAGE_OFFSET;
		if (system_state == SYSTEM_BOOTING ?
				x > MAXMEM : !phys_addr_valid(x)) {
			return false;
		}
	}

	return pfn_valid(x >> PAGE_SHIFT);
}

and 32-bit is similar (but simpler, since it doesn't need to worry about a separate kernel mapping).


>
> yields a positive indication from virt_addr_valid() on all tested addresses:
>
> <4>null: 00000000 00040000 1:1
> <4>half: 7fffffff 000bffff 1:1
> <4>hm-p: ed7ff000 0002d7ff 1:1
> <4>hm-1: ed7fffff 0002d7ff 1:1
> <4>hm: ed800000 0002d800 1:1
> <4>hm+1: ed800001 0002d800 1:1
> <4>hm+p: ed801000 0002d801 1:1
> <4>km: f56fa000 000356fa 1:1
> <4>hv: f5800000 00035800 1:1
>   

It would be interesting to try that with tip.git's version of 
__virt_addr_valid().  In the Xen case, all we need is a guarantee that 
virt_addr_valid() returns true iff __pa(addr) returns a proper result, 
so that we can use the resulting pfn as an index into pfn->mfn.  I 
believe this is what the current implementation does.

    J
