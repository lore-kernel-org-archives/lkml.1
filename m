Return-Path: <linux-kernel-owner+w=401wt.eu-S1751593AbZIBKyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751593AbZIBKyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 06:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751538AbZIBKyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 06:54:22 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:35702 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751071AbZIBKyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 06:54:22 -0400
Subject: Re: INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected for
	kmemleak_lock
From: Catalin Marinas <catalin.marinas@arm.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1251838545.2158.67.camel@dhcp231-106.rdu.redhat.com>
References: <1251838545.2158.67.camel@dhcp231-106.rdu.redhat.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Wed, 02 Sep 2009 11:54:08 +0100
Message-Id: <1251888848.28251.7.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 02 Sep 2009 10:54:09.0026 (UTC) FILETIME=[B2B05620:01CA2BBB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Tue, 2009-09-01 at 16:55 -0400, Eric Paris wrote:
> I wrote a multithreaded inotify syscall pounder intended to create
> files, destroy files, create watches, and destroy watches with the
> maximum number of races possible.  Instead after letting it run a while
> I came upon this!  And then my system started to crash in all sorts of
> fun and glorious ways (kmem_cache_alloc bugs/panics/whatever)
> 
> -Eric
> 
> [ 2235.913737] ======================================================
> [ 2235.914084] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
> [ 2235.914084] 2.6.31-rc8-next-20090901 #64
> [ 2235.914084] ------------------------------------------------------
> [ 2235.914084] syscall_thrash/2516 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> [ 2235.914084]  (kthread_create_lock){+.+...}, at: [<ffffffff81091543>] kthread_create+0x73/0x180
> [ 2235.914084] 
> [ 2235.914084] and this task is already holding:
> [ 2235.914084]  (kmemleak_lock){..----}, at: [<ffffffff81152611>] create_object+0x161/0x2e0
> [ 2235.914084] which would create a new lock dependency:
> [ 2235.914084]  (kmemleak_lock){..----} -> (kthread_create_lock){+.+...}

Are there other messages from kmemleak printed before that? It looks to
me like kmemleak got an exceptional situation (not being able to
allocate memory or inserting a pointer into the prio search tree) and it
disabled itself. When disabling, it starts a clean-up thread and AFAICT
that's the only condition when kmemleak_lock -> kthread_create_lock
dependency would be created.

I'm not sure whether disabling interrupts around kthread_run in
kmemleak_cleanup() would solve the problem. Otherwise, maybe the
kmemleak clean-up thread should take a different form or just a thread
waiting for a clean-up event (it currently acquires a mutex and cannot
be used in interrupt context).

Thanks.

-- 
Catalin

