Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbYLAM3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbYLAM3z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:29:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751682AbYLAM3p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:29:45 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:35284 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752282AbYLAM3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:29:44 -0500
Subject: Re: [PATCH 01/15] kmemleak: Add the base support
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <84144f020811302249i7587662ewa621d0a81f5426a2@mail.gmail.com>
References: <20081129103908.16726.24264.stgit@pc1117.cambridge.arm.com>
	 <20081129104312.16726.36218.stgit@pc1117.cambridge.arm.com>
	 <20081201142824.D552.E1E9C6FF@jp.fujitsu.com>
	 <84144f020811302249i7587662ewa621d0a81f5426a2@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Mon, 01 Dec 2008 12:29:22 +0000
Message-Id: <1228134562.25929.59.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Dec 2008 12:29:22.0991 (UTC) FILETIME=[70E0F3F0:01C953B0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-12-01 at 08:49 +0200, Pekka Enberg wrote:
> On Mon, Dec 1, 2008 at 7:39 AM, Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> >> +/*
> >> + * Insert a pointer into the pointer hash table.
> >> + */
> >> +static inline void create_object(unsigned long ptr, size_t size, int ref_count)
> >> +{
> >> +     unsigned long flags;
> >> +     struct memleak_object *object;
> >> +     struct prio_tree_node *node;
> >> +     struct stack_trace trace;
> >> +
> >> +     object = kmem_cache_alloc(object_cache, GFP_ATOMIC);
> >> +     if (!object)
> >> +             panic("kmemleak: cannot allocate a memleak_object structure\n");
> >
> > IIRC, GFP_ATOMIC allocation sometimes fails. (ex. when page cache occupies all
> > area). It seems to be easy to panic. Is it intended?
> 
> Yup, GFP_ATOMIC can fail as can any memory allocation on out-of-memory
> conditions unless you specify GFP_NOFAIL which will either succeed or
> lock up the box. I think you can just WARN_ON() here? However, it's
> probably safer to pass gfp flags from the callers here; otherwise we
> end up doing tons of GFP_ATOMIC allocations which is not healthy in
> general.

Yes, good idea, GFP_ATOMIC isn't always needed.

> Also, I see some other BUG_ON() calls in the code which probably
> should be converted to WARN_ON() as well.

This was also raised in the past by Ingo and it's on my to-do list to
fix. Basically, if an allocation for internal kmemleak structures fails,
kmemleak should print a warning and disable the tracing since further
leak reports are irrelevant. Once I add the run-time kmemleak
configuration/disabling, I'll change the BUG_ON and panic calls to
something less severe.

-- 
Catalin

