Return-Path: <linux-kernel-owner+w=401wt.eu-S1753541AbZJ2IcI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541AbZJ2IcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 04:32:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZJ2IcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 04:32:07 -0400
Received: from smtp-out.google.com ([216.239.45.13]:3039 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbZJ2IcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 04:32:02 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=fTOIVVP2SRZ32qLekSEMl2UJDm6Zb+ApOtQmcyWGWgzjr6Af9985j64dh2x8ESjyw
	qfG+A2beCRQvzIXVoYI4w==
Date: Thu, 29 Oct 2009 01:31:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Arcangeli <aarcange@redhat.com>, vedran.furac@gmail.com,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH] oom_kill: use rss value instead of vm size for badness
In-Reply-To: <20091029100042.973328d3.kamezawa.hiroyu@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.0910290125390.11476@chino.kir.corp.google.com>
References: <20091028175846.49a1d29c.kamezawa.hiroyu@jp.fujitsu.com> <alpine.DEB.2.00.0910280206430.7122@chino.kir.corp.google.com> <abbed627532b26d8d96990e2f95c02fc.squirrel@webmail-b.css.fujitsu.com>
 <20091029100042.973328d3.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Oct 2009, KAMEZAWA Hiroyuki wrote:

> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> It's reported that OOM-Killer kills Gnone/KDE at first...
> And yes, we can reproduce it easily.
> 
> Now, oom-killer uses mm->total_vm as its base value. But in recent
> applications, there are a big gap between VM size and RSS size.
> Because
>   - Applications attaches much dynamic libraries. (Gnome, KDE, etc...)
>   - Applications may alloc big VM area but use small part of them.
>     (Java, and multi-threaded applications has this tendency because
>      of default-size of stack.)
> 
> I think using mm->total_vm as score for oom-kill is not good.
> By the same reason, overcommit memory can't work as expected.
> (In other words, if we depends on total_vm, using overcommit more positive
>  is a good choice.)
> 
> This patch uses mm->anon_rss/file_rss as base value for calculating badness.
> 
> Following is changes to OOM score(badness) on an environment with 1.6G memory
> plus memory-eater(500M & 1G).
> 
> Top 10 of badness score. (The highest one is the first candidate to be killed)
> Before
> badness program
> 91228	gnome-settings-
> 94210	clock-applet
> 103202	mixer_applet2
> 106563	tomboy
> 112947	gnome-terminal
> 128944	mmap              <----------- 500M malloc
> 129332	nautilus
> 215476	bash              <----------- parent of 2 mallocs.
> 256944	mmap              <----------- 1G malloc
> 423586	gnome-session
> 
> After
> badness 
> 1911	mixer_applet2
> 1955	clock-applet
> 1986	xinit
> 1989	gnome-session
> 2293	nautilus
> 2955	gnome-terminal
> 4113	tomboy
> 104163	mmap             <----------- 500M malloc.
> 168577	bash             <----------- parent of 2 mallocs
> 232375	mmap             <----------- 1G malloc
> 
> seems good for me. Maybe we can tweak this patch more,
> but this one will be a good one as a start point.
> 

This appears to actually prefer X more than total_vm in Vedran's test 
case.  He cited http://pastebin.com/f3f9674a0 in 
http://marc.info/?l=linux-kernel&m=125678557002888.

There are 12 ooms in this log, which has /proc/sys/vm/oom_dump_tasks 
enabled.  It shows the difference between the top total_vm candidates vs. 
the top rss candidates.

total_vm
708945 test
195695 krunner
168881 plasma-desktop
130567 ktorrent
127081 knotify4
125881 icedove-bin
123036 akregator
118641 kded4

rss
707878 test
42201 Xorg
13300 icedove-bin
10209 ktorrent
9277 akregator
8878 plasma-desktop
7546 krunner
4532 mysqld

This patch would pick the memory hogging task, "test", first everytime 
just like the current implementation does.  It would then prefer Xorg, 
icedove-bin, and ktorrent next as a starting point.

Admittedly, there are other heuristics that the oom killer uses to create 
a badness score.  But since this patch is only changing the baseline from 
mm->total_vm to get_mm_rss(mm), its behavior in this test case do not 
match the patch description.

The vast majority of the other ooms have identical top 8 candidates:

total_vm
673222 test
195695 krunner
168881 plasma-desktop
130567 ktorrent
127081 knotify4
125881 icedove-bin
123036 akregator
121869 firefox-bin

rss
672271 test
42192 Xorg
30763 firefox-bin
13292 icedove-bin
10208 ktorrent
9260 akregator
8859 plasma-desktop
7528 krunner

firefox-bin seems much more preferred in this case than total_vm, but Xorg 
still ranks very high with this patch compared to the current 
implementation.
