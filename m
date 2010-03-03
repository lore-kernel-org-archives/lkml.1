Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab0CCUHy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 15:07:54 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:59773 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756525Ab0CCUHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 15:07:37 -0500
Date: Wed, 3 Mar 2010 21:07:34 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org,
       dm-devel@redhat.com
Subject: Re: [PATCH 1/2] blkdev: fix merge_bvec_fn return value checks
Message-ID: <20100303200734.GW5768@kernel.dk>
References: <1267292113-12900-1-git-send-email-dmonakhov@openvz.org> <20100228184634.GI5768@kernel.dk> <874okyf4iw.fsf@openvz.org> <170fa0d21003031020x5b71b492vd733cf0d7c9b83d4@mail.gmail.com> <87wrxtkzwu.fsf@openvz.org> <20100303191613.GB18480@redhat.com> <87lje9kx9i.fsf@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87lje9kx9i.fsf@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03 2010, Dmitry Monakhov wrote:
> Mike Snitzer <snitzer@redhat.com> writes:
> 
> > Linux has all sorts of internal interfaces that are "odd"... the current
> > 'q->merge_bvec_fn' interface included.  But odd is not a problem (nor is
> > it "broken") unless you make changes that don't consider how the current
> > interface is defined.
> Ok. then cant you please explain more historical questions
> 1) Why bio_add_page() can not add less data than requested?
>    Seems that it doesn't make caller's code much complicate
>    Off course barrier bio is special case. I don't consider it here.

Because the caller may not expect that, a partial add may not make any
sense to the caller. The bio code obviously doesn't care. And it
certainly could complicate the caller a lot, if they need to now issue
and wait for several bio's instead of just a single one. Now a single
completion queue and wait_for_completion() is not enough.

> 2) What statement "bio_add_page() must accept at least one page"
>    exactly means?
>    IMHO this means that bio_add_page() must accept at least
>    one page with len (PAGE_SIZE - offset). Or more restricted
>    statemnt that first bio_add_page() must be always successfull.

It's really 'first add must succeed', the restriction being that you
cannot rely on that first add being more than a single page. So the rule
is that you must accept at least a page at any offset if the bio is
currently empty, since we know that a page is typically our IO
granularity.

>    But currently in some places this rule treated as what all bio
>    which has size less whan PAGE_SIZE are accepted. And in x86 such
>    bio may has up to 8 pages/bvecs.

Not sure I follow what you are trying to say here.

-- 
Jens Axboe

