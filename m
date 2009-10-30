Return-Path: <linux-kernel-owner+w=401wt.eu-S932196AbZJ3OIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932196AbZJ3OIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 10:08:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932146AbZJ3OIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 10:08:43 -0400
Received: from idcmail-mo2no.shaw.ca ([64.59.134.9]:25902 "EHLO
	idcmail-mo2no.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932142AbZJ3OIm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 10:08:42 -0400
X-Cloudmark-SP-Filtered: true
X-Cloudmark-SP-Result: v=1.0 c=1 a=w4iE+TBsmj5y1WloLYF40w==:17 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8
 a=GSrTb78IA9IkJmNOi70A:9 a=yHBraDkWAC91qo8DWJUA:7
 a=rZTZA6l9f22nX2PnovynJ1jScJEA:4 a=x8gzFH9gYPwA:10 a=MMP-0Q0vT0A6wFia:21
 a=kTGByo1UXpPUgiGv:21
From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Reply-To: tfjellstrom@shaw.ca
To: linux-kernel@vger.kernel.org, vedran.furac@gmail.com
Subject: Re: Memory overcommit
Date: Fri, 30 Oct 2009 08:08:38 -0600
User-Agent: KMail/1.12.2 (Linux/2.6.26-2-amd64; KDE/4.3.2; x86_64; ; )
Cc: David Rientjes <rientjes@google.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
References: <hav57c$rso$1@ger.gmane.org> <alpine.DEB.2.00.0910291225460.27732@chino.kir.corp.google.com> <4AEAEFDD.5060009@gmail.com>
In-Reply-To: <4AEAEFDD.5060009@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <200910300808.38450.tfjellstrom@shaw.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri October 30 2009, Vedran Furač wrote:
> David Rientjes wrote:
> > Ok, so this is the forkbomb problem by adding half of each child's
> > total_vm into the badness score of the parent.  We should address this
> > completely seperately by addressing that specific part of the
> > heuristic, not changing what we consider to be a baseline.
> > thunderbird.
> >
> > You're making all these claims and assertions based _solely_ on the
> > theory that killing the application with the most resident RAM is
> > always the optimal solution.  That's just not true, especially if we're
> > just allocating small numbers of order-0 memory.
> 
> Well, you are kernel hacker, not me. You know how linux mm works much
> more than I do. I just reported a, what I think is a big problem, which
> needs to be solved ASAP (2.6.33). I'm afraid that we'll just talk much
> and nothing will be done with solution/fix postponed indefinitely. Not
> sure if you are interested, but I tested this on windowsxp also, and
> nothing bad happens there, system continues to function properly.
> 
> For 2-3 years I had memory overcommit turn off. I didn't get any OOM,
> but sometimes Java didn't work and it seems that because of some kernel
> weirdness (or misunderstanding on my part) I couldn't use all the
> available memory:
> 
> # echo 2 > /proc/sys/vm/overcommit_memory
> 
> # echo 95 > /proc/sys/vm/overcommit_ratio
> % ./test  /* malloc in loop as before */
> malloc: Cannot allocate memory /* Great, no OOM, but: */
> 
> % free -m
>           total       used       free     shared    buffers     cached
> Mem:      3458        3429         29          0        102       1119
> -/+ buffers/cache:    2207       1251
> 
> There's plenty of memory available. Shouldn't cache be automatically
> dropped (this question was in my original mail, hence the subject)?
> 
> All this frustrated not only me, but a great number of users on our
> local Croatian linux usenet newsgroup with some of them pointing that as
> the reason they use solaris. And so on...

I think this is the MOST serious issue related to the oom killer. For some 
reason it refuses to drop pages before trying to kill. When it should drop 
cache, THEN kill if needed.

> > Much better is to allow the user to decide at what point, regardless of
> > swap usage, their application is using much more memory than expected
> > or required.  They can do that right now pretty well with
> > /proc/pid/oom_adj without this outlandish claim that they should be
> > expected to know the rss of their applications at the time of oom to
> > effectively tune oom_adj.
> 
> Believe me, barely a few developers use oom_adj for their applications,
> and probably almost none of the end users. What should they do, every
> time they start an application, go to console and set the oom_adj. You
> cannot expect them to do that.
> 
> > What would you suggest?  A script that sits in a loop checking each
> > task's current rss from /proc/pid/stat or their current oom priority
> > though /proc/pid/oom_score and adjusting oom_adj preemptively just in
> > case the oom killer is invoked in the next second?
> >
> :)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>  in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 


-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca
