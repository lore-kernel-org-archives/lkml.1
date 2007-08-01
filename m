Return-Path: <linux-kernel-owner+w=401wt.eu-S1765314AbXHAOhj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765314AbXHAOhj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:37:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763886AbXHAOhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:37:19 -0400
Received: from jericho.provo.novell.com ([137.65.248.124]:19277 "EHLO
	jericho.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764087AbXHAOhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:37:18 -0400
Message-ID: <46B09A92.9090409@suse.de>
Date: Wed, 01 Aug 2007 23:37:06 +0900
From: Tejun Heo <teheo@suse.de>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Avi Kivity <avi@argo.co.il>
CC: NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 000 of 35] Refactor block layer to improve support for
 stacked devices.
References: <20070731112539.22428.patches@notabene> <46AF5534.3010902@argo.co.il>
In-Reply-To: <46AF5534.3010902@argo.co.il>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> NeilBrown wrote:
>> To achieve this, the "for_each" macros are now somewhat more complex.
>> For example, rq_for_each_segment is:
>>
>> #define bio_for_each_segment_offset(bv, bio, _i, offs, _size)        \
>>     for (_i.i = 0, _i.offset = (bio)->bi_offset + offs,        \
>>          _i.size = min_t(int, _size, (bio)->bi_size - offs);       \
>>          _i.i < (bio)->bi_vcnt && _i.size > 0;            \
>>          _i.i++)                            \
>>         if (bv = *bio_iovec_idx((bio), _i.i),            \
>>             bv.bv_offset += _i.offset,                \
>>             bv.bv_len <= _i.offset                \
>>             ? (_i.offset -= bv.bv_len, 0)            \
>>             : (bv.bv_len -= _i.offset,                \
>>                _i.offset = 0,                    \
>>                bv.bv_len < _i.size                \
>>                ? (_i.size -= bv.bv_len, 1)            \
>>                : (bv.bv_len = _i.size,                \
>>               _i.size = 0,                    \
>>               bv.bv_len > 0)))
>>
>> #define bio_for_each_segment(bv, bio, __i)                \
>>         bio_for_each_segment_offset(bv, bio, __i, 0, (bio)->bi_size)
>>
>> It does some with some explanatory text in a comment, but it is still
>> a bit daunting.  Any suggestions on making this more approachable
>> would be very welcome.
>>
>>   
> 
> Well, I hesitate to state the obvious, but how about:
> 
> #define bio_for_each_segment_offset(bv, bio, _i, offs, _size) \
>    for (bio_iterator_init(&_i, ...); bio_iterator_cont(&_i, ...);
> bio_iterator_advance(&_i, ...)) \
>         if (bio_iterator_want_segment(&_i, ...))
> 
> While this doesn't remove the complexity, at least it's readable.

Violently seconded.

-- 
tejun
