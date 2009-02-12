Return-Path: <linux-kernel-owner+w=401wt.eu-S1760723AbZBLMq2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760723AbZBLMq2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 07:46:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760218AbZBLMns
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 07:43:48 -0500
Received: from vervifontaine.sonytel.be ([80.88.33.193]:63172 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760217AbZBLMnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 07:43:46 -0500
Date: Thu, 12 Feb 2009 13:43:31 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: "Sachin P. Sant" <sachinp@in.ibm.com>
cc: linux-crypto@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Mel Gorman <mel@csn.ul.ie>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Dan Williams <dan.j.williams@intel.com>,
       Shannon Nelson <shannon.nelson@intel.com>
Subject: Re: [Crypto] 2.6.29-rc4-git4 build failure
 crypto/async_tx/async_xor
In-Reply-To: <4993CA04.60207@in.ibm.com>
Message-ID: <alpine.LRH.2.00.0902121340460.29413@vixen.sonytel.be>
References: <4993CA04.60207@in.ibm.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Feb 2009, Sachin P. Sant wrote:
> On a powerpc box 2.6.29-rc4-git4 randconfig build fails with :
> 
>  CC [M]  crypto/async_tx/async_xor.o
> crypto/async_tx/async_xor.c: In function async_xor_init:
> crypto/async_tx/async_xor.c:313: error: size of array type name is negative
> make[2]: *** [crypto/async_tx/async_xor.o] Error 1
> make[1]: *** [crypto/async_tx] Error 2
> make: *** [crypto] Error 2

| static int __init async_xor_init(void)
| {
| 	#ifdef CONFIG_DMA_ENGINE
| 	/* To conserve stack space the input src_list (array of page pointers)
| 	 * is reused to hold the array of dma addresses passed to the driver.
| 	 * This conversion is only possible when dma_addr_t is less than the
| 	 * the size of a pointer.  HIGHMEM64G is known to violate this
| 	 * assumption.
| 	 */
| 	BUILD_BUG_ON(sizeof(dma_addr_t) > sizeof(struct page *));
| 	#endif
| 
| 	return 0;
| }

Of course. This will fail on any 32-bit platform with a physical address space
larger than 32-bit (PPC44x, several MIPSes, ...).

The offending commit is:

commit 0036731c88fdb5bf4f04a796a30b5e445fc57f54
Author: Dan Williams <dan.j.williams@intel.com>
Date:   Sat Feb 2 19:49:57 2008 -0700

    async_tx: kill tx_set_src and tx_set_dest methods
    
    The tx_set_src and tx_set_dest methods were originally implemented to allow
    an array of addresses to be passed down from async_xor to the dmaengine
    driver while minimizing stack overhead.  Removing these methods allows
    drivers to have all transaction parameters available at 'prep' time, saves
    two function pointers in struct dma_async_tx_descriptor, and reduces the
    number of indirect branches..
    
    A consequence of moving this data to the 'prep' routine is that
    multi-source routines like async_xor need temporary storage to convert an
    array of linear addresses into an array of dma addresses.  In order to keep
    the same stack footprint of the previous implementation the input array is
    reused as storage for the dma addresses.  This requires that
    sizeof(dma_addr_t) be less than or equal to sizeof(void *).  As a
    consequence CONFIG_DMADEVICES now depends on !CONFIG_HIGHMEM64G.  It also
    requires that drivers be able to make descriptor resources available when
    the 'prep' routine is polled.
    
    Signed-off-by: Dan Williams <dan.j.williams@intel.com>
    Acked-by: Shannon Nelson <shannon.nelson@intel.com>

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
