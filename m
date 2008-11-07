Return-Path: <linux-kernel-owner+w=401wt.eu-S1753389AbYKGCc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbYKGCc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 21:32:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbYKGCcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 21:32:48 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58745 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbYKGCcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 21:32:47 -0500
Date: Fri, 7 Nov 2008 11:32:09 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       virtualization@lists.linux-foundation.org, jens.axboe@oracle.com,
       Hirokazu Takahashi <taka@valinux.co.jp>,
       Ryo Tsuruta <ryov@valinux.co.jp>, Andrea Righi <righi.andrea@gmail.com>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, Rik van Riel <riel@redhat.com>,
       fernando@oss.ntt.co.jp, Jeff Moyer <jmoyer@redhat.com>,
       menage@google.com, ngupta@google.com,
       Andrew Morton <akpm@linux-foundation.org>, balbir@linux.vnet.ibm.com
Subject: Re: [patch 1/4] io controller: documentation
Message-Id: <20081107113209.a6011c67.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20081106153135.743458085@redhat.com>
References: <20081106153022.215696930@redhat.com>
	<20081106153135.743458085@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2008 10:30:23 -0500
vgoyal@redhat.com wrote:
> +ISSUES
> +======
> +- IO controller can buffer the bios if suffcient tokens were not available
> +  at the time of bio submission. Once the tokens are available, these bios
> +  are dispatched to elevator/lower layers in first come first serve manner.
> +  And this has potential to break CFQ where a RT tasks should be able to
> +  dispatch the bio first or a high priority task should be able to release
> +  more bio as compared to low priority task in same cgroup.
> +
> +  Not sure how to fix it. May be we need to maintain another rb-tree and
> +  keep track of RT tasks and tasks priorities and dispatch accordingly. This
> +  is equivalent of duplicating lots of CFQ logic and not sure how would it
> +  impact AS behaviour.
> 
Why you don't isolate RT tasks into other cgroup ?
   /cgroup/bio-cgroup/group_for_usual/...usual tasks.
                     /group_for_RT/ ...RT tasks. you can use high-speed path.

How about adding RT flag to bio-cgroup and skip buffering at bio-cgroup if RT
flag is set ? I think handling an usual process and RT process in "a" cgroup
just makes the code complex.

Looking into a cpu-scheduler, which is the first module handling RT, it has
some tweaks to handle RT in the system.
 - special RT scheduler.
 - isolated RT domain
 - maximum execution time allowed to RT
 ....

Maybe handling RT in following way is usual way...(if we do something in this layer)

  - Allow RT-bio-cgroup to skip limit check.
  - But RT-bio-cgroup calculates io-throuput, execution time, statistics...
  - When RT tasks in RT-bio-cgroup does excessive I/O which starves the whole system
    too long, raise safeguard-limitter. and tell users Warning or kill it.

Hmm ?

Thanks,
-Kame

