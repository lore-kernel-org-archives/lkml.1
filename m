Return-Path: <linux-kernel-owner+w=401wt.eu-S1754175AbZGBDST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbZGBDST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 23:18:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753728AbZGBDSL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 23:18:11 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46198 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990AbZGBDSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 23:18:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 2 Jul 2009 12:16:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Paul Menage <menage@google.com>
Cc: lizf@cn.fujitsu.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       containers@lists.linux-foundation.org
Subject: Re: [PATCH 7/9] [RFC] Support multiply-bindable cgroup subsystems
Message-Id: <20090702121626.7676c7d4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <6599ad830907011952t2e698e77j1e8dba21402bc9a9@mail.gmail.com>
References: <20090702020624.14469.47066.stgit@menage.mtv.corp.google.com>
	<20090702021128.14469.3360.stgit@menage.mtv.corp.google.com>
	<20090702114555.b7253edf.kamezawa.hiroyu@jp.fujitsu.com>
	<6599ad830907011952t2e698e77j1e8dba21402bc9a9@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jul 2009 19:52:16 -0700
Paul Menage <menage@google.com> wrote:

> On Wed, Jul 1, 2009 at 7:45 PM, KAMEZAWA
> Hiroyuki<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >> - in the current version of this patch, mounting a cgroups hierarchy
> >>   with no options does *not* get you any of the multi-bindable
> >>   subsystems; possibly for consistency it should give you all of the
> >>   multi-bindable subsystems as well as all of the single-bindable
> >>   subsystems.
> >>
> > I don't think this is a big problem. Hmm, I wonder there are no people who
> > uses cgroup without any options (= mounts all subsys at once)...
> 
> In practice I suspect that it's a rare usage outside of manual
> playing/testing - any real production system is going to want to be
> aware of what subsystems are available and decide which to mount on
> each hierarchy.
> 
> >
> > Wow...seems complicated. How about adding linux/cgroup_multisubsys.h ?
> 
> I think that the readability benefits in cgroup.c would be outweighed
> by having two different subsys include files.
> 

Hm, then, moving SUBSYS() macro to linux/cgroup_subsys.h is a sane way, I think.
IMHO, it's not very good habit that cgroup_subsys.h is parsed in different ways in
cgroup.h and cgroup.c

I think cgroup_subsys.h like following is much simpler even if it's not very
sophisticated.
==
#define SUBSYSID(_name)		_name ## _subsys_id,
#define SUBSYSP(_name)		&_name ## _subsys,

#ifdef CONFIG_CPUSETS
#define CPUSETS_ID		SUBSYSID(cpuset)
#define CPUSETS_SUBSYS		SUBSYSP(cpuset)
#else
#define CPUSETS_ID		
#define CPUSETS_SUBSYS		
#endif

#ifdef CONFIG_CPU
#define CPU_ID			SUBSYSID(cpu)
#define CPU_SUBSYS		SUBSYSP(cpu)
#else
#define CPU_ID
#define CPU_SUBSYS
#endif

#ifdef CONFIG_MEMORY
#define MEMORY_ID		SUBSYSID(memory)
#define MEMORY_SUBSYS		SUBSYSP(memory)
#else
#define MEMORY_ID
#define MEMORY_SUBSYS
#endif

#define CGROUP_ALL_SUBSYSID	CPUSETS_ID CPU_ID MEMORY_ID
#define CGROUP_ALL_SUBSYSP	CPUSETS_SUBSYS CPU_SUBSYS MEMORY_SUBSYS

==
But I know I'm not a man who can talk about beauty of codes ;)

Thanks,
-Kame

