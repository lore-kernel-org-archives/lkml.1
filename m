Return-Path: <linux-kernel-owner+w=401wt.eu-S1758885AbYCNVdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885AbYCNVdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 17:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755912AbYCNVdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 17:33:31 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39577 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754998AbYCNVda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 17:33:30 -0400
Message-Id: <1205530409.27413.1242484373@webmail.messagingengine.com>
X-Sasl-Enc: YzBxVJ/YVex1PdCDWDu1xfBAmIpx531eqtfsWqvAzKNo 1205530409
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Alexander van Heukelum" <heukelum@mailshack.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, "LKML" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
Subject: Re: [PATCH] x86: merge the simple bitops and move them to bitops.h
In-Reply-To: <20080314195520.GV2522@one.firstfloor.org>
Date: Fri, 14 Mar 2008 22:33:29 +0100
References: <20080312200128.GA24983@mailshack.com> <47DABEFB.3050704@goop.org>   
   <1205523826.7441.1242464129@webmail.messagingengine.com>   
   <20080314195520.GV2522@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008 20:55:20 +0100, "Andi Kleen" <andi@firstfloor.org>
said:
> 
> The CMOV define should probably be dependent on what CPU the kernel
> is tuned for. It was originally written for when x86-64 was only
> K8 which has fast CMOV, but e.g. on P4 CMOV is actually deprecated
> over jumps.

Hi Andi,

I guess you are right. But there is quite a big number of different
types of P4. Let's see what the current situation is... defconfigs
(of current x86#testing+this patch/current linus) with
CONFIG_GENERIC_CPU=n:

Athlon: 4764 / 4667 occurences of cmovxx
Pentium-IV: 4079 / 3982 occurences of cmovxx
Pentium-M: 3939 / 3841 occurences of cmovxx
Core-2: 4335 / 4330 occurences of cmovxx

So it adds a few percent extra cmovxx's. The last one is fishy...
But I'm too hungry and sleepy to go hunt that one down.

> > Both define fls64(), but i386 uses a generic one and x86_64 defines
> > one all by itself. The generic one is currently not suitable for
> > use by 64-bit archs... that can change.
> 
> It is very unlikely a generic one will ever be able to compete
> with a single instruction.

Generic is maybe not the right term: asm-generic/bitops/fls64.h has:

static inline int fls64(__u64 x)
{
        __u32 h = x >> 32;
        if (h)
                return fls(h) + 32;
        return fls(x);
}

I just wanted to move the 64-bit version to that header, with some
ifdefs to select the right one.

> > x86_64 defines ARCH_HAS_FAST_MULTIPLIER, i386 not. This affects a
> > choice of generated code in the (generic) hweight function. It would
> > be nice if that could move to some other file.
> 
> It depends on the CPU, but it can be probably safely set on pretty much
> all modern x86 cores.

In fact I just found out that it only had an effect for 64 bit
machines. Still, setting it unconditionally feels wrong.

> > x86_64 has a mysterious inline function set_bit_string, which is
> > only used by pci-calgary_64.c and pci-gart_64.c. Not sure what to
> > do with it.
> 
> It's generic and could really live in linux/bitops.h

It could. But it is a trivial (slow?) implementation. Probably fine
for the uses in pci-calgary_64.c and pci-gart_64.c (small ranges?),
but I would worry about people using it, thinking it was a near-
optimal implementation.

Greetings,
    Alexander
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - IMAP accessible web-mail

