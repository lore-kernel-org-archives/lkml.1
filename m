Return-Path: <linux-kernel-owner+w=401wt.eu-S1761419AbYBNRi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761419AbYBNRi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 12:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754598AbYBNRiS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 12:38:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:47733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755505AbYBNRiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 12:38:17 -0500
Subject: Re: [PATCHv3 1/3] x86: use ELF format in compressed images.
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Ian Campbell <ijc@hellion.org.uk>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       virtualization@lists.linux-foundation.org
In-Reply-To: <1203008490.30818.69.camel@localhost.localdomain>
References: <1202936100-30859-1-git-send-email-ijc@hellion.org.uk>
	 <9d3a007a2bfe774201b6deed5115a0cc8182bbb4.1202935389.git.ijc@hellion.org.uk>
	 <1202988844.26435.4.camel@muff>
	 <1203008490.30818.69.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 17:37:55 +0000
Message-Id: <1203010675.16280.15.camel@muff>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-02-14 at 17:01 +0000, Ian Campbell wrote:
> On Thu, 2008-02-14 at 11:34 +0000, Mark McLoughlin wrote:
> > On Wed, 2008-02-13 at 20:54 +0000, Ian Campbell wrote:
> > > This allows other boot loaders such as the Xen domain builder the
> > > opportunity to extract the ELF file.
> > 
> > 	Right, Xen currently can't boot bzImage (it needs the ELF image) so you
> > still can't use the same kernel image on Xen as bare-metal.
> 
> I have a xen domain builder patch as well. I was waiting for the Linux
> side to gain some traction before putting it forward (I'd attach it now
> but it's at home on a laptop which is sleeping).

Yep, just want to highlight to people that your patches (or an
alternative) are needed before the same pv_ops kernel truly can be used
on bare-metal and Xen.

> > 	How about this?
> > 
> > +sed-offsets := -e 's/^00*/0/' \
> > +        -e 's/^\([0-9a-fA-F]*\) . \(input_data\|input_data_end\)$$/-D\2=0x\1 /p'
> > +
> > +$(obj)/header.o: AFLAGS_header.o += $(shell $(NM) $(obj)/compressed/vmlinux | sed -n $(sed-offsets))
> > +$(obj)/header.o: $(obj)/compressed/vmlinux FORCE
> 
> That's probably a neater way of doing it. Although the ".../header.o:
> AFLAGS_header.o" is redundant, either 
> 	header.o: AFLAGS += foo

With this, AFLAGS would apply to building when building the
prerequisites of header.o too, which you don't want

The make manual says:

  "when you define a target-specific variable that variable value is
   also in effect for all prerequisites of this target, and all their
   prerequisites"

> or
> 	AFLAGS_header.o += foo
> with the second being preferred in Linux Makefiles I think.

And with this, it would try and read vmlinux before it is built.

But, hmm, given the fact that the variable is defined when building
prerequisites, you'd think that even in my version AFLAGS would be
evaluated before building vmlinux.

Cheers,
Mark.

