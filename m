Return-Path: <linux-kernel-owner+w=401wt.eu-S1761038AbXHAQAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761038AbXHAQAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 12:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756971AbXHAP75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 11:59:57 -0400
Received: from rv-out-0910.google.com ([209.85.198.189]:3527 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756482AbXHAP74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 11:59:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=XHBeUb7XmxXY/Ml60u2tLv6snnBZnGMIYBbOa77n9kxYNC9UTUM2Yr/Kk9xBoG3oBd+KzQfcC+Nl8soleIi1LEte/D5T/K7BlFwEjuGPJwtr0uZ+38OF2mPUSqTaCeIlTDEDVkvutZ3UmX+ibwF2TnXvEhFugTR+Q3KNt49Kmvc=
Date: Thu, 2 Aug 2007 00:59:47 +0900
From: Tejun Heo <htejun@gmail.com>
To: John Stoffel <john@stoffel.org>
Cc: Tejun Heo <teheo@suse.de>, Avi Kivity <avi@argo.co.il>,
       NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 000 of 35] Refactor block layer to improve support for stacked devices.
Message-ID: <20070801155947.GG13674@htj.dyndns.org>
References: <20070731112539.22428.patches@notabene> <46AF5534.3010902@argo.co.il> <46B09A92.9090409@suse.de> <18096.44099.826200.638485@stoffel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18096.44099.826200.638485@stoffel.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 01, 2007 at 11:52:35AM -0400, John Stoffel wrote:
> 
> Tejun> Avi Kivity wrote:
> >> NeilBrown wrote:
> >>> To achieve this, the "for_each" macros are now somewhat more complex.
> >>> For example, rq_for_each_segment is:
> >>> 
> >>> #define bio_for_each_segment_offset(bv, bio, _i, offs, _size)        \
> >>> for (_i.i = 0, _i.offset = (bio)->bi_offset + offs,        \
> >>> _i.size = min_t(int, _size, (bio)->bi_size - offs);       \
> >>> _i.i < (bio)->bi_vcnt && _i.size > 0;            \
> >>> _i.i++)                            \
> >>> if (bv = *bio_iovec_idx((bio), _i.i),            \
> >>> bv.bv_offset += _i.offset,                \
> >>> bv.bv_len <= _i.offset                \
> >>> ? (_i.offset -= bv.bv_len, 0)            \
> >>> : (bv.bv_len -= _i.offset,                \
> >>> _i.offset = 0,                    \
> >>> bv.bv_len < _i.size                \
> >>> ? (_i.size -= bv.bv_len, 1)            \
> >>> : (bv.bv_len = _i.size,                \
> >>> _i.size = 0,                    \
> >>> bv.bv_len > 0)))
> >>> 
> >>> #define bio_for_each_segment(bv, bio, __i)                \
> >>> bio_for_each_segment_offset(bv, bio, __i, 0, (bio)->bi_size)
> >>> 
> >>> It does some with some explanatory text in a comment, but it is still
> >>> a bit daunting.  Any suggestions on making this more approachable
> >>> would be very welcome.
> >>> 
> >>> 
> >> 
> >> Well, I hesitate to state the obvious, but how about:
> >> 
> >> #define bio_for_each_segment_offset(bv, bio, _i, offs, _size) \
> >> for (bio_iterator_init(&_i, ...); bio_iterator_cont(&_i, ...);
> >> bio_iterator_advance(&_i, ...)) \
> >> if (bio_iterator_want_segment(&_i, ...))
> >> 
> >> While this doesn't remove the complexity, at least it's readable.
> 
> Tejun> Violently seconded.
> 
> How about it be made into a real function instead?  I was reading
> through the patch, but got timed out yesterday, so take this with a
> grain of salt.  
> 
> I thought I saw a couple of macros defined to use this macro yet
> again.  Which I figured might be a problem is the passed in variables
> get munged.
> 
> In any case, why does something so complicated need to be a macro, why
> not a function instead?

I agree and actually wrote about the same opinion in one of the
replies.  It might even be benefitial performance-wise due to smaller
cache foot print.

Thanks.

-- 
tejun
