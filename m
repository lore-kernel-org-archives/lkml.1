Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbZBDJQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbZBDJQv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 04:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752287AbZBDJQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 04:16:08 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63022 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754862AbZBDJQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 04:16:06 -0500
Message-ID: <49895CAD.1020008@cn.fujitsu.com>
Date: Wed, 04 Feb 2009 17:15:25 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] cgroups: fix lockdep subclasses overflow
References: <49895BD7.8090405@cn.fujitsu.com>
In-Reply-To: <49895BD7.8090405@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Zefan wrote:
> I enabled all cgroup subsystems when compiling kernel, and then:
>  # mount -t cgroup -o net_cls xxx /mnt
>  # mkdir /mnt/0
> 
> This showed up immediately:
>  BUG: MAX_LOCKDEP_SUBCLASSES too low!
>  turning off the locking correctness validator.
> 
> It's caused by the cgroup hierarchy lock:
> 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
> 		struct cgroup_subsys *ss = subsys[i];
> 		if (ss->root == root)
> 			mutex_lock_nested(&ss->hierarchy_mutex, i);
> 	}
> 
> Now we have 9 cgroup subsystems, and the above 'i' for net_cls is 9, but

sorry, a typo here: the above 'i' for net_cls is 8.

> MAX_LOCKDEP_SUBCLASSES is 8.
> 
> This patch uses different lockdep keys for different subsystems.
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
