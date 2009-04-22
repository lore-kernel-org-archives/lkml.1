Return-Path: <linux-kernel-owner+w=401wt.eu-S1756315AbZDVRU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756315AbZDVRU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 13:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753457AbZDVRUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 13:20:49 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:45589 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbZDVRUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 13:20:48 -0400
Date: Wed, 22 Apr 2009 19:20:45 +0200
From: Andreas Mohr <andi@lisas.de>
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: linux-net <linux-net@vger.kernel.org>,
       Jan-Pascal van Best <janpascal@vanbest.org>,
       Andreas Mohr <andi@lisas.de>, netdev@vger.kernel.org,
       Michael Hipp <hippm@informatik.uni-tuebingen.de>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next <linux-next@vger.kernel.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>
Subject: Re: [BUILD FAILURE 02/12] Next April 21 : PPC64 randconfig
	[drivers/net/ni65.c]
Message-ID: <20090422172045.GA10958@rhlx01.hs-esslingen.de>
References: <1240339794.9110.131.camel@subratamodak.linux.ibm.com> <1240416947.26824.9.camel@subratamodak.linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1240416947.26824.9.camel@subratamodak.linux.ibm.com>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Apr 22, 2009 at 09:45:47PM +0530, Subrata Modak wrote:
> On Wed, 2009-04-22 at 00:20 +0530, Subrata Modak wrote: 
> > I am observing this for the first time:
> > 
> > CC      drivers/net/ni65.o
> > drivers/net/ni65.c: In function ‘ni65_init_lance’:
> > drivers/net/ni65.c:585: error: implicit declaration of function
> > ‘isa_virt_to_bus’
> > drivers/net/ni65.c: In function ‘ni65_stop_start’:
> > drivers/net/ni65.c:757: error: implicit declaration of function
> > ‘isa_bus_to_virt’
> > make[2]: *** [drivers/net/ni65.o] Error 1
> > make[1]: *** [drivers/net] Error 2
> > make: *** [drivers] Error 2
> > ---
> 
> Is there any specific dependency of whether this should be built only
> with certain archs ? As the case may be, i found the functions
> prototypes defined inside the arch specific headers, which definitely
> will not compile on PPC64:
> 
> # find . -type f | xargs grep -in isa_virt_to_bus
> ./arch/alpha/include/asm/io.h:119:#define isa_virt_to_bus virt_to_bus
> ./arch/arm/include/asm/io.h:33:#define isa_virt_to_bus virt_to_phys
> ./arch/mips/include/asm/io.h:142:static inline unsigned long
> isa_virt_to_bus(volatile void * address)
> ./arch/parisc/include/asm/io.h:17:static inline unsigned long
> isa_virt_to_bus(void *addr) {
> ./arch/x86/include/asm/floppy.h:182:
> isa_virt_to_bus(addr) >= 0x1000000 ||
> ./arch/x86/include/asm/floppy.h:218:    set_dma_addr(FLOPPY_DMA,
> isa_virt_to_bus(addr));
> ./arch/x86/include/asm/io.h:130:static inline unsigned int
> isa_virt_to_bus(volatile void *address)

But NI65 is properly guarded against ISA bus non-support already:
config NI65
        tristate "NI6510 support"
        depends on NET_VENDOR_RACAL && ISA && ISA_DMA_API
        help
          If you have a network (Ethernet) card of this type, say Y and read
          the Ethernet-HOWTO, available from
          <http://www.tldp.org/docs.html#howto>.

          To compile this driver as a module, choose M here. The module
          will be called ni65.

And powerpc _does_ offer ISA bus support:
./arch/powerpc/Kconfig:config ISA
./arch/powerpc/Kconfig:	bool "Support for ISA-bus hardware"
./arch/powerpc/Kconfig:	  Find out whether you have ISA slots on your motherboard.  ISA is the

Of course I'm 167% sure that nobody has ever tried those cards on ppc ;-),
but still that would be a _possibility_ that shouldn't be denied straight away.

> Then there should be some solution to the problem inside
> drivers/net/Kconfig

Indeed, which (given my above comments) should probably be to provide
some isa_virt_to_bus() functionality on powerpc or conditionally disable (yuck!)
use of these mechanisms in the drivers.

Anyway, it's certainly not a mistake per se to try to build those drivers on
an ISA-support-enabled powerpc platform.


Of course I'm not certain as to current status of e.g. ni5010, but OTOH I still
have some of those cards... (after all I'm the driver co-author)

Thanks for the heads-up,

Andreas Mohr
