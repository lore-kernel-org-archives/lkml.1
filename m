Return-Path: <linux-kernel-owner+w=401wt.eu-S1754348AbZFPSC4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348AbZFPSC4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 14:02:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbZFPSCs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 14:02:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61986 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979AbZFPSCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 14:02:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Scott Wood <scottwood@freescale.com>
Subject: Re: PowerPC PCI DMA issues (prefetch/coherency?)
Date: Tue, 16 Jun 2009 20:02:11 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: linuxppc-dev@lists.ozlabs.org, Chris Pringle <chris.pringle@oxtel.com>,
       linux-kernel@vger.kernel.org
References: <4A37A503.3030209@oxtel.com> <200906161943.38764.arnd@arndb.de> <4A37DB0F.7060801@freescale.com>
In-Reply-To: <4A37DB0F.7060801@freescale.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200906162002.12376.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18OkTK+Qpz/bL4Uuo9Jher5Mg8cd5qyUoRVXjG
 aDG3gaf6dzrWaxsABjLCAXkLMr8wKb0aCsDe1jEFuSU2oCpK7i
 kF7n6yotdcDM05w+guQeg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 June 2009, Scott Wood wrote:
> > If the
> > device is the only one, you can also use dma_alloc_noncoherent() and
> > flush explicitly with dma_cache_sync().
> 
> I don't see how that would help -- aren't those also controlled by 
> CONFIG_NOT_COHERENT_CACHE?

Ah, yes you are right. PowerPC implements dma_alloc_noncoherent as
dma_alloc_coherent, so dma_cache_sync() is actually a NOP (or should be).

Actually there seems to be a bug in here: Since dma_alloc_noncoherent
gives you a coherent mapping (or NULL) on noncoherent machines,
dma_cache_sync() is redundant and should not actually flush the
cache, or we should change dma_alloc_noncoherent to do a simple
alloc_pages on CONFIG_NON_COHERENT_CACHE and leave dma_cache_sync()
as it is.

	Arnd <><
