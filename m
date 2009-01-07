Return-Path: <linux-kernel-owner+w=401wt.eu-S1763688AbZAGXEC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763688AbZAGXEC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:04:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762359AbZAGXD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:03:28 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:35908 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759206AbZAGXDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:03:25 -0500
Date: Wed, 07 Jan 2009 15:03:24 -0800
From: Om <om.turyx@gmail.com>
Subject: 64 bit PCI access using MMX register -- how?
To: linux-kernel@vger.kernel.org
Message-id: <496534BC.4060603@gmail.com>
MIME-version: 1.0
Content-type: text/plain; format=flowed; charset=ISO-8859-1
Content-transfer-encoding: 7BIT
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I have a buggy hardware with many 64 bit registers. (The bug is, when a
64bit read/write is split to two 32bit read/write, under high loads,
hardware would mess up the order of reads/writes. As a result,
read/written values would not be correct).

To avoid data corruption in 32bit Linux, when I implement `readq` as two
back to back `readl`, I need a lock serializing accesses to whole PIO
space. To avoid locking, I implemented suggestion from a friend to use
MMX registers like below.

#if BITS_PER_LONG == 32
static inline void hxge_writeq32(u64 val, void *addr)
{
         u64 tmp = 0;
         __asm__ __volatile__ (
                 "movq %%mm0, %[t]\n\t"
                 "movq %[d], %%mm0\n\t"
                 "movl %[a], %%eax\n\t"
                 "movq %%mm0, (%%eax)\n\t"
                 "movq %[t], %%mm0\n\t"
                 :[t] "+m"(tmp)
                 :[a] "r"(addr), [d] "m"(val)
                 :"%eax"
                 );
         smp_wmb();
         return;
}

static inline unsigned long long hxge_readq32(void __iomem *addr)
{
         u64 var = 0, tmp = 0xfeedfacedeadbeefULL;
         printk(KERN_ERR "addr= %#lx\n", (unsigned long) addr);
         __asm__ __volatile__ (
                 "movq %%mm0, %[t]\n\t"
                 "movl %[a], %%eax\n\t"
                 "movq (%%eax), %%mm0\n\t"
                 "movq %%mm0, %[r]\n\t"
                 "movq %[t], %%mm0\n\t"
                 :[r] "=m"(var), [t]"+m"(tmp)
                 :[a] "r"(addr)
                 :"%eax"
         );
         smp_rmb();
         printk(KERN_ERR "tmp = %#llx, var = %#llx\n", (unsigned long
long) tmp,
var);
         return var;
}

#endif

All the reads return 0xFFFFFFFFFFFFFFFF when tried on ioremap_nocache()
PCI address space.
E.g, output from dmesg:

addr= 0xf9f80010
tmp = 0x0, var = 0xffffffffffffffff

data = 0xffffffffffffffff, da = 0xbc000004

(da is the result of 32bit read on the same address)

Any idea what could be wrong? Any suggestions / pointers?
( I am not subscribed, please CC: me)

I tried reading and writing an ordinary memory location ( a global u64
variable, that is working fine. Only PCI access gives a problem)

PCI access in the form of
val = *((u64*)ioremapped_address)
gets me the expected result. But my question is, is this operation
atomic in 32bit arch?

Thanks,
Om.

