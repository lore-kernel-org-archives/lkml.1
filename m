Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709Ab0BQQkE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 11:40:04 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:60482 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752468Ab0BQQkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 11:40:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=rvVixNwo9e+NuoI25X3bXjMgHqfnYGIRJEWCGv1WHUJkKWz/xdZfV9c/LifJjpWz9U
         Bgp3q4AD69upT3cfg/LybP7yMp04dn3OU13GMkaiegvfCYu8rZkxMEzmd97kFgSqhj4O
         Vw+oJeYFSR866dQwPhOceJyZGv+IBbJlrk7vM=
Date: Wed, 17 Feb 2010 17:39:49 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH hw_breakpoint] percpu: add __percpu sparse annotations
	to hw_breakpoint
Message-ID: <20100217163944.GC5041@nowhere>
References: <4B7B4B7A.9050902@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B7B4B7A.9050902@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 17, 2010 at 10:50:50AM +0900, Tejun Heo wrote:
> Add __percpu sparse annotations to hw_breakpoint.
> 
> These annotations are to make sparse consider percpu variables to be
> in a different address space and warn if accessed without going
> through percpu accessors.  This patch doesn't affect normal builds.
> 
> In kernel/hw_breakpoint.c, per_cpu(nr_task_bp_pinned, cpu)'s will
> trigger sprious noderef related warnings from sparse.  Changing it to
> &per_cpu(nr_task_bp_pinned[0], cpu) will work around the problem but
> deemed to ugly by the maintainer.  Leave it alone until better
> solution can be found.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> ---
> Frederic, can you please put this into the tree for hw_breakpoint?
> 
> Thanks.


Yeah, looks good, I'm queuing it.
Just few comments below, for nano-considerations.



>  	cpu_events = alloc_percpu(typeof(*cpu_events));
>  	if (!cpu_events)
> -		return ERR_PTR(-ENOMEM);
> +		return (void __percpu __force *)ERR_PTR(-ENOMEM);



Is this pattern common enough that we can think about a ERR_CPU_PTR ?




>  	sample_hbp = register_wide_hw_breakpoint(&attr, sample_hbp_handler);
> -	if (IS_ERR(sample_hbp)) {
> -		ret = PTR_ERR(sample_hbp);
> +	if (IS_ERR((void __force *)sample_hbp)) {
> +		ret = PTR_ERR((void __force *)sample_hbp);


Same comments here, although I wouldn't like much a CPU_PTR_ERR or
IS_ERR_CPU.... CPP is just so poor in magic for that.

I must confess I miss a bit the old per_cpu prefix that guarded the implicit
separate namespace.

Anyway, I'm queuing it, thanks.

