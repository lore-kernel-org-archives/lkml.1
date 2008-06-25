Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbYFYLU2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbYFYLU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 07:20:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbYFYLUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 07:20:19 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:50902 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751623AbYFYLUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 07:20:18 -0400
Date: Wed, 25 Jun 2008 13:20:16 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: byteorder helpers and void * (was: Re: [PATCH 01/21] lib: add
 byteorder helpers for the aligned case)
In-Reply-To: <1214361338.21092.71.camel@brick>
Message-ID: <Pine.LNX.4.64.0806251319120.9483@vixen.sonytel.be>
References: <1211306721.5915.167.camel@brick> <20080523131310.GC9245@ucw.cz>
 <Pine.LNX.4.64.0806241445430.17853@vixen.sonytel.be> <1214361338.21092.71.camel@brick>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-329140865-1214392816=:9483"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-329140865-1214392816=:9483
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Tue, 24 Jun 2008, Harvey Harrison wrote:
> On Tue, 2008-06-24 at 14:54 +0200, Geert Uytterhoeven wrote:
> > > Document the fact that void * passed in needs to be 16-bit aligned?
> > 
> > Why not let it just take a __le16 *? Because in many use-cases the pointer just
> > points to an array of bytes?
> > 
> > For the unaligned case, e.g. get_unaligned_le16(), I can understand a bit the
> > rationale about using void * (a typical use-case is accessing a little endian
> > 16-bit value in the middle of an arrays of bytes).
> > 
> > However, a disadvantage is that you remove the ability of the compiler to check
> > for using the wrong accessor in a (packed for the unaligned case) struct, e.g.
> > 
> >     struct {
> > 	u8 pad;
> > 	__le16 val;			/* 16-bit value */
> >     } __attribute ((packed)) s;
> > 
> >     x = get_unaligned_le32(&s.val);	/* oops, 32-bit access */
> > 
> 
> I'm starting to come around to the typechecking argument.  This would
> also be a chance to fix the argument ordering in put_analigned_XXXX
> that was noticed by others.  As there are already some existing users
> in-tree, we could transition gradually by:
> 
> 1) Introduce typed versions of get/put_unaligned_XXXX, that implies the
> byteswap better:
> u16 load_unaligned_le16(__le16 *)
> void store_unaligned_le16(__le16 *, u16)

OK

> Then the aligned helpers could be:
> le16_to_cpup -> aligned equivalent of load_unaligned_le16
> store_le16(__le16 *, u16)
> 
> Implemented as (to allow constant folding)
> #define store_le16(ptr, val)	(*(__le16 *)(ptr) = cpu_to_le16((u16)(val)))

Again, no typechecking in store_le16(), due to the explicit cast.

> > I noticed there's also a __get_unaligned_le(), which uses compile-time
> > detection of the pointer time, to make sure the correct accessor is used.
> > Do you intend this to be used by generic code? It's function name starts
> > with double underscore, indicating otherwise.
> 
> It is not meant for generic use, it is just there as a helper for each
> arch to wire up it's get_unaligned() macro depending on its endianness,
> so each arch doesn't wire up its own version that may or may not have
> the size checking.

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
---584349381-329140865-1214392816=:9483--
