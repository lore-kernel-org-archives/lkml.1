Return-Path: <linux-kernel-owner+w=401wt.eu-S1760029AbXE3Vkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760029AbXE3Vkg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 17:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759810AbXE3VkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 17:40:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:29985 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759695AbXE3VkL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 17:40:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.14,595,1170662400"; 
   d="scan'208";a="91961173"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [patch] Introduce CONFIG_HAS_DMA.
Date: Wed, 30 May 2007 14:40:02 -0700
Message-ID: <0C7297FA1D2D244A9C7F6959C0BF1E5201EC6BE2@azsmsx413.amr.corp.intel.com>
In-Reply-To: <20070530111003.1d813d74@gondolin.boeblingen.de.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [patch] Introduce CONFIG_HAS_DMA.
Thread-Index: AceimlMGm7Rmwbu/TEipuTWPc6ZuSgAVeE+w
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: "Cornelia Huck" <cornelia.huck@de.ibm.com>
Cc: "Heiko Carstens" <heiko.carstens@de.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "John W. Linville" <linville@tuxdriver.com>,
       "Kyle McMartin" <kyle@parisc-linux.org>, <linux-kernel@vger.kernel.org>,
       <James.Bottomley@steeleye.com>, "Tejun Heo" <htejun@gmail.com>,
       "Jeff Garzik" <jeff@garzik.org>,
       "Martin Schwidefsky" <schwidefsky@de.ibm.com>, <geert@linux-m68k.org>,
       <zippel@linux-m68k.org>, <spyro@f2s.com>, <uclinux-v850@lsi.nec.co.jp>,
       <ysato@users.sourceforge.jp>
X-OriginalArrivalTime: 30 May 2007 21:40:04.0243 (UTC) FILETIME=[1563A630:01C7A303]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ please let me know if you want to be dropped from the cc ]

> From: Cornelia Huck [mailto:cornelia.huck@de.ibm.com]
> IMO, well-placed #ifdefs are preferrable to dragging non-working code
> around. Like:
> 
> - put the DMA path in a file only build for MY_STUFF_USE_DMA
> - let MY_STUFF select MY_STUFF_USE_DMA if HAS_DMA
> - have a header file that points to the implementation for
>   MY_STUFF_USE_DMA and uses well defined stubs for !MY_STUFF_USE_DMA,
>   like returning ICannotDoThat for check_if_can_do() (kind of like
what
>   include/linux/sysfs.h does, for example)
> 
> This contains the #ifdefs in a header, doesn't compile stuff that
won't
> work anyway on !HAS_DMA, and adds the ability to disable
> MY_STUFF_USE_DMA even if HAS_DMA at a later time if someone wants it.
> 
> > In other words let CONFIG_HAS_DMA prevent pure DMA code from being
> > built, but do not preclude "clever" implementations from calling
> > broken code.
> 
> If it calls broken code, it may not be so "clever" after all :)
> 
Yes, at run time, but not necessarily at compile time.  

> What I don't like about this is
> 
> - compiles stuff that is not needed on !HAS_DMA
> - worse, compiles stuff that will not work on !HAS_DMA
> - does not encourage to split code properly into a DMA and a non-DMA
>   part

I came to the same conclusions as I started to implement the bug-stubs.
The patch (to follow) attempts to satisfy all the concerns you outline
as well as my observation that async_tx requires no factoring for the
!HAS_DMA case.

With the patch non-dma-architectures that try to build code with true
dependencies on the DMA api will fail to link i.e.:

CONFIG_DMA_ENGINE=y CONFIG_HAS_DMA=n ASYNC_MEMCPY=y
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
async_tx/built-in.o: In function `async_memcpy':
xor.c:(.text+0x770): undefined reference to `dma_map_page'
xor.c:(.text+0x798): undefined reference to `dma_map_page'
xor.c:(.text+0x968): undefined reference to `dma_map_page'

Now changing CONFIG_DMA_ENGINE to depend on HAS_DMA (which is more
correct than saying !S390). Results in:
CONFIG_DMA_ENGINE=n CONFIG_HAS_DMA=n ASYNC_MEMCPY=y
  CC      init/version.o
  LD      init/built-in.o
  LD      .tmp_vmlinux1
  KSYM    .tmp_kallsyms1.S
  AS      .tmp_kallsyms1.o
  LD      .tmp_vmlinux2
  KSYM    .tmp_kallsyms2.S
  AS      .tmp_kallsyms2.o
  LD      vmlinux

This also allows include/asm-s390/dma-mapping.h to be dropped.

Dan
