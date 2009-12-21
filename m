Return-Path: <linux-kernel-owner+w=401wt.eu-S1756666AbZLUMC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756666AbZLUMC2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 07:02:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752593AbZLUMC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 07:02:27 -0500
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:35513 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752087AbZLUMC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 07:02:27 -0500
Date: Mon, 21 Dec 2009 13:02:24 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: kprobes: get rid of distinct type warning
Message-ID: <20091221120224.GA4471@osiris.boeblingen.de.ibm.com>
References: <20091221101549.GA3850@osiris.boeblingen.de.ibm.com>
 <20091221111759.GA12670@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091221111759.GA12670@in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 21, 2009 at 04:47:59PM +0530, Ananth N Mavinakayanahalli wrote:
> On Mon, Dec 21, 2009 at 11:15:49AM +0100, Heiko Carstens wrote:
> > From: Heiko Carstens <heiko.carstens@de.ibm.com>
> > 
> > Every time I see this:
> > 
> > kernel/kprobes.c: In function 'register_kretprobe':
> > kernel/kprobes.c:1038: warning: comparison of distinct pointer types lacks a cast
> > 
> > I'm wondering if something changed in common code and we need to do
> > something for s390. Apparently that's not the case.
> > Let's get rid of this annoying warning.
> > 
> > Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> 
> Thanks Heiko. I'd tested this on x86 and powerpc and neither throws the
> warning. No wonder I missed it.

Of course the patch wouldn't help for CONFIG_PREEMPT and !CONFIG_SMP since
we would have a comparison of a signed and and unsigned value again *sigh*.

So here's an updated version that should always work:

Subject: [PATCH] kprobes: get rid of distinct type warning

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Every time I see this:

kernel/kprobes.c: In function 'register_kretprobe':
kernel/kprobes.c:1038: warning: comparison of distinct pointer types lacks a cast

I'm wondering if something changed in common code and we need to do
something for s390. Apparently that's not the case.
Let's get rid of this annoying warning.

Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/kprobes.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -1035,7 +1035,7 @@ int __kprobes register_kretprobe(struct 
 	/* Pre-allocate memory for max kretprobe instances */
 	if (rp->maxactive <= 0) {
 #ifdef CONFIG_PREEMPT
-		rp->maxactive = max(10, 2 * num_possible_cpus());
+		rp->maxactive = max_t(unsigned int, 10, 2*num_possible_cpus());
 #else
 		rp->maxactive = num_possible_cpus();
 #endif
