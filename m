Return-Path: <linux-kernel-owner+w=401wt.eu-S1756151AbYJWPTv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756151AbYJWPTv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 11:19:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbYJWPT3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 11:19:29 -0400
Received: from nebensachen.de ([195.34.83.29]:57558 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbYJWPT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 11:19:27 -0400
X-Hashcash: 1:20:081023:jens.axboe@oracle.com::y+7ge01QqEmBivab:00000000000000000000000000000000000000000kke
X-Hashcash: 1:20:081023:tj@kernel.org::DxFy/1dfIue7FZMP:00003apm
X-Hashcash: 1:20:081023:linux-ide@vger.kernel.org::/F/Zn6ICP5H6T9hJ:0000000000000000000000000000000000000vVu
X-Hashcash: 1:20:081023:linux-kernel@vger.kernel.org::VTP40w1c3saU12VM:0000000000000000000000000000000001QSW
X-Hashcash: 1:20:081023:jeff@garzik.org::HzMdnGhps7ZirmN3:000Ght
From: Elias Oltmanns <eo@nebensachen.de>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org
Subject: Re: [PATCH 1/2] libata: get rid of ATA_MAX_QUEUE loop in ata_qc_complete_multiple()
References: <1224661243-7929-1-git-send-email-jens.axboe@oracle.com>
	<1224661243-7929-2-git-send-email-jens.axboe@oracle.com>
	<48FFFA15.8060603@kernel.org> <20081023064357.GT22217@kernel.dk>
	<20081023134017.GA22217@kernel.dk>
Date: Thu, 23 Oct 2008 17:19:12 +0200
In-Reply-To: <20081023134017.GA22217@kernel.dk> (Jens Axboe's message of "Thu,
	23 Oct 2008 15:40:18 +0200")
Message-ID: <87tzb39w5r.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe <jens.axboe@oracle.com> wrote:
> On Thu, Oct 23 2008, Jens Axboe wrote:
>> On Thu, Oct 23 2008, Tejun Heo wrote:
>
>> > while (done_mask) {
>> >         struct ata_queued_cmd *qc;
>> >         unsigned int next = __ffs(done_mask);
>> > 
>> >         tag += next;
>> >         if ((qc = ata_qc_from_tag(ap, tag))) {
>> >                 ata_qc_complete(qc);
>> >                 nr_done++;
>> >         }
>> >         next++;
>> >         tag += next;
>> >         done_mask >>= next;
>> > }
>> 
>> That doesn't work (you're adding next to tag twice), it needs a little
>> tweak:
>> 
>> while (done_mask) {
>>         struct ata_queued_cmd *qc;
>>         unsigned int next = __ffs(done_mask);
>> 
>>         if ((qc = ata_qc_from_tag(ap, tag + next))) {
>>                 ata_qc_complete(qc);
>>                 nr_done++;
>>         }
>>         next++;
>>         tag += next;
>>         done_mask >>= next;
>> }
>> 
>> and I think it should work. Not tested yet :-)
>
> Pondered some more, and it can't work. The problem is that if we
> complete tag 31, we attempt to shift done_mask down by 32 bits. On a
> 32-bit arch, that's not defined. So we DO need a check like the existing
> one, or something similar.
>
> So I don't think we need to make changes to this patch either, at least
> unless one of you can come up with a better check that avoids a branch.

What about a switch outside the while loop:

	if (done_mask == ATA_MAX_QUEUE >> 1) {
		if ((qc = ata_qc_from_tag(ap, ATA_MAX_QUEUE >> 1))) {
			ata_qc_complete(qc);
			nr_done = 1;
		}
	} else
		while (done_mask)
			...

Alternatively, you could just alter tag and done_mask (tag =
ATA_MAX_QUEUE >> 2, done_mask = 2) and enter the while loop
unconditionally. But then, you claimed that there will hardly ever be
more than one command to complete, so my suggestions will probably not
improve anything in real life.

Regards,

Elias
