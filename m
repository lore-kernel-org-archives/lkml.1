Return-Path: <linux-kernel-owner+w=401wt.eu-S1761306AbYHFUWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761306AbYHFUWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 16:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754592AbYHFUUv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 16:20:51 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64522 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754039AbYHFUUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 16:20:50 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5355"; a="5371765"
Message-ID: <489A079E.5040903@qualcomm.com>
Date: Wed, 06 Aug 2008 13:20:46 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Jackson <pj@sgi.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, menage@google.com,
       a.p.zijlstra@chello.nl, vegard.nossum@gmail.com, lizf@cn.fujitsu.com
Subject: Re: [PATCH] cpuset: Rework sched domains and CPU hotplug handling
 (2.6.27-rc1)
References: <1217631552-22129-1-git-send-email-maxk@qualcomm.com>	<20080802063900.6615e5ca.pj@sgi.com>	<48948C3A.6050805@qualcomm.com>	<20080802225127.2b0d138b.pj@sgi.com>	<4895F3ED.4020805@qualcomm.com>	<20080804010033.0d1b0549.pj@sgi.com>	<48977E81.4040207@qualcomm.com>	<20080804225636.541527e8.pj@sgi.com>	<4898B873.6000308@qualcomm.com>	<20080805180521.be7010e1.pj@sgi.com>	<48991973.90109@qualcomm.com>	<20080805222927.6dd95f5f.pj@sgi.com>	<4899202B.6030303@qualcomm.com>	<20080805232856.78dd50f7.pj@sgi.com>	<489930B5.9030906@qualcomm.com> <20080806004629.d321f3b0.pj@sgi.com>
In-Reply-To: <20080806004629.d321f3b0.pj@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Jackson wrote:
> How about this ... two routines quite identical and parallel,
> even in their names, except that one is async and the other not:
> 
> ==================================================================
> 
> /*
>  * Rebuild scheduler domains, asynchronously in a separate thread.
>  *
>  * If the flag 'sched_load_balance' of any cpuset with non-empty
>  * 'cpus' changes, or if the 'cpus' allowed changes in any cpuset
>  * which has that flag enabled, or if any cpuset with a non-empty
>  * 'cpus' is removed, then call this routine to rebuild the
>  * scheduler's dynamic sched domains.
>  *
>  * The rebuild_sched_domains() and partition_sched_domains()
>  * routines must nest cgroup_lock() inside get_online_cpus(),
>  * but such cpuset changes as these must nest that locking the
>  * other way, holding cgroup_lock() for much of the code.
>  *
>  * So in order to avoid an ABBA deadlock, the cpuset code handling
>  * these user changes delegates the actual sched domain rebuilding
>  * to a separate workqueue thread, which ends up processing the
>  * above rebuild_sched_domains_thread() function.
>  */
> static void async_rebuild_sched_domains(void)
> {
>         queue_work(cpuset_wq, &rebuild_sched_domains_work);
> }
> 
> /*
>  * Accomplishes the same scheduler domain rebuild as the above
>  * async_rebuild_sched_domains(), however it directly calls the
>  * rebuild routine inline, rather than calling it via a separate
>  * asynchronous work thread.
>  *
>  * This can only be called from code that is not holding
>  * cgroup_mutex (not nested in a cgroup_lock() call.)
>  */
> void inline_rebuild_sched_domains(void)
> {
>         rebuild_sched_domains_thread(NULL);
> }
> 
> ==================================================================

Sure. That looks fine. Although inline_ will probably be a bit confusing 
since one may think that it has something to do with the C 'inline'.
I'd suggest either sync_rebuild_sched_domains() or simply 
rebuild_sched_domains(). The later has the advantage that the patch will 
not have to touch the scheduler code.

Let me know your preference and I'll respin the patch.

Max

