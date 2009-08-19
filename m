Return-Path: <linux-kernel-owner+w=401wt.eu-S1750915AbZHSAy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750915AbZHSAy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 20:54:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbZHSAy0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 20:54:26 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38868 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758AbZHSAyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 20:54:25 -0400
Subject: Re: kernel segv with 2.6.31-rc6 ?
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Roland McGrath <roland@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Helge Deller <deller@gmx.de>,
       linux-parisc <linux-parisc@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20090819001424.4C1144730F@magilla.sf.frob.com>
References: <4A89CC4D.5040801@gmx.de>
	 <1250549376.7858.96.camel@mulgrave.site>
	 <200908181248.52572.rusty@rustcorp.com.au>
	 <20090818050637.4C3E74730F@magilla.sf.frob.com>
	 <1250640565.15079.3.camel@mulgrave.site>
	 <20090819001424.4C1144730F@magilla.sf.frob.com>
Content-Type: text/plain
Date: Tue, 18 Aug 2009 18:54:21 -0600
Message-Id: <1250643261.18426.8.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-08-18 at 17:14 -0700, Roland McGrath wrote:
> > Actually, for parisc, its not reasonable.  It's expected that our modules
> > have multiple text sections (we have to use -ffunction-sections to
> > generate them in order that the PCREL17 jump stubs can be interleaved).
> 
> I don't think you need what you think you need.  Having lots of sections in
> your .o's when you compile is fine.  These should be combined by the linker
> script that creates the .ko, however.  Unless I am missing something, there
> is no purpose to this section distinction at insmod time--it's only
> important for the relative layout of the parts of the .ko's text, which
> winds up contiguous whether laid out that way at ld -r (.ko creation) time
> or at insmod time.

Actually, I think we do; the module loader is a runtime linker, after
all.  We have specific module bugs we fixed by inserting relocation
stubs between the text sections.

Our specific problem is that the standard pa relocation is PCREL17 ...
as you can appreciate, 17 bits of relative jump isn't a lot.  If the
target isn't within the 17 bits, we have to insert a relocation stub to
do an indirect absolute jump thought the GOT.  Our problems occur when a
text section is wider than the 17 bits, which happens a lot in the
larger modules ... with nowhere to put the stub within range of the
relocation we can't load them.  Our fix is to split the text sections
with -ffunction-sections so we can be pretty much assured of having a
stub location within the 17 bits.

We don't care what they're called or anything.  We just care that
the .text is split up into multiple separately relocateable sections so
we can get the stubs within range of the jumps.

Now, of course, if the final linker could be persuaded to sprinkle
needed stubs through the text section and all we have to do is GOT
relocations, we don't need all the jiggery-pokery ... but I'm told this
can't be done.

James


