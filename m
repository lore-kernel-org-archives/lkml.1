Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbXEXVkT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbXEXVkT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 17:40:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753354AbXEXVkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 17:40:08 -0400
Received: from moutng.kundenserver.de ([212.227.126.174]:56442 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084AbXEXVkG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 17:40:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] Introduce CONFIG_VIRT_TO_BUS
Date: Thu, 24 May 2007 23:38:45 +0200
User-Agent: KMail/1.9.6
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <20070523170155.2cb9eff8.sfr@canb.auug.org.au> <20070523070450.GN4095@ftp.linux.org.uk>
In-Reply-To: <20070523070450.GN4095@ftp.linux.org.uk>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?iso-8859-1?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?iso-8859-1?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ?=
 =?iso-8859-1?q?=0A=098MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?iso-8859-1?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?iso-8859-1?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <200705242338.45499.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+N7CiGICVqrJ93Q4BNmO+VCEtGZl4VDZWtHUz
 r6aNJZjTCF5tc5B4D6QfGj7FRZ0VI0V7VCFGYudghmWyIcHc4+
 vzdVu0d5PL2gdvmEUaoPQ==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 May 2007, Al Viro wrote:
> 
> On Wed, May 23, 2007 at 05:01:55PM +1000, Stephen Rothwell wrote:
> > Make some offending drivers depend on it and set
> > CONFIG_ARCH_NO_VIRT_TO_BUS for ppc64 so that we don't build those drivers.
> 
> Seeing how few targets _do_ have that, I'd invert the that.  I.e. have
> HAS_VIRT_TO_BUS in arch/*/Kconfig for the few architectures that have
> that stuff.

Currently, that would mark x86_64 as HAS_VIRT_TO_BUS, while 64 bit powerpc
would be NO_VIRT_TO_BUS. I think they really should be the same, probably
like the other 64 bit targets, which means:

* If CONFIG_IOMMU is disabled, provide a __deprecated inline function that
maps virt_to_bus to virt_to_phys, and allow building drivers that use it.

* If we build with CONFIG_IOMMU enabled, but don't support disabling the
iommu, have no declaration for virt_to_bus at all, and disable the users
in Kconfig

* If the usage of the iommu is determined at run time, warn about users
of virt_to_bus at run time if it is enabled.

It could look like this

/* mm/memory.c or somewhere */
#if defined(CONFIG_HAS_VIRT_TO_BUS) && defined(CONFIG_IOMMU)
unsigned long virt_to_bus(void *virt)
{
	WARN_ON(iommu_enabled);
	return __virt_to_bus(virt);
}
#endif

/* include/linux/io.h */

#ifndef __virt_to_bus
#define __virt_to_bus virt_to_phys /* some architectures need 
					their own __virt_to_bus */
#endif

#ifdef CONFIG_HAS_VIRT_TO_BUS
#ifdef CONFIG_IOMMU
extern __deprecated unsigned long virt_to_bus(void *);
#else
static inline __deprecated unsigned long virt_to_bus(void *virt)
{
	return __virt_to_bus(virt);
}
#endif
#endif

	Arnd <><
