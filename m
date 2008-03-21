Return-Path: <linux-kernel-owner+w=401wt.eu-S1758545AbYCUO4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758545AbYCUO4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2008 10:56:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755391AbYCUO4q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Mar 2008 10:56:46 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47051 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754321AbYCUO4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2008 10:56:45 -0400
Date: Fri, 21 Mar 2008 15:55:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: venkatesh.pallipadi@intel.com
Cc: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 00/13] x86: PAT support updated - v3
Message-ID: <20080321145505.GA4868@elte.hu>
References: <20080319000012.439150000@intel.com> <20080321132417.GJ27245@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080321132417.GJ27245@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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

> > The patchset is against x86 testing from couple of days back.
> 
> thanks Venki, i've queued this up so that we can see how well it goes. 
> It now looks a lot less dangerous and more compatible than it did 
> before - but i'm sure there'll be issues nevertheless :-/

no big issues so far, just a simple build fix for the !MTRR case below.

	Ingo

----------------->
Subject: x86: PAT fix
From: Ingo Molnar <mingo@elte.hu>
Date: Fri Mar 21 15:42:28 CET 2008

build fix for !CONFIG_MTRR.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/asm-x86/mtrr.h |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

Index: linux-x86.q/include/asm-x86/mtrr.h
===================================================================
--- linux-x86.q.orig/include/asm-x86/mtrr.h
+++ linux-x86.q/include/asm-x86/mtrr.h
@@ -84,10 +84,9 @@ struct mtrr_gentry
 
 #ifdef __KERNEL__
 
-extern u8 mtrr_type_lookup(u64 addr, u64 end);
-
 /*  The following functions are for use by other drivers  */
 # ifdef CONFIG_MTRR
+extern u8 mtrr_type_lookup(u64 addr, u64 end);
 extern void mtrr_save_fixed_ranges(void *);
 extern void mtrr_save_state(void);
 extern int mtrr_add (unsigned long base, unsigned long size,
@@ -101,6 +100,13 @@ extern void mtrr_ap_init(void);
 extern void mtrr_bp_init(void);
 extern int mtrr_trim_uncached_memory(unsigned long end_pfn);
 #  else
+static inline u8 mtrr_type_lookup(u64 addr, u64 end)
+{
+	/*
+	 * Return no-MTRRs:
+	 */
+	return 0xff;
+}
 #define mtrr_save_fixed_ranges(arg) do {} while (0)
 #define mtrr_save_state() do {} while (0)
 static __inline__ int mtrr_add (unsigned long base, unsigned long size,
