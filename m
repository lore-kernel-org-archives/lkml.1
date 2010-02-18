Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723Ab0BREnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 23:43:19 -0500
Received: from mail-pz0-f187.google.com ([209.85.222.187]:55134 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857Ab0BREnS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 23:43:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=caPsMspII416XRi2HB3l0aevrOgM5os/y4wx0aKn+21xsjJeGvHu0Qqv40AZytrOhs
         idI0TU3ErDs31pTh5LVZy+gTMJtYXH1e0Gbbba8NF0MJOQguVvdU/2EPsXYGNV8A3Tf0
         k8zGEsdtjz568yO+GmPU3NkZx0tKSP9I+3rIo=
MIME-Version: 1.0
Date: Thu, 18 Feb 2010 10:13:17 +0530
Message-ID: <e9c371f11002172043j1151ea4avb3ad93257e175cd2@mail.gmail.com>
Subject: Doubt regarding source address to be given for DMA transfer
From: Anish K K <anishkk1@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I am using linux 2.6.22.18 kernel running on Marvel Sheeva MV88F6281 board.
I posses a doubt regarding the physical address to be given to DMA transfer.

In the Marvel board there is an XOR/DMA engine.
The DMA engine can be used to move data from SDRAM to SDRAM or from
PCIe to SDRAM.
For DMA READ from PCIe receive buffer,

the DESTINATION is a buffer allocated in kernel space

gReadBuffer = kmalloc(BUF_SIZE, GFP_KERNEL);

I am totally confused about the SOURCE address.
In Documentation/DMA-mapping.txt
It is found to use pci_alloc_consistent()
But the virtual address returned by the function fails the virt_addr_valid()
Check.

The DESTINATION is given as ‘to’ and source is given as ‘from’ to the
following function.

Can anyone tell me what is going wrong here?
Am I giving the correct source address?

void *xor_memcpy(void *to, const void *from, __kernel_size_t n)
{
u32 xor_dma_unaligned_to, xor_dma_unaligned_from;
void *orig_to = to;
u32 to_pa, from_pa;
int ua = 0;
int chan;
struct xor_channel_t *channel;

DPRINTK("xor_memcpy(0x%x, 0x%x, %lu): entering
", (u32) to, (u32) from,
(unsigned long)n);

if (xor_engine_initialized == 0)
{
DPRINTK(KERN_WARNING" %s: xor engines not initialized
yet
", __func__);
xor_dma_miss++;
return asm_memmove(to, from, n);
}
if (!(virt_addr_valid((u32) to) && virt_addr_valid((u32)       /*THIS
VALIDATION CHECK FAILS*/
from))) { /*THE IOREMAPPED ADDRESS FAILS THIS CHECK*/
DPRINTK("xor_memcpy(0x%x, 0x%x, %lu): falling back to memcpy
",
(u32) to, (u32) from, (unsigned long)n);
xor_dma_miss++;
return asm_memmove(to, from, n);
}

/*
* We can only handled completely cache-aligned transactions
* with the DMA engine. Source and Dst must be cache-line
* aligned AND the length must be a multiple of the cache-line.
*/

to_pa = virt_to_phys(to);
from_pa = virt_to_phys((void*)from);

if (((to_pa + n > from_pa) && (to_pa < from_pa)) ||
((from_pa < to_pa) && (from_pa + n > to_pa))) {
DPRINTK("overlapping copy region (0x%x, 0x%x, %lu),
falling back
",
to_pa, from_pa, (unsigned long)n);
xor_dma_miss++;
return asm_memmove(to, from, n);
}
/*
* Ok, start addr is not cache line-aligned, so we need to make it so.
*/
        xor_dma_unaligned_to = (u32) to & 31;
        xor_dma_unaligned_from = (u32) from & 31;;
        if (xor_dma_unaligned_to | xor_dma_unaligned_from) {
                ua++;
                if (xor_dma_unaligned_from > xor_dma_unaligned_to) {
                        asm_memmove(to, from, 32 - xor_dma_unaligned_to);
                        to = (void *)((u32)to + 32 - xor_dma_unaligned_to);
                        from = (void *)((u32)from + 32 - xor_dma_unaligned_to);
                        n -= 32 - xor_dma_unaligned_to;
                } else {
                        asm_memmove(to, from, 32 - xor_dma_unaligned_from);
                        to = (void *)((u32)to + 32 - xor_dma_unaligned_from);
                        from = (void *)((u32)from + 32 -
xor_dma_unaligned_from);
                        n -= 32 - xor_dma_unaligned_from;
                }
        }

        /*
         * Ok, we're aligned at the top, now let's check the end
         * of the buffer and align that. After this we should have
         * a block that is a multiple of cache line size.
         */
        xor_dma_unaligned_to = ((u32) to + n) & 31;
        xor_dma_unaligned_from = ((u32) from + n) & 31;;
        if (xor_dma_unaligned_to | xor_dma_unaligned_from) {
                ua++;
                if (xor_dma_unaligned_to > xor_dma_unaligned_from) {
                        u32 tmp_to = (u32) to + n - xor_dma_unaligned_to;
                        u32 tmp_from = (u32) from + n - xor_dma_unaligned_to;

                        asm_memmove((void *)tmp_to, (void *)tmp_from,
                                   xor_dma_unaligned_to);

                        n -= xor_dma_unaligned_to;
                } else {
                        u32 tmp_to = (u32) to + n - xor_dma_unaligned_from;
                        u32 tmp_from = (u32) from + n - xor_dma_unaligned_from;

                        asm_memmove((void *)tmp_to, (void *)tmp_from,
                                   xor_dma_unaligned_from);

                        n -= xor_dma_unaligned_from;
              }
        }

        /*
         * OK! We should now be fully aligned on both ends.
         */
        chan = allocate_channel();
        if ( chan == -1)
        {
                DPRINTK("XOR engines are busy, return\n");
                xor_dma_miss++;
                return asm_memmove(to, from, n);
        }
        DPRINTK("setting up rest of descriptor for channel %d\n", chan);
        channel = &xor_channel[chan];

        /* Ensure that the cache is clean */
        dmac_clean_range(from, from + n);
        dmac_inv_range(to, to + n);

        DPRINTK("setting up rest of descriptor\n");
        // flush the cache to memory before XOR engine touches them
        channel->pDescriptor->srcAdd0 = virt_to_phys((void*)from);
        channel->pDescriptor->phyDestAdd = virt_to_phys(to);
        channel->pDescriptor->byteCnt = n;
        channel->pDescriptor->phyNextDescPtr = 0;
        channel->pDescriptor->status = BIT31;
        channel->chan_active = 1;
#if defined(MV_BRIDGE_SYNC_REORDER)
        mvOsBridgeReorderWA();
#endif
        if( mvXorTransfer(chan, MV_DMA, channel->descPhyAddr) != MV_OK)
        {
            printk(KERN_ERR "%s: DMA copy operation on channel %d
failed!\n", __func__, chan);
            print_xor_regs(chan);
            BUG();
            free_channel(channel);
            return asm_memmove(to, from, n);
        }
        xor_waiton_eng(chan);

        DPRINTK("DMA copy complete\n");
        free_channel(channel);

        xor_dma_hit++;
        if (ua)
                xor_dma_unaligned++;

        return orig_to;
}
EXPORT_SYMBOL(xor_memcpy);
}


I am quite new in kernel. Please help me.

Thanks in advance
Regards,
Anish
