Return-Path: <linux-kernel-owner+w=401wt.eu-S1756693AbZGEJzj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693AbZGEJzj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 05:55:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756699AbZGEJzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 05:55:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:9037 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345AbZGEJzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 05:55:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gPGbPKPPMZf3l+O7DcHVT9bQocV9f2JVHESLdCtUTVqgn3KdsFZi6HYgVBD8gVsHG8
         lFePb0ZTAqkritGLwqKlitFaqVxgzi9HkD3Xb+hsNIGNMz9yKWBUZgS5RntZAfOgDkfc
         NjXFUjveHajD6szL+KhMJsR01W2qOT6s1zpMs=
Date: Sun, 5 Jul 2009 17:55:21 +0800
From: Wu Fengguang <fengguang.wu@gmail.com>
To: Rik van Riel <riel@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Woodhouse <dwmw2@infradead.org>,
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
Message-ID: <20090705095520.GA31587@localhost>
References: <20090701021645.GA6356@localhost> <20090701022644.GA7510@localhost> <20090701114959.85D3.A69D9226@jp.fujitsu.com> <4A4AD07E.2040508@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4AD07E.2040508@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 10:57:02PM -0400, Rik van Riel wrote:
> KOSAKI Motohiro wrote:
>
>>> [ 1522.019259] Active_anon:11 active_file:6 inactive_anon:0
>>> [ 1522.019260]  inactive_file:0 unevictable:0 dirty:0 writeback:0 unstable:0
>>> [ 1522.019261]  free:1985 slab:44399 mapped:132 pagetables:61830 bounce:0
>>> [ 1522.019262]  isolate:69817
>>
>> OK. thanks.
>> I plan to submit this patch after small more tests. it is useful for OOM analysis.
>
> It is also useful for throttling page reclaim.
>
> If more than half of the inactive pages in a zone are
> isolated, we are probably beyond the point where adding
> additional reclaim processes will do more harm than good.

Maybe we can try limiting the isolation phase of direct reclaims to
one per CPU?

        mutex_lock(per_cpu_lock);
        isolate_pages();
        shrink_page_list();
        put_back_pages();
        mutex_unlock(per_cpu_lock);

This way the isolated pages as well as major parts of direct reclaims
will be bounded by CPU numbers. The added overheads should be trivial
comparing to the reclaim costs.

Thanks,
Fengguang

