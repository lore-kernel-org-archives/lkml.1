Return-Path: <linux-kernel-owner+w=401wt.eu-S934503AbXLQQJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934503AbXLQQJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 11:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933385AbXLQQJn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 11:09:43 -0500
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:40156 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932977AbXLQQJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 11:09:42 -0500
Message-ID: <47669F1B.4090400@panasas.com>
Date: Mon, 17 Dec 2007 18:08:59 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Filippos Papadopoulos <psybases@gmail.com>,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: INITIO scsi driver fails to work properly
References: <9f00bd9d0712170139q1397af5fp3c855a2b94726227@mail.gmail.com>	 <20071217031841.f483e5ac.akpm@linux-foundation.org>	 <20071217130523.7e9c88bb@the-village.bc.nu> <47668A75.7040707@panasas.com>	 <20071217143641.760d4162@the-village.bc.nu> <1197903781.3204.4.camel@localhost.localdomain>
In-Reply-To: <1197903781.3204.4.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17 2007 at 17:03 +0200, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> On Mon, 2007-12-17 at 14:36 +0000, Alan Cox wrote:
>> On Mon, 17 Dec 2007 16:40:53 +0200
>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>>
>>> On Mon, Dec 17 2007 at 15:05 +0200, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>>>>> initio doesn't seem to have a maintainer...
>>>>>
>>>>> Are you able to identify any earlier kernel which worked OK?
>>>>>
>>>>> Maybe it's a new device?  If you can get the `lspci -vvxx' output
>>>>> for that device we can take a look.
>>>> If I remember rightly the fixes for this went into the scsi tree a couple
>>>> of months ago. The patch is in the -mm tree as well. No idea why its
>>>> gotten stuck as an obvious one liner.
>>>>
>>>> Alan
>>>> -
>>> You mean this one:
>>> http://git.kernel.org/?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commitdiff;h=ba2c270154cc90c9a8bfc45b7bed4cca78c75aaf
>>>
>>> It's only queued for 2.6.25 via scsi-misc.
>>>
>>> I have found another bug. (See other mail in thread). I Will wait for testing
>>> and submit a proper patch.
>> That one yes - which really should have gone straight into the main tree
>> as the initio driver has been broken all the time it sits queued for
>> future patches. It can't make the problem any worse - the driver does not
>> work.
> 
> Well, the change log isn't very committal for "rush me immediately into
> main line" plus, as far as I could dig out, there was no confirmation
> that it actually worked.  This way, I can now say please try the current
> -mm kernel to the bug reporter and we get to see if this fixes the
> problem.
> 
> James
> 
Below fixes a deadly typo. Might as well be included in 2.6.24
Boaz

--------
>From fdf8ca414f9bb9a5a2cab602991cbac0b128ea65 Mon Sep 17 00:00:00 2001
From: Boaz Harrosh <bharrosh@panasas.com>
Date: Mon, 17 Dec 2007 18:04:11 +0200
Subject: [PATCH] initio: bugfix for accessors patch

  patch: [SCSI] initio: convert to use the data buffer accessors
  had a small but fatal bug. Fixed here.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/initio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index 769a7a8..01bf018 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -2616,6 +2616,7 @@ static void initio_build_scb(struct initio_host * host, struct scsi_ctrl_blk * c
 		scsi_for_each_sg(cmnd, sglist, cblk->sglen, i) {
 			sg->data = cpu_to_le32((u32)sg_dma_address(sglist));
 			total_len += sg->len = cpu_to_le32((u32)sg_dma_len(sglist));
+			++sg;
 		}
 
 		cblk->buflen = (scsi_bufflen(cmnd) > total_len) ?
-- 
1.5.3.3



