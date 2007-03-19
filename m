Return-Path: <linux-kernel-owner+w=401wt.eu-S933832AbXCSN1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933832AbXCSN1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 09:27:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933886AbXCSN1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 09:27:24 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:15293 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933832AbXCSN1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 09:27:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gEamCY+OgKcdNOG/yrPB0FLN0VIHylse0puS+IEwPvnAXF+c6ZNRIok68lzJ2M2SXoRwHiB9O/kxNRLPG+zbMhm+oeVbvoen5wHFia/E1rqMN22Z/u+fvgAo3UE7RcrXyWO6gifJEKkTJCtV/oRXOJ2KhgrCDqIMUtfklB4HyH4=
Message-ID: <f44c5fdf0703190627x43427f26qaed948aed71847ad@mail.gmail.com>
Date: Mon, 19 Mar 2007 14:27:21 +0100
From: "Radoslaw Szkodzinski" <astralstorm@gmail.com>
To: davids@webmaster.com
Subject: Re: is RSDL an "unfair" scheduler too?
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKGEMBCFAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <45FCD449.60303@argo.co.il>
	 <MDEHLPKNGKAHNMBLJOLKGEMBCFAC.davids@webmaster.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/19/07, David Schwartz <davids@webmaster.com> wrote:
>
> > I didn't suggest adding any unfairness!  I suggested being fair by
> > user/job/process instead of being fair by thread (which is actually
> > unfair as it favors multi threaded processes over single threaded
> > processes).
>
> Wouldn't that be unfair because it favors multi-user approaches over
> single-user approaches with the same number of processes?

Not necessarily. Use GID rotations too.
And if you can't assign these properly, it's your own/your distro's fault.

> Consider two otherwise equivalent web server designs. They both use a helper
> process owned by the user who owns the file the web server is sending. One
> does a lot of work in the helper process, the other does very little. A
> "fair by user" scheduler would give the approach that puts more work in the
> helper process more CPU than the one that puts little work in the helper
> process.

Indeed, it's a drawback. Though a configurable one.

> Being fair by user builds lots of assumptions into the scheduler. When
> they're not true, the scheduler becomes sub-optimal. For example, consider a
> web server that runs two very important tools, 'foo' and 'bar'. Rather than
> running them as root, they run as users 'foo' and 'bar' for security. "Fair
> to user" would mean that just because most other people are using 'foo', I
> get less CPU when I try to use 'foo', because the OS doesn't know the "real
> user", just the fake user who owns the process -- a security decision that
> has no relationship to fairness. This would be handled perfectly by a "fair
> to process" approach.

Then, use a group quota. But checking that will be slower, and that
overhead might kill other gains.

> As for favoring multi-threaded processes over single-threaded processes,
> sometimes that's what you want.

Not on desktop.

Typical multi-threaded workloads:
- apache
- some P2P clients
- some audio servers/applications (small number of threads)

Single-threaded is much more popular.

> Consider two servers,
^ ^ ^

Well, aren't we discussing desktops?
Server admins can fine-tune the rights and CPU quotas per group.

> one using thread per
> job the other using process per job. Does it make sense to give the "process
> per job" server as much CPU to do a single task as the "thread per job"
> server gets for all the clients it's dealing with?

Not necessarily. You see, the processes themselves are schedulable,
the threads aren't.

>
> It's really more important that the scheduler be tunable and predictable.

This kind of scheduler, yes. Except it's much more tunable than a
simple fair or unfair scheduler, and much more suited to real-time
applications.

> That way, we can tell it what we want and get it. But the scheduler cannot
> read our minds.

That's why the per-user or per-group part would have to be optional.
It just doesn't make much sense on single-user desktops.
Then, RSDL design or even RSDL+bonus could be used.

The bonus part would have to be really simple, e.g. priority
inheritance for pipes, startup priority boost for nice 0 tasks.
(warning - fork bombs. :P )
No sleep estimator. Maybe these would suffice?

The interactive bonus would be disabled by default, same as
per-user/per-group scheduling.

Some syscalls would have to be added, maybe using LSM framework?
