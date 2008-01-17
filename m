Return-Path: <linux-kernel-owner+w=401wt.eu-S1757386AbYAQVXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757386AbYAQVXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 16:23:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752925AbYAQVXj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 16:23:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:43423 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbYAQVXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 16:23:38 -0500
Date: Thu, 17 Jan 2008 22:22:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Herrmann3 <andreas.herrmann3@amd.com>
Cc: Venki Pallipadi <venkatesh.pallipadi@intel.com>, ak@muc.de,
       ebiederm@xmission.com, rdreier@cisco.com, torvalds@linux-foundation.org,
       gregkh@suse.de, airlied@skynet.ie, davej@redhat.com, tglx@linutronix.de,
       hpa@zytor.com, akpm@linux-foundation.org, arjan@infradead.org,
       jesse.barnes@intel.com, davem@davemloft.net,
       linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com
Subject: Re: [patch 0/4] x86: PAT followup - Incremental changes and bug
	fixes
Message-ID: <20080117212214.GA10165@elte.hu>
References: <20080116023955.597433000@intel.com> <20080116185748.GA11244@alberich.amd.com> <20080116203328.GA17869@linux-os.sc.intel.com> <20080117191211.GA12631@alberich.amd.com> <20080117203600.GB27778@elte.hu> <20080117210301.GC12631@alberich.amd.com> <20080117211308.GA7858@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080117211308.GA7858@elte.hu>
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

> * Andreas Herrmann3 <andreas.herrmann3@amd.com> wrote:
> 
> > Yes.
> > 
> > Meanwhile I have figured out that it is some ACPI stuff that maps the 
> > page cached. I've changed the ioremap's in drivers/acpi/osl.c to 
> > ioremap_nocache. See attached patch.
> > 
> > Now the machine boots without conflicts.
> 
> ah, nice!
> 
> but in general we must be robust enough in this case and just degrade 
> any overlapping page to UC (and emit a warning perhaps) - instead of 
> failing the ioremap and thus failing the driver (and the bootup).

btw., there's a change i did in today's x86.git: _all_ the old BIOS data 
accesses now go through early_ioremap(). This cleaned up the boot code 
quite significantly, as it's much more apparent now when we access a 
BIOS data table. (it also solves the problem when BIOS data pages are in 
reserved areas that we map via UC or dont map at all)

the same happens with all ISA ioremaps as well - no more "low 1MB is 
treated special" exceptions.

[ This also solves the 'EFI puts data pages into really high memory we
  dont have mapped yet' category of problems that BIOS writers are
  apparently busy creating right now ;-) ]

the downside is that old linear-mapped assumptions might now result in 
an early fault - boot with earlyprintk=vga or 
earlyprintk=serial,ttyS0,115200. I fixed most such assumptions already 
and booted an allyesconfig kernel on both 32-bit and 64-bit x86, but a 
few more remain still. I've enhanced the early fault printout code as 
well to make it easier to debug such things, so it should be relatively 
easy to find the rest.

	Ingo
