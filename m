Return-Path: <linux-kernel-owner+w=401wt.eu-S1752978AbZAHOOA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978AbZAHOOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 09:14:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753075AbZAHONv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 09:13:51 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:58101 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbZAHONv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 09:13:51 -0500
Subject: Re: Is 386 processor still supported?
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Adam Osuchowski <adwol@zonk.pl>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <alpine.LRH.1.10.0901081359520.24105@twin.jikos.cz>
References: <20090108120338.6b8b4567@zonk.pl>
	 <alpine.LRH.1.10.0901081359520.24105@twin.jikos.cz>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Jan 2009 15:13:45 +0100
Message-Id: <1231424025.11687.447.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-08 at 14:05 +0100, Jiri Kosina wrote:
> [ CCs added ]
> 
> On Thu, 8 Jan 2009, Adam Osuchowski wrote:
> 
> > Recently, I found such piece of code in kernel 2.6.28 compiled for 386
> > processor:
> > 
> > # grep M386 .config
> > CONFIG_M386=y
> > # objdump -d vmlinux | grep -A11 '<_spin_lock>:'
> > c0321827 <_spin_lock>:
> > c0321827:	89 e2                	mov    %esp,%edx
> > c0321829:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
> > c032182f:	ff 42 14             	incl   0x14(%edx)
> > c0321832:	ba 00 01 00 00       	mov    $0x100,%edx
> > c0321837:	f0 66 0f c1 10       	lock xadd %dx,(%eax)
> > c032183c:	38 f2                	cmp    %dh,%dl
> > c032183e:	74 06                	je     c0321846 <_spin_lock+0x1f>
> > c0321840:	f3 90                	pause  
> > c0321842:	8a 10                	mov    (%eax),%dl
> > c0321844:	eb f6                	jmp    c032183c <_spin_lock+0x15>
> > c0321846:	c3                   	ret    
> > 
> > But there is no xadd instruction on 386 processors. It is available on
> > 486+ only. I have no chance to run this kernel on real 386 box, so I can't
> > check it in practice, but I think it will not run.
> > 
> > It is not compiler problem because it is explicitly written in assembly
> > in __raw_spin_lock() function (include/asm-x86/spinlock.h) and there is
> > no alternative code depending on CONFIG_M386.
> 
> Hmm, this really looks like a bug to me. How about something like this 
> (untested).
> 
> 
> From: Jiri Kosina <jkosina@suse.cz>
> Subject: x86: make spinlocks available on machines without xadd insn
> 
> Current kernel wouldn't compile on ancient x86 machines that don't support 
> xadd instruction, as ticket spinlocks implementation unconditionally uses 
> it.
> 
> On machines without CONFIG_X86_XADD, use old-style byte spinlock 
> implementation instead.

afaik we don't support i386-smp and up spinlocks are trivial
preempt_disable() calls.
