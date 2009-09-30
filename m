Return-Path: <linux-kernel-owner+w=401wt.eu-S1755117AbZI3TPk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755117AbZI3TPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 15:15:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbZI3TPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 15:15:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37132 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754686AbZI3TPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 15:15:38 -0400
Date: Wed, 30 Sep 2009 12:14:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Arnd Bergmann <arnd@arndb.de>
cc: "H. Peter Anvin" <hpa@zytor.com>, Arjan van de Ven <arjan@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, mingo@elte.hu,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-api@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [RFC][v7][PATCH 8/9]: Define clone2() syscall
In-Reply-To: <200909301959.41706.arnd@arndb.de>
Message-ID: <alpine.LFD.2.01.0909301208410.6996@localhost.localdomain>
References: <20090924165548.GA16586@us.ibm.com> <200909301815.45211.arnd@arndb.de> <alpine.LFD.2.01.0909300925170.6996@localhost.localdomain> <200909301959.41706.arnd@arndb.de>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Sep 2009, Arnd Bergmann wrote:
> 
> Right, you still need to save all the registers from the entry code.
> I was under the wrong assumption that task_pt_regs(current)
> would give the full register set on all architectures.
> 
> However, I'd still hope that a new system call can be defined in
> a way that you only need to have an assembly wrapper to save
> the full pt_regs, but no arch specific code to get the syscall arguments
> out of that again. In do_clone(), you need a pointer to pt_regs and
> the user stack pointer, but that can be generated from
> user_stack_pointer(regs).

I don't think it can. You don't know what the system call stack layout is. 

> Does task_pt_regs(current) give the right pointer on all architectures
> or do we also need to pass the regs into the syscall?

I do not believe that it gives the right pointer in general. In fact, I 
can guarantee it doesn't. Even on x86 it only works for certain contexts 
(non-vm86 mode at a minimum), and on architectures like alpha it's not at 
all sufficient, because even if you can locate the 'pt_regs' structure, 
you _also_ need the extra guarantees of the pt_regs being next to the 
extended signal state register structure - and that only happens for magic 
sequences like signal handling and explicit setups like fork/clone.

So I do repeat: if you think you can do all of this in generic code, then 
you're sadly and totally mistaken. Don't even try. It may work on some 
architectures, but it's simply fundamentally _wrong_.

		Linus
