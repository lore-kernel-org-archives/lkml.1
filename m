Return-Path: <linux-kernel-owner+w=401wt.eu-S1765675AbXHAPxL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765675AbXHAPxL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 11:53:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933136AbXHAPww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:52:52 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:59908 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932988AbXHAPwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:52:51 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18096.44099.826200.638485@stoffel.org>
Date: Wed, 1 Aug 2007 11:52:35 -0400
From: "John Stoffel" <john@stoffel.org>
To: Tejun Heo <teheo@suse.de>
Cc: Avi Kivity <avi@argo.co.il>, NeilBrown <neilb@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 000 of 35] Refactor block layer to improve support for
 stacked devices.
In-Reply-To: <46B09A92.9090409@suse.de>
References: <20070731112539.22428.patches@notabene>
	<46AF5534.3010902@argo.co.il>
	<46B09A92.9090409@suse.de>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Tejun> Avi Kivity wrote:
>> NeilBrown wrote:
>>> To achieve this, the "for_each" macros are now somewhat more complex.
>>> For example, rq_for_each_segment is:
>>> 
>>> #define bio_for_each_segment_offset(bv, bio, _i, offs, _size)        \
>>> for (_i.i = 0, _i.offset = (bio)->bi_offset + offs,        \
>>> _i.size = min_t(int, _size, (bio)->bi_size - offs);       \
>>> _i.i < (bio)->bi_vcnt && _i.size > 0;            \
>>> _i.i++)                            \
>>> if (bv = *bio_iovec_idx((bio), _i.i),            \
>>> bv.bv_offset += _i.offset,                \
>>> bv.bv_len <= _i.offset                \
>>> ? (_i.offset -= bv.bv_len, 0)            \
>>> : (bv.bv_len -= _i.offset,                \
>>> _i.offset = 0,                    \
>>> bv.bv_len < _i.size                \
>>> ? (_i.size -= bv.bv_len, 1)            \
>>> : (bv.bv_len = _i.size,                \
>>> _i.size = 0,                    \
>>> bv.bv_len > 0)))
>>> 
>>> #define bio_for_each_segment(bv, bio, __i)                \
>>> bio_for_each_segment_offset(bv, bio, __i, 0, (bio)->bi_size)
>>> 
>>> It does some with some explanatory text in a comment, but it is still
>>> a bit daunting.  Any suggestions on making this more approachable
>>> would be very welcome.
>>> 
>>> 
>> 
>> Well, I hesitate to state the obvious, but how about:
>> 
>> #define bio_for_each_segment_offset(bv, bio, _i, offs, _size) \
>> for (bio_iterator_init(&_i, ...); bio_iterator_cont(&_i, ...);
>> bio_iterator_advance(&_i, ...)) \
>> if (bio_iterator_want_segment(&_i, ...))
>> 
>> While this doesn't remove the complexity, at least it's readable.

Tejun> Violently seconded.

How about it be made into a real function instead?  I was reading
through the patch, but got timed out yesterday, so take this with a
grain of salt.  

I thought I saw a couple of macros defined to use this macro yet
again.  Which I figured might be a problem is the passed in variables
get munged.

In any case, why does something so complicated need to be a macro, why
not a function instead?

John
