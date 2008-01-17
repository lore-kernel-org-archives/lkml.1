Return-Path: <linux-kernel-owner+w=401wt.eu-S1758401AbYAQWQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758401AbYAQWQG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 17:16:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758991AbYAQWPn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 17:15:43 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:46795 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758936AbYAQWPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 17:15:42 -0500
Date: Thu, 17 Jan 2008 23:15:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann3 <andreas.herrmann3@AMD.COM>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Venki Pallipadi <venkatesh.pallipadi@intel.com>, ak@muc.de,
       ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, arjan@infradead.org,
       jesse.barnes@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug
	fixes
Message-ID: <20080117221505.GB18883@elte.hu>
References: <20080116023955.597433000@intel.com> <20080116185748.GA11244@alberich.amd.com> <20080116203328.GA17869@linux-os.sc.intel.com> <20080117191211.GA12631@alberich.amd.com> <20080117203600.GB27778@elte.hu> <20080117210301.GC12631@alberich.amd.com> <20080117211308.GA7858@elte.hu> <20080117213131.GA25389@linux-os.sc.intel.com> <20080117214209.GA12811@elte.hu> <20080117220650.GE12631@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117220650.GE12631@alberich.amd.com>
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


* Andreas Herrmann3 <andreas.herrmann3@AMD.COM> wrote:

> On Thu, Jan 17, 2008 at 10:42:09PM +0100, Ingo Molnar wrote:
> > 
> > * Siddha, Suresh B <suresh.b.siddha@intel.com> wrote:
> > 
> > > On Thu, Jan 17, 2008 at 10:13:08PM +0100, Ingo Molnar wrote:
> > > > but in general we must be robust enough in this case and just degrade 
> > > > any overlapping page to UC (and emit a warning perhaps) - instead of 
> > > > failing the ioremap and thus failing the driver (and the bootup).
> > > 
> > > But then, this will cause an attribute conflicit. Old one was 
> > > specifying WB in PAT (ioremap with noflags) and the new ioremap 
> > > specifies UC.
> > 
> > we could fix up all aliases of that page as well and degrade them to UC?
> 
> Yes, we must fix all aliases or reject the conflicting mapping. But 
> fixing all aliases might not be that easy. (I've just seen a panic 
> when using your patch ;-(

yes, indeed my patch is bad if you have PAT enabled: conflicting cache 
attributes might be present. I'll go with your patch for now.

should we perhaps do UC by default for early_ioremap() as well? Normally 
those mappings are only temporary - but in case of a leak they might 
hang around in the pagetables and the CPU might stumble upon them. Also, 
should early_iounmap() do a wbinvd() [/clflush()] call as well, to be 
safe?

	Ingo
