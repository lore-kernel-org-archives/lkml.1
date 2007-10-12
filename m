Return-Path: <linux-kernel-owner+w=401wt.eu-S1757055AbXJLJtt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbXJLJtt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 05:49:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbXJLJti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 05:49:38 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:47652 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbXJLJtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 05:49:36 -0400
Date: Fri, 12 Oct 2007 15:12:31 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ballabio_dario@emc.com,
       linux-scsi@vger.kernel.org,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Subject: Build Failure (Was Re: 2.6.23-mm1)
Message-ID: <20071012094231.GA15012@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071011213126.cf92efb7.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2007 at 09:31:26PM -0700, Andrew Morton wrote:
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23/2.6.23-mm1/
> 

Hi Andrew

My compile just failed with 

drivers/scsi/gdth.c: In function ‘gdth_search_dev’:
drivers/scsi/gdth.c:646: warning: ‘pci_find_device’ is deprecated
(declared at include/linux/pci.h:482)
drivers/scsi/gdth.c: In function ‘gdth_init_isa’:
drivers/scsi/gdth.c:857: error: ‘gdth_irq_tab’ undeclared (first use in
this function)
drivers/scsi/gdth.c:857: error: (Each undeclared identifier is reported
only once
drivers/scsi/gdth.c:857: error: for each function it appears in.)
drivers/scsi/gdth.c: In function ‘gdth_copy_internal_data’:
drivers/scsi/gdth.c:2362: warning: unused variable ‘sg’
make[2]: *** [drivers/scsi/gdth.o] Error 1
make[1]: *** [drivers/scsi] Error 2
make: *** [drivers] Error 2
[dhaval@gondor linux-2.6.23]$

Looking into the code I notice that gdth_irq_tab is not declared with
CONFIG_ISA=y and !CONFIG_EISA.

The values seem to be same in 2.6.23 (I am not sure why it has been put
with #ifdefs in -mm) so I have just modified the #ifdef to take care of
CONFIG_ISA as well.

(Compile tested only)

Thanks,

--

Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>


Index: linux-2.6.23/drivers/scsi/gdth.c
===================================================================
--- linux-2.6.23.orig/drivers/scsi/gdth.c	2007-10-12 14:07:28.000000000 +0530
+++ linux-2.6.23/drivers/scsi/gdth.c	2007-10-12 15:06:47.000000000 +0530
@@ -288,7 +288,7 @@ static struct timer_list gdth_timer;
 #ifdef CONFIG_ISA
 static unchar   gdth_drq_tab[4] = {5,6,7,7};            /* DRQ table */
 #endif
-#ifdef CONFIG_EISA
+#if defined(CONFIG_EISA) || defined(CONFIG_ISA)
 static unchar   gdth_irq_tab[6] = {0,10,11,12,14,0};    /* IRQ table */
 #endif
 static unchar   gdth_polling;                           /* polling if TRUE */

-- 
regards,
Dhaval
