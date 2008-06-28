Return-Path: <linux-kernel-owner+w=401wt.eu-S1763836AbYF1ACw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763836AbYF1ACw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 20:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758378AbYF1ACm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 20:02:42 -0400
Received: from smtp-out.google.com ([216.239.33.17]:12464 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753495AbYF1ACl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 20:02:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Vg6DJTj8VbSABRbc0Rrk6KdqcGcy0vqZgjJ8S/6VLbMNMjmnsGRe5jB+P81VHMmox
	+8GYAGaKEq+eUTjyDFBdg==
Message-ID: <6599ad830806271702y2c1df2edh3a75dda75336ddad@mail.gmail.com>
Date: Fri, 27 Jun 2008 17:02:35 -0700
From: "Paul Menage" <menage@google.com>
To: a.p.zijlstra@chello.nl, maxk@qualcomm.com, pj@sgi.com,
       vegard.nossum@gmail.com
Subject: Re: [RFC][PATCH] CGroups: Add a per-subsystem hierarchy lock
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080627075912.92AE43D6907@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080627075912.92AE43D6907@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 27, 2008 at 12:59 AM, Paul Menage <menage@google.com> wrote:
>
> This patch adds a hierarchy_mutex to the cgroup_subsys object that
> protects changes to the hierarchy observed by that subsystem. It is
> taken by the cgroup subsystem for the following operations:
>
> - linking a cgroup into that subsystem's cgroup tree
> - unlinking a cgroup from that subsystem's cgroup tree
> - moving the subsystem to/from a hierarchy (including across the
>  bind() callback)
>
> Thus if the subsystem holds its own hierarchy_mutex, it can safely
> traverse its ts own hierarchy.
>

It struck me that there's a small race in this code now that we're not
doing cgroup_lock() in the hotplug path.

- we start to attach a task T to cpuset C, with a single CPU "X" in
its "cpus" list
- cpuset_can_attach() returns successfully since the cpuset has a cpu
- CPU X gets hot-unplugged; any tasks in C are moved to their parent
cpuset and C loses its cpu.
- we update T->cgroups to point to C, which is broken since C has no cpus.

So we'll need some additional locking work on top of this - but I
think this patch is still a step in the right direction.

Paul
