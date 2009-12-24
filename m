Return-Path: <linux-kernel-owner+w=401wt.eu-S1753658AbZLXFr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753658AbZLXFr2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 00:47:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752152AbZLXFr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 00:47:27 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:59824 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752136AbZLXFr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 00:47:26 -0500
Message-ID: <4B330063.2030202@cn.fujitsu.com>
Date: Thu, 24 Dec 2009 13:47:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Dave Anderson <anderson@redhat.com>
CC: menage@google.com, linux-kernel@vger.kernel.org,
       Ben Blum <bblum@andrew.cmu.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "containers@lists.osdl.org" <containers@lists.osdl.org>
Subject: Re: [PATCH] cgroups: fix 2.6.32 regression causing BUG_ON() in cgroup_diput()
References: <4B32660A.8070106@redhat.com>
In-Reply-To: <4B32660A.8070106@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Andrew
CC: Container list

Dave Anderson wrote:
> 
> The LTP cgroup test suite generates a "kernel BUG at kernel/cgroup.c:790!"
> here in cgroup_diput():
> 
>                 /*
>                  * if we're getting rid of the cgroup, refcount should
> ensure
>                  * that there are no pidlists left.
>                  */
>                 BUG_ON(!list_empty(&cgrp->pidlists));
> 

Good catch. Thanks!

This BUG can be easily triggered if 2 threads are reading the same cgroup's
tasks file at the same time, and then the cgroup gets removed.

And this patch needs to be added to 2.6.32.x.

> The cgroup pidlist rework in 2.6.32 generates the BUG_ON, which is caused
> when pidlist_array_load() calls cgroup_pidlist_find():
> 
> (1) if a matching cgroup_pidlist is found, it down_write's the mutex of the
>     pre-existing cgroup_pidlist, and increments its use_count.
> (2) if no matching cgroup_pidlist is found, then a new one is allocated, it
>     down_write's its mutex, and the use_count is set to 0.
> (3) the matching, or new, cgroup_pidlist gets returned back to
> pidlist_array_load(),
>     which increments its use_count -- regardless whether new or
> pre-existing --
>     and up_write's the mutex.
> 
> So if a matching list is ever encountered by cgroup_pidlist_find() during
> the life of a cgroup directory, it results in an inflated use_count value,
> preventing it from ever getting released by cgroup_release_pid_array().
> Then if the directory is subsequently removed, cgroup_diput() hits the
> BUG_ON() when it finds that the directory's cgroup is still populated
> with a pidlist.
> 
> The patch simply removes the use_count increment when a matching
> pidlist is found by cgroup_pidlist_find(), because it gets bumped by
> the calling pidlist_array_load() function while still protected by the
> list's mutex.
> 
> Signed-off-by: Dave Anderson <anderson@redhat.com>
> 

Reviewed-by: Li Zefan <lizf@cn.fujitsu.com>

