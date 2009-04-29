Return-Path: <linux-kernel-owner+w=401wt.eu-S1761089AbZD2TyU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761089AbZD2TyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 15:54:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756958AbZD2TyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 15:54:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60563 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbZD2TyH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 15:54:07 -0400
Date: Wed, 29 Apr 2009 21:53:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, borislav.petkov@amd.com, greg@kroah.com,
       tglx@linutronix.de, hpa@zytor.com, dougthompson@xmission.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/21] amd64_edac: add f10-and-later methods-p3
Message-ID: <20090429195357.GB17021@elte.hu>
References: <1241024107-14535-1-git-send-email-borislav.petkov@amd.com> <1241024107-14535-14-git-send-email-borislav.petkov@amd.com> <20090429182255.GD8321@elte.hu> <20090429120501.ae005dc4.akpm@linux-foundation.org> <20090429192326.GA14652@elte.hu> <20090429124228.8677d4eb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429124228.8677d4eb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 29 Apr 2009 21:23:26 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
> 
> > > > > +		if (CSFound >= 0) {
> > > > > +			*node_id = NodeID;
> > > > > +			*channel_select = ChannelSelect;
> > > > > +		}
> > > > > +	}
> > > > > +
> > > > > +	return CSFound;
> > > > > +}
> > > > 
> > > > this function is probably too large, and also it uses some weird 
> > > > hungarian notation coding style. Please dont do that! It's 
> > > > completely unacceptable.
> > > 
> > > These identifers (or at least, DctSelBaseOffsetLong, which is the 
> > > only one I googled for) come straight out of the AMD "BIOS and 
> > > Kernel Developer's Guide".
> > > 
> > > Sucky though they are, there's value in making the kernel code 
> > > match up with the documentation.
> > 
> > I'm generally resisting patches that hungarinize arch/x86/ (and heck 
> > there's been many attempts ...) but there's some conflicting advice 
> > here. I've Cc:-ed Linus, maybe he has an opinion about this.
> > 
> > My gut reaction would be 'hell no'. There's other, structural 
> > problems with this code too, and doing some saner naming would 
> > mostly be a sed job and would take minimal amount of time. The 
> > naming can still be intuitive. The symbols from the documentation 
> > can perhaps be mentioned in a couple of comments to establish a 
> > mapping.
> 
> I think I disagree.  For those identifiers which map 1:1 with the 
> manufacturer's document, the ugliness involved in exactly copying 
> the manufacturer's chosen identifiers is outweighed by the benefit 
> of exactly copying the manufacturer's chosen identifiers.
> 
> Of course, we don't have to use StinkyIdentifiers anywhere else.  
> And the nice thing about that is that when one reads the code and 
> comes across a StinkyIdentifier, one immeditely knows that it's an 
> AMD-provided thing rather than a Linux-provided thing.
> 
> Zillions of StinkyIdentifiers get merged via this logic.

Andrew, for heaven's sake, please review the patchset - as i did.

The thing is, up to 12/21, the patches look like normal Linux 
patches. (there's problems with them too, but on a different level)

Then do the StinkyIdentifiers show up, in full force:

+static int f10_match_to_this_node(struct amd64_pvt *pvt, int DramRange,
+                               u64 SystemAddr,
+                               int *node_id,
+                               int *channel_select)
+{
+       int CSFound = -1;
+       int NodeID;
+       int HiRangeSelected;
+       u32 IntlvEn, IntlvSel;
+       u32 DramEn;
+       u32 Ilog;
+	u32 HoleOffset, HoleEn;
+       u32 InputAddr, Temp;
+       u32 DctSelBaseAddr, DctSelIntLvAddr;
+       u32 DctSelHi;
+       u32 ChannelSelect;
+       u64 DramBaseLong, DramLimitLong;
+	u64 DctSelBaseOffsetLong, ChannelAddrLong;

Tell me, how is 'SystemAddr' or 'Temp' or 'Ilog' an AMD document 
thing?

I have a much simpler explanation really: someone got really bored 
at converting some code written For Another OS, somewhere in the 
middle - and started plopping Other OS Code into a Linux driver ...

I dont mind the occasional _constant_ that tells us a hw API detail 
in whatever externally dictated style - but this thing stinks 
HeadToToe ... ;-)

	Ingo
