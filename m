Return-Path: <linux-kernel-owner+w=401wt.eu-S1757459AbZFTTCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459AbZFTTCS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 15:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755269AbZFTTCJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 15:02:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58961 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754996AbZFTTCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 15:02:08 -0400
Date: Sat, 20 Jun 2009 12:01:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] core kernel fixes
In-Reply-To: <alpine.LFD.2.01.0906201132020.4160@localhost.localdomain>
Message-ID: <alpine.LFD.2.01.0906201154230.4160@localhost.localdomain>
References: <20090620173022.GA14145@elte.hu> <alpine.LFD.2.01.0906201132020.4160@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 20 Jun 2009, Linus Torvalds wrote:
> 
> On x86, the natural way to do what you want done is ONE SINGLE 
> INSTRUCTION! As far as I can tell, the above crazy function is 100% 
> equivalent to this:
> 
> 	asm __inline__("lock ; addl $0,%0":"+m" (*uaddr): :"memory", "cc");
> 
> which really makes me think that using "get_user_pages_fast()" for it is 
> some truly crazy crap.

We could also take the opposite approach - knowing that this is called 
only when the page doesn't exist, and just doing

	down_read(mmap_sem)
	vma = find_vma(..)
	ret = VM_FAULT_ERROR;
	if (vma && vma->vm_start <= address)
		ret = handle_mm_fault(mm, vma, address, 1);
	up_read(mmap_sem);
	return (ret & VM_FAULT_ERROR) ? -EFAULT : 0;

or something like that. Again, that looks saner than using 
get_user_pages() for this and then dropping the page.

		Linus
