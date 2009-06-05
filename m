Return-Path: <linux-kernel-owner+w=401wt.eu-S1754946AbZFEXdq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946AbZFEXdq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 19:33:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbZFEXd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 19:33:27 -0400
Received: from gate.crashing.org ([63.228.1.57]:55245 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512AbZFEXdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 19:33:25 -0400
Subject: Re: [BUILD FAILURE 01/04] Next June 04:PPC64 randconfig
 [drivers/staging/comedi/drivers.o]
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <greg@kroah.com>
Cc: Subrata Modak <subrata@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux-Next <linux-next@vger.kernel.org>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Michael Ellerman <michael@ellerman.id.au>
In-Reply-To: <20090605182618.GA11853@kroah.com>
References: <20090605182625.24093.7808.sendpatchset@elm3a191.beaverton.ibm.com>
	 <20090605182618.GA11853@kroah.com>
Content-Type: text/plain
Date: Sat, 06 Jun 2009 09:31:40 +1000
Message-Id: <1244244700.31984.15.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-06-05 at 11:26 -0700, Greg KH wrote:
> Should the comedi layer just not be using PAGE_KERNEL_NOCACHE here?  I
> can't believe that we need to do something like this in a driver.  What
> should the proper fix for this be?

Actualy, I think powerpc -had- PAGE_KERNEL_NOCACHE and I removed it ...
Oh well... My understanding was that the exposed interface isn't that
but instead pgprot_noncached().

Nowadays we provide these on ppc:

#define pgprot_noncached(prot)    (__pgprot((pgprot_val(prot) & ~_PAGE_CACHE_CTL) | \
                                            _PAGE_NO_CACHE | _PAGE_GUARDED))

#define pgprot_noncached_wc(prot) (__pgprot((pgprot_val(prot) & ~_PAGE_CACHE_CTL) | \
                                            _PAGE_NO_CACHE))

#define pgprot_cached(prot)       (__pgprot((pgprot_val(prot) & ~_PAGE_CACHE_CTL) | \
                                            _PAGE_COHERENT))

#define pgprot_cached_wthru(prot) (__pgprot((pgprot_val(prot) & ~_PAGE_CACHE_CTL) | \
                                            _PAGE_COHERENT | _PAGE_WRITETHRU))


Now, of course, expect interesting problems if you use it in vmap, since
you are mapping struct pages, you are effectively mapping memory.

On some platforms, it's absolutely illegal to map memory non-cacheable while
this memory is mapped cacheable elsewhere and can be fatal. But the pages you
are mapping here, I suppose, are also part of the linear mapping which is ...
cacheable.

Why would you need that non-cacheable mapping in the first place ? If it's
for DMA, it's the wrong interface I believe....

Cheers,
Ben.


