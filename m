Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbYCCOXP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbYCCOXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 09:23:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752232AbYCCOW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 09:22:58 -0500
Received: from ag-out-0708.google.com ([72.14.246.245]:28693 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbYCCOW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 09:22:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=Hmw4wLzVkBR8QHq+izZmNXkooaDehlONUXuWwxxYE0Bgh7tb5TU9yHqYPQkLI4MgFSMQMzFRGBLl3s/7NI6u+bHFHGSJ4tlUBO9wFr4yCgSThMraxAgYhmU6nV7Evswaf3ELMsSArPRqfEbFqH1YfSX2ZLAm+vME4scI5WEFzP8=
Message-ID: <47CC09B6.6090709@gmail.com>
Date: Mon, 03 Mar 2008 23:22:46 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: FUJITA Tomonori <tomof@acm.org>
CC: fujita.tomonori@lab.ntt.co.jp, jens.axboe@oracle.com,
       James.Bottomley@HansenPartnership.com, efault@gmx.de,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       jgarzik@pobox.com
Subject: Re: [PATCH] block: fix residual byte count handling
References: <47CBFF6F.4060301@gmail.com>	<20080303225024J.tomof@acm.org>	<47CC036C.2060902@gmail.com> <20080303230121M.tomof@acm.org>
In-Reply-To: <20080303230121M.tomof@acm.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
>> At the end of blk_rq_map_user() together with data_len / extra_len
>> mangling or were you talking about James' original patch?
> 
> With my patch, at the end of blk_rq_map_user, we have:
> 
> 	if (len & queue_dma_alignment(q)) {
> 		unsigned int pad_len = (queue_dma_alignment(q) & ~len) + 1;
> 
> 		rq->extra_len += pad_len;
> 	}
> 
> 
> So no change as compared with 2.6.24?

Oh.. you killed sg list manipulation.  Many controllers do allow odd
bytes as the last sg entry but not all.  Also, if you append drain
buffer after it, it ends up with unaligned sg entry in the middle and
rq->data_len + rq->extra_len will overrun the sg entry after the drain
page which is really dangerous.

-- 
tejun
