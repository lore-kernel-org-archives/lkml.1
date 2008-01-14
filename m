Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbYANQpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbYANQpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 11:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751360AbYANQoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 11:44:55 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58972 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbYANQoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 11:44:55 -0500
Date: Mon, 14 Jan 2008 17:43:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch 02/11] PAT x86: Map only usable memory in x86_64
	identity map and kernel text
Message-ID: <20080114164324.GH15542@elte.hu>
References: <p737iiho5yq.fsf@bingen.suse.de> <924EFEDD5F540B4284297C4DC59F3DEE5A2805@orsmsx423.amr.corp.intel.com> <20080110192808.GF747@one.firstfloor.org> <924EFEDD5F540B4284297C4DC59F3DEE5A28CE@orsmsx423.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEE5A28CE@orsmsx423.amr.corp.intel.com>
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


* Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:

> Also, relying on MTRR, is like giving more importance to BIOS writer 
> than required :-). I think the best way to deal with MTRR is just to 
> not touch it. Leave it as it is and do not try to assume that they are 
> correct, as frequently they will not be.

i'd suggest the following strategy on PAT-capable CPUs:

 - do not try to write MTRRs. Ever.

 - _read_ the current MTRR settings (including the default MTRR) and 
   check them against the e820 map. I can see two basic types of 
   mismatches:

     - RAM area marked fine in e820 but marked UC by MTRR: this 
       currently results in a slow system. (NOTE: UC- would be fine and 
       overridable by PAT, hence it's not a conflict we should detect.)

     - mmio area marked cacheable in the MTRR (results in broken system)

   then emit a warning and exclude all such areas from any further Linux 
   use. I.e. if it's RAM then clip it from our memory map. If it's mmio 
   area then try to exclude it from BAR sizing/positioning.

   this way we'll only have two sorts of physical pages put into 
   pagetables by Linux:

     1) RAM page, marked cacheable by MTRR
     2) RAM page, marked as UC- by MTRR
     2) mmio page, marked as UC- by MTRR

 - then we'd use PAT for all these patches to differentiate their 
   caching properties. We mark RAM pages as cacheable, and we mark mmio 
   pages as WC or UC.

I.e. try to be as conservative and always have a deterministic exit 
strategy towards a 100% working system, even if BIOS writers messed up 
the MTRR defaults. _Worst-case_ we boot up with somewhat less RAM or 
with a somewhat smaller mmio area. (but there will be warnings in the 
dmesg about that so users can complain about the BIOS.) We should never 
ever allow the wrong BIOS MTRR defaults to impact Linux's correctness.

hm?

	Ingo
