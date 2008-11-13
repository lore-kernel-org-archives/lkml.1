Return-Path: <linux-kernel-owner+w=401wt.eu-S1755604AbYKMVi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604AbYKMVi2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 16:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755137AbYKMViK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 16:38:10 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:37223 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754907AbYKMViI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 16:38:08 -0500
Date: Thu, 13 Nov 2008 22:37:44 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andi Kleen <andi@firstfloor.org>, Robert Richter <robert.richter@amd.com>,
       oprofile-list@lists.sf.net, Jiri Benc <jbenc@suse.cz>,
       Vilem Marsik <vmarsik@suse.cz>, Eric Dumazet <dada1@cosmosbay.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: Oprofile [still] doesn't work on 2.6.28-rc4 on certain CPU
Message-ID: <20081113213744.GA8429@elte.hu>
References: <alpine.LNX.1.10.0811132147030.19853@jikos.suse.cz> <20081113212446.GA5694@elte.hu> <alpine.LNX.1.10.0811132226140.19853@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0811132226140.19853@jikos.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Kosina <jkosina@suse.cz> wrote:

> On Thu, 13 Nov 2008, Ingo Molnar wrote:
> 
> > > I haven't yet found a time to start bisecting this.
> > Would be nice to identify a commit to revert - in case we run out of 
> > time fixing it.
> 
> Yup, I first wanted to make this known to the public in hope that it 
> will ring a bell somewhere.
> 
> If noone sees an obvous reason for this, I will do my best to bisect 
> this tomorrow.

We've got the one patch below pending, but that's not for AMD cpus so 
it shouldnt impact your case.

But ... some change made it all much more fragile. I'm curious why 
things became more fragile.

	Ingo

--------------->
Subject: oprofile: un-mask APIC before resetting counter in ppro_check_ctrs()
From: Eric Dumazet <dada1@cosmosbay.com>
Date: Tue, 11 Nov 2008 09:32:12 +0100

While using oprofile on my HP BL460c G1, (two quad core intel E5450 CPU),
I noticed that one CPU after the other could not get anymore NMI.

After a while, all cores where blocked (ie not generating events for oprofile)
I tried all major linux versions and all where affected by this freeze.

I found that we have to un-mask APIC *before* writing to MSR counter
when we get event notification, because we use APIC_LVTPC in edge triggered mode.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/oprofile/op_model_ppro.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: tip/arch/x86/oprofile/op_model_ppro.c
===================================================================
--- tip.orig/arch/x86/oprofile/op_model_ppro.c
+++ tip/arch/x86/oprofile/op_model_ppro.c
@@ -126,6 +126,12 @@ static int ppro_check_ctrs(struct pt_reg
 	u64 val;
 	int i;
 
+	/*
+	 * We need to unmask the apic vector *before* writing reset_value
+	 * to msr counter, because we use edge trigger
+	 */
+	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
+
 	for (i = 0 ; i < num_counters; ++i) {
 		if (!reset_value[i])
 			continue;
@@ -136,10 +142,6 @@ static int ppro_check_ctrs(struct pt_reg
 		}
 	}
 
-	/* Only P6 based Pentium M need to re-unmask the apic vector but it
-	 * doesn't hurt other P6 variant */
-	apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
-
 	/* We can't work out if we really handled an interrupt. We
 	 * might have caught a *second* counter just after overflowing
 	 * the interrupt for this counter then arrives
