Return-Path: <linux-kernel-owner+w=401wt.eu-S1760051AbZAHTks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760051AbZAHTks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 14:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbZAHTkl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 14:40:41 -0500
Received: from lazybastard.de ([212.112.238.170]:45210 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753913AbZAHTkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 14:40:40 -0500
Date: Thu, 8 Jan 2009 20:40:32 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] B+Tree library V2
Message-ID: <20090108194031.GB24884@logfs.org>
References: <20081026124643.GA1328@logfs.org> <1225449314.3535.23.camel@johannes.berg> <20081031112651.GD18182@logfs.org> <1225452761.3535.28.camel@johannes.berg> <20081031125453.GE18182@logfs.org> <20081101155958.GA28776@logfs.org> <1231376241.3545.96.camel@johannes> <20090108162429.GA24884@logfs.org> <1231432450.8038.4.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1231432450.8038.4.camel@johannes>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 January 2009 17:34:10 +0100, Johannes Berg wrote:
> 
> > Well, I used to have heaps of btrees around and wanted to share the
> > mempool between all of them.  Not sure if I still do, I believe not.
> > Will check.
> > 
> > If mempools aren't shared, I agree that encapsulating those bits is much
> > nicer.
> 
> Just made the API a bit quirky, maybe just support both ways of using
> things? Would only need a flag somewhere in the btree structure, I'd
> think; ultimately it doesn't matter much to me though.

I don't think we need a flag.  Just a regular pair of init/cleanup
functions and some __init_i_want_to_share_mempools_and_crawl_on_my_knees
without a cleanup for those who need it.

> > If you want to open-code it, you can use btree_lookup_less().  I added
> > that function sometime last month.  Basically something like this:
> > 	key = btree_last(head, geo);
> > 	while (key) {
> > 		/* do something with key */
> > 		key = btree_lookup_less(head, geo, key);
> > 	}
> > 
> > Maybe it should be renamed to btree_get_prev_key().  I never noticed how
> > confusing it was because my head was busy with other problems.  The code
> > is currently burried within my logfs tree:
> > http://logfs.org/git?p=logfs;a=summary
> 
> I don't think I've understood this yet. That code above there is a
> backwards walk over the key space, and it's safe to call
> btree_remove(key) at /* do something with key */?

Yes, it's a backwards walk.  The btree is sorted backwards as a
micro-optimization.  Loops will terminate a bit earlier without a
complicated test this way.

And you can do absolutely anything at  /* do something with key */.  The
btree_get_prev_key() will simply tell you what the next-lowest key in
the btree is at that time.  You no longer need locking around the whole
visitor, but can release the lock after each step, if you want.

Downside is that each step will walk the btree from the root again.
Twice, because you also need to lookup/remove each element.  Tanstaafl.

Jörn

-- 
Courage is not the absence of fear, but rather the judgement that
something else is more important than fear.
-- Ambrose Redmoon
