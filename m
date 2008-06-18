Return-Path: <linux-kernel-owner+w=401wt.eu-S1755216AbYFRMyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216AbYFRMyX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 08:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbYFRMyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 08:54:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:34235 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752265AbYFRMyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 08:54:15 -0400
Date: Wed, 18 Jun 2008 14:53:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH] SGI UV: TLB shootdown using broadcast assist unit
Message-ID: <20080618125353.GB20056@elte.hu>
References: <E1K6t40-0000UB-GC@eag09.americas.sgi.com> <20080618122931.GB12763@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080618122931.GB12763@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Cliff Wickman <cpw@sgi.com> wrote:
> 
> > From: Cliff Wickman <cpw@sgi.com>
> > 
> > TLB shootdown for SGI UV. 
> > 
> > This patch brings v1 up to v5.
> 
> applied to tip/x86/uv, thanks Cliff.
> 
> Note that i've done a few minor cleanups as well in that branch (see the 
> patch below). The code could still be improved.
> 
> Found a potential security hole while doing that:
> 
> static ssize_t uv_ptc_proc_write(struct file *file, const char __user *user,
>                                  size_t count, loff_t *data)
> {
>         long newmode;
>         char optstr[64];
> 
>         if (copy_from_user(optstr, user, count))
>                 return -EFAULT;
> 
> is count guaranteed to never be larger than 64?

another problem was that it wasnt build-tested, see the fix below.

	Ingo

-------------->
commit fa3ee1e0c85be26f6e1ba62cd66d62b305d45efd
Author: Ingo Molnar <mingo@elte.hu>
Date:   Wed Jun 18 14:51:57 2008 +0200

    SGI UV: TLB shootdown using broadcast assist unit, fix
    
    fix:
    
    arch/x86/kernel/tlb_uv.c: In function ‘uv_table_bases_init':
    arch/x86/kernel/tlb_uv.c:612: error: ‘bau_tabsp' undeclared (first use in this function)
    arch/x86/kernel/tlb_uv.c:612: error: (Each undeclared identifier is reported only once
    arch/x86/kernel/tlb_uv.c:612: error: for each function it appears in.)
    
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/kernel/tlb_uv.c b/arch/x86/kernel/tlb_uv.c
index 7bdbf67..b362913 100644
--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -609,7 +609,7 @@ static struct bau_control * __init uv_table_bases_init(int blade, int node)
 
 	uv_bau_table_bases[blade] = bau_tabp;
 
-	return bau_tabsp;
+	return bau_tabp;
 }
 
 /*
