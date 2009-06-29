Return-Path: <linux-kernel-owner+w=401wt.eu-S1759997AbZF2QWt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759997AbZF2QWt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 12:22:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758701AbZF2QWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 12:22:42 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:55694 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbZF2QWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 12:22:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: [PATCH][RFC] asm-generic:remove calling flush_write_buffers() in dma_sync_*_for_cpu
Date: Mon, 29 Jun 2009 18:22:17 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: tom.leiming@gmail.com, fujita.tomonori@lab.ntt.co.jp,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <1246199959-6548-1-git-send-email-tom.leiming@gmail.com> <200906281534.37148.arnd@arndb.de> <20090629123142.GL5139@amd.com>
In-Reply-To: <20090629123142.GL5139@amd.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200906291822.18334.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+0qhwL/QzPtCEj3r62VpXA61hMaYTcD5xRyyY
 Q3VTydv0sdJzNLT/VOKo3THbd03VDcxzCzN+W5GJdAGTtBKp2x
 AlRWgicA21L5rlc24m5xw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 June 2009, Joerg Roedel wrote:
> On Sun, Jun 28, 2009 at 03:34:35PM +0000, Arnd Bergmann wrote:
> > On Sunday 28 June 2009 14:39:19 tom.leiming@gmail.com wrote:
> > > From: Ming Lei <tom.leiming@gmail.com>
> > > 
> > > dma_sync_*_for_cpu() is introduced to make cpu access dma buffers safely when
> > > dma transfer is over, it seems there is nothing to do with cpu write buffer,
> > > so remove it.
> > > 
> > > Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> > 
> > Right, this looks correct. On a related note, flush_write_buffers is
> > architecture specific right now: only x86 and frv implement it at all,
> > though and with slightly different semantics.
> 
> This doen't look correct to me. The sync functions may do bounce buffering
> which is all about copying data from one place in main memory to another. So we
> need these flush_write_buffer() calls in the _for_cpu path too.

Right, I didn't consider that.

Wouldn't it be better to put the flush_write_buffer in the specific
operation (swiotlb_sync_*_for_*) rather than the multiplexer?

Maybe in that case, smp_wmb() would be more appropriate because
it is defined on all architectures.

> > Maybe it would be more consistent to change the dma_map_* and
> > dma_sync_*_for_device stuff there to wmb() to make it  portable
> > to other architectures.
> 
> If we change it to wmb() it would be executed every time there even if the
> processor doesn't require it. Other architectures could simply add a
> flush_write_buffers() implemention if they want to adapt the common dma-mapping
> implementation, no?

As mentioned, the definition of flush_write_buffers() seems a little dodgy,
I would feel much more comfortable with putting it into the architecture
specific code or using one of the existing common barriers, since we already
have so many of them.

	Arnd <><
