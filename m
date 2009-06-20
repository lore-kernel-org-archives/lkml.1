Return-Path: <linux-kernel-owner+w=401wt.eu-S1753832AbZFTH0t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbZFTH0t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 03:26:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751321AbZFTH0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 03:26:41 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:34518 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbZFTH0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 03:26:41 -0400
Message-ID: <4A3C8F2F.9030602@in.ibm.com>
Date: Sat, 20 Jun 2009 12:56:39 +0530
From: Sachin Sant <sachinp@in.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081216)
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: linuxppc-dev@ozlabs.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PowerPC] 2.6.30-git14 boot failure with SLAB
References: <4A3B615F.8090504@in.ibm.com>  <4A3BC57B.8000408@in.ibm.com> <1245450580.16880.12.camel@pasglop>
In-Reply-To: <1245450580.16880.12.camel@pasglop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin Herrenschmidt wrote:
> That is strange. If I revert that commit, I get breakages on machines
> here. It would be interesting to understand what the problem is here,
> as we -do- use that kmem cache for allocating page tables, so we do
> need it initialized that early. (IE, we can't allow vmalloc for example
> to be called before the page table caches are initialized).
>
> This will need more debugging and understanding as to why it hangs.
>   
Hi Ben,

Looks like the control enters pgtable_cache_init but rever returns. The
machine just hangs. I triggered a system reset via HMC to see what's
happening on the cpu. Here is the xmon o/p after a system reset.
The code that was executed was __mutex_lock_slowpath..

cpu 0x0: Vector: 100 (System Reset) at [c000000000b138e0]
    pc: c00000000060a4b8: .__mutex_lock_slowpath+0x9c/0x1f4
    lr: c00000000060abc8: .mutex_lock+0x50/0x70
    sp: c000000000b13b60
   msr: 8000000000081032
  current = 0xc000000000a3ab70
  paca    = 0xc000000000be2400
    pid   = 0, comm = swapper
enter ? for help
[c000000000b13c30] c00000000060abc8 .mutex_lock+0x50/0x70
[c000000000b13cb0] c00000000008c7f0 .get_online_cpus+0x4c/0x84
[c000000000b13d40] c00000000014a120 .kmem_cache_create+0xcc/0x5f4
[c000000000b13e50] c000000000033f38 .pgtable_cache_init+0x28/0x78
[c000000000b13ee0] c0000000008809a4 .start_kernel+0x1f8/0x568
[c000000000b13f90] c0000000000083d8 .start_here_common+0x1c/0x44
0:mon> 
0:mon> di $.__mutex_lock_slowpath
c00000000060a41c  fba1ffe8      std     r29,-24(r1)
c00000000060a420  7c0802a6      mflr    r0
 .... SNIP .....
c00000000060a46c  7fe4fb78      mr      r4,r31
c00000000060a470  419e0014      beq     cr7,c00000000060a484    # .__mutex_lock_slowpath+0x68/0x1f4
c00000000060a474  4ba6859d      bl      c000000000072a10        # .mutex_spin_on_owner+0x0/0xbc
c00000000060a478  60000000      nop
c00000000060a47c  2fa30000      cmpdi   cr7,r3,0
c00000000060a480  419e0078      beq     cr7,c00000000060a4f8    # .__mutex_lock_slowpath+0xdc/0x1f4
c00000000060a484  93010070      stw     r24,112(r1)
c00000000060a488  93210074      stw     r25,116(r1)
c00000000060a48c  81210070      lwz     r9,112(r1)
c00000000060a490  80010074      lwz     r0,116(r1)
c00000000060a494  7d2907b4      extsw   r9,r9
c00000000060a498  7c0007b4      extsw   r0,r0
0:mon> 
c00000000060a49c  7c2004ac      lwsync
c00000000060a4a0  7d60e828      lwarx   r11,0,r29
c00000000060a4a4  7c0b4800      cmpw    r11,r9
c00000000060a4a8  40c20010      bne-    c00000000060a4b8        # .__mutex_lock_slowpath+0x9c/0x1f4
c00000000060a4ac  7c00e92d      stwcx.  r0,0,r29
c00000000060a4b0  40c2fff0      bne-    c00000000060a4a0        # .__mutex_lock_slowpath+0x84/0x1f4
c00000000060a4b4  4c00012c      isync
c00000000060a4b8  2f8b0001      cmpwi   cr7,r11,1
  ^^^^^ PC points to this instruction ^^^^^^^^
c00000000060a4bc  2f3f0000      cmpdi   cr6,r31,0
c00000000060a4c0  409e0010      bne     cr7,c00000000060a4d0    # .__mutex_lock_slowpath+0xb4/0x1f4
c00000000060a4c4  78200464      rldicr  r0,r1,0,49
c00000000060a4c8  f81d0030      std     r0,48(r29)
c00000000060a4cc  48000118      b       c00000000060a5e4        # .__mutex_lock_slowpath+0x1c8/0x1f4
c00000000060a4d0  409a001c      bne     cr6,c00000000060a4ec    # .__mutex_lock_slowpath+0xd0/0x1f4
c00000000060a4d4  e81b0000      ld      r0,0(r27)
c00000000060a4d8  7809f7e3      rldicl. r9,r0,62,63
0:mon> r
R00 = 0000000000000000   R16 = 0000000002bc4b68
R01 = c000000000b13b60   R17 = 0000000000000000
R02 = c000000000b0bca0   R18 = c0000000008c4b68
R03 = c000000000d07fd0   R19 = 0000000001b1fc90
R04 = 0000000000000000   R20 = 00000000000000b8
R05 = 000000000000005e   R21 = c0000000007ec008
R06 = 0000000000040000   R22 = 00000000007c28bb
R07 = c000000000a95288   R23 = c0000000007cbdd5
R08 = 0000000000000000   R24 = 0000000000000001
R09 = 0000000000000001   R25 = 0000000000000000
R10 = 0000000000000000   R26 = c000000000d08000
R11 = 00000000ffffffff   R27 = c000000000b10080
R12 = 0000000024000082   R28 = c000000000a3ab70
R13 = c000000000be2400   R29 = c000000000d07fd0
R14 = c0000000008c4c30   R30 = c000000000a75be8
R15 = c000000000a95288   R31 = 0000000000000000
pc  = c00000000060a4b8 .__mutex_lock_slowpath+0x9c/0x1f4
lr  = c00000000060abc8 .mutex_lock+0x50/0x70
msr = 8000000000081032   cr  = 84000022
ctr = 0000000000136f8c   xer = 0000000000000001   trap =  100
0:mon>

Let me know if i can provide more information.

Thanks
-Sachin

-- 

---------------------------------
Sachin Sant
IBM Linux Technology Center
India Systems and Technology Labs
Bangalore, India
---------------------------------

