Return-Path: <linux-kernel-owner+w=401wt.eu-S1753431AbZF2Qp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431AbZF2Qp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbZF2Qpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:45:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63645 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbZF2Qpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:45:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers() in dma_sync_*_for_cpu
Date: Mon, 29 Jun 2009 18:45:15 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: Joerg Roedel <joerg.roedel@amd.com>, tom.leiming@gmail.com,
       fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com> <200906291822.18334.arnd@arndb.de> <20090629173121.768f2923@lxorguk.ukuu.org.uk>
In-Reply-To: <20090629173121.768f2923@lxorguk.ukuu.org.uk>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906291845.16335.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+TdV1Bsl7AZxu/A4X+/hTJjBz5QXwj7moXAIQ
 YC/QmqcAoCk/ZCS+evqJbgfZ8s26gJ9FhVJV3pZyGmEOIWY97k
 DShAvMEZ12hSzfE7r+adg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 June 2009, Alan Cox wrote:
> > Wouldn't it be better to put the flush_write_buffer in the specific
> > operation (swiotlb_sync_*_for_*) rather than the multiplexer?
> > 
> > Maybe in that case, smp_wmb() would be more appropriate because
> > it is defined on all architectures.
> 
> smp_wmb() is stronger and it would slow down x86 if we did that (we'd go
> from no-op on a coherent platform to using mfence/lfence etc)
> 
Really? In my copy of system.h, I read

#ifdef CONFIG_SMP
# ifdef CONFIG_X86_OOSTORE
#  define smp_wmb()      wmb()
# else
#  define smp_wmb()      barrier()
# endif
#else
# define smp_wmb()       barrier()
#endif

That actually looks weaker than flush_write_buffer, as it would turn into
a barrier() in case of !SMP or !X86_OOSTORE, and into an sfence instead of
lock addl on all modern CPUs in case of SMP && X86_OOSTORE.

Of course that raises the question of whether smp_wmb() is too weak in case of
!SMP or X86_PPRO_FENCE, but with the described scenario, I don't think
it does.

	Arnd <><
