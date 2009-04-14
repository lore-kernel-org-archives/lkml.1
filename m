Return-Path: <linux-kernel-owner+w=401wt.eu-S1755316AbZDNLqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbZDNLqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 07:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754054AbZDNLqD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 07:46:03 -0400
Received: from an-out-0708.google.com ([209.85.132.247]:17526 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618AbZDNLqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 07:46:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Uj4tSQxbXwG/D+qLl3uGDvMbF1YI3Igl5eu5skkDhi/SxcWVa6ODAiMHlwG+yNQSVQ
         HjGbt/iFb4/H/x+olHRv3no4QdsVr2t27USNklq8Elp4gHYslI1bj7urozHP2GGAU9AY
         zOQWt2QV0pUmZ0bifgSEm7XDLlN0oGEW/3yrM=
Date: Tue, 14 Apr 2009 13:45:54 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, davem@davemloft.net, tglx@linutronix.de,
       sfr@canb.auug.org.au, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/urgent] lockdep: warn about lockdep disabling after
	kernel taint, fix
Message-ID: <20090414114553.GB5994@nowhere>
References: <20090414144317.026498df.sfr@canb.auug.org.au> <tip-27b19565fe4ca5b0e9d2ae98ce4b81ca728bf445@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-27b19565fe4ca5b0e9d2ae98ce4b81ca728bf445@git.kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 09:15:38AM +0000, tip-bot for Ingo Molnar wrote:
> Commit-ID:  27b19565fe4ca5b0e9d2ae98ce4b81ca728bf445
> Gitweb:     http://git.kernel.org/tip/27b19565fe4ca5b0e9d2ae98ce4b81ca728bf445
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Tue, 14 Apr 2009 11:03:12 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Tue, 14 Apr 2009 11:11:52 +0200
> 
> lockdep: warn about lockdep disabling after kernel taint, fix
> 
> Impact: build fix for Sparc and s390
> 
> Stephen Rothwell reported that the Sparc build broke:
> 
>  In file included from kernel/panic.c:12:
>  include/linux/debug_locks.h: In function '__debug_locks_off':
>  include/linux/debug_locks.h:15: error: implicit declaration of function 'xchg'
> 
> due to:
> 
>  9eeba61: lockdep: warn about lockdep disabling after kernel taint
> 
> There is some inconsistency between architectures about where exactly
> xchg() is defined.
> 
> The traditional place is in system.h but the more logical point for it
> is in atomic.h - where most architectures (especially new ones) have
> it defined. These architecture also still offer it via system.h.
> 
> Some, such as Sparc or s390 only have it in asm/system.h and not available
> via asm/atomic.h at all.
> 
> Use the widest set of headers in debug_locks.h and also include asm/system.h.
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> LKML-Reference: <20090414144317.026498df.sfr@canb.auug.org.au>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  include/linux/debug_locks.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/debug_locks.h b/include/linux/debug_locks.h
> index 493dedb..29b3ce3 100644
> --- a/include/linux/debug_locks.h
> +++ b/include/linux/debug_locks.h
> @@ -3,6 +3,7 @@
>  
>  #include <linux/kernel.h>
>  #include <asm/atomic.h>
> +#include <asm/system.h>
>  
>  struct task_struct;
>  



I'm sorry about this build breakage...

I've grep'ed the definitions of xchg() for this pach and indeed remember
that some architectures defined it in asm/atomic.h and
others in asm/system.h

And I've also seen some of them including system.h from
atomic.h so I thought it was safe but.. heh...

