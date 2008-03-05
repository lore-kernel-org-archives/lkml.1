Return-Path: <linux-kernel-owner+w=401wt.eu-S1754244AbYCEOIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754244AbYCEOIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 09:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751678AbYCEOIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 09:08:22 -0500
Received: from rn-out-0910.google.com ([64.233.170.185]:61666 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbYCEOIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 09:08:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=WHKR+afMzmEYq+xR+yDtS6hHIZLftnhthObhqfi3rKDWm781V5tGWgPuao6Bcjab9KaPrbXuvH1GCL7VIruyom5R5sVr6w+OndcxsB3MBTSO4Gxe/1YVhxqH1q6nIYcDIAxZr1L7tZQG6DJCagxvGBimXy5Mqv8EXR9FAVIVQK4=
Message-ID: <47CEA948.6050408@gmail.com>
Date: Wed, 05 Mar 2008 23:08:08 +0900
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
References: <47CD7C05.1080707@gmail.com> <20080305041914V.tomof@acm.org> <47CDDC31.4070806@gmail.com> <20080305092619Y.fujita.tomonori@lab.ntt.co.jp> <47CE72EF.7050302@panasas.com> <20080305123317.GI6704@kernel.dk> <47CE9634.6040501@panasas.com> <20080305124857.GJ6704@kernel.dk> <47CEA40F.6050903@gmail.com> <20080305135121.GK6704@kernel.dk>
In-Reply-To: <20080305135121.GK6704@kernel.dk>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Jens.

Jens Axboe wrote:
>> This is getting insanely subtle.  Let's say there's PIO driver which
>> transfer certain sized chunks at a time and completes request partially
>> after completing each chunk and the driver uses draining to eat up
>> whatever excess data, which seems like a legit use case to me.  But it
>> won't work because __end_that_request_first() will terminate when it
>> reaches reaches the 'true' transfer size.  That's just broken API.  FWIW,
>>
>> Nacked-by: Tejun Heo <htejun@gmail.com>
> 
> Yeah, I think I may have gone a bit overboard in applying this so
> quickly. It's just not a good interface, silently adding the extra
> length if asked to complete more. It may even happen right now, for a
> driver that does no padding (it probably wont do any harm here either,
> but still).

Unless it explicitly requests padding, it shouldn't be a problem
extra_len will always be zero and currently the only driver which uses
padding and draining is libata.

> I'll try and see if I can come up with something cleaner.
> 
> My basic design paradigm for this is that the _driver_ (or mid layer, if
> SCSI wants to handle it) should care about the padding. So make it easy
> for them to pad, but have it 'unrolled' by completion time. We should
> NOT need any extra_len checks or additions in the block/ directory,
> period.

Maybe I'm from Mars but I don't really understand all this fuss.  The
two patches I posted way back work perfectly fine and don't have any of
these problems and as I have said again and again that's because it
doesn't break the assumption which our internal mechanics depend on.

Can you please put the "true" size aside for a while and consider those
patches?  There's nothing fundamentally wrong with letting the
rq->data_len be sum(sg) which can differ from user requested data length
if and only if low level driver requests so.

If you can come up with something nicer, that will be great too but I
really don't think the current scheme will work.

Thanks.

-- 
tejun
