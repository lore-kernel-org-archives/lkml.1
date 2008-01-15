Return-Path: <linux-kernel-owner+w=401wt.eu-S1757040AbYAOWSy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757040AbYAOWSy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:18:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757815AbYAOWSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:18:37 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:57560 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757458AbYAOWSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:18:35 -0500
Date: Tue, 15 Jan 2008 23:17:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       Andi Kleen <andi@firstfloor.org>, ebiederm@xmission.com,
       rdreier@cisco.com, torvalds@linux-foundation.org, gregkh@suse.de,
       airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       jesse.barnes@intel.com
Subject: Re: [patch 02/11] PAT x86: Map only usable memory in x86_64
	identity map and kernel text
Message-ID: <20080115221758.GG2665@elte.hu>
References: <p737iiho5yq.fsf@bingen.suse.de> <924EFEDD5F540B4284297C4DC59F3DEE5A2805@orsmsx423.amr.corp.intel.com> <20080110192808.GF747@one.firstfloor.org> <924EFEDD5F540B4284297C4DC59F3DEE5A28CE@orsmsx423.amr.corp.intel.com> <20080114164324.GH15542@elte.hu> <20080114212105.GB8903@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080114212105.GB8903@linux-os.sc.intel.com>
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


* Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:

> On Mon, Jan 14, 2008 at 05:43:24PM +0100, Ingo Molnar wrote:
> > 
> > * Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com> wrote:
> > 
> > > Also, relying on MTRR, is like giving more importance to BIOS writer 
> > > than required :-). I think the best way to deal with MTRR is just to 
> > > not touch it. Leave it as it is and do not try to assume that they are 
> > > correct, as frequently they will not be.
> > 
> > i'd suggest the following strategy on PAT-capable CPUs:
> > 
> >  - do not try to write MTRRs. Ever.
> > 
> >  - _read_ the current MTRR settings (including the default MTRR) and 
> >    check them against the e820 map. I can see two basic types of 
> >    mismatches:
> > 
> >      - RAM area marked fine in e820 but marked UC by MTRR: this 
> >        currently results in a slow system.
> 
> Time to resurrect Jesse's old patches 
> i386-trim-memory-not-covered-by-wb-mtrrs.patch(which was in -mm 
> sometime back)

just to make sure i understood the attribute priorities right: we cannot 
just mark it WB in the PAT and expect it to be write-back - the UC of 
the MTRR will control?

> >        (NOTE: UC- would be fine and 
> >        overridable by PAT, hence it's not a conflict we should detect.)
> 
> UC- can't be specified by MTRR's.

hm, only by PATs? Not even by the default MTRR?

> >      - mmio area marked cacheable in the MTRR (results in broken 
> >      system)
> 
> PAT can help specify the UC/WC attribute here.

ok. So it seems we dont even need all that many special cases, a "dont 
write MTRRs" and "use PATs everywhere" rule would just do the right 
thing all across?

	Ingo
