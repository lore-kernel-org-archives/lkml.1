Return-Path: <linux-kernel-owner+w=401wt.eu-S1753624AbZGEKwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753624AbZGEKwS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 06:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751641AbZGEKwD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 06:52:03 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:16790 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbZGEKwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 06:52:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=q2tGGIceUBdRmBTklrEIkobJcJzPz+SZ65IllQgd13PjCBzrWdcIburgi48vqDrm8x
         v8kZcQS5iAhd2y3pUJpMCZGKwxbG7PJZak0CpBAGeP31brlfEuGtTCvMq0taF+wpCvIf
         8Zr5fwhpstpjJ4/y8hc4sWihDT/Ra2Xrmp3QQ=
Date: Sun, 5 Jul 2009 18:51:58 +0800
From: Wu Fengguang <fengguang.wu@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, David Woodhouse <dwmw2@infradead.org>,
       David Howells <dhowells@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
       Johannes Weiner <hannes@cmpxchg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       "peterz@infradead.org" <peterz@infradead.org>,
       "tytso@mit.edu" <tytso@mit.edu>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "elladan@eskimo.com" <elladan@eskimo.com>,
       "npiggin@suse.de" <npiggin@suse.de>,
       "Barnes, Jesse" <jesse.barnes@intel.com>
Subject: Re: Found the commit that causes the OOMs
Message-ID: <20090705105158.GA1804@localhost>
References: <4A4AD07E.2040508@redhat.com> <20090705095520.GA31587@localhost> <20090705193551.090E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090705193551.090E.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 05, 2009 at 07:38:54PM +0900, KOSAKI Motohiro wrote:
> > >> OK. thanks.
> > >> I plan to submit this patch after small more tests. it is useful for OOM analysis.
> > >
> > > It is also useful for throttling page reclaim.
> > >
> > > If more than half of the inactive pages in a zone are
> > > isolated, we are probably beyond the point where adding
> > > additional reclaim processes will do more harm than good.
> > 
> > Maybe we can try limiting the isolation phase of direct reclaims to
> > one per CPU?
> > 
> >         mutex_lock(per_cpu_lock);
> >         isolate_pages();
> >         shrink_page_list();
> >         put_back_pages();
> >         mutex_unlock(per_cpu_lock);
> > 
> > This way the isolated pages as well as major parts of direct reclaims
> > will be bounded by CPU numbers. The added overheads should be trivial
> > comparing to the reclaim costs.
> 
> hm, this idea makes performance degression on few CPU machine, I think.

Yes, this is also my big worry. But one possible workaround is to
allow N direct reclaims per CPU.

> e.g.
> if system have only one cpu and sysmtem makes lumpy reclaim, lumpy reclaim
> makes synchronous pageout and it makes very long waiting time.

We can temporarily drop the lock during the writeback waiting.
0-order reclaims shall not be blocked by ongoing high order reclaims.

> I suspect per-cpu decision is not useful in this area.

Maybe. I'm just proposing one more possible way to choose from :)

Thanks,
Fengguang

