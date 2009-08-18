Return-Path: <linux-kernel-owner+w=401wt.eu-S1759339AbZHRQ2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759339AbZHRQ2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 12:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759329AbZHRQ2M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 12:28:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:45693 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758706AbZHRQ2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 12:28:11 -0400
Date: Wed, 19 Aug 2009 01:27:55 +0900 (JST)
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH] proc: let task status file print utime and stime.
Cc: kosaki.motohiro@jp.fujitsu.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Tatsuhiro Aoshima <tatsu.pc@gmail.com>,
       YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>, albert@users.sf.net
In-Reply-To: <20090817083404.GC5868@cr0.nay.redhat.com>
References: <20090817153253.52bf9c69.kamezawa.hiroyu@jp.fujitsu.com> <20090817083404.GC5868@cr0.nay.redhat.com>
Message-Id: <20090819010833.A656.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

> On Mon, Aug 17, 2009 at 03:32:53PM +0900, KAMEZAWA Hiroyuki wrote:
> >On Mon, 17 Aug 2009 14:32:02 +0800
> >Amerigo Wang <xiyou.wangcong@gmail.com> wrote:
> >
> >> On Mon, Aug 17, 2009 at 03:22:06PM +0900, KAMEZAWA Hiroyuki wrote:
> >> >On Mon, 17 Aug 2009 14:18:21 +0800
> >> >Amerigo Wang <xiyou.wangcong@gmail.com> wrote:
> >> >
> >> >> Ah... in fact, I expected 'ps' can report this, however, surprisingly
> >> >> it doesn't have this, at least not what I expect (unless I miss
> >> >> something obvious).

Yes, hehe, I also expected so :-)



> >> >> >In another thinking, in old days, /proc/<pid>/stat was enough because most of
> >> >> >users uses scanf() or some C langage to read fixed-format data.
> >> >> >/proc/<pid>/status is useful for some script languages which has 
> >> >> >good parser per line. 
> >> >> 
> >> >> Well... I think this work should be left to 'ps', e.g.
> >> >> 
> >> >>   ps -o pid,utime,stime
> >> >> 
> >> >> 'ps' is responsible to read /proc/<pid>/stat for the user.
>
> >> >Hmm, personally, I don't like 'ps' and its unified filter.
> >> >
> >> >When I want to know status of a process of PID,
> >> ># ps -o pid,utime,stime  PID
> >> >
> >> >'ps' scans *all* process and filter PID. (try #strace ps)
> >> >I like checking /proc/<pid>/<something> without 'ps' in an environment
> >> >where thousands of processes runs.
> >> 
> >> Sure, we already have '-p' for 'ps', e.g.
> >> 
> >>  ps -p 1 -o pid,user,comm
> >> 
> >> Enjoy. :-)
> >I said it's verrrrry slow.
>
> 
> Hmm, for me it looks like that 'ps' should be fixed...
> 
> I haven't checked the source code of 'ps', but I don't think
> this is O(n) if '-p' is specified. If we just use something
> like 'test -d /proc/<pid>' it would be O(1).

I think kamezawa-san is right.
procps always read ALL proc. and after, it check pid by want_this_proc().

That's obviously O(n) ;-)

---------------------------------------------------------------
static void simple_spew(void){
(snip)
  switch(thread_flags & (TF_show_proc|TF_loose_tasks|TF_show_task)){
  case TF_show_proc:                   // normal non-thread output
    while(readproc(ptp,&buf)){
      if(want_this_proc(&buf)){
        show_one_proc(&buf, proc_format_list);
      }
      if(buf.cmdline) free((void*)*buf.cmdline); // ought to reuse
      if(buf.environ) free((void*)*buf.environ); // ought to reuse
    }
    break;
---------------------------------------------------------------



> >> Anyway, I would like to see 'ps' to have 'utime,stime' field, on
> >> my machine, its output for 'utime,stime' looks wrong.
> >> 
> >> Maybe we should Cc procps developers?
> >ya, maybe. it's good to be CCed.
> 
> Done. Albert?

Albert? What do you think?



> >BTW, why all other status
> >Name:   cat
> >State:  R (running)
> >Tgid:   7068
> >Pid:    7068
> >PPid:   6115
> >TracerPid:      0
> >Uid:    500     500     500     500
> >Gid:    500     500     500     500
> >FDSize: 256
> >Groups: 500
> >
> >are allowed to be duplicated ?
> 
> 
> I don't know... :( I still prefer to use 'ps'.

Do their have any exclusive relation?




