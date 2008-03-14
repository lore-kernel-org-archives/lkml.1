Return-Path: <linux-kernel-owner+w=401wt.eu-S1757454AbYCNWBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454AbYCNWBc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 18:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753945AbYCNWBW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 18:01:22 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46501 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753201AbYCNWBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 18:01:21 -0400
Message-Id: <1205532078.32744.1242485965@webmail.messagingengine.com>
X-Sasl-Enc: XDXikVeePNSGw0OdryRZ3I3jq72oIuOJXMlgzY+T0uph 1205532078
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: "Andi Kleen" <andi@firstfloor.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Alexander van Heukelum" <heukelum@mailshack.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, "LKML" <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
References: <20080312200128.GA24983@mailshack.com> <47DABEFB.3050704@goop.org>
   <1205523826.7441.1242464129@webmail.messagingengine.com>
   <20080314195520.GV2522@one.firstfloor.org>
   <1205530409.27413.1242484373@webmail.messagingengine.com>
   <20080314214205.GW2522@one.firstfloor.org>
Subject: Re: [PATCH] x86: merge the simple bitops and move them to bitops.h
In-Reply-To: <20080314214205.GW2522@one.firstfloor.org>
Date: Fri, 14 Mar 2008 23:01:18 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008 22:42:05 +0100, "Andi Kleen" <andi@firstfloor.org>
said:
> On Fri, Mar 14, 2008 at 10:33:29PM +0100, Alexander van Heukelum wrote:
> > static inline int fls64(__u64 x)
> > {
> >         __u32 h = x >> 32;
> >         if (h)
> >                 return fls(h) + 32;
> >         return fls(x);
> > }
> > 
> > I just wanted to move the 64-bit version to that header, with some
> > ifdefs to select the right one.
> 
> That's still far more than the single 64bit instruction fls64 uses

I agree that it should end up using bsr. It would look like this in
the end, I guess. Might be familiar.

#if BITS_PER_LONG == 32
static inline int fls64(__u64 x)
{
        __u32 h = x >> 32;
        if (h)
                return __fls(h) + 33;
        return fls(x);
}
#else
static inline int fls64(__u64 x)
{
        if (x == 0)
                return 0;
        return __fls(x) + 1;
}
#endif

> > In fact I just found out that it only had an effect for 64 bit
> > machines. Still, setting it unconditionally feels wrong.
> 
> I don't think your feeling is correct.

This is the only reason that this define exists. With another
name it would be fine. HWEIGHT_USE_MULTIPLIER?

> > > > x86_64 has a mysterious inline function set_bit_string, which is
> > > > only used by pci-calgary_64.c and pci-gart_64.c. Not sure what to
> > > > do with it.
> > > 
> > > It's generic and could really live in linux/bitops.h
> > 
> > It could. But it is a trivial (slow?) implementation. Probably fine
> 
> It is this way because the callers in 95+% of all cases only
> set a single bit. For that case it is not slow.

And my feeling is that this is exactly the reason why this is
not a good version for a generic implementation in bitops.h. But
I don't care much.

Greetings,
    Alexander

> -Andi
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - Accessible with your email software
                          or over the web

