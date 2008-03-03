Return-Path: <linux-kernel-owner+w=401wt.eu-S1759394AbYCCJVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759394AbYCCJVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 04:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086AbYCCJVX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 04:21:23 -0500
Received: from wf-out-1314.google.com ([209.85.200.174]:26527 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025AbYCCJVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 04:21:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=jdyq5bZtMYaYF/SybgaN2M6aeccYXCOXjUebs9Ftst0DafbS6KpBrZY5Cqit3yTqj3R7uRmPNhRQmL6Q1WYsxHPzGSOwOsuQBUJc9u8A9FQ0mpphOY3amJaEaYD6fHzFrmaM0NG9UcLH03/B4Tc/hGLtWbeSG6fY8NnQk05UWfo=
Message-ID: <47CBC309.7090106@gmail.com>
Date: Mon, 03 Mar 2008 18:21:13 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: tomof@acm.org, jens.axboe@oracle.com,
       James.Bottomley@HansenPartnership.com, efault@gmx.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com
Subject: Re: [PATCH] block: fix residual byte count handling
References: <47CB6508.3040206@gmail.com>	<20080303125940T.fujita.tomonori@lab.ntt.co.jp>	<47CB79E9.8000505@gmail.com> <20080303172623O.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20080303172623O.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
>>> I can't see what changing the meaning of rq->data_len (and
>>> investigating all the block drivers) gives us.
>> No matter which way you go, you change the meaning of rq->data_len and
>> you MUST inspect rq->data_len usage whichever way you go.
> 
> The patch doens't change that rq->data_len means the true data
> length. But yeah, it breaks rq->data_len == sum(sg). So it might break
> some drivers.

Yeah, that's what I was saying.  You end up breaking one of the two
assumptions.  As sglist is getting modified for any driver if it has DMA
alignment set, whether rq->data_len is adjusted together or not, sglist
and data_len usages have to be audited.

>> Apply your patch and try to do sg IO on IDE cdrom w/ various
>> transfer lengths.
> 
> I've just tried the patch with both ata and libata and it seems to
> work.

Right, I missed you added extra_len in libata and IDE isn't using block
layer stuff yet.

> For anyone hitting this problem, please try the following patch:
> 
> http://lkml.org/lkml/2008/3/2/218

Whether rq->data_len stays with requested data buffer size or sum(sg), I
think we need to separate out padding from address alignment; otherwise,
we'll have to audit every block driver to make sure they can deal with
extended sglist no matter which value rq->data_len ends up indicating.

If padding is applied iff explicitly requested, rq->data_len indicates
matters only to the drivers which want to see the data length adjusted,
so most of the problems go away.

-- 
tejun
