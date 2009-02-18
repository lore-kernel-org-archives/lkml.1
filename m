Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbZBRKxB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbZBRKxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 05:53:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751832AbZBRKww
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 05:52:52 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:43518 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbZBRKwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 05:52:51 -0500
Subject: Re: [PATCH 2/3] generic-ipi: remove kmalloc()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Jens Axboe <jens.axboe@oracle.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>
In-Reply-To: <200902181601.06738.rusty@rustcorp.com.au>
References: <20090217215904.059250145@chello.nl>
	 <20090217220053.500765201@chello.nl>
	 <200902181601.06738.rusty@rustcorp.com.au>
Content-Type: text/plain
Date: Wed, 18 Feb 2009 11:52:29 +0100
Message-Id: <1234954349.4637.59.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-02-18 at 16:01 +1030, Rusty Russell wrote:
> On Wednesday 18 February 2009 08:29:06 Peter Zijlstra wrote:
> > Remove the use of kmalloc() from the smp_call_function_*() calls.
> 
> This patch is actually quite nice.  Not sure it's correct, but it's neat :)

:-)

> One minor quibble:
> 
> > +			data = &per_cpu(csd_data, me);
> 
> "data = &__get_cpu_var(csd_data);" is slightly preferred.  A few less cycles.

Thanks, next version will include the below.

Index: linux-2.6/kernel/smp.c
===================================================================
--- linux-2.6.orig/kernel/smp.c
+++ linux-2.6/kernel/smp.c
@@ -325,7 +325,7 @@ int smp_call_function_single(int cpu, vo
 			 * will make sure the callee is done with the
 			 * data before a new caller will use it.
 			 */
-			data = &per_cpu(csd_data, me);
+			data = &__get_cpu_var(csd_data);
 			csd_lock(data);
 		} else {
 			data = &d;
@@ -413,7 +413,7 @@ void smp_call_function_many(const struct
 		return;
 	}
 
-	data = &per_cpu(cfd_data, me);
+	data = &__get_cpu_var(cfd_data);
 	csd_lock(&data->csd);
 
 	spin_lock_irqsave(&data->lock, flags);


