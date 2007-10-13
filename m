Return-Path: <linux-kernel-owner+w=401wt.eu-S1760604AbXJMRtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760604AbXJMRtJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 13:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbXJMRs4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 13:48:56 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:60771 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751994AbXJMRsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 13:48:55 -0400
Message-ID: <47110500.8050503@garzik.org>
Date: Sat, 13 Oct 2007 13:48:48 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Torsten Kaiser <just.for.lkml@googlemail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, Kuan Luo <kluo@nvidia.com>,
       Peer Chen <pchen@nvidia.com>
Subject: Re: 2.6.23-mm1
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>	 <20071011234202.2f15bb76.akpm@linux-foundation.org>	 <64bb37e0710120131y6b939951y74c50bd596b1d938@mail.gmail.com>	 <20071012013729.ada2127b.akpm@linux-foundation.org>	 <64bb37e0710130101y7fb8e4c0lf214fd821e8305ed@mail.gmail.com>	 <4710A407.3070000@garzik.org>	 <64bb37e0710130503haa66d6eu93e75ecdc78ac866@mail.gmail.com>	 <4710B7C5.5050403@garzik.org>	 <64bb37e0710130732p303547e3n54cfa9dac34c53b5@mail.gmail.com>	 <64bb37e0710130740u78613f83wbd4f43d073bbe13d@mail.gmail.com> <64bb37e0710130813le68c48dve36f8473b197b84b@mail.gmail.com>
In-Reply-To: <64bb37e0710130813le68c48dve36f8473b197b84b@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------070805000105090406000304"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070805000105090406000304
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Torsten Kaiser wrote:
> On 10/13/07, Torsten Kaiser <just.for.lkml@googlemail.com> wrote:
>> Wait!
>>
>> I think I found the bug: Its a evil interaction between the above
>> patch and the swncq patch that is applied later.
>> The qc_defer patch removes the old ata_scmd_need_defer that was always
>> called for all drivers and substitutes it for ata_std_qc_defer and
>> adds it as aops->qc_defer to all drivers that support NCQ *at that
>> point*.
>> Then the swncq patch adds a new NCQ capable driver, but the nobody
>> added the qc_defer-ops to the ops-structure that is added. So swncq
>> will never defer any commands and the first command that would need to
>> be defered (the SMART commands) blows up, if there is still another
>> command in flight.
>>
>> I will only add the qc_defer and try this...
> 
> 3 boots, all worked. So I'm very sure that was the bug, but I will now
> do a little load testing...
> 
> The only strange thing about 2.6.23-mm1 is, that it takes ~4 second
> more to boot.

So, you basically applied the attached patch?

Yeah, absence of qc_defer for an NCQ-capable chip would do it.

	Jeff



--------------070805000105090406000304
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index cf5c85e..240a892 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -554,6 +554,7 @@ static const struct ata_port_operations nv_swncq_ops = {
 	.bmdma_start		= ata_bmdma_start,
 	.bmdma_stop		= ata_bmdma_stop,
 	.bmdma_status		= ata_bmdma_status,
+	.qc_defer		= ata_std_qc_defer,
 	.qc_prep		= nv_swncq_qc_prep,
 	.qc_issue		= nv_swncq_qc_issue,
 	.freeze			= nv_mcp55_freeze,

--------------070805000105090406000304--
