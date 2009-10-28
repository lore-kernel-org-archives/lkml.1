Return-Path: <linux-kernel-owner+w=401wt.eu-S1757320AbZJ1E5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320AbZJ1E5y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 00:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752968AbZJ1E5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 00:57:52 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39388 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757292AbZJ1E5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 00:57:49 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Oct 2009 13:55:19 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: vedran.furac@gmail.com, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, minchan.kim@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: Memory overcommit
Message-Id: <20091028135519.805c4789.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.0910272047430.8988@chino.kir.corp.google.com>
References: <hav57c$rso$1@ger.gmane.org>
	<20091013120840.a844052d.kamezawa.hiroyu@jp.fujitsu.com>
	<hb2cfu$r08$2@ger.gmane.org>
	<20091014135119.e1baa07f.kamezawa.hiroyu@jp.fujitsu.com>
	<4ADE3121.6090407@gmail.com>
	<20091026105509.f08eb6a3.kamezawa.hiroyu@jp.fujitsu.com>
	<4AE5CB4E.4090504@gmail.com>
	<20091027122213.f3d582b2.kamezawa.hiroyu@jp.fujitsu.com>
	<Pine.LNX.4.64.0910271843510.11372@sister.anvils>
	<alpine.DEB.2.00.0910271351140.9183@chino.kir.corp.google.com>
	<4AE78B8F.9050201@gmail.com>
	<alpine.DEB.2.00.0910271723180.17615@chino.kir.corp.google.com>
	<4AE792B8.5020806@gmail.com>
	<alpine.DEB.2.00.0910272047430.8988@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Oct 2009 21:08:56 -0700 (PDT)
David Rientjes <rientjes@google.com> wrote:

> On Wed, 28 Oct 2009, Vedran Furac wrote:
> 
> > > This is wrong; it doesn't "emulate oom" since oom_kill_process() always 
> > > kills a child of the selected process instead if they do not share the 
> > > same memory.  The chosen task in that case is untouched.
> > 
> > OK, I stand corrected then. Thanks! But, while testing this I lost X
> > once again and "test" survived for some time (check the timestamps):
> > 
> > http://pastebin.com/d5c9d026e
> > 
> > - It started by killing gkrellm(!!!)
> > - Then I lost X (kdeinit4 I guess)
> > - Then 103 seconds after the killing started, it killed "test" - the
> > real culprit.
> > 
> > I mean... how?!
> > 
> 
> Here are the five oom kills that occurred in your log, and notice that the 
> first four times it kills a child and not the actual task as I explained:
> 
> [97137.724971] Out of memory: kill process 21485 (VBoxSVC) score 1564940 or a child
> [97137.725017] Killed process 21503 (VirtualBox)
> [97137.864622] Out of memory: kill process 11141 (kdeinit4) score 1196178 or a child
> [97137.864656] Killed process 11142 (klauncher)
> [97137.888146] Out of memory: kill process 11141 (kdeinit4) score 1184308 or a child
> [97137.888180] Killed process 11151 (ksmserver)
> [97137.972875] Out of memory: kill process 11141 (kdeinit4) score 1146255 or a child
> [97137.972888] Killed process 11224 (audacious2)
> 
> Those are practically happening simultaneously with very little memory 
> being available between each oom kill.  Only later is "test" killed:
> 
> [97240.203228] Out of memory: kill process 5005 (test) score 256912 or a child
> [97240.206832] Killed process 5005 (test)
> 
> Notice how the badness score is less than 1/4th of the others.  So while 
> you may find it to be hogging a lot of memory, there were others that 
> consumed much more.

not related to child-parent problem.

Seeing this number more.
==
[97137.709272] Active_anon:671487 active_file:82 inactive_anon:132316
[97137.709273]  inactive_file:82 unevictable:50 dirty:0 writeback:0 unstable:0
[97137.709273]  free:6122 slab:17179 mapped:30661 pagetables:8052 bounce:0
==

acitve_file + inactive_file is very low. Almost all pages are for anon.
But "mapped(NR_FILE_MAPPED)" is a little high. This implies remaining file caches
are mapped by many processes OR some mega bytes of shmem is used.

# of pagetables is 8052, this means
  8052x4096/8*4k bytes = 16Gbytes of mapped area.

Total available memory is near to be active/inactive + slab 
671487+82+132316+82+50+6122+17179+8052=835370x4k= 3.2Gbytes ?
(this system is swapless)

Then, considering the pmap kosaki shows,
I guess killed ones had big total_vm but has not much real rss,
and no helps for oom.

Thanks,
-Kame

