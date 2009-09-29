Return-Path: <linux-kernel-owner+w=401wt.eu-S1752854AbZI2VTG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbZI2VTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 17:19:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbZI2VTG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 17:19:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52223 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752096AbZI2VTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 17:19:05 -0400
Date: Tue, 29 Sep 2009 14:17:58 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, John Stultz <johnstul@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: Linux 2.6.32-rc1
In-Reply-To: <4AC2712C.4080901@gmail.com>
Message-ID: <alpine.LFD.2.01.0909291410440.6996@localhost.localdomain>
References: <alpine.LFD.2.01.0909271511190.3349@localhost.localdomain> <4AC060AE.1090401@gmail.com> <alpine.LFD.2.01.0909280829100.3349@localhost.localdomain> <20090928191506.40b61793@mschwide.boeblingen.de.ibm.com> <4AC10365.7090802@gmail.com>
 <4AC2712C.4080901@gmail.com>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 29 Sep 2009, Eric Dumazet wrote:
> 
> Checking this commit, I believe problem comes from cmpxchg(), which doesnt 
> handle 64 bit on X86_32 (no compilation error, and  null operation :( )

Wow. That's broken. Very nasty silent failure.

> 1) Use cmpxchg64()

Clearly better than what we have now, although cmpxchg64 does result is 
some really disgusting code. We will use a bare CMPXCHG64 only if you 
compile for PAE right now - so even if you tell Kconfig that you want to 
compile for a modern CPU, we won't be doing that whole cmpxchg64b thing 
directly, we'll inline some really disgusting code.

So we really need to fix that up before it would be acceptable to use 
cmpxchg64(). 

And regardless, we should fix the silent cmpxchg failure, even if it's 
just a link-time failure or something. 64-bit things in the kernel used to 
be rare and special, but they aren't any more.

Ingo, Peter, comments?

		Linus
