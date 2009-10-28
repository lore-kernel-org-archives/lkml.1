Return-Path: <linux-kernel-owner+w=401wt.eu-S1756944AbZJ1APw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944AbZJ1APw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 20:15:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756927AbZJ1APv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 20:15:51 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54442 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892AbZJ1APv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 20:15:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Oct 2009 09:13:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: vedran.furac@gmail.com
Cc: Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       "hugh.dickins@tiscali.co.uk" <hugh.dickins@tiscali.co.uk>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       rientjes@google.com
Subject: Re: [RFC][PATCH] oom_kill: avoid depends on total_vm and use real
 RSS/swap value for oom_score (Re: Memory overcommit
Message-Id: <20091028091321.b136d9d9.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4AE730C2.30401@gmail.com>
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
	<4AE730C2.30401@gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 18:41:22 +0100
Vedran Furač <vedran.furac@gmail.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> 
> > On Tue, 27 Oct 2009 15:55:26 +0900
> > Minchan Kim <minchan.kim@gmail.com> wrote:
> > 
> >>>> Hmm.
> >>>> I wonder why we consider VM size for OOM kiling.
> >>>> How about RSS size?
> >>>>
> >>> Maybe the current code assumes "Tons of swap have been generated, already" if
> >>> oom-kill is invoked. Then, just using mm->anon_rss will not be correct.
> >>>
> >>> Hm, should we count # of swap entries reference from mm ?....
> >> In Vedran case, he didn't use swap. So, Only considering vm is the problem.
> >> I think it would be better to consider both RSS + # of swap entries as
> >> Kosaki mentioned.
> >>
> > Then, maybe this kind of patch is necessary.
> > This is on 2.6.31...then I may have to rebase this to mmotom.
> > Added more CCs.
> > 
> > Vedran, I'm glad if you can test this patch.
> 
> Thanks for the patch! I'll test it during this week a report after that.
> 
> > Instead of total_vm, we should use anon/file/swap usage of a process, I think.
> > This patch adds mm->swap_usage and calculate oom_score based on
> >   anon_rss + file_rss + swap_usage.
> 
> Isn't file_rss shared between processes? Sorry, I'm newbie. :)
> 
It's shared. But in typical case, file_rss will very small at OOM.


> % pmap $(pidof test)
> 29049:   ./test
> 0000000000400000      4K r-x--  /home/vedranf/dev/tmp/test
> 0000000000600000      4K rw---  /home/vedranf/dev/tmp/test
> 00002ba362a80000    116K r-x--  /lib/ld-2.10.1.so
> 00002ba362a9d000     12K rw---    [ anon ]
> 00002ba362c9c000      4K r----  /lib/ld-2.10.1.so
> 00002ba362c9d000      4K rw---  /lib/ld-2.10.1.so
> 00002ba362c9e000   1320K r-x--  /lib/libc-2.10.1.so
> 00002ba362de8000   2044K -----  /lib/libc-2.10.1.so
> 00002ba362fe7000     16K r----  /lib/libc-2.10.1.so
> 00002ba362feb000      4K rw---  /lib/libc-2.10.1.so
> 00002ba362fec000 1024028K rw---    [ anon ] // <-- This
> 00007ffff4618000     84K rw---    [ stack ]
> 00007ffff47b7000      4K r-x--    [ anon ]
> ffffffffff600000      4K r-x--    [ anon ]
>  total          1027648K
> 
> I would just look at anon if that's OK (or possible).
> 
> > Considering usual applications, this will be much better information than
> > total_vm.
> 
> Agreed.
> 
> > score   PID     name
> > 4033	3176	gnome-panel
> > 4077	3113	xinit
> > 4526	3190	python
> > 4820	3161	gnome-settings-
> > 4989	3289	gnome-terminal
> > 7105	3271	tomboy
> > 8427	3177	nautilus
> > 17549	3140	gnome-session
> > 128501	3299	bash
> > 256106	3383	mmap
> > 
> > This order is not bad, I think.
> 
> Yes, this looks much better now.  Bash is only having somewhat strangely
> high score.
> 
It gets half score of mmap....If mmap goes, bash's score will goes down
dramatically. I'll read other's comments and tweak this patch more.

Thanks,
-Kame



> Regards,
> 
> Vedran
> 
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

