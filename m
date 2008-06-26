Return-Path: <linux-kernel-owner+w=401wt.eu-S1761180AbYFZUef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761180AbYFZUef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 16:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752954AbYFZUe0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 16:34:26 -0400
Received: from smtp-out.google.com ([216.239.33.17]:22151 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474AbYFZUeZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 16:34:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=rDx/rkpftGljAd9PmkrAPs0pOyznGo54xqwJ16Pbuf2L/3xJaCx7DbbW3RLTl/MXI
	UfjZ/Qq8fS20eH7RbpHCw==
Message-ID: <6599ad830806261334y6def5f7an57ac8f071a08eb4b@mail.gmail.com>
Date: Thu, 26 Jun 2008 13:34:11 -0700
From: "Paul Menage" <menage@google.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>
Subject: Re: [RFC][PATCH] CPUSets: Move most calls to rebuild_sched_domains() to the workqueue
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>, "Paul Jackson" <pj@sgi.com>,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       "Gautham shenoy" <ego@in.ibm.com>
In-Reply-To: <4863E4C8.9050705@qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48634BC1.8@google.com>
	 <19f34abd0806260234y7616bab2k54bc019dfb0c6305@mail.gmail.com>
	 <6599ad830806260250m39d700a5haf0f32d999cd2129@mail.gmail.com>
	 <4863E4C8.9050705@qualcomm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 11:49 AM, Max Krasnyansky <maxk@qualcomm.com> wrote:
>>
>> Does that mean that you can't ever call get_online_cpus() from a
>> workqueue thread?
>
> In general it should be ok (no different from user-space task calling it).

No, I think it is a problem.

When a CPU goes down, the hotplug code holds cpu_hotplug.lock and
calls cleanup_workqueue_thread() which waits for any running work on
that thread to finish.

So if the workqueue thread running on that CPU calls get_online_cpus()
while the hotplug thread is waiting for it, it will deadlock. (It's
not clear to me how lockdep figured this out - I guess it's something
to do with the *_acquire() annotations that tell lockdep to treat the
workqueue structure as a pseudo-lock?)

I guess the fix for that would be to have a non-workqueue thread to
handle the async domain rebuilding, which isn't tied to a particular
cpu the way workqueue threads are.

> But there is still circular dependency because we're calling into
> domain partitioning code.

OK, so the problem is that since cpu_hotplug contains a hand-rolled
rwsem, lockdep is going to spot false deadlocks.

Is there any reason not to replace cpu_hotplug.lock and
cpu_hotplug.refcount with an rw_semaphore, and have the following:

void get_online_cpus(void)
{
        might_sleep();
        if (cpu_hotplug.active_writer == current)
                return;
        down_read(&cpu_hotplug.lock);
}

void put_online_cpus(void)
{
        if (cpu_hotplug.active_writer == current)
                return;
        up_read(&cpu_hotplug.lock);
}

static void cpu_hotplug_begin(void)
{
        down_write(&cpu_hotplug.lock);
        cpu_hotplug.active_writer = current;
}

static void cpu_hotplug_done(void)
{
        cpu_hotplug.active_writer = NULL;
        up_write(&cpu_hotplug.lock);
}

I think that combined with moving the async rebuild_sched_domains to a
separate thread should solve the problem, but I'm wondering why
cpu_hotplug.lock was implemented this way in the first place.

Paul
