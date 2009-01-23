Return-Path: <linux-kernel-owner+w=401wt.eu-S932136AbZAWSiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932136AbZAWSiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 13:38:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZAWSiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 13:38:00 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36840 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690AbZAWSh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 13:37:59 -0500
Date: Fri, 23 Jan 2009 19:36:53 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Menage <menage@google.com>
Cc: akpm@linux-foundation.org, serue@us.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org
Subject: Re: [PATCH] cgroup: Fix root_count when mount fails due to busy
	subsystem
Message-ID: <20090123183653.GC5984@elte.hu>
References: <20090123004703.25103.29754.stgit@menage.corp.google.com> <20090123181056.GA31142@elte.hu> <6599ad830901231032h76a301ceica371145eca30388@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830901231032h76a301ceica371145eca30388@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Menage <menage@google.com> wrote:

> On Fri, Jan 23, 2009 at 10:10 AM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Paul Menage <menage@google.com> wrote:
> >
> >> cgroup: Fix root_count when mount fails due to busy subsystem
> >>
> >> root_count was being incremented in cgroup_get_sb() after all error
> >> checking was complete, but decremented in cgroup_kill_sb(), which can be
> >> called on a superblock that we gave up on due to an error.  This patch
> >> changes cgroup_kill_sb() to only decrement root_count if the root was
> >> previously linked into the list of roots.
> >
> > i'm wondering, what happens in the buggy case: does cgroup_kill_sb() get
> > called twice (if yes, why?),
> 
> No.
> 
> > or do we call cgroup_kill_sb() on a not yet
> > added sb and hence root_count has not been elevated yet?
> 
> Right.
> 
> > (if yes, which
> > codepath does this?)
> 
> It's via the call to deactivate_super().

Which exact call chain is that?

> The code could be restructured such that:
> 
> - we don't set sb->s_fs_info until we've linked the new root into the root_list
> - do any necessary cleanup for a failed root in cgroup_get_sb()
> - have cgroup_kill_sb() handle either no root or a fully-initialized root
> 
> But then you're replacing "only decrement root_count if root was linked 
> in to list" with "only do root cleanup if root was atached to sb" in 
> cgroup_kill_sb(). I don't see that one is much cleaner than the other.

Agreed, that's not an improvement.

> For 2.6.29, we should fix this by reverting the broken part of the patch 
> that made it into 2.6.29-rcX

Agreed too - i withdraw my objection.

Nevertheless my observation remains: kernel/cgroup.c has a complex looking 
error paths which should be cleaned up. (independently of this issue)

	Ingo
