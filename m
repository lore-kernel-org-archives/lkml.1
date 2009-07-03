Return-Path: <linux-kernel-owner+w=401wt.eu-S1757622AbZGCQuQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757622AbZGCQuQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 12:50:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756870AbZGCQuG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 12:50:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57899 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756519AbZGCQuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 12:50:05 -0400
Date: Fri, 3 Jul 2009 09:50:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Menage <menage@google.com>
Cc: Benjamin Blum <bblum@google.com>, lizf@cn.fujitzu.com, serue@us.ibm.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Adds a read-only "procs" file similar to "tasks"
 that  shows only unique tgids
Message-Id: <20090703095000.cf46ad19.akpm@linux-foundation.org>
In-Reply-To: <6599ad830907030911m6176dc59id3a7d897b03d2bd@mail.gmail.com>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	<20090702232620.3969.16680.stgit@menage.mtv.corp.google.com>
	<20090702164649.303c4952.akpm@linux-foundation.org>
	<2f86c2480907021731h13e0bb95q94f06829eded9aa6@mail.gmail.com>
	<20090702175341.fd2e26d5.akpm@linux-foundation.org>
	<6599ad830907021808o6f3bb51eh324e4bf13544d83e@mail.gmail.com>
	<2f86c2480907021817o79fce75yd9785aab682f7bb4@mail.gmail.com>
	<20090702190845.0cafc46a.akpm@linux-foundation.org>
	<6599ad830907022116n7a711c7fs52ff9b400ec8797f@mail.gmail.com>
	<20090702235527.7ddc873c.akpm@linux-foundation.org>
	<6599ad830907030911m6176dc59id3a7d897b03d2bd@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Jul 2009 09:11:56 -0700 Paul Menage <menage@google.com> wrote:

> Hmm, I guess we could use a combination of the IDR approach that you
> suggested and the present shared-array approach:
> 
> - when opening a tasks file:
>   - populate an IDR with all the pids/tgids in the cgroup
>   - find any existing IDR open for the cgroup in the list keyed by
> namespace and filetype ("procs"/"tasks")
>   - replace (and free) the existing IDR or extend the list with a new one
>   - bump the refcount
> 
> - when reading:
>   - iterate from the last reported pid/tgid
> 
> - when closing:
>   - drop the refcount, and free the IDR if the count reaches 0
> 
> That maintains the property of preventing userspace from consuming
> arbitrary amounts of memory just by holding an fd open on a large
> cgroup, while also maintaining a consistency guarantee, and we get the
> ordering for free as a side-effect of the IDR, with no large memory
> allocations. It's not hugely different from the current solution - all
> we're doing is replacing the large array in the cgroup_pidlist
> structure with an IDR, and populating/reading it appropriately.

I think you're saying "for each pid N in the cgroup, set the Nth
element in an IDR tree".  That would work.  And it automatically gives
ordered traversal and dupe removal.  

I don't think IDRs permit in-order traversal, whereas radix-trees do
support this.  Unfortunately radix-trees are presented as operating on
void* data, so one would need to do some typecasting when storing
BITS_PER_LONG-sized bitfields inside them.

> The downsides would be a higher fixed cost, I suspect - setting up an
> IDR and populating/scanning it sounds like it has to be more expensive
> than filling/reading a linear buffer. But it's probably not enough
> extra overhead to worry too much about it.

Yes, I expect it'd be fairly modest.  There will be far more calls to
kmalloc() when using a tree, but that's the whole point..

