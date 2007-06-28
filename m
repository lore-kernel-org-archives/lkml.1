Return-Path: <linux-kernel-owner+w=401wt.eu-S1765637AbXF1SmV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765637AbXF1SmV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 14:42:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764468AbXF1SmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 14:42:08 -0400
Received: from gw.goop.org ([64.81.55.164]:54350 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756936AbXF1SmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 14:42:06 -0400
Message-ID: <4683D78E.6080309@goop.org>
Date: Thu, 28 Jun 2007 11:45:18 -0400
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Roman Zippel <zippel@linux-m68k.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Arch <linux-arch@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] cross-architecture ELF clean up
References: <20070620230854.246399397@goop.org> <20070620230902.387008536@goop.org> <Pine.LNX.4.64.0706251531110.4386@scrub.home> <468168FD.1080200@goop.org> <Pine.LNX.4.64.0706280027100.4890@scrub.home>
In-Reply-To: <Pine.LNX.4.64.0706280027100.4890@scrub.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Roman Zippel wrote:
> This could be avoided by reordering things within elf.h, but is it really 
> necessary since there is no user of this right now?
>   

Well, yes, I don't have much need to include ELF headers in asm now, but 
I still think its worth separating the arch-specific definitions from 
asm/elf.h and all the other stuff they pull in.  Specifically, the 
structure forward declarations and constants have very few external 
dependencies, but the structure definitions - particularly the 
arch-specific ones - have very wide dependencies, which is what I'm 
trying to solve.  Very few pieces of code care about the arch-specific 
structures.

> module.h does indeed pull in way too much, but instead of hacking headers 
> into little pieces, IMO it would be better to solve the real problem.
>   

No, that's not the real problem; its a side-effect of the real problem.  
The real problem is that linux/elf.h ends up bringing in too much.  
arch/powerpc, for example, has its own stripped down copy of elf.h for 
bootloader stuff in order to avoid this extra crud.  The fix is to make 
it possible to get just the appropriate ELF definitions without getting 
everything else.

There's the secondary problem that lots of ELF stuff is copy'n'paste 
duplicated across all the architectures, but all they really care about 
is one of two sets of parallel definitions (32 or 64 ELF structures).  
That was the secondary

> I played with it a little and the patch below moves a lot stuff out of 
> module.h, so this would drastically reduce the header dependencies.
> Unless there are major objections, I can test the patch a little more and 
> convert the other archs.
>   

Well, it seems like a large fiddly patch which only solves part of the 
problem I want to solve; actually it doesn't help me at all, but it 
achieves one of the side-effects of my patch. The arch changes make it 
look pretty awkward to merge.

    J

