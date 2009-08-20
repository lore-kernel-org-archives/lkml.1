Return-Path: <linux-kernel-owner+w=401wt.eu-S1755477AbZHTXBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477AbZHTXBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 19:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbZHTXBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 19:01:14 -0400
Received: from hiauly1.hia.nrc.ca ([132.246.100.193]:3571 "EHLO
	hiauly1.hia.nrc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbZHTXBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 19:01:13 -0400
Subject: Re: kernel segv with 2.6.31-rc6 ?
To: James.Bottomley@HansenPartnership.com (James Bottomley)
Date: Thu, 20 Aug 2009 19:01:13 -0400 (EDT)
From: "John David Anglin" <dave@hiauly1.hia.nrc.ca>
Cc: deller@gmx.de, rusty@rustcorp.com.au, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, dave.anglin@nrc.ca, roland@redhat.com
In-Reply-To: <1250805049.4302.121.camel@mulgrave.site> from "James Bottomley" at Aug 20, 2009 03:50:49 pm
X-Mailer: ELM [version 2.4 PL25]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <20090820230114.36D3E4E7A@hiauly1.hia.nrc.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 2009-08-20 at 23:45 +0200, Helge Deller wrote:
> > On 08/20/2009 08:55 PM, John David Anglin wrote:
> > >> The reason seems to be, that something in the newer gcc compilers changed to generate multiple sections all named ".text" for the PCREL17 relocations.
> > >> Older compilers named those sections ".text.1", ".text.2", ".text.3" and so forth.
> > >
> > > GCC has never generated ".text.1", etc, on parisc linux as far as I know.
> > 
> > Hmm, I don't like to disagree with an gcc-expert like you,but
> > I did pasted an objdump in my last mail, which shows that gcc did
> > generated .text.1, .text.2 and so on:
> > 
> > Sections:
> > Idx Name          Size      VMA       LMA       File off  Algn
> >    0 .text         00000000  00000000  00000000  00000034  2**0
> >                    CONTENTS, ALLOC, LOAD, READONLY, CODE
> > ...
> >    4 .text.1       00000000  00000000  00000000  000000b0  2**0
> >                    CONTENTS, ALLOC, LOAD, READONLY, CODE
> 
> Since this is a relinked object, might it be possible that ld rather
> than gcc is the culprit?

I think it must be from binutils.  It might be a result of broken
section merging.  Possibly, we don't merge .text sections when
doing ld -r so that stub sections could be interleaved.  Alan Modra
wrote that code and I'm not that familiar with it.

The GCC definition of TEXT_SECTION_ASM_OP in pa-linux.h has never changed.
The PA backend in GCC doesn't play any section games on linux targets,
so it's hard to see how this could happen.  Check the assembler output
from GCC if you don't believe me.

At some time, GCC may start a new .text section at the beginning of
each function.  We do this on hpux but not linux.  This will cause
multiple .text sections to be present in an object and allow finer grained
stub placement.

Dave
-- 
J. David Anglin                                  dave.anglin@nrc-cnrc.gc.ca
National Research Council of Canada              (613) 990-0752 (FAX: 952-6602)
