Return-Path: <linux-kernel-owner+w=401wt.eu-S934139AbZLOXzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934139AbZLOXzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 18:55:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934011AbZLOXy4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 18:54:56 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:52512 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934122AbZLOXyz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 18:54:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=Ik7aiIpujPABMbuz4tkesLTWAyNbDGFPmKAUEGkCOsQJadq/sjcFeqzojbd+F1LHYS
         JCTS1i4eeInot1n4KnvNU1Mv+gP1bvK4MD69swQVP9u8NUkwb2xrFVI5HsEIdkbHA6mD
         UHQfzUDwPjNJhVANYDNf3SMDJWmG65roIxXJ0=
Date: Wed, 16 Dec 2009 08:48:59 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       minchan.kim@gmail.com, Lee.Schermerhorn@hp.com
Subject: Re: [mmotm][PATCH 2/5] mm : avoid  false sharing on mm_counter
Message-Id: <20091216084859.a93c9727.minchan.kim@barrios-desktop>
In-Reply-To: <alpine.DEB.2.00.0912150920160.16754@router.home>
References: <20091215180904.c307629f.kamezawa.hiroyu@jp.fujitsu.com>
	<20091215181337.1c4f638d.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0912150920160.16754@router.home>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Christoph. 

On Tue, 15 Dec 2009 09:25:01 -0600 (CST)
Christoph Lameter <cl@linux-foundation.org> wrote:

> On Tue, 15 Dec 2009, KAMEZAWA Hiroyuki wrote:
> 
> >  #if USE_SPLIT_PTLOCKS
> > +#define SPLIT_RSS_COUNTING
> >  struct mm_rss_stat {
> >  	atomic_long_t count[NR_MM_COUNTERS];
> >  };
> > +/* per-thread cached information, */
> > +struct task_rss_stat {
> > +	int events;	/* for synchronization threshold */
> 
> Why count events? Just always increment the task counters and fold them
> at appropriate points into mm_struct. Or get rid of the mm_struct counters
> and only sum them up on the fly if needed?

We are now suffering from finding appropriate points you mentioned.
That's because we want to remove read-side overhead with no regression.
So I think Kame removed schedule update hook.

Although the hooks is almost no overhead, I don't want to make mm counters
stale because it depends on schedule point.
If any process makes many faults in its time slice and it's not preempted
(ex, RT) as extreme case, we could show stale counters. 

But now it makes consistency to merge counters.
Worst case is 64. 

In this aspect, I like this idea. 

-- 
Kind regards,
Minchan Kim
