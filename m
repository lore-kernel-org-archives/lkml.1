Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbZCDLko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbZCDLko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 06:40:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751903AbZCDLkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 06:40:35 -0500
Received: from mx1.emlix.com ([193.175.82.87]:43384 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750901AbZCDLkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 06:40:35 -0500
From: "Oskar Schirmer" <os@emlix.com>
Date: Wed, 4 Mar 2009 12:39:38 +0100
To: Paul Mundt <lethal@linux-sh.org>
Cc: Johannes Weiner <jw@emlix.com>, Andrew Morton <akpm@linux-foundation.org>,
       Oskar Schirmer <os@emlix.com>, David Howells <dhowells@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>, Bryan Wu <cooloney@kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org
Subject: Re: [patch] binfmt_flat: fix data sections alignment
References: <E1LeXY0-0007Fb-KQ@mailer.emlix.com> <20090303182801.GA6907@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090303182801.GA6907@linux-sh.org>
Organization: emlix GmbH
User-Agent: Mutt/1.5.16 (2007-06-09)
Message-Id: <E1LepRq-0006nu-VT@mailer.emlix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 04, 2009 at 03:28:02 +0900, Paul Mundt wrote:
> On Tue, Mar 03, 2009 at 05:33:13PM +0100, Johannes Weiner wrote:
> > The flat loader uses an architecture's flat_stack_align() to align the
> > stack but assumes word-alignment is enough for the data sections.
> > 
> > However, on the Xtensa S6000 we need an alignment of more than
> > wordsize for data that is loaded to 128bit wide registers.
> > 
> > This patch replaces the specific flat_stack_align() with a more
> > generic flat_data_align() that is then used for both stack, the data
> > and bss section.
> > 
> > It also fixes m32r which was obviously kaput, aligning an
> > uninitialized stack entry instead of the stack pointer.
> > 
> Can you provide a bit more information about this for your platform? I
> note that while this patch is aimed to generalize things for your
> platform, there is no Xtensa patch included here, making it difficult to
> Ack without having more context to go on.

You are right, currently there is no variant which
really needs these fixes. But the Xtensa noMMU port
(will follow as soon as possible) wont work without
these.

> Based on your description, it looks like you need register size alignment
> in the case where your registers are greater than BYTES_PER_WORD, or the

This is right. Xtensa S6000 provides an additional set of
wide registers (128 bit), and load/store instructions to
fill them. These load/store cycles need to be 16 byte aligned.

> pointer size. If this is the case, then you are going to have the same
> issues with the slab caches and need to set ARCH_SLAB_MINALIGN
> accordingly. This is presently a situation that exists for certain ARM
> and SH platforms already today, but none that are actively used in nommu
> configurations. It would be preferable to generalize this, rather than
> duplicating the special-cased alignment.

This sounds like a good proposal.
We will rewrite the patch to use the more generic
ARCH_SLAB_MINALIGN and send it soon.

  Oskar
-- 
oskar schirmer, emlix gmbh, http://www.emlix.com
fon +49 551 30664-0, fax -11, bahnhofsallee 1b, 37081 göttingen, germany
geschäftsführung: dr. uwe kracke, dr. cord seele, ust-idnr.: de 205 198 055
sitz der gesellschaft: göttingen, amtsgericht göttingen hr b 3160

emlix - your embedded linux partner
