Return-Path: <linux-kernel-owner+w=401wt.eu-S1755290AbZBZImI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbZBZImI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 03:42:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZBZIly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 03:41:54 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50997 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbZBZIlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 03:41:53 -0500
Date: Thu, 26 Feb 2009 17:40:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cpuacct: add a branch prediction
Message-Id: <20090226174033.094e4834.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49A65455.4030204@cn.fujitsu.com>
References: <49A6475F.4000502@cn.fujitsu.com>
	<20090226170738.a982057b.kamezawa.hiroyu@jp.fujitsu.com>
	<49A6501B.7040604@cn.fujitsu.com>
	<20090226172234.a931931f.kamezawa.hiroyu@jp.fujitsu.com>
	<49A65455.4030204@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009 16:35:33 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> ca is not checked before hierarchy support, and it's a side-effect.
> 
> Before cpuacct is initialized, css == task->cgroups->subsys[cpuacct_subsys] == NULL,
> but ca = task_ca(tsk) is not necessarily NULL, unless struct cgroup_subsys_state is the
> first member of struct cpuacct.
> 
> And the above code actually should be:
> 
> do {
> 	...
> } while (ca->parent);
> 
I'll send no more objections to this patch itself.

But IMHO, this loop is tooo bad, I think. The hierarchy information should be gathered by
read-side and the total code should be

void charge_statistics(tsk, cputime)
{
   ca = task_ca(tsk)
   /* ca can be null while init */
   if (likely(ca)) {
     u64 *cpuusage = percpu_ptr(ca->cpuusage, task_cpu(tsk))
     *cpuusage += cputime
   }
}
(Need changes to read-side and create/destroy of cpuacct cgroups.)

Thanks,
-Kame

