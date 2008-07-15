Return-Path: <linux-kernel-owner+w=401wt.eu-S1761824AbYGOR2A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761824AbYGOR2A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:28:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754535AbYGOR1w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:27:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:42457 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754084AbYGOR1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:27:51 -0400
X-IronPort-AV: E=McAfee;i="5200,2160,5339"; a="4557744"
Message-ID: <487CDE15.1070401@qualcomm.com>
Date: Tue, 15 Jul 2008 10:27:49 -0700
From: Max Krasnyansky <maxk@qualcomm.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Paul Menage <menage@google.com>
CC: mingo@elte.hu, pj@sgi.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl
Subject: Re: [PATCH] cpuset: Make rebuild_sched_domains() usable from any
 context
References: <1216122293-4888-1-git-send-email-maxk@qualcomm.com> <6599ad830807150914h152e3716n914dfa5e28288d28@mail.gmail.com>
In-Reply-To: <6599ad830807150914h152e3716n914dfa5e28288d28@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Menage wrote:
> On Tue, Jul 15, 2008 at 4:44 AM, Max Krasnyansky <maxk@qualcomm.com> wrote:
>> From: Max Krasnyanskiy <maxk@qualcomm.com>
>>
>> I do not really like the current solution of dropping cgroup lock
>> but it shows what I have in mind in general.
> 
> I think that dropping the cgroup lock will open up races for cpusets.
> The idea of a separate workqueue/thread to do the sched domain
> rebuilding is simplest.

Actually I audited (to the best of my knowledge) all the paths in 
cpusets and rebuild_sched_domains() is the last action. ie We drop the 
lock right after it anyways. It's just it's embedded deep in the call 
stack and therefor I cannot drop it at the higher level.

The only path where I think it's not safe is the cgroup destroy thing 
where we do
	
cgroup.c
	cgroup_lock();
	for_each_cgroups(...)
		cg->destroy();
	cgroup_unlock();

So in theory it's just that one patch that really needs the workqueue 
trick. But I do agree that it'll make it less tricky across the board.
So I'll pick up you work queue based patch, convert it to single 
threaded, bang on a bit later today and send a patch on top of this one.

Max


