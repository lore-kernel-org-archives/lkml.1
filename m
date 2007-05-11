Return-Path: <linux-kernel-owner+w=401wt.eu-S1759033AbXEKJjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759033AbXEKJjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 05:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755945AbXEKJjf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 05:39:35 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:17181 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754834AbXEKJjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 05:39:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=XFF2AAfPHPkGLnaB8cxb76mswQH9N9MAi8CDJeUyc9tQ3WptAWzy/I2oS7EZ2O8AgPmAhD8t5qcUjXq6ITtZk2x34PIGDiJA2Txj7IVES/wHGY//lthmKTs09dPDFYyy2BQZhSIkHfXDtSro+mmU2Sljri7LtCEuO9fKLuVM6lg=
Message-ID: <464439C8.7090309@gmail.com>
Date: Fri, 11 May 2007 11:39:20 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>, Tejun Heo <htejun@gmail.com>,
       jeff@garzik.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
CC: garyhade@us.ibm.com
Subject: Re: libata reset-seq merge broke sata_sil on sh
References: <20070510072005.GA27316@linux-sh.org> <464301D3.5060306@gmail.com> <464307CC.40701@gmail.com> <20070510072005.GA27316@linux-sh.org> <464301D3.5060306@gmail.com> <20070510124645.GA18534@linux-sh.org> <4643196B.7070806@gmail.com> <20070511005217.GA23186@linux-sh.org>
In-Reply-To: <20070511005217.GA23186@linux-sh.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[cc'ing Gary Hade for GoVault drive, Hello]

Hello, Paul.

Paul Mundt wrote:
> On Thu, May 10, 2007 at 03:08:59PM +0200, Tejun Heo wrote:
>> Paul Mundt wrote:
>>> The detection is simply flaky after that point, however before the
>>> current master it never hit the 35 second point (and thus never implied
>>> that the link was down). I'll double check the bisect log to see if there
>>> was anything beyond that that may have caused it.
>>>
>>> The -ENODEV at least implies that the SRST fails, so at least that's a
>>> starting point.
>> If prereset() fails to get the initial DRDY before 10secs, it assumes
>> something went wrong and escalates to hardreset.  sil family of
>> controllers report 0xff status while the link is broken and it seems
>> that your particular drive needs more than the current 150ms to recover
>> phy link.  It probably went unnoticed till now because the device was
>> never hardreset before.  If the diagnosis is correct, increasing the
>> delay in hardreset should fix the problem.  Well, let's see.  :-)
>>
> Bumping the hardreset delay up does indeed fix it, I've had to bump it up
> to 1200 before it started working (at 600 it still fails):
> 
> [    0.967379] scsi0 : sata_sil
> [    0.970425] scsi1 : sata_sil
> [    0.973298] ata1: SATA max UDMA/100 cmd 0xfd000280 ctl 0xfd00028a bmdma 0xfd000200 irq 0
> [    0.981331] ata2: SATA max UDMA/100 cmd 0xfd0002c0 ctl 0xfd0002ca bmdma 0xfd000208 irq 0
> [    1.299353] ata1: device not ready (errno=-19), forcing hardreset
> [    2.817893] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> [    2.826284] ata1.00: ata_hpa_resize 1: sectors = 39070080, hpa_sectors = 39070080
> [    2.831052] ata1.00: ATA-5: HHD424020F7SV00, 00MLA0A5, max UDMA/100
> [    2.837548] ata1.00: 39070080 sectors, multi 0: LBA
> [    2.842702] ata1.00: applying bridge limits
> [    2.854162] ata1.00: ata_hpa_resize 1: sectors = 39070080, hpa_sectors = 39070080
> [    2.858938] ata1.00: configured for UDMA/100
> [    3.172602] ata2: SATA link down (SStatus 0 SControl 310)
> [    3.175736] scsi 0:0:0:0: Direct-Access     ATA      HHD424020F7SV00  00ML PQ: 0 ANSI: 5
> 
> I'm not sure if it matters or not, but this is an iVDR drive, so that
> might also have additional implications.

Don't have the flimsiest idea what an iVDR drive is but I take it that
it's some sort of special purpose thing.  :-)

So, the HHD424020F7SV00 is the second device which isn't happy with
150ms wait after reset.  The first one was Quantum GoVault.  It's a bit
different in that the HHD only fails after hardreset.

Anyways, so, it seems we'll have to extent the 150ms wait.  I'll try to
cook up a patch for that && parallel probing.

Gary, IIRC, the requirement for GoVault was 3secs, right?  Paul, can you
try to estimate the minimum required delay?  Please go down by 100ms and
report where it breaks.

Thanks.

-- 
tejun
