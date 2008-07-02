Return-Path: <linux-kernel-owner+w=401wt.eu-S1761099AbYGBBXj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761099AbYGBBXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 21:23:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbYGBBX3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 21:23:29 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60629 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129AbYGBBX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 21:23:27 -0400
Subject: Re: [PATCH 14/23] make section names compatible with
	-ffunction-sections -fdata-sections: parisc
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-arch@vger.kernel.org, Russell King <rmk@arm.linux.org.uk>,
       David Howells <dhowells@redhat.com>, Ralf Baechle <ralf@linux-mips.org>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Josh Boyer <jwboyer@linux.vnet.ibm.com>,
       Paul Mackerras <paulus@samba.org>,
       David Woodhouse <dwmw2@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       Paul Gortmaker <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tim Bird <tim.bird@am.sony.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Dave Miller <davem@davemloft.net>
In-Reply-To: <200807020200.49518.vda.linux@googlemail.com>
References: <200807020239.11410.vda.linux@googlemail.com>
	 <1214955660.3316.31.camel@localhost.localdomain>
	 <200807020200.49518.vda.linux@googlemail.com>
Content-Type: text/plain
Date: Tue, 01 Jul 2008 20:23:19 -0500
Message-Id: <1214961799.3316.36.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-02 at 02:00 +0200, Denys Vlasenko wrote:
> On Wednesday 02 July 2008 01:41, James Bottomley wrote:
> > On Wed, 2008-07-02 at 02:39 +0200, Denys Vlasenko wrote:
> > > The purpose of this patch is to make kernel buildable
> > > with "gcc -ffunction-sections -fdata-sections".
> > > This patch fixes parisc architecture.
> > > 
> > > Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
> > 
> > Um ... if you look at the Makefile you'll see we already build parisc
> > with -ffunction-sections; we have to: our relative jumps are too small
> > to guarantee finding the stubs in large files.
> > 
> > Since our text is -ffunction-sections compatible already, I question the
> > need for transformations like this:
> > 
> > > -               *(.text.do_softirq)
> > > -               *(.text.sys_exit)
> > > -               *(.text.do_sigaltstack)
> > > -               *(.text.do_fork)
> > > +               *(.do_softirq.text)
> > > +               *(.sys_exit.text)
> > > +               *(.do_sigaltstack.text)
> > > +               *(.do_fork.text)
> 
> arch/parisc/kernel/vmlinux.lds.S contains these lines:
> 
>                TEXT_TEXT
>                SCHED_TEXT
>                LOCK_TEXT
>                *(.text.do_softirq)
>                *(.text.sys_exit)
>                *(.text.do_sigaltstack)
>                *(.text.do_fork)
> 
> which suggested to me that for parisc it is important to have
> these sections in that place (after LOCK_TEXT) and order.

Yes ... moderately.

> If you use -ffunction-sections, any function with the name
> do_fork (say, a static function somewhere) will end up in
> .text.do_fork function, and will be "mixed up" with
> global do_fork(). For parisc it is maybe not a problem
> (I am not an expert) but in other places/arches people
> clearly would not want this kind of things to happen.

Erm, but we're trying to name text sections of the -ffunction-sections.
We're doing this because we are trying to do a semblance of a reasonable
arrangement for the relative jumps (and avoid stubs).  Your patch is
explicitly breaking all of this.

> In order to handle these situations uniformly, in these patches
> I decided to _never_ use .text.XXXX names for sections,
> effectively leaving them "reserved for gcc's use".

We need to use the names gcc outputs, not some random name.

> Did I understand you right that in this chunk I need to
> leave .text.FUNC_NAME as it was before?

Yes.

> > And thus by the same token the data transformations.
> 
> It would be easiest for me if you will reply to the parisc patch
> and indicate all parts where I should NOT do name change.

That would be the piece above.

James


