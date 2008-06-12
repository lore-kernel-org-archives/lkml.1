Return-Path: <linux-kernel-owner+w=401wt.eu-S1758553AbYFLOlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553AbYFLOlH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 10:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751854AbYFLOkz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 10:40:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60320 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908AbYFLOkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 10:40:55 -0400
Date: Thu, 12 Jun 2008 10:40:29 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Ingo Molnar <mingo@elte.hu>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Cc: sfr@canb.auug.org.au, tglx@linutronix.de
Subject: Regarding CONFIG_PHYSICAL_START=16MB in linux-next tree
Message-ID: <20080612144029.GC9654@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

I just noticed that configs/i386_defconfig now contains the
CONFIG_PHYSICAL_START=0x1000000 (16MB) instead of 1MB.

This change has been introduced by following commit in linux-next tree.

commit 5cb04df8d3f03e37a19f2502591a84156be71772
Author: Ingo Molnar <mingo@elte.hu>
Date:   Sun May 4 19:49:04 2008 +0200

    x86: defconfig updates
    
    refresh 32-bit defconfig too, and update the 64-bit configs as well,
    the defconfig should be much more useful by default, so most of the
    updates are the enabling of various options.

I think this will break kdump on i386. Now kernel will be compiled for
physical address 16MB but effectively it will run from physical address
2MB. Boot loader will load kernel at 1MB and due to alignment restriction
of 2MB, kernel will move itself to 2MB address.

Now run time virtual addresses for kernel symbols will be different from
compile time virtual address and gdb and crash utilities will not be
able to open kernel dumps.

What's the reason that we want to compile the kernel for 16MB address? I
guess, probably the intention must have been that we want to run kernel
from 16MB physical address by default so that lower memory addresses are
available for DMA etc?

If that's the case, we probably also need to change
CONFIG_PHYSICAL_ALIGN=16MB, so that first kernel is compiled for 16MB and
it runs from 16MB address and kdump is not broken.

The side effect of this will be when same kernel is loaded in reserved
memory for kdump operation, it will look for 16MB aligned addresses as
compared to 2MB. Asking for 16MB aligned addresses as compared to 2MB
aligned addresses is more strict a requirement when second kernel is
running in a constrained memory environment.

If that's not the intention, then CONFIG_PHYSICAL_START=1MB should be good.
 
Thanks
Vivek
