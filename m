Return-Path: <linux-kernel-owner+w=401wt.eu-S1757639AbZBLBT1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbZBLBT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 20:19:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756236AbZBLBTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 20:19:15 -0500
Received: from smtp-out.google.com ([216.239.45.13]:50240 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756205AbZBLBTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 20:19:14 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=FRt47C11jGJLRcoln5iowCGJl1b8JQInqhAisCv0O42mFzshb/uFnnRca5OOQ3Bgk
	odkg747nfPUWwT16HFv7g==
MIME-Version: 1.0
In-Reply-To: <200902121154.02868.nickpiggin@yahoo.com.au>
References: <4976D77C.3020107@cn.fujitsu.com>
	 <200902091502.27056.nickpiggin@yahoo.com.au>
	 <6599ad830902100337mbde885fr89e5942f1016a1c@mail.gmail.com>
	 <200902121154.02868.nickpiggin@yahoo.com.au>
Date: Wed, 11 Feb 2009 17:19:11 -0800
Message-ID: <6599ad830902111719n2750ac29u458face30bf3f7cb@mail.gmail.com>
Subject: Re: [PATCH] cpuset: fix allocating page cache/slab object on the 
	unallowed node when memory spread is set
From: Paul Menage <menage@google.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>, Paul Jackson <pj@sgi.com>
Cc: miaox@cn.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
       mingo@elte.hu, linux-kernel@vger.kernel.org, cl@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 11, 2009 at 4:54 PM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
>
> It would be possible, depending on timing, for the allocating thread to
> see either pre or post mems_allowed even if access was fully locked.

Right - seeing either the pre set or the post set is fine.

>
> The only difference is that a partially changed mems_allowed could be
> seen. But what does this really mean? Some combination of the new and
> the old nodes. I don't think this is too much of a problem.

But if the old and new nodes are disjoint, that could lead to seeing no nodes.

Also, having the results of cpuset_zone_allowed() and
cpuset_current_mems_allowed change at random times over the course of
a call to alloc_pages() might cause interesting effects (e.g. we make
progress freeing pages from one set of nodes, and then call
get_page_from_freelist() on a different set of nodes).

>
> This could work if we *really* need an atomic snapshot of mems_allowed.
> seqcount synchronisation would be an alternative too that could allow
> sleeping more easily than SRCU (OTOH if you don't need sleeping, then
> RCU should be faster than seqcount).
>
> But I'm not convinced we do need this to be atomic.

It's possible that I'm being overly-paranoid here. The decision to
make mems_allowed updates be purely pulled by the task itself predates
my involvement with cpusets code by a long time. Paul Jackson (CC'd)
may have opinions here, but I suspect his sgi.com email address no
longer works, and I don't have any more recent address for him.

Paul
