Return-Path: <linux-kernel-owner+w=401wt.eu-S1752605AbYIWJxc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605AbYIWJxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 05:53:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751105AbYIWJxL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 05:53:11 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:14630 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890AbYIWJxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 05:53:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=GzTOPZV5w8pPOUrk0iQHOObL3QaRa7OfzvNXeKiJlcHNXKrVnWsl9JCCAnuToZIoho
         BBRv+oIQoCiXU2TG0l2CbAhCNKBx0NgoJa7FpiqHbshf5Vnsyo0NauOX4LjpX7gHXm+T
         CZ0xACJIM0qrR+P6AhDaLhIIr2mQP5Hs7QDAw=
Message-ID: <e5931ce10809230253m7d821c3ev48676884bb382eaf@mail.gmail.com>
Date: Tue, 23 Sep 2008 17:53:06 +0800
From: "=?BIG5?B?sf6kSLq1?=" <killman.bear@msa.hinet.net>
To: linux-kernel@vger.kernel.org
Subject: IDE DMA sglist handle probelem
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: a31a0d21b766a9a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I want to test a private cache for IDE R/W in 2.6.26.
Before develop the private cache, I need to do something with the IDE
read/write buffer.
If service a read command, I replace the DMA buffer address of sglist
by my buffer before transfer, and memcpy the received data(in my
buffer) to original DMA buffer of sglist.
If service a write command, I replace the DMA buffer address by my
buffer, and memcpy the write data from sglist to my buffer, then
transfer it.
I implement it on  linux-2.6.26/drivers/ata/libata-core.c.

I replace each DMA address of sglist as follow:
-----------------------------------------------------------------------------
       for_each_sg(qc->sg, sg, qc->n_elem, si) {
       u32 addr, len;
               addr = sg_dma_address(sg);
               len = sg_dma_len(sg);

               //if write command, copy data from DMA address to my buf
               if (qc->tf.command == ATA_CMD_WRITE || qc->tf.command ==
ATA_CMD_WRITE_EXT) {
                       memcpy(myBuf[si], bus_to_virt(addr), len);
               }

               //save orignal DAM address
               savedAddr[si] = (unsigned char *)addr;

               //replace DMA address by my buf
               sg_dma_address(sg) = myBuf[si];
       }
-----------------------------------------------------------------------------
The book Linux Device Driver say that driver can not access DMA sg
between dma_map_sg and dma_unmap_sg, so I implement them before
dma_map_sg and after dma_unmap_sg.
I use a burn-in tool to test the fixed functions, and found the data
verify success for 80 hours, buf if I try to extract three big
packages in the disk at the same time, the kernel panic:

BUG: unable to handle kernel paging request a ff450fd7
IP:[<c05f5ba4>] iret_exc+0x68c/0x8d2
*pde = 00008067 *pte = 00000000
Oop : 0002 [#1] SMP

I do not know what is wrong.
How to access the sglist DMA buffer correctly?
