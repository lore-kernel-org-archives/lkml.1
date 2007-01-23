Return-Path: <linux-kernel-owner+w=401wt.eu-S1751873AbXAWBYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873AbXAWBYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 20:24:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932137AbXAWBYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 20:24:48 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:32348 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbXAWBYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 20:24:46 -0500
Date: Mon, 22 Jan 2007 19:24:22 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SATA exceptions with 2.6.20-rc5
In-reply-to: <fa.4QxeKMcmkoyhlL26AivZV6BFQJQ@ifi.uio.no>
To: =?ISO-8859-1?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       Robert Hancock <hancockr@shaw.ca>, Jeff Garzik <jeff@garzik.org>,
       Chr <chunkeey@web.de>, Alistair John Strachan <s0348365@sms.ed.ac.uk>,
       linux-kernel@vger.kernel.org, htejun@gmail.com, jens.axboe@oracle.com,
       lwalton@real.com, pomac@vapor.com
Message-id: <45B563C6.5070505@shaw.ca>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_M1DEzE9gNBICK2MbKZa4Ag)"
References: <fa.ow4pXUncgdZmfLf3oyfrn1W+Bk0@ifi.uio.no>
 <fa.SoSeidhDuEr/K0kN+L4vW61Vpnc@ifi.uio.no>
 <fa.m8QbVQMhuOshKzTdlSjNjOhaNcc@ifi.uio.no>
 <fa.hDS02YCM8Tv1/STeTpJGEQD/49s@ifi.uio.no>
 <fa.eqBbU9XvtTizNMpuUjctnk8vuOI@ifi.uio.no>
 <fa.4QxeKMcmkoyhlL26AivZV6BFQJQ@ifi.uio.no>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_M1DEzE9gNBICK2MbKZa4Ag)
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 8BIT

Björn Steinbrink wrote:
>>> Running a kernel with the return statement replace by a line that prints
>>> the irq_stat instead.
>>>
>>> Currently I'm seeing lots of 0x10 on ata1 and 0x0 on ata2.
>> 40 minutes stress test now and no exception yet. What's interesting is
>> that ata1 saw exactly one interrupt with irq_stat 0x0, all others that
>> might have get dropped are as above.
>> I'll keep it running for some time and will then re-enable the return
>> statement to see if there's a relation between the irq_stat 0x0 and the
>> exception.
> 
> No, doesn't seem to be related, did get 2 exceptions, but no irq_stat
> 0x0 for ata1. Syslog/dmesg has nothing new either, still the same
> pattern of dismissed irq_stats.

I've finally managed to reproduce this problem on my box, by doing:

watch --interval=0.1 /sbin/hdparm -I /dev/sda

on one drive and then running bonnie++ on /dev/sdb connected to the 
other port on the same controller device. Usually within a few minutes 
one of the IDENTIFY commands would time out in the same way you guys 
have been seeing.

Through some various trials and tribulations, the only conclusion I can 
come to is that this controller really doesn't like that 
NV_INT_STATUS_CK804 register being looked at in ADMA mode. I tried 
adding some debug code to the qc_issue function that would check to see 
if the BUSY flag in altstatus went high or that register showed an 
interrupt within a certain time afterwards, however that really seemed 
to hose things, the system wouldn't even boot.

Try out this patch, it just calls the ata_host_intr function where 
appropriate without using nv_host_intr which looks at the 
NV_INT_STATUS_CK804 register. This is what the original ADMA patch from 
Mr. Mysterious NVIDIA Person did, I'm guessing there may be a reason for 
that. With this patch I can get through a whole bonnie++ run with the 
repeated IDENTIFY requests running without seeing the error.

As an aside, there seems to be some dubious code in nv_host_intr, if 
ata_host_intr returns 0 for handled when a command is outstanding, it 
goes and calls ata_check_status anyway. This is rather dangerous since 
if an interrupt showed up right after ata_host_intr but before 
ata_check_status, the ata_check_status would clear it and we would 
forget about it. I tried fixing just that issue and still had this 
problem however. I suspect that code is truly broken and needs further 
thought, but this patch avoids calling it in the ADMA case, at any rate.

As a final aside, this is another case where the hardware docs for this 
controller would really be useful, in order to know whether we are 
actually supposed to be reading that register in ADMA mode or not. I 
sent a query to Allen Martin at NVIDIA asking if there's a way I could 
get access to the documents, but I haven't heard anything yet.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


--Boundary_(ID_M1DEzE9gNBICK2MbKZa4Ag)
Content-type: text/plain; name=sata_nv-dont-check-ck804-int-status-in-adma.patch
Content-transfer-encoding: 7BIT
Content-disposition: inline;
 filename=sata_nv-dont-check-ck804-int-status-in-adma.patch

--- linux-2.6.20-rc5/drivers/ata/sata_nv.c	2007-01-19 19:18:53.000000000 -0600
+++ linux-2.6.20-rc5debug/drivers/ata/sata_nv.c	2007-01-22 18:35:09.000000000 -0600
@@ -750,9 +750,9 @@ static irqreturn_t nv_adma_interrupt(int
 
 			/* if in ATA register mode, use standard ata interrupt handler */
 			if (pp->flags & NV_ADMA_PORT_REGISTER_MODE) {
-				u8 irq_stat = readb(host->mmio_base + NV_INT_STATUS_CK804)
-					>> (NV_INT_PORT_SHIFT * i);
-				handled += nv_host_intr(ap, irq_stat);
+				struct ata_queued_cmd *qc = ata_qc_from_tag(ap, ap->active_tag);
+				if(qc && !(qc->tf.flags & ATA_TFLAG_POLLING))
+					handled += ata_host_intr(ap, qc);
 				continue;
 			}
 

--Boundary_(ID_M1DEzE9gNBICK2MbKZa4Ag)--
