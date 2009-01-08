Return-Path: <linux-kernel-owner+w=401wt.eu-S1762723AbZAHVJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762723AbZAHVJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 16:09:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755248AbZAHVJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 16:09:19 -0500
Received: from lazybastard.de ([212.112.238.170]:51809 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbZAHVJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 16:09:19 -0500
Date: Thu, 8 Jan 2009 22:09:10 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] B+Tree library V2
Message-ID: <20090108210910.GE24884@logfs.org>
References: <1225449314.3535.23.camel@johannes.berg> <20081031112651.GD18182@logfs.org> <1225452761.3535.28.camel@johannes.berg> <20081031125453.GE18182@logfs.org> <20081101155958.GA28776@logfs.org> <1231376241.3545.96.camel@johannes> <20090108162429.GA24884@logfs.org> <1231434601.8398.9.camel@johannes> <20090108200243.GD24884@logfs.org> <1231445935.8398.18.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1231445935.8398.18.camel@johannes>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 January 2009 21:18:55 +0100, Johannes Berg wrote:
> 
> > Looks correct otherwise.  Probably needs a comment that without "tmp" we
> > would skip a 0 key.  Or am I the only one who wants to simplify the code
> > before spotting this little subtlety?
> 
> I, uh, I didn't even realise that. I think the code for
> btree_last/btree_get_prev_key isn't correct as is since the 0 key is
> valid, but you can't tell whether it returned 0 because it didn't find
> anything, or because there was no more entry. Or am I missing something?

Correct or not is a matter of opinion, so let's not go there.  It
certainly is unexpected and also inefficient.  The alternative would be
to return two values, they key and a flag to indicate the end.

> > > (and possibly some type-checking variants that hardcode the geo)
> > > 
> > > Does that seem correct? And would it be possible to provide btree_last()
> > > that takes an void ** and fills it with the last entry, and the same for
> > > lookup_less(), so we can write btree_for_each_entry() too?
> > 
> > Not sure what you mean.  Something with the same effect as this?
                                                ^^^^^^^^^^^ ;)
> > 
> > #define btree_for_each_val(head, geo, key, val)				\
> > 	 for (key = btree_last(head, geo),				\
> > 	 		val = btree_lookup(head, geo, key);		\
> > 	 		val;						\
> > 			key = btree_get_prev_key(head, geo, key),	\
> > 			val = btree_lookup(head, geo, key))
> 
> Well, that does lots of lookups that don't seem necessary, since a
> function like btree_last should be able to return the value right away.
> Also, if it was
> 
> #define btree_for_each_val(head, geo, key, val)
> 	for (val = btree_last(head, geo, &key);
> 	     val;
> 	     val = btree_get_prev(head, geo, &key))
> 
> it would be more correct, I think?

More efficient, certainly.  Half the tree walks are gone.  Let's do it.

Note, btw, that this changes effort from O(2n) to O(n), while the old
visitor is O(1) *).  That was the reason why I wrote it in the first
place.  If the code wasn't as horrible and hard to use, it would be a
clear winner.  Guess we'll have to keep both variants.

*) Or rather O(2n*log(n)), O(n*log(n)) and O(log(n)) respectively.

Jörn

-- 
Joern's library part 6:
http://www.gzip.org/zlib/feldspar.html
