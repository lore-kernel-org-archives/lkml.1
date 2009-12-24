Return-Path: <linux-kernel-owner+w=401wt.eu-S1755812AbZLXIjM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755812AbZLXIjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Dec 2009 03:39:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755129AbZLXIjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Dec 2009 03:39:11 -0500
Received: from RELAY.ANDREW.CMU.EDU ([128.2.10.212]:45977 "EHLO
	relay.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048AbZLXIjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Dec 2009 03:39:10 -0500
Date: Thu, 24 Dec 2009 03:38:45 -0500
From: Ben Blum <bblum@andrew.cmu.edu>
To: Dave Anderson <anderson@redhat.com>
Cc: menage@google.com, linux-kernel@vger.kernel.org, lizf@cn.fujitsu.com
Subject: Re: [PATCH] cgroups: fix 2.6.32 regression causing BUG_ON() in cgroup_diput()
Message-ID: <20091224083845.GA16162@andrew.cmu.edu>
References: <4B32660A.8070106@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B32660A.8070106@redhat.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 23, 2009 at 01:48:42PM -0500, Dave Anderson wrote:
> 
> The LTP cgroup test suite generates a "kernel BUG at kernel/cgroup.c:790!"
> here in cgroup_diput():
> 
>                 /*
>                  * if we're getting rid of the cgroup, refcount should 
>                  ensure
>                  * that there are no pidlists left.
>                  */
>                 BUG_ON(!list_empty(&cgrp->pidlists));
> 
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
>     pre-existing --
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
> ---
> 
> 

Ack! That was probably my fault. Good catch.
