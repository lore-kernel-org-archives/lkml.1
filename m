Return-Path: <linux-kernel-owner+w=401wt.eu-S1757383AbZJ3ToV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757383AbZJ3ToV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Oct 2009 15:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757359AbZJ3ToU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Oct 2009 15:44:20 -0400
Received: from smtp-out.google.com ([216.239.45.13]:34601 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757292AbZJ3ToR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Oct 2009 15:44:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=BthA8T3mhaW/pNUEZ+Jj34qT49LzO/AHeUvdnrEb7JH4SUTAzkzqcpKMCcuozrRYI
	QH+MnsBKrw5k7CYhZplyQ==
Date: Fri, 30 Oct 2009 12:44:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: vedran.furac@gmail.com
cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
In-Reply-To: <4AEAEFDD.5060009@gmail.com>
Message-ID: <alpine.DEB.2.00.0910301232180.1090@chino.kir.corp.google.com>
References: <hav57c$rso$1@ger.gmane.org> <20091013120840.a844052d.kamezawa.hiroyu@jp.fujitsu.com> <hb2cfu$r08$2@ger.gmane.org> <20091014135119.e1baa07f.kamezawa.hiroyu@jp.fujitsu.com> <4ADE3121.6090407@gmail.com> <20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com>
 <4AE5CB4E.4090504@gmail.com> <20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com> <Pine.LNX.4.64.0910271843510.11372@sister.anvils> <alpine.DEB.2.00.0910271351140.9183@chino.kir.corp.google.com> <4AE78B8F.9050201@gmail.com>
 <alpine.DEB.2.00.0910271723180.17615@chino.kir.corp.google.com> <4AE792B8.5020806@gmail.com> <alpine.DEB.2.00.0910272047430.8988@chino.kir.corp.google.com> <4AE846E8.1070303@gmail.com> <alpine.DEB.2.00.0910281307370.23279@chino.kir.corp.google.com>
 <4AE9068B.7030504@gmail.com> <alpine.DEB.2.00.0910290132320.11476@chino.kir.corp.google.com> <4AE97618.6060607@gmail.com> <alpine.DEB.2.00.0910291225460.27732@chino.kir.corp.google.com> <4AEAEFDD.5060009@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Oct 2009, Vedran Furac wrote:

> Well, you are kernel hacker, not me. You know how linux mm works much
> more than I do. I just reported a, what I think is a big problem, which
> needs to be solved ASAP (2.6.33).

The oom killer heuristics have not been changed recently, why is this 
suddenly a problem that needs to be immediately addressed?  The heuristics 
you've been referring to have been used for at least three years.

> I'm afraid that we'll just talk much
> and nothing will be done with solution/fix postponed indefinitely. Not
> sure if you are interested, but I tested this on windowsxp also, and
> nothing bad happens there, system continues to function properly.
> 

I'm totally sympathetic to testcases such as your own where the oom killer 
seems to react in an undesirable way.  I agree that it could do a much 
better job at targeting "test" and killing it without negatively impacting 
other tasks.

However, I don't think we can simply change the baseline (like the rss 
change which has been added to -mm (??)) and consider it a major 
improvement when it severely impacts how system administrators are able to 
tune the badness heuristic from userspace via /proc/pid/oom_adj.  I'm sure 
you'd agree that user input is important in this matter and so that we 
should maximize that ability rather than make it more difficult.  That's 
my main criticism of the suggestions thus far (and, sorry, but I have to 
look out for production server interests here: you can't take away our 
ability to influence oom badness scoring just because other simple 
heuristics may be more understandable).

> > Much better is to allow the user to decide at what point, regardless of 
> > swap usage, their application is using much more memory than expected or 
> > required.  They can do that right now pretty well with /proc/pid/oom_adj 
> > without this outlandish claim that they should be expected to know the rss 
> > of their applications at the time of oom to effectively tune oom_adj.
> 
> Believe me, barely a few developers use oom_adj for their applications,
> and probably almost none of the end users. What should they do, every
> time they start an application, go to console and set the oom_adj. You
> cannot expect them to do that.
> 

oom_adj is an extremely important part of our infrastructure and although 
the majority of Linux users may not use it (I know a number of opensource 
programs that tune its own, however), we can't let go of our ability to 
specify an oom killing priority.

There are no simple solutions to this problem: the model proposed thus 
far, which has basically been to acknowledge that oom killer is a bad 
thing to encounter (but within that, some rationale was found that we can 
react however we want??) and should be extremely easy to understand (just 
kill the memory hogger with the most resident RAM) is a non-starter.

What would be better, and what I think we'll end up with, is a root 
selectable heuristic so that production servers and desktop machines can 
use different heuristics to make oom kill selections.  We already have 
/proc/sys/vm/oom_kill_allocating_task which I added 1-2 years ago to 
address concerns specifically of SGI and their enormously long tasklist 
scans.  This would be variation on that idea and would include different 
simplistic behaviors (such as always killing the most memory hogging task, 
killing the most recently started task by the same uid, etc), and leave 
the default heuristic much the same as currently.
