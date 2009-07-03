Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbZGCEQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbZGCEQ0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 00:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751778AbZGCEQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 00:16:17 -0400
Received: from smtp-out.google.com ([216.239.33.17]:13431 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbZGCEQR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 00:16:17 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=Y27TQpnLiTdHZWBcKz8MlkPD+d1wLP1Z8D8jNbCp7b9b8xDsc6VNKMfZGT9leu0y1
	+MatP6nHkjbbg3+CyRBYA==
MIME-Version: 1.0
In-Reply-To: <20090702190845.0cafc46a.akpm@linux-foundation.org>
References: <20090702231814.3969.44308.stgit@menage.mtv.corp.google.com>
	 <20090702232620.3969.16680.stgit@menage.mtv.corp.google.com>
	 <20090702164649.303c4952.akpm@linux-foundation.org>
	 <2f86c2480907021731h13e0bb95q94f06829eded9aa6@mail.gmail.com>
	 <20090702175341.fd2e26d5.akpm@linux-foundation.org>
	 <6599ad830907021808o6f3bb51eh324e4bf13544d83e@mail.gmail.com>
	 <2f86c2480907021817o79fce75yd9785aab682f7bb4@mail.gmail.com>
	 <20090702190845.0cafc46a.akpm@linux-foundation.org>
Date: Thu, 2 Jul 2009 21:16:15 -0700
Message-ID: <6599ad830907022116n7a711c7fs52ff9b400ec8797f@mail.gmail.com>
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

On Thu, Jul 2, 2009 at 7:08 PM, Andrew Morton<akpm@linux-foundation.org> wrote:
>
> Why are we doing all this anyway?  To avoid presenting duplicated pids
> to userspace?  Nothing else?

To present the pids or tgids in sorted order. Removing duplicates is
only for the case of the "procs" file; that could certainly be left to
userspace, but it wouldn't by itself remove the existing requirement
for a contiguous array.

The seq_file iterator for these files relies on them being sorted so
that it can pick up where it left off even in the event of the pid set
changing between reads - it does a binary search to find the first pid
greater than the last one that was returned, so as to guarantee that
we return every pid that was in the cgroup before the scan started and
remained in the cgroup until after the scan finished; there are no
guarantees about pids that enter/leave the cgroup during the scan.

> Or we can do it the other way?  Create an initially-empty local IDR
> tree or radix tree and, within that, mark off any pids which we've
> already emitted?  That'll have a worst-case memory consumption of
> approximately PID_MAX_LIMIT bits -- presently that's half a megabyte.
> With no large allocations needed?
>

But that would be half a megabyte per open fd? That's a lot of memory
that userspace can pin down by opening fds. The reason for the current
pid array approach is to mean that there's only ever one pid array
allocated at a time per cgroup, rather than per open fd.

There's actually a structure already for doing that - cgroup_scanner,
which uses a high-watermark and a priority heap to provide a similar
guarantee, with a constant memory size overhead (typically one page).
But it can take O(n^2) time to scan a large cgroup, as would, I
suspect, using an IDR, so it's only used for cases where we really
can't avoid it due to locking reasons. I'd rather have something that
accumulates unsorted pids in page-size chunks as we iterate through
the cgroup, and then sorts them using something like Lai Jiangshan's
patch did.

>
> btw, did pidlist_uniq() actually needs to allocate new memory for the
> output array?  Could it have done the filtering in-place?

Yes - or just omit duplicates in the seq_file iterator, I guess

Paul
