Return-Path: <linux-kernel-owner+w=401wt.eu-S1757958AbYGJOdF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958AbYGJOdF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 10:33:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755259AbYGJOcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 10:32:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58127 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755248AbYGJOcd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 10:32:33 -0400
Date: Thu, 10 Jul 2008 10:30:18 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Paul Menage <menage@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Libcg Devel Mailing List <libcg-devel@lists.sourceforge.net>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <pzijlstr@redhat.com>,
       Kazunaga Ikeno <k-ikeno@ak.jp.nec.com>,
       Morton Andrew Morton <akpm@linux-foundation.org>,
       Thomas Graf <tgraf@redhat.com>, Rik Van Riel <riel@redhat.com>
Subject: Re: [RFC] How to handle the rules engine for cgroups
Message-ID: <20080710143018.GC3782@redhat.com>
References: <20080701191126.GA17376@redhat.com> <20080703101957.b3856904.kamezawa.hiroyu@jp.fujitsu.com> <20080703155446.GB9275@redhat.com> <6599ad830807100223m2453963cwcfbe6eb1ad54d517@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830807100223m2453963cwcfbe6eb1ad54d517@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2008 at 02:23:52AM -0700, Paul Menage wrote:
> On Thu, Jul 3, 2008 at 8:54 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> >
> > As of today it should happen because newly execed process will run into
> > same cgroup as parent.  But that's what probably we need to avoid.
> > For example, if an admin has created three cgroups "database", "browser"
> > "others" and a user launches "firefox" from shell (assuming shell is running
> > originally in "others" cgroup), then any memory allocation for firefox should
> > come from "browser" cgroup and not from "others".
> 
> I think that I'm a little skeptical that anyone would ever want to do that.
> 
> Wouldn't it be a simpler mechanism for the admin to simply have
> wrappers around the "firefox" and "oracle" binaries that move the
> process into the "browser" or "database" cgroup before running the
> real binaries?
> 

Well, that would mean first wrappers need to be created around all the
applications which needs to be controlled. Then wrapper needs to 
synchronize with the classification daemon if I have been put into
the right cgroup and can I go ahead with launching the real binary etc.
This sounds ugly and putting wrappers around all the applications does
not seem very practical. 

> >
> > I am assuming that this will be a requirement for enterprise class
> > systems. Would be good to know the experiences of people who are already
> > doing some kind of work load management.
> 
> I can help there. :-) At Google we have two approaches:
> 
> - grid jobs, which are moved into the appropriate cgroup (actually,
> currently cpuset) by the grid daemon when it starts the job
> 

So grid daemon probably first forks off, determines the right cpuset
move the job there and then do exec?

> - ssh logins, which are moved into the appropriate cpuset by a
> forced-command script specified in the sshd config.
> 
> I don't see the rule-based approach being all that useful for our needs.
> 
> It's all very well coming up with theoretical cases that a fancy new
> mechanism solves. But it carries more weight if someone can stand up
> and say "Yes, I want to use this on my real cluster of machines". (Or
> even "Yes, if this is implemented I *will* use it on my desktop" would
> be a start)
> 

So it boils down to.

1) Can we bear the delay in task classification (Especially, exec). If yes,
  then all the classification job can take place in userspace.

2) If no,
	a) Then either we need to implement rule based engine to let
	  kernel do classfication.

	b) or we need to do various things in user space as you suggested.
		- Pur wrapper around applications.
		- Job launcher (ex. Grid daemon) is modified to determine
		  the right cgroup and place application there before
		  actually launching the job.

Balbir and other people, any more thoughts on this? How exactly this thing
need to be used in your work environment.

I am little skeptical of options 2b working in most of the scenarios.

Thanks
Vivek
