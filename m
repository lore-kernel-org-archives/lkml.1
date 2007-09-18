Return-Path: <linux-kernel-owner+w=401wt.eu-S1761236AbXIRRXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761236AbXIRRXt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 13:23:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759635AbXIRRXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 13:23:38 -0400
Received: from wx-out-0506.google.com ([66.249.82.230]:22912 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759694AbXIRRXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 13:23:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=IkVi8oojEGjZaHR7XqeeNpGueg+ZakP8LnPVgR62QmcANTQVbNr8A+oL0eM6VDGxXQ1ewCKbCyiNqWSlqe/aTrTDz4uKBXXNHvC1SGDuECSnb/6yxQu0ulMOYYne2+PDkSJPrEsEufODVhH5sQPh5DFwaPtG6Dzz8my19DblxNw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Michael Chan <mchan@broadcom.com>
Subject: bnx2 dirver's firmware images
Date: Tue, 18 Sep 2007 18:23:26 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709181823.26429.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

In bnx2_fw.h I see the following:

static u32 bnx2_RXP_b06FwBss[(0x13dc/4) + 1] = { 0x0 };

static struct fw_info bnx2_rxp_fw_06 = {
...
        .bss                            = bnx2_RXP_b06FwBss,
...
};

I grepped for the usage of .bss member (grepped for '[.>]bss[^_]')
and it is used only here:

        if (fw->bss) {
                int j;

                for (j = 0; j < (fw->bss_len/4); j++, offset += 4) {
                        REG_WR_IND(bp, offset, fw->bss[j]);
                }
        }

If I understand it correctly, you read zero words one by one from
bnx2_RXP_b06FwBss and writing them into the card. This is very
suboptimal usage of nearly 5k of kernel unswappable memory.

Do you plan to fix it?

Do you have any plans to switch to request_firmware() interface,
which will allow you to avoid keeping firmware in unswappable kernel
memory and thus free ~80k?

$ size bnx2.o
   text    data     bss     dec     hex filename
  52255   81551    6360  140166   22386 bnx2.o
--
vda
