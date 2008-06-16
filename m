Return-Path: <linux-kernel-owner+w=401wt.eu-S1753472AbYFPFWm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472AbYFPFWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 01:22:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751180AbYFPFWc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 01:22:32 -0400
Received: from ag-out-0708.google.com ([72.14.246.251]:4934 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751145AbYFPFWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 01:22:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=KEUpRuaaW+k2hsgK0DQZf741a8qW2UH0WJK26pNTeJ4hNmr43lMzWj3nmUT07L9pRk
         xJR9dpkUGt3cTpMGx202SnYiSmyj+XOykqrxQNtnyD7TGsUuyww3Byr+xJIzCnEQR/XG
         dqZEVCN3I2rXkQRFWSRtf29zPokg6zTDz9MWo=
Subject: Re: [PATCH 1/3] relay: Fix 4 off-by-one errors occuring when
	writing to a CPU buffer.
From: Tom Zanussi <tzanussi@gmail.com>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       compudj@krystal.dyndns.org, linux-kernel@vger.kernel.org,
       righi.andrea@gmail.com
In-Reply-To: <20080614175223.4d3c6084@linux360.ro>
References: <20080613040947.7465b9a5@linux360.ro>
	 <1213418437.8237.51.camel@charm-linux>
	 <20080614175223.4d3c6084@linux360.ro>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 00:22:27 -0500
Message-Id: <1213593748.7744.34.camel@charm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2008-06-14 at 17:52 +0300, Eduard - Gabriel Munteanu wrote:
> On Fri, 13 Jun 2008 23:40:37 -0500
> Tom Zanussi <tzanussi@gmail.com> wrote:
> 
> > I'm wondering if the all-zeroes at the end of the buffer might be
> > another case of the all-zeroes you were seeing due to cross-cpu
> > reading you decribed in the other patch.  In any case, I'm pretty
> > sure this patch isn't doing what you think it is, and don't see how
> > it could have fixed the problem (see below).  There may still be a
> > bug somewhere, but it would be good to be able to reproduce it.  Does
> > it happen even when running on a single cpu?
> 
> Hi,
> 
> I noticed this problem after adding those spinlocks. As far as I can
> tell, having (offset == subbuf_size + 1) at any given moment allows the
> read() handler to see inconsistent offsets:
> 1. writer sets offset = subbuf_size + 1
> 2. writer releases spinlock
> 3. read() acquires spinlock and reads the wrong offset
> 4. read() releases spinlock
> 5. next writer corrects the offset at the next write
>  
> > This case, offset being 1 larger than the subbuf size, is how we note
> > a full sub-buffer, so changing this will break full-subbuffer cases. 
> 
> No, it won't. Maximum length messages result in the following condition:
> start + offset == subbuf_size
> This happens because a buffer of length subbuf_size actually ranges
> from zero to (subbuf_size - 1) in regard to how it is addressed. Then,
> subbuf_size + 1 isn't just outside the bounds, but one more byte off.
> "Visual" example:
> subbuf_size = 4
> |[ ][ ][ ][ ]|[ ]
>   0  1  2  3   subbuf_size
> 
> So, a full subbufer means offset equals subbuf_size, that is, the next
> empty slot is just outside the subbuffer.
> 

Yes, I understand that - what I meant was that the subbuf_size + 1
condition happens only in the buffer-full case (i.e. no reader or
lagging reader), but not during the normal filling of a subbuffer, which
you describe correctly.

So apparently what you're seeing is zeroes being read when there's a
buffer-full condition?  If so, we need to figure out exactly why that's
happening to see whether your fix is really what's needed; I haven't
seen problems in the buffer-full case before and I think your fix would
break it even if it fixed your read problem.  So it would be good to be
able to reproduce it first.

Tom  


> 
> 	Eduard

