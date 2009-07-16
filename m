Return-Path: <linux-kernel-owner+w=401wt.eu-S933596AbZGPX3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933596AbZGPX3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 19:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933573AbZGPX3O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 19:29:14 -0400
Received: from smtp-out.google.com ([216.239.45.13]:40627 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933556AbZGPX3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 19:29:13 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=loZ6p+R/AoxeUMktHXEf7zgmMXROE6BvBGkgC16pC2IlZk3iRdDwLTGIBE15P+c4D
	ldpaIF7ZCwQh6CvSrOGxA==
MIME-Version: 1.0
In-Reply-To: <6599ad830907141815x64e74a6ek1499f6032cea6f5@mail.gmail.com>
References: <200906020557.n525v6KO004302@imap1.linux-foundation.org>
	 <6599ad830907141752n5c701f9ap2a87df0a7f4f6ff3@mail.gmail.com>
	 <20090714210557.0f983c37@bree.surriel.com>
	 <6599ad830907141815x64e74a6ek1499f6032cea6f5@mail.gmail.com>
Date: Thu, 16 Jul 2009 16:29:06 -0700
Message-ID: <6599ad830907161629p54783716p7246e030b8da00fe@mail.gmail.com>
Subject: Re: [PATCH] copy over oom_adj value at fork time
From: Paul Menage <menage@google.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       rientjes@google.com, mel@csn.ul.ie, npiggin@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 6:15 PM, Paul Menage<menage@google.com> wrote:
>
> But ironically, with this fix applied the main part of the original
> change (force all threads in a process to share a single oom_adj
> value) will start to break my code - it's no longer possible to have
> the regular threads in a process be oom-immune, then vfork() and set a
> non-disabled oom_adj in the child, since this will set it for the
> entire process. (Our job scheduler does something like this, in order
> to have the launcher be OOM immune and the running jobs be at various
> oom_adj levels depending on their priority).
>

How about if instead of having the oom_adj be per-mm, we kept an array
of counters in the mm, tracking how many users were at each oom_adj
level; the OOM killer could then use the level of the mm's highest
oom_adj user when deciding how to calculate the badness of a thread
using that mm.

That would preserve the previous semantics of letting a spawned child
inherit a per-thread oom_adj value, while avoiding the specific
problem of the OOM killer getting livelocked (that David's patch
originally addressed) and the more general case of the inconsistency
in determining the oom_adj level of an mm depending on which thread
you look at.

For the very common case where all users of the mm are at the same
oom_adj level, this array could be left unallocated as NULL, and the
thread's own oom_adj used.

Paul
