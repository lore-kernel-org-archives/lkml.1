Return-Path: <linux-kernel-owner+w=401wt.eu-S1759422AbZD2BXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759422AbZD2BXz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 21:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755990AbZD2BXp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 21:23:45 -0400
Received: from brm-mailgate-2.brocade.com ([144.49.197.3]:9957 "EHLO
	brm-mailgate-2.brocade.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755162AbZD2BXp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 21:23:45 -0400
x-mimeole: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: bug in drivers/edac/mpc85xx_edac.c:mpc85xx_mc_check()
Date: Tue, 28 Apr 2009 18:23:42 -0700
Message-ID: <57AC2FA1761300418C7AB8F3EA493C9702E319DB@HQ-EXCH-5.corp.brocade.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: bug in drivers/edac/mpc85xx_edac.c:mpc85xx_mc_check()
Thread-Index: AcnIaSI4030RL+J3TGC2Z9EvLjGxUA==
From: "Jeff Haran" <jharan@Brocade.COM>
To: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 29 Apr 2009 01:23:43.0901 (UTC) FILETIME=[22E034D0:01C9C869]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Recent versions of this function contain the following snippets:

    if (err_detect & DDR_EDE_SBE)
        edac_mc_handle_ce(mci, pfn, err_addr & PAGE_MASK,
                  syndrome, row_index, 0, mci->ctl_name);

    if (err_detect & DDR_EDE_MBE)
        edac_mc_handle_ue(mci, pfn, err_addr & PAGE_MASK,
                  row_index, mci->ctl_name);

I am pretty sure the references to PAGE_MASK should be proceeded by a
tilda, as in:

    if (err_detect & DDR_EDE_SBE)
        edac_mc_handle_ce(mci, pfn, err_addr & ~PAGE_MASK,
                  syndrome, row_index, 0, mci->ctl_name);

    if (err_detect & DDR_EDE_MBE)
        edac_mc_handle_ue(mci, pfn, err_addr & ~PAGE_MASK,
                  row_index, mci->ctl_name);


Much as I would like to submit a tested patch like the rest of the
world, I find myself in the situation where the only Freescale target
system I have to test on is running a 3 year old kernel (2.6.14), which
preceeds the introduction of EDAC driver support, at least for
Freescale. So the best I can do is borrow from the new EDAC driver and
backport it to the old kernel.

But I have learned a few things in this process and can thus share what
I've learned as it may be of help to the EDAC driver developers:

1) Before you read the Freescale 8548 CAPTURE_ADDRESS register, you want
to read CAPTURE_ATTRIBUTES first and make sure the VLD bit (least
significant bit in the register) is set or else the data in
CAPTURE_ADDRESS may not be yet valid.

2) When you are done scrubbing the memory with the single bit error, you
want to write 0 to CAPTURE_ATTRIBUTES so as to clear VLD and thus setup
the ECC capture logic to capture the next single bit error.

Please include this email address in responses as I do not subscribe.

Thanks,

Jeff Haran
Brocade
