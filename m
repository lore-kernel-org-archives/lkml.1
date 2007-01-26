Return-Path: <linux-kernel-owner+w=401wt.eu-S1161046AbXAZQ5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161046AbXAZQ5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 11:57:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030913AbXAZQ5c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 11:57:32 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:49339 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030918AbXAZQ5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 11:57:17 -0500
Date: Fri, 26 Jan 2007 11:57:12 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       linux-mips@linux-mips.org
Subject: Re: [PATCH 05/10] local_t : mips extension
Message-ID: <20070126165712.GA21098@Krystal>
References: <1169741777507-git-send-email-mathieu.desnoyers@polymtl.ca> <1169741780423-git-send-email-mathieu.desnoyers@polymtl.ca> <20070126120437.GA18778@linux-mips.org> <20070126163623.GB26138@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070126163623.GB26138@Krystal>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.32-grsec (i686)
X-Uptime: 11:53:59 up 156 days, 14:01,  5 users,  load average: 5.09, 2.48, 1.53
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@polymtl.ca) wrote:
> > What I generally dislike about this patch is that several fairly large
> > functions have been duplicated with only little change.
> > 
> 
> Yeah, I know. Until we find some way to share atomic operation code for
> both operation on local and shared data, we have to duplicate this. We
> could think about a header that would support multiple inclusion and
> behave differently (different function prefix and LOCKing/memory
> barriers) depending on defines set by the top level header.
> 
> Something like
> 
> asm/atomic.h
>   #define ATOMIC_SHARED
>   #include <asm/atomic-ops.h>  /* shared */
>   #undef ATOMIC_SHARED
>   #include <asm/atomic-ops.h>  /* local */
> 
> asm/atomic-ops.h 
>   #ifdef ATOMIC_SHARED
>   #define ATOMIC_PREFIX atomic
>   #define ATOMIC_BARRIER() smp_mb()
>   #define ATOMIC_TYPE atomic_t
>   #define ATOMIC_VAR (v->counter)
>   #else
>   #define ATOMIC_PREFIX local
>   #define ATOMIC_BARRIER()
>   #define ATOMIC_TYPE local_t
>   #define ATOMIC_VAR (v->a.counter)
>   #endif
>   
>   static __inline__ ATOMIC_PREFIX##_add_return(int i, ATOMIC_TYPE *v)
>   .....
>   #undef ATOMIC_PREFIX
>   #undef ATOMIC_BARRIER
>   #undef ATOMIC_TYPE
>   #undef ATOMIC_VAR
> 

More prefisely, for this to work, we should change :
#define ATOMIC_PREFIX atomic
and
#define ATOMIC_PREFIX local
for

#define ATOMICF(fctname) atomic_##fctname
and
#define ATOMICF(fctname) local_##fctname


which would make de declaration look like :

static __inline__ ATOMICF(add_return)(int i, ATOMIC_TYPE *v)

Which starts to look a little odd to me, doesn't it ?

Regards,

Mathieu

-- 
OpenPGP public key:              http://krystal.dyndns.org:8080/key/compudj.gpg
Key fingerprint:     8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68 
