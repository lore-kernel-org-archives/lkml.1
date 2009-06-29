Return-Path: <linux-kernel-owner+w=401wt.eu-S1756600AbZF2Sr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600AbZF2Sr4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 14:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752775AbZF2Srr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 14:47:47 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:23582
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750755AbZF2Srq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 14:47:46 -0400
X-SpamScore: -23
X-BigFish: VPS-23(z1039oz1432R9370P98dR1805Mzz1202hzzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0KM0K76-01-AX6-01
Date: Mon, 29 Jun 2009 20:47:06 +0200
From: Joerg Roedel <joerg.roedel@amd.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, tom.leiming@gmail.com,
       fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers()
 in dma_sync_*_for_cpu
Message-ID: <20090629184706.GA9401@amd.com>
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com>
 <200906291822.18334.arnd@arndb.de>
 <20090629173121.768f2923@lxorguk.ukuu.org.uk>
 <200906291845.16335.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <200906291845.16335.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 29 Jun 2009 18:47:06.0767 (UTC) FILETIME=[004A39F0:01C9F8EA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 06:45:15PM +0200, Arnd Bergmann wrote:
> On Monday 29 June 2009, Alan Cox wrote:
> > > Wouldn't it be better to put the flush_write_buffer in the specific
> > > operation (swiotlb_sync_*_for_*) rather than the multiplexer?
> > > 
> > > Maybe in that case, smp_wmb() would be more appropriate because
> > > it is defined on all architectures.
> > 
> > smp_wmb() is stronger and it would slow down x86 if we did that (we'd go
> > from no-op on a coherent platform to using mfence/lfence etc)
> > 
> Really? In my copy of system.h, I read
> 
> #ifdef CONFIG_SMP
> # ifdef CONFIG_X86_OOSTORE
> #  define smp_wmb()      wmb()
> # else
> #  define smp_wmb()      barrier()
> # endif
> #else
> # define smp_wmb()       barrier()
> #endif

With that definition an smp_wmb() would do the right job on x86. If thats also
true for other architectures using this generic header we can remove
flush_write_buffer().

> 
> That actually looks weaker than flush_write_buffer, as it would turn into
> a barrier() in case of !SMP or !X86_OOSTORE, and into an sfence instead of
> lock addl on all modern CPUs in case of SMP && X86_OOSTORE.

X86_OOSTORE is defined for (MWINCHIP3D || MWINCHIPC6) && MTRR. I am not sure if
these chips have sfence.
It would also help to know what OOSTORE exactly means in the context of that
chip.

	Joerg

-- 
           | Advanced Micro Devices GmbH
 Operating | Karl-Hammerschmidt-Str. 34, 85609 Dornach bei München
 System    | 
 Research  | Geschäftsführer: Thomas M. McCoy, Giuliano Meroni
 Center    | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
           | Registergericht München, HRB Nr. 43632

