Return-Path: <linux-kernel-owner+w=401wt.eu-S1755347AbYFXMyZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbYFXMyZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 08:54:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751680AbYFXMyR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 08:54:17 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:62951 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751254AbYFXMyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 08:54:16 -0400
Date: Tue, 24 Jun 2008 14:54:05 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Pavel Machek <pavel@ucw.cz>
cc: Harvey Harrison <harvey.harrison@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: byteorder helpers and void * (was: Re: [PATCH 01/21] lib: add
 byteorder helpers for the aligned case)
In-Reply-To: <20080523131310.GC9245@ucw.cz>
Message-ID: <Pine.LNX.4.64.0806241445430.17853@vixen.sonytel.be>
References: <1211306721.5915.167.camel@brick> <20080523131310.GC9245@ucw.cz>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1223546138-1214312045=:17853"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1223546138-1214312045=:17853
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 23 May 2008, Pavel Machek wrote:
> On Tue 2008-05-20 11:05:21, Harvey Harrison wrote:
> > Some users know the pointer they are writeing to are aligned,
> > rather than doing *(__le16 *)ptr = cpu_to_le16(val) add helpers
> > wrapping this up that have the same convention as put_unaligned_le/be.
> > 
> > Although the get_be/le versions duplicate the le16_to_cpup functionality
> > add them anyway as it makes this a complete api and start work to
> > eliminate {le|be}{16|32|64}_to_cpup uses (not many).
> > 
> > This makes the api look like:
> > 
> > get_unaligned_le16
> > put_unaligned_le16
> > 
> > get_le16
> > put_le16
> > 
> > With explicit alignment constraints.
> > 
> > Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
> > ---
> >  include/linux/byteorder/generic.h |   60 +++++++++++++++++++++++++++++++++++++
> >  1 files changed, 60 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/byteorder/generic.h b/include/linux/byteorder/generic.h
> > index 0846e6b..1f0c07e 100644
> > --- a/include/linux/byteorder/generic.h
> > +++ b/include/linux/byteorder/generic.h
> > @@ -119,6 +119,66 @@
> >  #define cpu_to_be16s __cpu_to_be16s
> >  #define be16_to_cpus __be16_to_cpus
> >  
> > +static inline u16 get_le16(void *ptr)
> > +{
> > +	return le16_to_cpu(*(__le16 *)ptr);
> > +}
> > +
> 
> Document the fact that void * passed in needs to be 16-bit aligned?

Why not let it just take a __le16 *? Because in many use-cases the pointer just
points to an array of bytes?

For the unaligned case, e.g. get_unaligned_le16(), I can understand a bit the
rationale about using void * (a typical use-case is accessing a little endian
16-bit value in the middle of an arrays of bytes).

However, a disadvantage is that you remove the ability of the compiler to check
for using the wrong accessor in a (packed for the unaligned case) struct, e.g.

    struct {
	u8 pad;
	__le16 val;			/* 16-bit value */
    } __attribute ((packed)) s;

    x = get_unaligned_le32(&s.val);	/* oops, 32-bit access */

I noticed there's also a __get_unaligned_le(), which uses compile-time
detection of the pointer time, to make sure the correct accessor is used.
Do you intend this to be used by generic code? It's function name starts
with double underscore, indicating otherwise.

Thanks!

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

Sony Technology and Software Centre Europe
A division of Sony Service Centre (Europe) N.V.
Registered office: Technologielaan 7 · B-1840 Londerzeel · Belgium
VAT BE 0413.825.160 · RPR Brussels
Fortis 293-0376800-10 GEBA-BE-BB
---584349381-1223546138-1214312045=:17853--
