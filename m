Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbZFJG32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbZFJG32 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 02:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751916AbZFJG3V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 02:29:21 -0400
Received: from viefep14-int.chello.at ([62.179.121.34]:36641 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbZFJG3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 02:29:20 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [benchmark] 1% performance overhead of paravirt_ops on native
 kernels
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>, Rusty Russell <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Avi Kivity <avi@redhat.com>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <alpine.LFD.2.01.0906090924580.6847@localhost.localdomain>
References: <4A0B62F7.5030802@goop.org>
	 <200906032208.28061.rusty@rustcorp.com.au>
	 <alpine.LFD.2.01.0906030901460.4880@localhost.localdomain>
	 <200906041554.37102.rusty@rustcorp.com.au>
	 <alpine.LFD.2.01.0906040736350.4880@localhost.localdomain>
	 <20090609093918.GC16940@wotan.suse.de>
	 <alpine.LFD.2.01.0906090749380.6847@localhost.localdomain>
	 <20090609153847.GB9211@wotan.suse.de>
	 <alpine.LFD.2.01.0906090849080.6847@localhost.localdomain>
	 <20090609162125.GC9211@wotan.suse.de>
	 <alpine.LFD.2.01.0906090924580.6847@localhost.localdomain>
Content-Type: text/plain
Date: Wed, 10 Jun 2009 08:29:14 +0200
Message-Id: <1244615354.13761.11388.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-09 at 09:26 -0700, Linus Torvalds wrote:
> 
> On Tue, 9 Jun 2009, Nick Piggin wrote:
> > 
> > The idea seems nice but isn't the problem that kmap gives back a
> > basically 1st class kernel virtual memory? (ie. it can then be used
> > by any other CPU at any point without it having to use kmap?).
> 
> No, everybody has to use kmap()/kunmap().
> 
> The "problem" is that you could in theory run out of kmap frames, since if 
> everybody does a kmap() in an interruptible context and you have lots and 
> lots of threads doing different pages, you'd run out. But that has nothing 
> to do with kmap_atomic(), which is basically limited to just the number of 
> CPU's and a (very small) level of nesting.

One of the things I did for -rt back when I rewrote mm/highmem.c for it
was to reserve multiple slots per kmap() user so that if you did 1 you
could always do another.

With everything in task context like rt does 2 seemed enough, but you
cuold ways extend that scheme and reserve enough for the worst case
nesting depth and be done with it.

