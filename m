Return-Path: <linux-kernel-owner+w=401wt.eu-S1753201AbXEGBYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201AbXEGBYn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 21:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbXEGBYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 21:24:43 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:45588 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753201AbXEGBYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 21:24:42 -0400
Date: Mon, 7 May 2007 10:24:18 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Robin Getz <rgetz@blackfin.uclinux.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: linux-2.6.21-uc0 (MMU-less updates)
Message-ID: <20070507012418.GB25739@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Greg Ungerer <gerg@snapgear.com>,
	Robin Getz <rgetz@blackfin.uclinux.org>,
	linux-kernel@vger.kernel.org
References: <46382055.8030203@snapgear.com> <200705030655.36957.rgetz@blackfin.uclinux.org> <4639C164.5070908@snapgear.com> <200705030735.36879.rgetz@blackfin.uclinux.org> <4639E40D.6030809@snapgear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4639E40D.6030809@snapgear.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 03, 2007 at 11:30:53PM +1000, Greg Ungerer wrote:
> Robin Getz wrote:
> >>Its not an architecture problem. It can effect any board that
> >>has RAM mapped at a large numerical addresses (larger than TASK_SIZE).
> >>So it can effect any non-MMU platform.
> >
> >Depending on how TASK_SIZE is defined - it looks like everyone else forces 
> >it to end of memory, except 68k[nommu].
> >
> >asm-arm/memory.h:#define TASK_SIZE              (CONFIG_DRAM_SIZE)
> >asm-blackfin/processor.h:#define TASK_SIZE      (memory_end)
> >asm-frv/mem-layout.h:#define TASK_SIZE                  __UL(0xFFFFFFFFUL)
> >
> >asm-m68k/processor.h:#define TASK_SIZE  (0xF0000000UL)
> >asm-m68k/processor.h:#define TASK_SIZE  (0x0E000000)
> >asm-m68k/processor.h:#define TASK_SIZE  (0x0E000000UL)
> >asm-m68knommu/processor.h:#define TASK_SIZE     (0xF0000000UL)
> 
> Probably too:
> 
> asm-sh/processor.h:#define TASK_SIZE    0x7c000000UL
> 
> which has some parts with MMU.
> 
> There have been others out of tree that have it like this to.
> 
It would be at 0x80000000UL on SH if it weren't for address space area
limitations. The 0x7c000000 - 0x7fffffff space is used for shadowing P4
registers in the virtual address space (area 7) with the MMU and it's a
reserved area without the MMU, so TASK_SIZE is trimmed right before this.

However, I'm not sure that the patch Greg has in this set is sufficient
for the problem described. do_mmap_pgoff() won't allow a > TASK_SIZE
mapping anyways. In the SH case we certainly have address spaces that
can be given user permissions well above TASK_SIZE, area 7 space is used
as a bit of a hack for some of this in the MMU case..
