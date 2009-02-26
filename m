Return-Path: <linux-kernel-owner+w=401wt.eu-S1757148AbZBZDSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148AbZBZDSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 22:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbZBZDSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 22:18:05 -0500
Received: from hera.kernel.org ([140.211.167.34]:45519 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbZBZDSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 22:18:03 -0500
Message-ID: <49A609E0.5040807@kernel.org>
Date: Thu, 26 Feb 2009 12:17:52 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>, "jeremy@goop.org" <jeremy@goop.org>,
       "cpw@sgi.com" <cpw@sgi.com>, "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH 09/10] percpu: implement new dynamic percpu allocator
References: <1234958676-27618-1-git-send-email-tj@kernel.org> <200902192221.52835.rusty@rustcorp.com.au> <499E1D01.2040408@kernel.org> <200902241326.23605.rusty@rustcorp.com.au> <49A389F7.9030002@kernel.org> <57C9024A16AD2D4C97DC78E552063EA361924956@orsmsx505.amr.corp.intel.com>
In-Reply-To: <57C9024A16AD2D4C97DC78E552063EA361924956@orsmsx505.amr.corp.intel.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 26 Feb 2009 03:17:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Luck, Tony wrote:
> ia64 started out with a pinned TLB entry to map the percpu space to the
> top 64K of address space (so that the compiler can generate ld/st instructions
> with a small negative offset from register r0 to access local-to-this-cpu
> objects).
> 
> Then we started using a one of the ar.k* registers to hold the base
> physical address for each cpus per-cpu area so that early parts of
> machine check code (which runs with MMU off) can access per-cpu variables.
> 
> Finally we found that certain transaction processing benchmarks ran faster
> if we let the cpu have free access to one extra TLB entry ... so we
> stopped pinning the per-cpu area, and wrote a s/w fault handler to
> insert the mapping on demand (using the ar.k3 register to get the
> physical address for the mapping).
> 
> N.B. ar.k3 is a medium-slow register ... I wouldn't want to use it
> in the code sequence for *every* per-cpu variable access.

Ah... I see, so the 64k limit for small offset.  I think what we can
do is using the first chunk for static percpu variables.  We'll still
be able to use the same accessor by doing something like...

#define unified_percpu_accessor(ptr) ({ \
	if (__builtin_constant_p(ptr)) \
		return r0 - unit_size + ptr; \
	else \
		do ar.k3 + ptr; \
	})

So, dynamic ones will be slower than normal ones but faster than what
we currently have (it will be faster than indirect pointer
derferencing, right?) while keeping static accesses fast.  Does it
sound okay to you?  Also, does anyone know whether there's a working
ia64 emulator?  There doesn't seem to be any and it seems almost
impossible to get hold of an actual ia64 machine over here.  :-(

Thanks.

-- 
tejun
