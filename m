Return-Path: <linux-kernel-owner+w=401wt.eu-S1757933AbZDAM4d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757933AbZDAM4d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 08:56:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764191AbZDAM4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 08:56:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:45662 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764723AbZDAMz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 08:55:59 -0400
Message-ID: <49D36452.9000605@kernel.org>
Date: Wed, 01 Apr 2009 21:55:46 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: bharrosh@panasas.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/8] bio: actually inline inline bvecs into bio
References: <1238583884-13517-1-git-send-email-tj@kernel.org> <1238583884-13517-5-git-send-email-tj@kernel.org> <20090401124709.GG5178@kernel.dk>
In-Reply-To: <20090401124709.GG5178@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 01 Apr 2009 12:55:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Wed, Apr 01 2009, Tejun Heo wrote:
>> Impact: cleanup
>>
>> BIO_INLINE_VECS bvecs are inlined into bio to avoid bvec allocation
>> for small transfers.  This was achieved by declaring zero sized bvec
>> array at the end of bio and allocating bio with extra bytes at the
>> end.  As BIO_INLINE_VECS is constant, there is no reason to do this
>> allocation trick.  This patch simply defines BIO_INLINE_VECS sized
>> bvec array at the end.  This will help fixing bio_kmalloc().
> 
> I don't like this, it's much nicer to do it with a zero sized array. If
> you don't need a bio_vec, then you don't consume the extra space. I
> guess for that to really work, we'd need one more slab and mempool
> though. At least for non-stack bio's. I also fear that direct uses of
> ->bi_inline_vecs[] will then crop up, making it harder to go back.

I don't know.  None of the current users cares about it and unless
there's plan to make the number of inlined vecs variable, doing it
separately doesn't buy much and I think we'll probably pay more by
having extra slab and mempool.

Dropping this one isn't difficult tho.  If your objection is strong,
I'll drop it and update the next one accordingly.  Actually, what we
can do for bio_kmalloc() is to embed whole bvec as we know the size
anyway.

Thanks.

-- 
tejun
