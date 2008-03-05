Return-Path: <linux-kernel-owner+w=401wt.eu-S1753081AbYCENqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081AbYCENqa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 08:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751215AbYCENqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 08:46:18 -0500
Received: from wa-out-1112.google.com ([209.85.146.177]:63719 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbYCENqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 08:46:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=svdHG/t8d/AuM8+EITwiDRf5R1+fyDeTFC/VkXbBMltv0C+dPAnFOsjoGUluceh12nEU9XxQqWeKLTaAnmRxEDiS4zmP3RLIIfn11nZxHa2Gwk2OO2gxtxk+KU+uMqfzxu/Rz4htd/mVMraG6obswi+FFC+QwaUjoGSCT//V17o=
Message-ID: <47CEA40F.6050903@gmail.com>
Date: Wed, 05 Mar 2008 22:45:51 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Boaz Harrosh <bharrosh@panasas.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Galbraith <efault@gmx.de>, James.Bottomley@HansenPartnership.com,
       tomof@acm.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com, bzolnier@gmail.com
Subject: Re: [PATCH] blk: missing add of padded bytes to io completion byte
  count
References: <47CD7C05.1080707@gmail.com> <20080305041914V.tomof@acm.org> <47CDDC31.4070806@gmail.com> <20080305092619Y.fujita.tomonori@lab.ntt.co.jp> <47CE72EF.7050302@panasas.com> <20080305123317.GI6704@kernel.dk> <47CE9634.6040501@panasas.com> <20080305124857.GJ6704@kernel.dk>
In-Reply-To: <20080305124857.GJ6704@kernel.dk>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens, Boaz.

Jens Axboe wrote:
>>>> From: Boaz Harrosh <bharrosh@panasas.com>
>>>> Date: Wed, 5 Mar 2008 12:07:12 +0200
>>>> Subject: [PATCH] blk: missing add of padded bytes to io completion byte count
>>>>
>>>> the commit e97a294ef6938512b655b1abf17656cf2b26f709 was very wrong. This is
>>>> because scsi-ml supports the ability to split a request into smaller chunks,
>>>> in which case scsi_bufflen() is smaller then request length. Then at completion
>>>> time the remainder can be issued as a new scsi command. In that case the above
>>>> commit is a data corruption.

Thanks for catching the stupidity.  Did it actually happen?  PC commands
are not completed in pieces and padding / draining should only happen
for those.  qc->extra_len should be zero where commands can be splitted
for all current cases.

>>> We needed something for -rc4, so it had to be rushed a bit...
>>>
>>>> Also in this fix all users of block layer are taken care of, and not only
>>>> scsi devices.
>>>>
>>>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
>>>> Signed-off-by: Benny Halevy <bhalevy@panasas.com>
>>>> ---
>>>>  block/blk-core.c    |    4 ++++
>>>>  drivers/scsi/scsi.c |    2 +-
>>>>  2 files changed, 5 insertions(+), 1 deletions(-)
>>>>
>>>> diff --git a/block/blk-core.c b/block/blk-core.c
>>>> index 2a438a9..37fcccc 100644
>>>> --- a/block/blk-core.c
>>>> +++ b/block/blk-core.c
>>>> @@ -1549,6 +1549,9 @@ static int __end_that_request_first(struct request *req, int error,
>>>>  			     nr_bytes >> 9, req->sector);
>>>>  	}
>>>>  
>>>> +	if (nr_bytes >= blk_rq_bytes(req))
>>>> +		nr_bytes += req->extra_len;
>>>> +

This is getting insanely subtle.  Let's say there's PIO driver which
transfer certain sized chunks at a time and completes request partially
after completing each chunk and the driver uses draining to eat up
whatever excess data, which seems like a legit use case to me.  But it
won't work because __end_that_request_first() will terminate when it
reaches reaches the 'true' transfer size.  That's just broken API.  FWIW,

Nacked-by: Tejun Heo <htejun@gmail.com>

-- 
tejun
