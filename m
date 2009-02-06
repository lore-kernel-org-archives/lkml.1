Return-Path: <linux-kernel-owner+w=401wt.eu-S1757374AbZBFV5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374AbZBFV5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 16:57:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbZBFV5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 16:57:40 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45651 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753505AbZBFV5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 16:57:39 -0500
Date: Fri, 6 Feb 2009 13:57:18 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>, roland@redhat.com,
       linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
       heiko.carstens@de.ibm.com
Subject: Re: [BUG] binfmt_elf: get_user() called in vma_dump_size() after
 set_fs(KERNEL_DS)
In-Reply-To: <20090206134410.d548b72c.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0902061351390.3048@localhost.localdomain>
References: <1233940235.22140.9.camel@localhost.localdomain> <20090206134410.d548b72c.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 6 Feb 2009, Andrew Morton wrote:

> On Fri, 06 Feb 2009 18:10:35 +0100
> Gerald Schaefer <gerald.schaefer@de.ibm.com> wrote:
> > 
> > elf_core_dump() does a set_fs(KERNEL_DS) and then calls vma_dump_size(),
> > which uses get_user() to check for an ELF header at vma->vm_start in the
> > user mapping. This is a bug because vm_start is a user virtual address and
> > get_user() will fail or even read from a kernel address (KERNEL_DS).
> > 
> > Maybe a get_user_pages() should be used to get the user data, or a temporary
> > set_fs(USER_DS)?
> > 
> 
> Could use __get_user() to skip the access_ok() check?

That's not the problem.

The problem is that
 (a) some architectures actually use separate address spaces (sparc, at 
     least), so using "get_user()" while you are in KERNEL_DS will 
     literally access the wrong thing.

     __get_user doesn't affect this part.

 (b) the security one: KERNEL_DS will change the access checks that 
     get_user() does, and allow access to kernel memory.

     Using __get_user _does_ affect this part by removing the checks, but 
     since the problem was that KERNEL_DS already _weakened_ the checks, 
     removign the too-weak checking doesn't actually help.

> We'd need to be sure that the address isn't a kernel address or iomem
> or something. 

As mentioned, even this won't actually help. On at least some sparc 
machines (sparc64?), memory accesses really are segmented, with different 
address spaces for user and kernel mode, so a user and kernel address may 
actually have the exact same pointer value, but point to different memory!

So you can't just check the address. You really have to do the whole 
"set_fs()" thing to set the segment register.

		Linus
