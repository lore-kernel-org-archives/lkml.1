Return-Path: <linux-kernel-owner+w=401wt.eu-S932101AbZJ0H4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbZJ0H4q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 03:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbZJ0H4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 03:56:45 -0400
Received: from mail-yx0-f187.google.com ([209.85.210.187]:38084 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756037AbZJ0H4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 03:56:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=KoW3XBV+WvvI/89E+6g4oA3oZWOmhrKldrqOPvT/2IsPRXZylKwp0GBPy6vZ716bWz
         gAI91fqqlPMzOmiUgJWhVe2y+467ahabZp/ry+FgZp83LXIpHOWY8dFB1mwK2STBO6pH
         qLmdC5tPJy9Km8Jpq2cq1GOT1UGs48hb1ZX5I=
Date: Tue, 27 Oct 2009 16:56:12 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       vedran.furac@gmail.com, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       rientjes@google.com
Subject: Re: [RFC][PATCH] oom_kill: avoid depends on total_vm and use real
 RSS/swap value for oom_score (Re: Memory overcommit
Message-Id: <20091027165612.4122d600.minchan.kim@barrios-desktop>
In-Reply-To: <20091027164526.da6a23cb.kamezawa.hiroyu@jp.fujitsu.com>
References: <hav57c$rso$1@ger.gmane.org>
	<hb2cfu$r08$2@ger.gmane.org>
	<20091014135119.e1baa07f.kamezawa.hiroyu@jp.fujitsu.com>
	<4ADE3121.6090407@gmail.com>
	<20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com>
	<4AE5CB4E.4090504@gmail.com>
	<20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com>
	<2f11576a0910262310g7aea23c0n9bfc84c900879d45@mail.gmail.com>
	<20091027153429.b36866c4.minchan.kim@barrios-desktop>
	<20091027153626.c5a4b5be.kamezawa.hiroyu@jp.fujitsu.com>
	<28c262360910262355p3cac5c1bla4de9d42ea67fb4e@mail.gmail.com>
	<20091027164526.da6a23cb.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 16:45:26 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Tue, 27 Oct 2009 15:55:26 +0900
> Minchan Kim <minchan.kim@gmail.com> wrote:
> 
> > >> Hmm.
> > >> I wonder why we consider VM size for OOM kiling.
> > >> How about RSS size?
> > >>
> > >
> > > Maybe the current code assumes "Tons of swap have been generated, already" if
> > > oom-kill is invoked. Then, just using mm->anon_rss will not be correct.
> > >
> > > Hm, should we count # of swap entries reference from mm ?....
> > 
> > In Vedran case, he didn't use swap. So, Only considering vm is the problem.
> > I think it would be better to consider both RSS + # of swap entries as
> > Kosaki mentioned.
> > 
> Then, maybe this kind of patch is necessary.
> This is on 2.6.31...then I may have to rebase this to mmotom.
> Added more CCs.
> 
> Vedran, I'm glad if you can test this patch.
> 
> 
> ==
> Now, oom-killer's score uses mm->total_vm as its base value.
> But, in these days, applications like GUI program tend to use
> much shared libraries and total_vm grows too high even when
> pages are not fully mapped.
> 
> For example, running a program "mmap" which allocates 1 GBbytes of
> anonymous memory, oom_score top 10 on system will be..
> 
>  score  PID     name
>  89924	3938	mixer_applet2
>  90210	3942	tomboy
>  94753	3936	clock-applet
>  101994	3919	pulseaudio
>  113525	4028	gnome-terminal
>  127340	1	init
>  128177	3871	nautilus
>  151003	11515	bash
>  256944	11653	mmap <-----------------use 1G of anon
>  425561	3829	gnome-session
> 
> No one believes gnome-session is more guilty than "mmap".
> 
> Instead of total_vm, we should use anon/file/swap usage of a process, I think.
> This patch adds mm->swap_usage and calculate oom_score based on
>   anon_rss + file_rss + swap_usage.
> Considering usual applications, this will be much better information than
> total_vm. After this patch, the score on my desktop is
> 
> score   PID     name
> 4033	3176	gnome-panel
> 4077	3113	xinit
> 4526	3190	python
> 4820	3161	gnome-settings-
> 4989	3289	gnome-terminal
> 7105	3271	tomboy
> 8427	3177	nautilus
> 17549	3140	gnome-session
> 128501	3299	bash
> 256106	3383	mmap
> 
> This order is not bad, I think.
> 
> Note: This adss new counter...then new cost is added.
> 
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

Thanks for making the patch.
Let's hear other's opinion. :)

-- 
Kind regards,
Minchan Kim
