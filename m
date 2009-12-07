Return-Path: <linux-kernel-owner+w=401wt.eu-S932854AbZLGTsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854AbZLGTsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 14:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932776AbZLGTsF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 14:48:05 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:57496 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932775AbZLGTsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 14:48:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=YjQF8YVBzdBxaP1pu+HkbcPDkpPFKMq6VXbISgYif580rwa9ZiLMmN5TXqPk241fjX
         SF6SZM30fmEKXDw7/GfzbYGZhZNFSO3F3R64xe8srhB8OZ6CU7QNU+tP56ChxT89HCIw
         RiR9NNqU9T3PipR6ooWRXhONk622cY01qK6pQ=
Date: Mon, 7 Dec 2009 20:48:05 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 2/2] perf lock: New subcommand "lock" to perf for
	analyzing lock statistics
Message-ID: <20091207194802.GB5049@nowhere>
References: <20091115022135.GA5427@nowhere> <1260156884-8474-2-git-send-email-mitake@dcl.info.waseda.ac.jp> <20091207044125.GB5262@nowhere> <20091207072752.GG10868@elte.hu> <4B1CBEEB.3090800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1CBEEB.3090800@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 04:38:03PM +0800, Xiao Guangrong wrote:
> 
> 
> Ingo Molnar wrote:
> 
> > Also, i agree that the performance aspect is probably the most pressing 
> > issue. Note that 'perf bench sched messaging' is very locking intense so 
> > a 10x slowdown is not entirely unexpected - we still ought to optimize 
> > it all some more. 'perf lock' is an excellent testcase for this in any 
> > case.
> > 
> 
> Here are some test results to show the overhead of lockdep trace events:
> 
>                    select    pagefault   mmap    Memory par   Cont_SW
>                    latency    latency   latency   R/W BD      latency
> 
> disable ftrace        0         0         0         0          0
> 
> enable all ftrace  -16.65%    -109.80%   -93.62%   0.14%      -6.94%
> 
> enable all ftrace  -2.67%      1.08%     -3.65%   -0.52%      -0.68%
> except lockdep
> 
> 
> We also found big overhead when using kernbench and fio, but we haven't
> verified whether it's caused by lockdep events.
> 
> Thanks,
> Xiao


This profile has been done using ftrace with perf right?
It might be because the lock events are high rate events and
fill a lot of perf buffer space. More than other events.
In one of your previous mails, you showed us the difference
of the size of perf.data by capturing either scheduler events
or lock events.

And IIRC, the case of lock events resulted in a 100 MB perf.data
whereas it was a small file for sched events.

The overhead in the pagefault and mmap latency could then
result in the fact we have much more events to save, walking
through much more pages in perf buffer, then faulting more often,
etc.

Plus the fact various locks are taken in mmap and fault path,
generating more lock events.

Just a guess...

