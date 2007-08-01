Return-Path: <linux-kernel-owner+w=401wt.eu-S1763643AbXHARoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763643AbXHARoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 13:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbXHARoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 13:44:25 -0400
Received: from rv-out-0910.google.com ([209.85.198.187]:27866 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbXHARoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 13:44:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=rcFlxfEFbR3yBhe+GpFe6oYErdFTFsOUFIeY34KTq7IEiyQzIatrPN12gKmqXxJgHFZD+QNi9+hRhbkpgnc8JTYJMtRBgzPSvTzrnTPzN7szApO1hVi0wi2rjCwJ9ljzDVmkiTgYaeFaobTpEsohq5qhG7LvvLFY+NNfdnkRztE=
Date: Thu, 2 Aug 2007 02:44:18 +0900
From: Tejun Heo <htejun@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 025 of 35] Treat rq->hard_nr_sectors as setting an overriding limit in the size of the request
Message-ID: <20070801174418.GI13674@htj.dyndns.org>
References: <20070731112539.22428.patches@notabene> <1070731021759.25484@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1070731021759.25484@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 31, 2007 at 12:17:59PM +1000, NeilBrown wrote:
> 
> For a request to be able to refer to part of a bio, we need to be able
> to impose a size limit at the request level.  So allow hard_nr_sectors
> to be less than the size of the bios (and bio_vecs) and interpret it
> such that anything in the last bio beyond that limit is ignored.
> 
> As some bios can be less than one sector - as happens when a SCSI
> sense command is being submitted - we need to set hard_nr_sectors to
> bi_size rounded up in blk_rq_bio_prep, and we need to abort the
> rq_for_each_segment loop if _iter.bio becomes NULL even if _iter.size
> is still non-zero

This is pretty confusing.  In all other places, bi_size -> #sector
conversion is done by rounding down but only in blk_rq_bio_prep() it's
being rounded up.

Is my following reasoning correct?

It was okay till now because unaligned requests don't get merged and
also haven't done partial completions (end_that_request_first with
partial count)?  So till now, hard_nr_sectors and nr_sectors didn't
really matter for unaligned requests but now it matters because it's
considered while iterating over bvecs in rq.

If so, I think the correct thing to do would be changing bio_sectors()
to round up first or let block layer measure transfer in bytes not in
sectors.  I don't think everyone would agree with the latter tho.  I
(tentatively) think it would be better to represent length in bytes
tho.  A lot of requests which aren't aligned to 512 bytes pass through
the block layer and the mismatch can result in subtle bugs.

Thanks.

-- 
tejun
