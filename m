Return-Path: <linux-kernel-owner+w=401wt.eu-S934320AbZGQJeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934320AbZGQJeT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 05:34:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934303AbZGQJeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 05:34:18 -0400
Received: from smtp-out.google.com ([216.239.45.13]:39319 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934302AbZGQJeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 05:34:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=DPhGY77hYHo2Mwit4Txw/xsqfES2oFlQUmxOuWhoIV+w/78BP7wVnTavCEdjujT2i
	uQXrs1tEZUbBfwfgYF3cw==
Date: Fri, 17 Jul 2009 02:34:09 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Paul Menage <menage@google.com>
cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mel@csn.ul.ie, npiggin@suse.de
Subject: Re: [PATCH] copy over oom_adj value at fork time
In-Reply-To: <6599ad830907161629p54783716p7246e030b8da00fe@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.0907170225570.15373@chino.kir.corp.google.com>
References: <200906020557.n525v6KO004302@imap1.linux-foundation.org> <6599ad830907141752n5c701f9ap2a87df0a7f4f6ff3@mail.gmail.com> <20090714210557.0f983c37@bree.surriel.com> <6599ad830907141815x64e74a6ek1499f6032cea6f5@mail.gmail.com>
 <6599ad830907161629p54783716p7246e030b8da00fe@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Jul 2009, Paul Menage wrote:

> How about if instead of having the oom_adj be per-mm, we kept an array
> of counters in the mm, tracking how many users were at each oom_adj
> level; the OOM killer could then use the level of the mm's highest
> oom_adj user when deciding how to calculate the badness of a thread
> using that mm.
> 

That would lead to the same inconsistencies that we had before: consider 
two tasks sharing the same mm_struct, taskA and taskB.  It was previously 
possible for taskA to have an oom_adj value of -15 and taskB to have an 
oom_adj value of +15.  This would cause /proc/pid/oom_score to be very 
small for taskA and oom_score would be very large for taskB.  With your 
proposal, taskB's badness score would implicitly be very small, yet it is 
reported to userspace as very high.

The only way to workaround that is by using the highest oom_adj user for 
the mm_struct from the array in reporting /proc/pid/oom_score, as well.  
But that would lead to /proc/pid/oom_adj not affecting oom_score at all, 
which isn't consistent.

I think you'll find that having oom_adj values purely be an attribute of 
the memory it represents is the cleanest solution since it most accurately 
describes how the oom killer interprets it when deciding on which task to 
kill.

> That would preserve the previous semantics of letting a spawned child
> inherit a per-thread oom_adj value, while avoiding the specific
> problem of the OOM killer getting livelocked (that David's patch
> originally addressed) and the more general case of the inconsistency
> in determining the oom_adj level of an mm depending on which thread
> you look at.
> 

Right, it's still a little strange that changing /proc/pid/oom_adj for one 
thread will change it for another if they share memory, even if they are 
in different thread groups, but that shouldn't happen if the admin 
understands that the oom killer must kill _all_ threads sharing memory 
with the target to lead to future memory freeing.

The inheritance issue should be fixed with Rik's patch with the exception 
of vfork -> change /proc/pid-of-child/oom_adj -> execve.  If scripts were 
written to do that with the old behavior, they'll have to adjust to change 
oom_adj _after_ the execve to avoid changing the oom_adj value of the 
vfork parent.  If there is no execve, or we're just doing CLONE_VM, then 
the child shares memory with the parent and, thus, their oom_adj values 
will be the same.
