Return-Path: <linux-kernel-owner+w=401wt.eu-S1753682AbYLCNFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682AbYLCNFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 08:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751975AbYLCNFX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 08:05:23 -0500
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:56973 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbYLCNFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 08:05:22 -0500
Date: Wed, 3 Dec 2008 13:04:17 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: nickpiggin@yahoo.com.au, davej@redhat.com, arjan@infradead.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 7/8] badpage: ratelimit print_bad_pte and bad_page
In-Reply-To: <20081202165654.b84ffdad.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0812031253060.6817@blonde.anvils>
References: <Pine.LNX.4.64.0812010032210.10131@blonde.site>
 <Pine.LNX.4.64.0812010045520.11401@blonde.site> <20081202165654.b84ffdad.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Dec 2008, Andrew Morton wrote:
> On Mon, 1 Dec 2008 00:46:53 +0000 (GMT)
> Hugh Dickins <hugh@veritas.com> wrote:
> > +	/*
> > +	 * Allow a burst of 60 reports, then keep quiet for that minute;
> > +	 * or allow a steady drip of one report per second.
> > +	 */
> > +	if (nr_shown == 60) {
> > +		if (time_before(jiffies, resume)) {
> > +			nr_unshown++;
> > +			goto out;
> > +		}
> > +		if (nr_unshown) {
> > +			printk(KERN_EMERG
> > +				"Bad page state: %lu messages suppressed\n",
> > +				nr_unshown);
> > +			nr_unshown = 0;
> > +		}
> > +		nr_shown = 0;
> > +	}
> > +	if (nr_shown++ == 0)
> > +		resume = jiffies + 60 * HZ;
> > +
> 
> gee, that's pretty elaborate.  There's no way of using the
> possibly-enhanced ratelimit.h?

Thanks a lot for the pointer: I'd browsed around kernel/printk.c and
not found what I needed, hadn't realized there's a lib/ratelimit.c.

It looks eerily like what I'm trying to do, just a less specific
missed/suppressed message, never mind that.  I'll try making a patch
later to replace this (in its subsequent KERN_ALERT form) by that -
in doing so, perhaps I'll encounter a problem, but should be good.

Hugh
