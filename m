Return-Path: <linux-kernel-owner+w=401wt.eu-S1756547AbZJ0H65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbZJ0H65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 03:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756169AbZJ0H65
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 03:58:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:32902 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756124AbZJ0H64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 03:58:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 27 Oct 2009 16:56:28 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
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
Message-Id: <20091027165628.acda4540.kamezawa.hiroyu@jp.fujitsu.com>
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
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 16:45:26 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
  	/*
>  	 * After this unlock we can no longer dereference local variable `mm'
> @@ -92,8 +93,13 @@ unsigned long badness(struct task_struct
>  	 */
>  	list_for_each_entry(child, &p->children, sibling) {
>  		task_lock(child);
> -		if (child->mm != mm && child->mm)
> -			points += child->mm->total_vm/2 + 1;
> +		if (child->mm != mm && child->mm) {
> +			unsigned long cpoint;
> +			/* At considering child, we don't count swap */
> +			cpoint = get_mm_counter(child->mm, anon_rss) +
> +				 get_mm_counter(child->mm, file_rss);
> +			points += cpoint/2 + 1;
> +		}
>  		task_unlock(child);

BTW, I'd like to get rid of this code.

Can't we use other techniques for detecting fork-bomb ?

This check can't catch following type, anyway.

   fork()
     -> fork()
          -> fork()
               -> fork()
                    ....

but I have no good idea.
What is the difference with task-launcher and fork bomb()...

Thanks,
-Kame

