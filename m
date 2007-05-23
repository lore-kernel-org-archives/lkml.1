Return-Path: <linux-kernel-owner+w=401wt.eu-S1764862AbXEWJaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764862AbXEWJaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 05:30:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758263AbXEWJaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 05:30:05 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:56762 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757673AbXEWJaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 05:30:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=VUQjelHrbsRkai6HH94R8IYGom9WqnigYTuFhcn0QbwkSs4TYQCtrCALHmPdqF1QwBx8dTXwYb3NSG3cXQPS7o98hwHNxpeA8R6UIG3U2AMz5QndVQb6Ucu9sCvPxUKUMVEm6VH6qRnyRrNYvzuIVMK/4k5kby3TlldGCQf+5xQ=
Message-ID: <46540981.9080603@gmail.com>
Date: Wed, 23 May 2007 11:29:37 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, Tejun Heo <htejun@gmail.com>,
       Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: pata_platform: Disable prereset logic.
References: <20070523064408.GA29593@linux-sh.org> <4653F62C.4070700@gmail.com> <20070523083026.GA29851@linux-sh.org>
In-Reply-To: <20070523083026.GA29851@linux-sh.org>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------060408010508000708070509"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060408010508000708070509
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Paul Mundt wrote:
> On Wed, May 23, 2007 at 10:07:08AM +0200, Tejun Heo wrote:
>> Paul Mundt wrote:
>>> On a number of boards the current prereset logic seems to misbehave:
>>>
>>> scsi0 : pata_platform
>>> ata1: PATA max PIO0 cmd 0xb06001f0 ctl 0xb06003f6 bmdma 0x00000000 irq 0
>>> ata1: device not ready (errno=-19), forcing hardreset
>>> ata1: BUG: prereset() requested invalid reset type
>>>
>>> This triggers when there is no card inserted in the slot.
>>>
>>> Simply disabling the prereset gets rid of this, and doesn't seem to cause
>>> any problems for either PCMCIA or CF cards when they're actually present.
>> NACK.  The BUG printking needs fixing but you can't just kill
>> prereset().  Did it work properly on 2.6.21.1?  Can you modify
>> ata_wait_ready() such that it prints out the status value while waiting?
>>
> ata_wait_ready() works fine, it reports 0xff immediately (and this is
> what I would expect when there is no card inserted).

Does the attached patch fix your problem?

-- 
tejun

--------------060408010508000708070509
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index a6de57e..79f2175 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3368,7 +3368,7 @@ int ata_std_prereset(struct ata_port *ap
 	 */
 	if (!(ap->flags & ATA_FLAG_SKIP_D2H_BSY) && !ata_port_offline(ap)) {
 		rc = ata_wait_ready(ap, deadline);
-		if (rc) {
+		if (rc && rc != -ENODEV) {
 			ata_port_printk(ap, KERN_WARNING, "device not ready "
 					"(errno=%d), forcing hardreset\n", rc);
 			ehc->i.action |= ATA_EH_HARDRESET;

--------------060408010508000708070509--
