Return-Path: <linux-kernel-owner+w=401wt.eu-S1752890AbYKYPBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890AbYKYPBm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 10:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751885AbYKYPBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 10:01:34 -0500
Received: from e28smtp04.in.ibm.com ([59.145.155.4]:55889 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbYKYPBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 10:01:33 -0500
Message-ID: <492C1345.9090201@linux.vnet.ibm.com>
Date: Tue, 25 Nov 2008 20:31:25 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
CC: linux-mm@kvack.org, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [mm] [PATCH 3/4] Memory cgroup hierarchical reclaim (v4)
References: <20081116081034.25166.7586.sendpatchset@balbir-laptop> <20081116081055.25166.85066.sendpatchset@balbir-laptop> <20081125205832.38f8c365.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20081125205832.38f8c365.nishimura@mxp.nes.nec.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daisuke Nishimura wrote:
> Hi.
> 
> Unfortunately, trying to hold cgroup_mutex at reclaim causes dead lock.
> 
> For example, when attaching a task to some cpuset directory(memory_migrate=on),
> 
>     cgroup_tasks_write (hold cgroup_mutex)
>         attach_task_by_pid
>             cgroup_attach_task
>                 cpuset_attach
>                     cpuset_migrate_mm
>                         :
>                         unmap_and_move
>                             mem_cgroup_prepare_migration
>                                 mem_cgroup_try_charge
>                                     mem_cgroup_hierarchical_reclaim
> 

Did lockdep complain about it?

1. We could probably move away from cgroup_mutex to a memory controller specific
mutex.
2. We could give up cgroup_mutex before migrate_mm, since it seems like we'll
hold the cgroup lock for long and holding it during reclaim will definitely be
visible to users trying to create/delete nodes.

I prefer to do (2), I'll look at the code more closely

> I think similar problem can also happen when removing memcg's directory.
> 

Why removing a directory? memcg (now) marks the directory as obsolete and we
check for obsolete directories and get/put references.

Thanks for the bug report!

-- 
	Balbir
