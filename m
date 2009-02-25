Return-Path: <linux-kernel-owner+w=401wt.eu-S1760261AbZBYQaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760261AbZBYQaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Feb 2009 11:30:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755490AbZBYQaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Feb 2009 11:30:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58188 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755278AbZBYQaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Feb 2009 11:30:20 -0500
Date: Wed, 25 Feb 2009 17:29:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Salman Qazi <sqazi@google.com>,
       davem@davemloft.net, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [patch] x86, mm: pass in 'total' to __copy_from_user_*nocache()
Message-ID: <20090225162954.GA22251@elte.hu>
References: <20090224020304.GA4496@google.com> <200902242002.37555.nickpiggin@yahoo.com.au> <alpine.LFD.2.00.0902240744500.3111@localhost.localdomain> <200902251423.58861.nickpiggin@yahoo.com.au> <20090225072503.GD21903@elte.hu> <alpine.LFD.2.00.0902250753030.3111@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902250753030.3111@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> So I do think we should just apply the simple patch. Not make 
> a big deal out of it. We have numbers. We use cached memory 
> copies for everything else. It's always "safe".

ok, 4K is definitely a simple, defensible, calculatable rule.

The only thing that pushes me a bit towards the 'total' tweak is 
that it still is a simple rule and too applies to something the 
user app controls and is intimately familiar with (the total 
size of write()), and it is very cheap to do.

The 64-bit x86 defconfig comparison is:

|
|    text	   data	    bss	    dec	    hex	filename
| 7669425	1138036	 842840	9650301	 93407d	vmlinux.before
| 7669425	1138036	 842840	9650301	 93407d	vmlinux.after
|

md5 shows it's different instructions:

|
|  ec6ba8ae17bdd3ae55062fc59f83fd25  vmlinux.before
|  1f7e9ea67524926cb92b96d5db97f9ff  vmlinux.after
|

i.e. it got almost all of it eliminated at the inlining level, 
and what we have are different but already existing parameters 
being passed in.

There was a single instruction added:

|
|  $ codiff vmlinux.before vmlinux.after
|
|  vmlinux.after:
|   2 functions changed, 6 bytes added, 1 bytes removed, diff: +5
|
|  mm/filemap.c:
|    __iovec_copy_from_user_inatomic |   +6
|    iov_iter_copy_from_user         |   -1
|   2 functions changed, 6 bytes added, 1 bytes removed, diff: +5
|

But hidden in the total size end result by lucky function size 
alignment.

If you are still not convinced i'll remove the two followup 
commits and will keep the first one only.

	Ingo
