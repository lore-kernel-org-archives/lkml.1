Return-Path: <linux-kernel-owner+w=401wt.eu-S1759034AbZCYLzS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034AbZCYLzS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:55:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752238AbZCYLzB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:55:01 -0400
Received: from hera.kernel.org ([140.211.167.34]:36719 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752074AbZCYLzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:55:01 -0400
Message-ID: <49CA1AC3.9080908@kernel.org>
Date: Wed, 25 Mar 2009 20:51:31 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
CC: mingo@elte.hu, rusty@rustcorp.com.au, tglx@linutronix.de, x86@kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com,
       Paul Mundt <lethal@linux-sh.org>, rmk@arm.linux.org.uk,
       starvik@axis.com, ralf@linux-mips.org, davem@davemloft.net,
       cooloney@kernel.org, kyle@mcmartin.ca, matthew@wil.cx,
       grundler@parisc-linux.org, takata@linux-m32r.org,
       benh@kernel.crashing.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
       heiko.carstens@de.ibm.com
Subject: Re: [GIT RFC] percpu: use dynamic percpu allocator as the default
 percpu allocator
References: <1236671631-9305-1-git-send-email-tj@kernel.org> <20090316190132.7965a49a@skybase> <49C300D8.5080204@kernel.org> <49C8FAC4.6060508@kernel.org> <20090325122738.42d105b7@skybase>
In-Reply-To: <20090325122738.42d105b7@skybase>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 25 Mar 2009 11:51:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Martin.

Martin Schwidefsky wrote:
>>>> With the dynamic percpu allocator there is no need anymore to play
>>>> tricks with the GOTENT relocation for the access to the percpu
>>>> symbols. A simple RELOC_HIDE gets the job done.
>>> Hmm... I don't quite get it.  The GOTENT was to work around large
>>> offsets for modules, right?  Can you please explain what changed by
>>> the dynamic percpu allocator?
> 
> Unfortunately it didn't change. The problem is still there, only with
> my particular configuration (and the correct patch) the system did
> work because the problematic modules were not in use. But in general it
> won't work.
> 
> The reason for the GOTENT indirection are static per-cpu variables that
> are defined inside a module. The compiler considers these to be local.
> For locally defined per_cpu__#var symbols the compiler uses an
> instruction that is limited to the scope of a single object, which is
> +-4 GB. The trick with GOTENT introduced an indirection which hid the
> problem.
> 
> Without the GOTENT indirection the access to a static per cpu variable
> will look like this:
> 
> 0000000000000000 <test_fn>:
>    0:   e3 30 03 30 00 04       lg      %r3,816
>    6:   c0 10 00 00 00 00       larl    %r1,6 <test_fn+0x6>
>                         8: R_390_PC32DBL        .data.percpu+0x2
>    c:   e3 23 10 00 00 04       lg      %r2,0(%r3,%r1)
> 
> The R_390_PC32DBL relocation in the module relocation will fail if the
> per-cpu area is farther than 4GB away from the vmalloc area.

Okay, up to this point, I understand, so nothing really changed for
symbols (core or modules) by the dynamic percpu allocator and they
still need GOTENT, right?

> With your patches and a RELOC_HIDE version that uses the GOTENT
> indirection the kernel won't compile because the "X" constraint for
> the GOTENT access needs a symbol and there are quite a few users that
> pass a pointer. I do not see a simple solution for that problem yet.

Ah... okay.  Now I get it.  It wasn't expecting variables there.  How
about doing the following?

 #define SHIFT_PERCPU_PTR(ptr, offset) (({				\
	 if (__builtin_constant_p(ptr))					\
		 do GOTENT trick;					\
	 else								\
		 RELOC_HIDE();						\
 }))

Thanks.

-- 
tejun
