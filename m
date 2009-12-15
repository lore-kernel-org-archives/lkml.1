Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbZLOBfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbZLOBfX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 20:35:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbZLOBfU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 20:35:20 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53134 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754872AbZLOBfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 20:35:17 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 15 Dec 2009 10:32:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Rientjes <rientjes@google.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [BUGFIX][PATCH] oom-kill: fix NUMA consraint check with
 nodemask v4.2
Message-Id: <20091215103202.eacfd64e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20091214171632.0b34d833.akpm@linux-foundation.org>
References: <20091110162121.361B.A69D9226@jp.fujitsu.com>
	<20091110162445.c6db7521.kamezawa.hiroyu@jp.fujitsu.com>
	<20091110163419.361E.A69D9226@jp.fujitsu.com>
	<20091110164055.a1b44a4b.kamezawa.hiroyu@jp.fujitsu.com>
	<20091110170338.9f3bb417.nishimura@mxp.nes.nec.co.jp>
	<20091110171704.3800f081.kamezawa.hiroyu@jp.fujitsu.com>
	<20091111112404.0026e601.kamezawa.hiroyu@jp.fujitsu.com>
	<20091111134514.4edd3011.kamezawa.hiroyu@jp.fujitsu.com>
	<20091111142811.eb16f062.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0911102155580.2924@chino.kir.corp.google.com>
	<20091111152004.3d585cee.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0911102224440.6652@chino.kir.corp.google.com>
	<20091111153414.3c263842.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0911171609370.12532@chino.kir.corp.google.com>
	<20091118095824.076c211f.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.0911171725050.13760@chino.kir.corp.google.com>
	<20091214171632.0b34d833.akpm@linux-foundation.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 17:16:32 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> 
> So I have a note-to-self here that these patches:
> 
> oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
> oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
> oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
> 
> are tentative and it was unclear whether I should merge them.
> 
> What do we think?
> 

In my view,
  oom-kill-show-virtual-size-and-rss-information-of-the-killed-process.patch
  - should be merged. Because we tend to get several OOM reports in a month,
    More precise information is always welcomed.

  oom-kill-fix-numa-consraint-check-with-nodemask-v42.patch
  - should be merged. This is a bug fix.

  oom_kill-use-rss-value-instead-of-vm-size-for-badness.patch
  - should not be merged.
    I'm now preparing more counters for mm's statistics. It's better to
    wait  and to see what we can do more. And other patches for total
    oom-killer improvement is under development.

    And, there is a compatibility problem.
    As David says, this may break some crazy software which uses
    fake_numa+cpuset+oom_killer+oom_adj for resource controlling.
   (even if I recommend them to use memcg rather than crazy tricks...)
    
    2 ideas which I can think of now are..
    1) add sysctl_oom_calc_on_committed_memory 
       If this is set, use vm-size instead of rss.

    2) add /proc/<pid>/oom_guard_size
       This allows users to specify "valid/expected size" of a task.
       When
       #echo 10M > /proc/<pid>/oom_guard_size
       At OOM calculation, 10Mbytes is subtracted from rss size.
       (The best way is to estimate this automatically from vm_size..but...)



Thanks,
-Kame

