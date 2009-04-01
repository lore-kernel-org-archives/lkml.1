Return-Path: <linux-kernel-owner+w=401wt.eu-S1763901AbZDAM1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763901AbZDAM1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 08:27:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761629AbZDAM1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 08:27:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:52192 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758985AbZDAM1X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 08:27:23 -0400
Message-ID: <49D35D9F.3000204@kernel.org>
Date: Wed, 01 Apr 2009 21:27:11 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: jens.axboe@oracle.com, bharrosh@panasas.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] block: fix SG_IO vector request data length	handling
References: <1238583884-13517-3-git-send-email-tj@kernel.org>	<20090401204716N.fujita.tomonori@lab.ntt.co.jp>	<20090401115058.GD5178@kernel.dk> <20090401211851Y.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20090401211851Y.fujita.tomonori@lab.ntt.co.jp>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 12:27:15 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FUJITA Tomonori wrote:
> On Wed, 1 Apr 2009 13:50:58 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
>> On Wed, Apr 01 2009, FUJITA Tomonori wrote:
>>> On Wed,  1 Apr 2009 20:04:38 +0900
>>> Tejun Heo <tj@kernel.org> wrote:
>>>
>>>> Impact: fix SG_IO behavior such that it matches the documentation
>>>>
>>>> SG_IO howto says that if ->dxfer_len and sum of iovec disagress, the
>>>> shorter one wins.  However, the current implementation returns -EINVAL
>>>> for such cases.  Trim iovc if it's longer than ->dxfer_len.
>>> Is that description about sg's SG_IO?

It looks like it's the closest thing.

>> The more important question is what sg.c actually does, that's more
>> important than the documentation.

The current code would fail it with -EINVAL but after brief look into
2.6.12-rc2, it seems like it would use the shorter one.  On direct
mapping path, it builds considering both lengths and on indirect path
it doesn't seem to look at the iov supplied till the transfer is
actually complete using the dxfer_len and then copy out whatever can
be copied out.

> Do you think that Doug is a person who makes such mistake? ;)
> 
> Seems that sg worked as the howto says. But I think that I broke it
> when I converted sg to use the block layer. I'll fix it soon.
> 
> About this patch, as we know, there are lots of subtle differences
> between sg's SG_IO and the block's. I'm not sure that it's a good idea
> to change the behavior of the block's SG_IO.

I think it's better to make the behavior more consistent.  Using
shorter dxfer_len can be considered a feature too, so...

Thanks.

-- 
tejun
