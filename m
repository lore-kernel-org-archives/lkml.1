Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab0CLADK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 19:03:10 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42291 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166Ab0CLADG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 19:03:06 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] cpuset: current_cpuset_is_being_rebound() need rcu lock
Cc: kosaki.motohiro@jp.fujitsu.com, Miao Xie <miaox@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, David Rientjes <rientjes@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Nick Piggin <npiggin@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100311190759.GA6298@linux.vnet.ibm.com>
References: <20100311142035.94FD.A69D9226@jp.fujitsu.com> <20100311190759.GA6298@linux.vnet.ibm.com>
Message-Id: <20100312085807.950B.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Fri, 12 Mar 2010 09:03:03 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Mar 11, 2010 at 02:46:15PM +0900, KOSAKI Motohiro wrote:
> > rcu lockdep detected cpuset have wrong rcu usage.
> > the fixing is trivial. but I wonder why don't cpuset_being_rebound assignment
> > and read need a memory barrier pairing?
> 
> The fix is in -tip, commit 99ee4ca746dda71326db7645463b4075ac1d665c.
> 
> This is an initialization-time use of rcu_dereference(), so no other
> task has a reference to this data.  Hence it is constant.  Other uses
> of this code operate on shared data structures, which might change at
> any time.

thanks. I haven't notice such commit.

I think you are talking about task_cs(current) accessing and you are right
in such point.
but I'm talking cpuset_being_rebound global variable.

update_tasks_nodemask() has following code

static void update_tasks_nodemask(struct cpuset *cs, const nodemask_t *oldmem,
                                 struct ptr_heap *heap)
{
        cpuset_being_rebound = cs;		/* start transaction */
        cgroup_scan_tasks(&scan);
        cpuset_being_rebound = NULL;		/* end transaction */
}



