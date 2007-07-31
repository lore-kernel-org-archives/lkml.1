Return-Path: <linux-kernel-owner+w=401wt.eu-S1761041AbXGaP2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761041AbXGaP2v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 11:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756134AbXGaP2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 11:28:43 -0400
Received: from il.qumranet.com ([82.166.9.18]:35898 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753727AbXGaP2m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 11:28:42 -0400
Message-ID: <46AF5534.3010902@argo.co.il>
Date: Tue, 31 Jul 2007 18:28:52 +0300
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 000 of 35] Refactor block layer to improve support for
 stacked devices.
References: <20070731112539.22428.patches@notabene>
In-Reply-To: <20070731112539.22428.patches@notabene>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

NeilBrown wrote:
> To achieve this, the "for_each" macros are now somewhat more complex.
> For example, rq_for_each_segment is:
>
> #define bio_for_each_segment_offset(bv, bio, _i, offs, _size)		\
> 	for (_i.i = 0, _i.offset = (bio)->bi_offset + offs,		\
> 		 _i.size = min_t(int, _size, (bio)->bi_size - offs);   	\
> 	     _i.i < (bio)->bi_vcnt && _i.size > 0;			\
> 	     _i.i++)							\
> 		if (bv = *bio_iovec_idx((bio), _i.i),			\
> 		    bv.bv_offset += _i.offset,				\
> 		    bv.bv_len <= _i.offset				\
> 		    ? (_i.offset -= bv.bv_len, 0)			\
> 		    : (bv.bv_len -= _i.offset,				\
> 		       _i.offset = 0,					\
> 		       bv.bv_len < _i.size				\
> 		       ? (_i.size -= bv.bv_len, 1)			\
> 		       : (bv.bv_len = _i.size,				\
> 			  _i.size = 0,					\
> 			  bv.bv_len > 0)))
>
> #define bio_for_each_segment(bv, bio, __i)				\
> 		bio_for_each_segment_offset(bv, bio, __i, 0, (bio)->bi_size)
>
> It does some with some explanatory text in a comment, but it is still
> a bit daunting.  Any suggestions on making this more approachable
> would be very welcome.
>
>   

Well, I hesitate to state the obvious, but how about:

#define bio_for_each_segment_offset(bv, bio, _i, offs, _size) \
    for (bio_iterator_init(&_i, ...); bio_iterator_cont(&_i, ...); 
bio_iterator_advance(&_i, ...)) \
         if (bio_iterator_want_segment(&_i, ...))

While this doesn't remove the complexity, at least it's readable.

-- 
error compiling committee.c: too many arguments to function

