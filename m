Return-Path: <linux-kernel-owner+w=401wt.eu-S1755432AbYLJILh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432AbYLJILh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 03:11:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753884AbYLJIL1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 03:11:27 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:37349 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652AbYLJIL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 03:11:27 -0500
Date: Wed, 10 Dec 2008 13:41:14 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: menage@google.com, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Miyakawa <dmiyakawa@google.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [RFC][RFT] memcg fix cgroup_mutex deadlock when cpuset
	reclaims memory
Message-ID: <20081210081114.GB25467@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Mail-Followup-To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
	menage@google.com,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Daisuke Miyakawa <dmiyakawa@google.com>,
	YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20081210051947.GH7593@balbir.in.ibm.com> <20081210151948.9a83f70a.nishimura@mxp.nes.nec.co.jp> <20081210164126.8b3be761.nishimura@mxp.nes.nec.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081210164126.8b3be761.nishimura@mxp.nes.nec.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> [2008-12-10 16:41:26]:

> On Wed, 10 Dec 2008 15:19:48 +0900, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> > On Wed, 10 Dec 2008 10:49:47 +0530, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > Hi,
> > > 
> > > Here is a proposed fix for the memory controller cgroup_mutex deadlock
> > > reported. It is lightly tested and reviewed. I need help with review
> > > and test. Is the reported deadlock reproducible after this patch? A
> > > careful review of the cpuset impact will also be highly appreciated.
> > > 
> > > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > > 
> > > cpuset_migrate_mm() holds cgroup_mutex throughout the duration of
> > > do_migrate_pages(). The issue with that is that
> > > 
> > > 1. It can lead to deadlock with memcg, as do_migrate_pages()
> > >    enters reclaim
> > > 2. It can lead to long latencies, preventing users from creating/
> > >    destroying other cgroups anywhere else
> > > 
> > > The patch holds callback_mutex through the duration of cpuset_migrate_mm() and
> > > gives up cgroup_mutex while doing so.
> > > 
> > I agree changing cpuset_migrate_mm not to hold cgroup_mutex to fix the dead lock
> > is one choice, and it looks good to me at the first impression.
> > 
> > But I'm not sure it's good to change cpuset(other subsystem) code because of memcg.
> > 
> > Anyway, I'll test this patch and report the result tomorrow.
> > (Sorry, I don't have enough time today.)
> > 
> Unfortunately, this patch doesn't seem enough.
> 
> This patch can fix dead lock caused by "circular lock of cgroup_mutex",
> but cannot that of caused by "race between page reclaim and cpuset_attach(mpol_rebind_mm)".
> 
> (The dead lock I fixed in memcg-avoid-dead-lock-caused-by-race-between-oom-and-cpuset_attach.patch
> was caused by "race between memcg's oom and mpol_rebind_mm, and was independent of hierarchy.)
> 

Yes, I agree, my point was to fix the deadlock caused in the hierarchy
due to cpuset_migrate_mm(). If I understand correctly

1. This patch introduces no new bug, but the old bug remains. The
deadlock is fixed
2. We need this patch + your fix to completely solve the problem?

Could you also share how to reproduce the issue, I'll test on my end
as well.

Thanks for your help!

-- 
	Balbir
