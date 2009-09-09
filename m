Return-Path: <linux-kernel-owner+w=401wt.eu-S1754748AbZIIXr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbZIIXr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 19:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754736AbZIIXrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 19:47:55 -0400
Received: from smtp06.online.nl ([194.134.42.51]:59529 "EHLO smtp06.online.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754735AbZIIXry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 19:47:54 -0400
Date: Thu, 10 Sep 2009 01:47:51 +0200 (CEST)
From: "Robert M. Stockmann" <stock@stokkie.net>
X-X-Sender: stock@dellie2.hardebol.nl
To: linux-kernel@vger.kernel.org
cc: Linus Torvalds <torvalds@osdl.org>
Subject: PCIe : PCI-Express or actually PCI-EISA ?
Message-ID: <Pine.LNX.4.44.0909100146001.6693-100000@dellie2.hardebol.nl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Online-Scanned: by Cloudmark authority (on smtp06.online.nl)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

PCIe : PCI-Express or actually PCI-EISA ?

After patching the e1000e driver for the Intel PRO/1000 Gigabit 
Ethernet card on PCIe to compile with gcc2 on linux-2.4 [1], it dawned 
on me that this driver actually makes use of some old EISA DMA 
buffering code as found inside e1000.h :

"/usr/include/sys/eisa.h" [2]:

 "/**************************************************************************
   *                                                                        *
   *              Copyright ( C ) 1993, Silicon Graphics, Inc.              *
   *                                                                        *
   *  These coded instructions, statements, and computer programs  contain  *
   *  unpublished  proprietary  information of Silicon Graphics, Inc., and  *
   *  are protected by Federal copyright law.  They  may  not be disclosed  *
   *  to  third  parties  or copied or duplicated in any form, in whole or  *
   *  in part, without the prior written consent of Silicon Graphics, Inc.  *
   *                                                                        *
   **************************************************************************/
  
  #ifndef _SYS_EISA_H
  #define _SYS_EISA_H
  
  #ident "$Revision: 1.7 $"
  
  #include <sys/kmem.h>
  
  /*
   * EISA register set
   */
  
  [ ...... ]
  
  /*
   * eisa dma buffer descriptor structure
   */
  struct eisa_dma_buf {
          uint_t                  count;          /* size of block */
          paddr_t                 address;        /* phys addr of data block */
          struct eisa_dma_buf     *next_buf;      /* next buffer descriptor */
          paddr_t                 stopval;        /* ring buf stop */
  };
  
  /*
   * eisa dma command block structure
   */
  struct eisa_dma_cb {
          struct eisa_dma_buf *reqrbufs;  /* list of reqr data bufs */
          union modes {
              struct {
                ushort_t
                   mreqr_ringstop:1,      /* use channel's stop reg? */
                   mreqr_eop:1,           /* is EOP input/output */
                   mreqr_timing:2,        /* A,B,C,ISA compat */
                   mreqr_path:2,          /* 8/16/32 */
                   :2,                    /* reserved */
                   mtrans_type:2,         /* Single/Demand/Blck/Cascade */
                   mtarg_step:1,          /* Inc/Dec */
                   :1,
                   mcommand:2,            /* Read/Write/Translate/Verify*/
                   :2;                    /* reserved */
              } m;
              ushort_t mode;
          } mu;
          uchar_t bufprocess;             /* single/chain/autoinit */
          uchar_t reqr_bswap;             /* byte swap data on/off */
          void    *procparam;             /* parameter buf for app call */
          int     (*proc)(void*);         /* addr of app call routine */
  };
  
  #define reqr_ringstop   mu.m.mreqr_ringstop
  #define reqr_eop        mu.m.mreqr_eop
  #define reqr_timing     mu.m.mreqr_timing
  #define reqr_path       mu.m.mreqr_path
  #define trans_type      mu.m.mtrans_type
  #define targ_step       mu.m.mtarg_step
  #define cb_cmd          mu.m.mcommand
  #define moderegs        mu.mode
  
  /*
   * Command block defines (conforms to eisa reg values,
   * do not modify)
   */
  
  /* reqr_ringstop */
  #define EISA_DMA_RING_OFF       0       /* don't use stop reg */
  #define EISA_DMA_RING_ON        1       /* use stop reg */
  
  /* reqr_eop */
  #define EISA_DMA_EOP_OUTPUT     0       /* EOP is output */
  #define EISA_DMA_EOP_INPUT      1       /* EOP is input */
  
  /* reqr_timing */
  #define EISA_DMA_TIME_ISA       0       /* ISA compat mode timing */
  #define EISA_DMA_TIME_A         1       /* type A timing */
  #define EISA_DMA_TIME_B         2       /* type B timing */

  [ ...... ]"
  
  
So its not far fetched to describe PCIe for what it really
is : a fast edition of the PCI bus with EISA capabilities.

Cheers,

Robert
PS.
[1] e1000e-0.5.11.2-gcc2-linux2.4.patch
   http://crashrecovery.org/CrashRecoveryKit/iso/2.4.37.5/e1000e-0.5.11.2-gcc2-linux2.4.patch.html
   http://crashrecovery.org/CrashRecoveryKit/iso/2.4.37.5/

[2] /usr/include/sys/eisa.h
    taken from IRIX 5.3 (c)1993 SGi
-- 
Robert M. Stockmann - RHCE
Network Engineer - UNIX/Linux Specialist
crashrecovery.org  stock@stokkie.net

