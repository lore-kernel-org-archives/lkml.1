Return-Path: <linux-kernel-owner+w=401wt.eu-S1756470AbZAPCqZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470AbZAPCqZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 21:46:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753938AbZAPCqL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 21:46:11 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50486 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbZAPCqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 21:46:09 -0500
Date: Fri, 16 Jan 2009 11:45:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: matthltc@us.ibm.com
Cc: Paul Menage <menage@google.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       Containers <containers@lists.linux-foundation.org>
Subject: Re: [RFC][PATCH] NOOP cgroup subsystem
Message-Id: <20090116114502.b3bd565d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1232072445.7955.40.camel@localhost>
References: <20090109143226.b79d21b4.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830901082226h6d47053cp801dafb67b6e2bc9@mail.gmail.com>
	<20090109153219.dd8c153d.kamezawa.hiroyu@jp.fujitsu.com>
	<1232072445.7955.40.camel@localhost>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2009 18:20:45 -0800
Matthew Helsley <matthltc@us.ibm.com> wrote:

> On Fri, 2009-01-09 at 15:32 +0900, KAMEZAWA Hiroyuki wrote:
> > On Thu, 8 Jan 2009 22:26:46 -0800
> > Paul Menage <menage@google.com> wrote:
> > 
> > > On Thu, Jan 8, 2009 at 9:32 PM, KAMEZAWA Hiroyuki
> > > <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > >
> > > > Motivation: Simply classify Applications by cgroup
> > > >  When using cgroup for classifying applications, some kind of "control" or
> > > >  "account" subsys must be used. For flexible use of cgroup's nature of
> > > >  classifying applications, NOOP is useful. It can be used regardless of
> > > >  resource accounting unit or name spaces or some controls.
> > > >  IOW, NOOP cgroup allows users to tie PIDs with some nickname.
> > > 
> > > I agree that the idea is useful. But to me it seems to a bit
> > > artificial that you still have to mount some kind of subsystem purely
> > > to get the grouping, and that you can only have one such grouping.
> > > 
> > > I think I'd prefer the ability to mount a cgroups hierarchy without
> > > *any* subsystems (maybe with "-o none"?) which would give you a
> > > similar effect, but without you needing to know about a special no-op
> > > subsystem, and would allow you to have multiple "no-op" groupings.
> > > 
> > 
> > Oh, it seems better idea. Then, we need no configs and no additional subsys.
> > Thank you for a hint. I'll check how I can do it.
> > 
> > Thanks,
> > -Kame
> 
> 	My feeling is this should be a signal subsystem rather than a NOOP
> subsystem. Then, if users want the grouping for something besides
> signaling, it doesn't matter if they don't issue any signals via the
> signal.send file. Also, I think Paul's suggestion would be just as
> useful for a signal subsystem.
> 
> 	What do you think?
> 

I think
  - Paul's suggestion sounds attractive. But I can't see fundamental differences
    from user's side between "implemented as subsys" and "implemetned as cgroup's
    feature". I feel it's easier for user's cgroup library to handle subsys rather
    than "we can mount it anywhere, multiple times!".
    Flexiblity doesn't means it's easy to use.

  - About signal, there is a problem.
    * cgroup's attach() is per thread.
    * signal is per process.
    To fix this gap, signal subsystem should be implemented as it is with some
    *policy*. This doesn't match simple grouping by NOOP.

  - And, I personally thinks that signal subsystem has to implement following
    controls. (if we implement it.)
    Assume that 
      - we send SIGHUP to all process under /cgroup/group_A/ to restart.
      - we send SIGABRT to tale coredump.
    At doing this kind of things, the user should know the order target and has
    specify order in many cases.
    For example) 
     send signal to one by one  ProcessA -> ProcessB -> ProceessC 
                                or
                                ProcessC -> ProcessB -> ProcessA
     or
       send all at once.
     Which is better is case-by-case.
     (In this area, "freezing" subsystem is also have problems.)



Thanks,
-Kame
    


> Cheers,
> 	-Matt Helsley
> 
> PS: Adding containers@lists.linux-foundation.org to Cc.
> 
> 

