Return-Path: <linux-kernel-owner+w=401wt.eu-S1760753AbXJMGx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760753AbXJMGx6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 02:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbXJMGxt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 02:53:49 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49665 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751967AbXJMGxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 02:53:48 -0400
Date: Fri, 12 Oct 2007 23:52:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <willy@debian.org>,
       linuxppc-dev@ozlabs.org
Subject: Re: 2.6.23-mm1 - build failure with advansys
Message-Id: <20071012235242.9d7daf05.akpm@linux-foundation.org>
In-Reply-To: <47104D26.7050206@linux.vnet.ibm.com>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	<47104D26.7050206@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 13 Oct 2007 10:14:22 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:

> Hi Andrew,
> 
> Another build failure with following message
> 
>   CC      drivers/scsi/advansys.o
> drivers/scsi/advansys.c:71:2: warning: #warning this driver is still not properly converted to the DMA API
> drivers/scsi/advansys.c: In function ‘AdvBuildCarrierFreelist’:
> drivers/scsi/advansys.c:6486: error: implicit declaration of function ‘virt_to_bus’
> drivers/scsi/advansys.c: In function ‘AdvInitAsc3550Driver’:
> drivers/scsi/advansys.c:6974: error: implicit declaration of function ‘bus_to_virt’
> drivers/scsi/advansys.c:6974: warning: cast to pointer from integer of different size
> drivers/scsi/advansys.c:6994: warning: cast to pointer from integer of different size
> drivers/scsi/advansys.c: In function ‘AdvInitAsc38C0800Driver’:
> drivers/scsi/advansys.c:7450: warning: cast to pointer from integer of different size
> drivers/scsi/advansys.c:7471: warning: cast to pointer from integer of different size
> drivers/scsi/advansys.c: In function ‘AdvInitAsc38C1600Driver’:
> drivers/scsi/advansys.c:7939: warning: cast to pointer from integer of different size
> drivers/scsi/advansys.c:7963: warning: cast to pointer from integer of different size
> drivers/scsi/advansys.c: In function ‘adv_isr_callback’:
> drivers/scsi/advansys.c:8175: warning: cast to pointer from integer of different size
> drivers/scsi/advansys.c: In function ‘AdvISR’:
> drivers/scsi/advansys.c:8392: warning: cast to pointer from integer of different size
> drivers/scsi/advansys.c:8412: warning: cast to pointer from integer of different size
> drivers/scsi/advansys.c: In function ‘AdvExeScsiQueue’:
> drivers/scsi/advansys.c:10845: warning: cast to pointer from integer of different size
> make[2]: *** [drivers/scsi/advansys.o] Error 1
> make[1]: *** [drivers/scsi] Error 2
> make: *** [drivers] Error 2
> 
> 
> The functions virt_to_bus and bus_to_virt are begin defined between ifdef CONFIG_PPC32
> but when i compile allyesconfig with ppc64 box,i get this error. This patch removes the
> ifdef.

Please copy the powerpc developers on powerpc patches.

> Signed-off-by : Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> ---
> --- linux-2.6.23/include/asm-powerpc/io.h       2007-10-12 15:46:14.000000000 +0530
> +++ linux-2.6.23/include/asm-powerpc/~io.h      2007-10-12 15:46:00.000000000 +0530
> @@ -690,7 +690,6 @@ static inline void * phys_to_virt(unsign
>   * drivers (shame shame shame) that use bus_to_virt() and haven't been
>   * fixed yet so I need to define it here.
>   */
> -#ifdef CONFIG_PPC32
>  
>  static inline unsigned long virt_to_bus(volatile void * address)
>  {
> @@ -708,7 +707,6 @@ static inline void * bus_to_virt(unsigne
>  
>  #define page_to_bus(page)      (page_to_phys(page) + PCI_DRAM_OFFSET)
>  
> -#endif /* CONFIG_PPC32 */
>  
>  /* access ports */
>  #define setbits32(_addr, _v) out_be32((_addr), in_be32(_addr) |  (_v))
> 

especially ones like that ;)

Matthew has proposed that advansys should be dependent upon
CONFIG_VIRT_TO_BUS.  I don't think anyone's done a patch yet though.

(Actually, the code which you've altered there should probably be using
CONFIG_VIRT_TO_BUS, too).

