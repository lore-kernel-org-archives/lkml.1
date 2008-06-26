Return-Path: <linux-kernel-owner+w=401wt.eu-S1758817AbYFZVRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbYFZVRy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 17:17:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754254AbYFZVRo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 17:17:44 -0400
Received: from smtp-out.google.com ([216.239.33.17]:28049 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbYFZVRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 17:17:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Z5+qNZgm2X4yMycRzWac/Ad07LDIw0VA34Byr0VeWGZBEVPmue7I/q5QLPcIh0l4l
	8nAoQW4G0bNMPrLAMutzg==
Message-ID: <6599ad830806261417u3015a9b2i6318841de866d768@mail.gmail.com>
Date: Thu, 26 Jun 2008 14:17:35 -0700
From: "Paul Menage" <menage@google.com>
To: "Max Krasnyansky" <maxk@qualcomm.com>
Subject: Re: [RFC][PATCH] CPUSets: Move most calls to rebuild_sched_domains() to the workqueue
Cc: "Vegard Nossum" <vegard.nossum@gmail.com>, "Paul Jackson" <pj@sgi.com>,
       a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       "Gautham shenoy" <ego@in.ibm.com>
In-Reply-To: <6599ad830806261334y6def5f7an57ac8f071a08eb4b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48634BC1.8@google.com>
	 <19f34abd0806260234y7616bab2k54bc019dfb0c6305@mail.gmail.com>
	 <6599ad830806260250m39d700a5haf0f32d999cd2129@mail.gmail.com>
	 <4863E4C8.9050705@qualcomm.com>
	 <6599ad830806261334y6def5f7an57ac8f071a08eb4b@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 1:34 PM, Paul Menage <menage@google.com> wrote:
>
> void get_online_cpus(void)
> {
>        might_sleep();
>        if (cpu_hotplug.active_writer == current)
>                return;
>        down_read(&cpu_hotplug.lock);
> }
>
> void put_online_cpus(void)
> {
>        if (cpu_hotplug.active_writer == current)
>                return;
>        up_read(&cpu_hotplug.lock);
> }
>
> static void cpu_hotplug_begin(void)
> {
>        down_write(&cpu_hotplug.lock);
>        cpu_hotplug.active_writer = current;
> }
>
> static void cpu_hotplug_done(void)
> {
>        cpu_hotplug.active_writer = NULL;
>        up_write(&cpu_hotplug.lock);
> }
>
> I think that combined with moving the async rebuild_sched_domains to a
> separate thread should solve the problem, but I'm wondering why
> cpu_hotplug.lock was implemented this way in the first place.

Oh, I guess that doesn't work because of recursive calls to
get_online_cpus(). Maybe we need a down_read_recursive() that skips
ahead of waiting writers if the lock is already held in read mode?

Paul
