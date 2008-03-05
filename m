Return-Path: <linux-kernel-owner+w=401wt.eu-S1755269AbYCEPMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755269AbYCEPMe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 10:12:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbYCEPMQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 10:12:16 -0500
Received: from wr-out-0506.google.com ([64.233.184.231]:62847 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752445AbYCEPMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 10:12:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=oI1Xu2YnWt9S8vEfezh5uugNHHK9cmMz4PWl5tL46ohYLGScTVSMktoMzT1TZP/bHMoKF/AV/0Um2N84q8woNC1exdfSo10E7Oy804q8J9yPV8yGGzte08QT3Y8vm6wCQ8TmDZOU5Dpam3gucTuYFW0k7vduBLZqCn5DD90f5Ls=
Message-ID: <47CEB832.4040807@gmail.com>
Date: Thu, 06 Mar 2008 00:11:46 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Galbraith <efault@gmx.de>, James.Bottomley@HansenPartnership.com,
       tomof@acm.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com, bzolnier@gmail.com
Subject: Re: [PATCH] blk: missing add of padded bytes to io completion byte
 count
References: <47CD7C05.1080707@gmail.com> <20080305041914V.tomof@acm.org> <47CDDC31.4070806@gmail.com> <20080305092619Y.fujita.tomonori@lab.ntt.co.jp> <47CE72EF.7050302@panasas.com> <20080305123317.GI6704@kernel.dk> <47CE9634.6040501@panasas.com> <20080305124857.GJ6704@kernel.dk> <47CEA40F.6050903@gmail.com> <47CEB23E.4000809@panasas.com>
In-Reply-To: <47CEB23E.4000809@panasas.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Boaz.

Boaz Harrosh wrote:
>> This is getting insanely subtle.  Let's say there's PIO driver which
>> transfer certain sized chunks at a time and completes request partially
>> after completing each chunk and the driver uses draining to eat up
>> whatever excess data, which seems like a legit use case to me.  But it
>> won't work because __end_that_request_first() will terminate when it
>> reaches reaches the 'true' transfer size.  That's just broken API.  FWIW,
>>
>> Nacked-by: Tejun Heo <htejun@gmail.com>
>>
> 
> I don't understand? Drivers can still do that. Do you mean That it wants
> to also complete the draining portion in smaller chunks? I thought the draining
> is always done at once, at most. Is that theoretical or is it so in any of the 
> drivers.

Ah... I wasn't really Nacking your patch specifically.  I was trying to
say "this scheme isn't gonna work".  Your patch does make good sense
given the situation (and I think I did acknowledge that above).  Sorry
about the miscommunication.

> Any way Nack from my side on the scsi_finish_command(), it makes too many 
> assumptions that are unchecked anywhere. And it's a terrible layering violation.
> scsi is a pass-threw block device, the fix should be in block or in using device
> drivers (eg libata), that know what is going on.

Yeap, completely agreed.  That one gets my big Nack-You-Idiot.

> Any way you are always saying req->data_len == sum(sg) but that  was certainly
> never true for scsi_bufflen() == sum(sg) so leave that alone please.

I don't really care about scsi_bufflen() and I'm not willing to change
any of that.  If SCSI LLDs are happy with scsi_bufflen() != sum(sg), no
problem at all.  What I'm against is pushing that into block layer,
which until now had "true" size == rq->data_len == sum(sg).

We're about to break one of the two equals if we're gonna do sg
manipulation in block layer (Jens seems to be planning something
different) and all I'm saying is we're far better off breaking the
former one.

First, I don't really think SCSI LLDs will make much use of explicit
padding or draining.  Secondly, even when such need arises, keeping
scsi_bufflen() at the "true" size is easy no matter which way we go with
rq->data_len.

Anyways, let's wait and see what Jens comes up with.

> Any other block layer fixes are welcome. But for now this is the best fix we have
> that only breaks theoretical, yet to be submitted drivers.

Yeap, given the current code, I agree.

Thanks.

-- 
tejun
