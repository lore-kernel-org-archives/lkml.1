Return-Path: <linux-kernel-owner+w=401wt.eu-S1759924AbZBDX47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924AbZBDX47 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:56:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbZBDX4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:56:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:58521 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755446AbZBDX4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:56:49 -0500
Subject: Re: FW: [PATCH] powerpc/mm: Export HPAGE_SHIFT
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Roland Dreier <rdreier@cisco.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Eli Cohen <eli@mellanox.co.il>,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       Rusty Russell <rusty@rustcorp.com.au>
In-Reply-To: <adad4dym2zp.fsf@cisco.com>
References: <20090203164930.GA10101@mtls03> <ada8wonnh3t.fsf@cisco.com>
	 <1233712248.16867.131.camel@pasglop>
	 <20090203211329.d6190a08.akpm@linux-foundation.org>
	 <aday6wmn2vr.fsf@cisco.com>
	 <20090203222601.747ca8b7.akpm@linux-foundation.org>
	 <adad4dym2zp.fsf@cisco.com>
Content-Type: text/plain
Date: Thu, 05 Feb 2009 10:55:29 +1100
Message-Id: <1233791729.4612.28.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> get_user_pages() also gives us the vma back, and we can see from
> is_vm_hugetlb_page() (-- BTW can I just say that a function
> is_xxx_page() that operates on vmas is horribly misnamed --) that these
> pages all come from a hugetlb mapping, but figuring out the size of that
> mapping is I guess a challenge.

Note that g_u_p() has all sort of shortcommings... we were discussing
some of that recently due to bugs reported from the field.

The problem mostly is that you cannot guarantee that the physical page
will remain mapped to that virtual address in the process. For example,
if your code is part of some library used by an application, and that
application somewhere does a fork/exec (for example, a system() call to
run a shell helper), copy-on-write will hit, and you may end up with
the child process getting the original physical page and the original
process getting the copy...

So your HW will still DMA to a valid page (ie, it's count will have
been incremented) but it's not going to be the one the application
uses any more.

There are similar issues that can be cause, afaik, by madvise, etc...

We've been discussing that at KS with various people, Linus says g_u_p()
sucks, don't do that :-) Most of the time, the other approach should be
used, ie, the driver allocates memory, and userspace mmap's it, in which
case you get access to the VMA to set flags such as don't copy on fork.

An option possibly would be to make fork() pre-COW pages with an
elevated count to ensure that at least the original process is the one
to keep the original physical page... but that has other potential side
effects or performance issues.

A can of worms..

Cheers,
Ben.


