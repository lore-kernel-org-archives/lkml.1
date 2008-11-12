Return-Path: <linux-kernel-owner+w=401wt.eu-S1755472AbYKLWjr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472AbYKLWjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 17:39:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751790AbYKLWjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 17:39:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:55516 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbYKLWjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 17:39:35 -0500
Subject: Re: [PATCH =-v3 07/21] fanotify: fastpath to ignore certain in
	core inodes
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, malware-list@lists.printk.net,
       viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
In-Reply-To: <20081112161103.25434.30104.stgit@paris.rdu.redhat.com>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
	 <20081112161103.25434.30104.stgit@paris.rdu.redhat.com>
Content-Type: text/plain
Date: Wed, 12 Nov 2008 23:38:44 +0100
Message-Id: <1226529524.6696.37.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On Wed, 2008-11-12 at 11:11 -0500, Eric Paris wrote:
> +#ifdef CONFIG_FANOTIFY
> +       struct list_head        fastpath_entries; /* fanotify fastpath entries protected by group */
> +       rwlock_t                fastpath_rwlock; /* protect the fastpath entries list */
> +#endif

Are you really sure those rwlocks actually gain you performance?

rwlocks are really bad, the critical section must be short because its
non-preemptable, but both the lock and unlock are atomic ops that can
(and usually will) bounce cachelines. So you often get into the
situation where your performance is limited by the cacheline bouncing.

There's also a starvation case in there, where the cacheline is so hot
on one package/node that another package/node doesn't get it.

Regular spinlocks are usually faster in those cases (and on those archs
that have ticket locks avoid the starvation case too).

And for those cases where the read side is long enough to not be
dominated by the cacheline bouncing, RCU is usually the best way out.

