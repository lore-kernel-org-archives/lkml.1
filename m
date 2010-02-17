Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933700Ab0BQAE5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 19:04:57 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:47092 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933653Ab0BQAEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 19:04:54 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 17 Feb 2010 09:01:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch -mm 4/9 v2] oom: remove compulsory panic_on_oom mode
Message-Id: <20100217090124.398769d5.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1002161550550.11952@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002151416470.26927@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1002151418190.26927@chino.kir.corp.google.com>
	<20100216090005.f362f869.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002151610380.14484@chino.kir.corp.google.com>
	<20100216092311.86bceb0c.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002160058470.17122@chino.kir.corp.google.com>
	<20100217084239.265c65ea.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002161550550.11952@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Feb 2010 15:54:50 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Wed, 17 Feb 2010, KAMEZAWA Hiroyuki wrote:
> > Then, please leave panic_on_oom=always.
> > Even with mempolicy or cpuset 's OOM, we need panic_on_oom=always option.
> > And yes, I'll add something similar to memcg. freeze_at_oom or something.
> > 
> 
> Memcg isn't a special case here, it should also panic the machine if 
> panic_on_oom == 2, so if we aren't going to remove this option then I 
> agree with Nick that we need to panic from mem_cgroup_out_of_memory() as 
> well.  Some users use cpusets, for example, for the same effect of memory 
> isolation as you use memcg, so panicking in one scenario and not the other 
> is inconsistent.
> 
Hmm, I have a few reason to add special behavior to memcg rather than panic.

 - freeze_at_oom is enough.
   If OOM can be notified, the management daemon can do useful jobs. Shutdown
   all other cgroups or migrate them to other host and do kdump.

 - memcg's oom is not very complicated.
   Because we just counts RSS+FileCache

But, Hmm...I'd like to go this way.

 1. At first, support panic_on_oom=2 in memcg.

 2. Second, I'll add OOM-notifier and freeze_at_oom to memcg.
    and don't call memcg_out_of_memory in oom_kill.c in this case. Because
    we don't kill anything. Taking coredumps of all procs in memcg is not
    very difficult.

I need to discuss with memcg guys. But this will be a way to go, I think

Thanks,
-Kame

