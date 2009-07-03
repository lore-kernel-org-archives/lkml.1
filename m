Return-Path: <linux-kernel-owner+w=401wt.eu-S1758477AbZGCQML@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758477AbZGCQML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 12:12:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758064AbZGCQL6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 12:11:58 -0400
Received: from smtp-out.google.com ([216.239.45.13]:39129 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959AbZGCQL4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 12:11:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=YsdcAvnYasY4aohjUTWI5RcZixqOqr5joPH1mSnqVGOY1AQuw0EeH5Im1H/Gl0hv6
	ZGOWnhqnxcFr8Fj8dOsaQ==
MIME-Version: 1.0
In-Reply-To: <20090702235527.7ddc873c.akpm@linux-foundation.org>
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
Date: Fri, 3 Jul 2009 09:11:56 -0700
Message-ID: <6599ad830907030911m6176dc59id3a7d897b03d2bd@mail.gmail.com>
Subject: Re: [PATCH 1/2] Adds a read-only "procs" file similar to "tasks" that 
	shows only unique tgids
From: Paul Menage <menage@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Benjamin Blum <bblum@google.com>, lizf@cn.fujitzu.com, serue@us.ibm.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 11:55 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
>> The seq_file iterator for these files relies on them being sorted so
>> that it can pick up where it left off even in the event of the pid set
>> changing between reads - it does a binary search to find the first pid
>> greater than the last one that was returned, so as to guarantee that
>> we return every pid that was in the cgroup before the scan started and
>> remained in the cgroup until after the scan finished; there are no
>> guarantees about pids that enter/leave the cgroup during the scan.
>
> OIC.  Gee we made it hard for ourselves.  That tears it.

Without a guarantee like that, the file becomes much less useful - it
would just be "a random subset of the pids that were in the cgroup at
some time during the read".

>
> Was it a mistake to try to present an ordered, dupes-removed view of a
> large amount of data from the kernel?

The dupe-removal is a red-herring in this argument - that's only added
by this patch, and doesn't affect the existing "tasks" file. I think
we could even change it into a "mostly dupe-removed" view very cheaply
by simply ignoring a tgid when building the array if it's the same as
the previous one we just saw, and leaving userspace to deal with any
remaining dupes.

The ordered semantics of the tasks file comes from cpusets and I
maintained the API (which actually allocated a potentially even larger
array containing the pre-formatted data).

I'd be surprised if removing the ordering constraint broke anything in
userspace, but the more important part about the ordering is to allow
the kernel to present a consistent view in the presence of changing
pids.

Hmm, I guess we could use a combination of the IDR approach that you
suggested and the present shared-array approach:

- when opening a tasks file:
  - populate an IDR with all the pids/tgids in the cgroup
  - find any existing IDR open for the cgroup in the list keyed by
namespace and filetype ("procs"/"tasks")
  - replace (and free) the existing IDR or extend the list with a new one
  - bump the refcount

- when reading:
  - iterate from the last reported pid/tgid

- when closing:
  - drop the refcount, and free the IDR if the count reaches 0

That maintains the property of preventing userspace from consuming
arbitrary amounts of memory just by holding an fd open on a large
cgroup, while also maintaining a consistency guarantee, and we get the
ordering for free as a side-effect of the IDR, with no large memory
allocations. It's not hugely different from the current solution - all
we're doing is replacing the large array in the cgroup_pidlist
structure with an IDR, and populating/reading it appropriately.

The downsides would be a higher fixed cost, I suspect - setting up an
IDR and populating/scanning it sounds like it has to be more expensive
than filling/reading a linear buffer. But it's probably not enough
extra overhead to worry too much about it.

Paul
