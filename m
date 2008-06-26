Return-Path: <linux-kernel-owner+w=401wt.eu-S1758040AbYFZJuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758040AbYFZJuh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 05:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755132AbYFZJua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 05:50:30 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58926 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbYFZJu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 05:50:29 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=E7jbexrfrf9r4t/ByZ+18iWcVWUcocUQhHqHVx9lYMdKXhCjJ9K9o5ZCrQaDLVSm8
	OlaJuJLB0xHXKx91z6Icg==
Message-ID: <6599ad830806260250m39d700a5haf0f32d999cd2129@mail.gmail.com>
Date: Thu, 26 Jun 2008 02:50:19 -0700
From: "Paul Menage" <menage@google.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: [RFC][PATCH] CPUSets: Move most calls to rebuild_sched_domains() to the workqueue
Cc: "Paul Jackson" <pj@sgi.com>, a.p.zijlstra@chello.nl, maxk@qualcomm.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0806260234y7616bab2k54bc019dfb0c6305@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48634BC1.8@google.com>
	 <19f34abd0806260234y7616bab2k54bc019dfb0c6305@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 2:34 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Thu, Jun 26, 2008 at 9:56 AM, Paul Menage <menage@google.com> wrote:
>> CPUsets: Move most calls to rebuild_sched_domains() to the workqueue
>>
>> In the current cpusets code the lock nesting between cgroup_mutex and
>> cpuhotplug.lock when calling rebuild_sched_domains is inconsistent -
>> in the CPU hotplug path cpuhotplug.lock nests outside cgroup_mutex,
>> and in all other paths that call rebuild_sched_domains() it nests
>> inside.
>>
>> This patch makes most calls to rebuild_sched_domains() asynchronous
>> via the workqueue, which removes the nesting of the two locks in that
>> case. In the case of an actual hotplug event, cpuhotplug.lock nests
>> outside cgroup_mutex as now.
>>
>> Signed-off-by: Paul Menage <menage@google.com>
>>
>> ---
>>
>> Note that all I've done with this patch is verify that it compiles
>> without warnings; I'm not sure how to trigger a hotplug event to test
>> the lock dependencies or verify that scheduler domain support is still
>> behaving correctly. Vegard, does this fix the problems that you were
>> seeing? Paul/Max, does this still seem sane with regard to scheduler
>> domains?
>
> Nope, sorry :-(
>
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.26-rc8-dirty #39
> -------------------------------------------------------
> bash/3510 is trying to acquire lock:
>  (events){--..}, at: [<c0145690>] cleanup_workqueue_thread+0x10/0x70
>
> but task is already holding lock:
>  (&cpu_hotplug.lock){--..}, at: [<c015d9da>] cpu_hotplug_begin+0x1a/0x50
>
> which lock already depends on the new lock.
>

Does that mean that you can't ever call get_online_cpus() from a
workqueue thread?

Paul.
