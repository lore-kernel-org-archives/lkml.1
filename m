Return-Path: <linux-kernel-owner+w=401wt.eu-S1756302AbZJ2Cbo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302AbZJ2Cbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 22:31:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756190AbZJ2Cbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 22:31:43 -0400
Received: from mail-yw0-f202.google.com ([209.85.211.202]:42395 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbZJ2Cbm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 22:31:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NdlIWT+0gANBF0sjZu+XRdzGXL5YAa2J8XqkGe/79Bpz72bVMQxx5tksh7PPX/nCS4
         9vi2YnJecNFzEfnQ/xam1SDVJhVFyFulRKnBib4LG5jCUrvxfN/50Et2yP/OGcIq1HcL
         Fzeat9FMQc+0AwG5Az5NNljv0hnOwvmSg9TTs=
MIME-Version: 1.0
In-Reply-To: <20091029100042.973328d3.kamezawa.hiroyu@jp.fujitsu.com>
References: <20091028175846.49a1d29c.kamezawa.hiroyu@jp.fujitsu.com>
	 <alpine.DEB.2.00.0910280206430.7122@chino.kir.corp.google.com>
	 <abbed627532b26d8d96990e2f95c02fc.squirrel@webmail-b.css.fujitsu.com>
	 <20091029100042.973328d3.kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 29 Oct 2009 11:31:47 +0900
Message-ID: <28c262360910281931n57a3792elcf10ce0ff3f59815@mail.gmail.com>
Subject: Re: [PATCH] oom_kill: use rss value instead of vm size for badness
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrea Arcangeli <aarcange@redhat.com>, vedran.furac@gmail.com,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 29, 2009 at 10:00 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> I'll wait until the next week to post a new patch.
>> We don't need rapid way.
>>
> I wrote above...but for my mental health, this is bug-fixed version.
> Sorry for my carelessness. David, thank you for your review.
> Regards,
> -Kame
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> It's reported that OOM-Killer kills Gnone/KDE at first...
> And yes, we can reproduce it easily.
>
> Now, oom-killer uses mm->total_vm as its base value. But in recent
> applications, there are a big gap between VM size and RSS size.
> Because
>  - Applications attaches much dynamic libraries. (Gnome, KDE, etc...)
>  - Applications may alloc big VM area but use small part of them.
>    (Java, and multi-threaded applications has this tendency because
>     of default-size of stack.)
>
> I think using mm->total_vm as score for oom-kill is not good.
> By the same reason, overcommit memory can't work as expected.
> (In other words, if we depends on total_vm, using overcommit more positive
>  is a good choice.)
>
> This patch uses mm->anon_rss/file_rss as base value for calculating badness.
>
> Following is changes to OOM score(badness) on an environment with 1.6G memory
> plus memory-eater(500M & 1G).
>
> Top 10 of badness score. (The highest one is the first candidate to be killed)
> Before
> badness program
> 91228   gnome-settings-
> 94210   clock-applet
> 103202  mixer_applet2
> 106563  tomboy
> 112947  gnome-terminal
> 128944  mmap              <----------- 500M malloc
> 129332  nautilus
> 215476  bash              <----------- parent of 2 mallocs.
> 256944  mmap              <----------- 1G malloc
> 423586  gnome-session
>
> After
> badness
> 1911    mixer_applet2
> 1955    clock-applet
> 1986    xinit
> 1989    gnome-session
> 2293    nautilus
> 2955    gnome-terminal
> 4113    tomboy
> 104163  mmap             <----------- 500M malloc.
> 168577  bash             <----------- parent of 2 mallocs
> 232375  mmap             <----------- 1G malloc
>
> seems good for me. Maybe we can tweak this patch more,
> but this one will be a good one as a start point.
>
> Changelog: 2009/10/29
>  - use get_mm_rss() instead of get_mm_counter()
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Let's start from this.

-- 
Kind regards,
Minchan Kim
