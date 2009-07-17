Return-Path: <linux-kernel-owner+w=401wt.eu-S1752849AbZGQUEE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbZGQUEE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 16:04:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752648AbZGQUEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 16:04:04 -0400
Received: from smtp-out.google.com ([216.239.45.13]:59967 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbZGQUED convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 16:04:03 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=cpkQGjY39hEZj5pls+nRHuxqX5pZ6+Q0sPGtvkBJo0M4cKyTuZhJeOC+3o4Y33oB2
	asaXTNkvkdUhskZabCr0A==
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.0907170225570.15373@chino.kir.corp.google.com>
References: <200906020557.n525v6KO004302@imap1.linux-foundation.org>
	 <6599ad830907141752n5c701f9ap2a87df0a7f4f6ff3@mail.gmail.com>
	 <20090714210557.0f983c37@bree.surriel.com>
	 <6599ad830907141815x64e74a6ek1499f6032cea6f5@mail.gmail.com>
	 <6599ad830907161629p54783716p7246e030b8da00fe@mail.gmail.com>
	 <alpine.DEB.2.00.0907170225570.15373@chino.kir.corp.google.com>
Date: Fri, 17 Jul 2009 13:03:56 -0700
Message-ID: <6599ad830907171303v255a0d65t64885d37c41b764a@mail.gmail.com>
Subject: Re: [PATCH] copy over oom_adj value at fork time
From: Paul Menage <menage@google.com>
To: David Rientjes <rientjes@google.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mel@csn.ul.ie, npiggin@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 17, 2009 at 2:34 AM, David Rientjes<rientjes@google.com> wrote:
>
> The only way to workaround that is by using the highest oom_adj user for
> the mm_struct from the array in reporting /proc/pid/oom_score, as well.

That sounds fine to me.

> But that would lead to /proc/pid/oom_adj not affecting oom_score at all,
> which isn't consistent.

Isn't consistent with what? It's perfectly consistent with saying "the
oom_score of a task is based on the highest oom_adj value of any task
sharing the same mm". Admittedly it's not 100% consistent with the old
semantics, but I'm having trouble imagining a scenario where someone
was relying on the changed semantics.

But taking a completely different approach, is there a reason that we
couldn't have just moved the do_each_thread() check for OOM_DISABLED
out of oom_kill_task() and into select_bad_process() at the point
where we've decided that the thread in question is a better victim
than the current victim? That would fix the OOM livelock while
allowing us to keep exactly the same oom_adj/oom_score semantics as in
previous kernels.

> The inheritance issue should be fixed with Rik's patch with the exception
> of vfork -> change /proc/pid-of-child/oom_adj -> execve.  If scripts were
> written to do that with the old behavior, they'll have to adjust to change
> oom_adj _after_ the execve

Think about what you're suggesting here - execve() replaces your code
with whatever you're execing, so unless that code is also written to
handle oom_adj (which for something like a generic job scheduler, the
exec'd code is unlikely to do) you're stuck.

Paul
