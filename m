Return-Path: <linux-kernel-owner+w=401wt.eu-S1756223AbYAJMWs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756223AbYAJMWs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 07:22:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYAJMWj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 07:22:39 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46100 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751039AbYAJMWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 07:22:38 -0500
Date: Thu, 10 Jan 2008 13:22:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <ak@suse.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       suresh.b.siddha@intel.com, Arjan van de Ven <arjan@infradead.org>,
       Dave Jones <davej@redhat.com>
Subject: Re: CPA patchset
Message-ID: <20080110122204.GA25129@elte.hu>
References: <20080103424.989432000@suse.de> <20080110093126.GA360@elte.hu> <20080110095337.GK25945@bingen.suse.de> <20080110104351.GC28209@elte.hu> <20080110110704.GQ25945@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080110110704.GQ25945@bingen.suse.de>
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


* Andi Kleen <ak@suse.de> wrote:

> > What is very real though are the hard limitations of MTRRs. So i'd 
> > rather first like to see a clean PAT approach (which all other 
> > modern OSs have already migrated to in the past 10 years)
> 
> That's mostly orthogonal. Don't know why you bring it up now?

because the PAT (Page Attribute Table support) patchset and the CPA 
(change_page_attr()) patchset are are not orthogonal at all - as their 
name already signals: because they change the implementation/effects of 
the same interface(s). [just at different levels].

Both patchsets change how the kernel pagetable caching is handled. PAT 
changes the kernel pte details and unshackles us from MTRR reliance and 
thus solves real problems on real boxes:

 55 files changed, 1288 insertions(+), 237 deletions(-)

CPA moves change_page_attr() from invwb flushing to cflush flushing, for 
a speedup/latency-win, plus a whole bunch of intermingled fixes and 
improvements to page attribute modification:

 26 files changed, 882 insertions(+), 423 deletions(-)

so in terms of risk management, the "perfect patch order" is:

 - minimal_set of correctness fixes to the highlevel cpa code.

 - ( then any provably NOP cleanups to pave the way. )

 - then change the lowlevel pte code (PAT) to reduce/eliminate the need 
   to have runtime MTRR use

 - then structural improvements/cleanups of the highlevel cpa code

 - then the cflush (optional) performance feature ontop of it.

 - then gigabyte-largepages/TLBs support [new CPU feature that further
   complicates page-attribute management]

All in an easy-to-revert fashion. We _will_ regress here, and this stuff 
is very hard to debug.

	Ingo
