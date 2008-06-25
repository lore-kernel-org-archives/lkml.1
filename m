Return-Path: <linux-kernel-owner+w=401wt.eu-S1755660AbYFYCfs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660AbYFYCfs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 22:35:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbYFYCfj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 22:35:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:20973 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754285AbYFYCfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 22:35:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=pwJ3U1UZYdwCtwEdxFo71IL2icfmSeMMOcIT0XwYb8zo2G3ZimxUvBABYkcdNW7xfX
         cHXysOJHZpcT+GOfl/LKnadQMy8A0vSQ4BA+IIvQXz96YpXHuzpE60lnvPy3e8FP56z8
         qEYb5tdwa0egHbNtmGdI+4c58aEy2+MVHyNXs=
Subject: Re: byteorder helpers and void * (was: Re: [PATCH 01/21] lib: add
	byteorder helpers for the aligned case)
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Pavel Machek <pavel@ucw.cz>, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0806241445430.17853@vixen.sonytel.be>
References: <1211306721.5915.167.camel@brick> <20080523131310.GC9245@ucw.cz>
	 <Pine.LNX.4.64.0806241445430.17853@vixen.sonytel.be>
Content-Type: text/plain
Date: Tue, 24 Jun 2008 19:35:37 -0700
Message-Id: <1214361338.21092.71.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-06-24 at 14:54 +0200, Geert Uytterhoeven wrote:
> > 
> > Document the fact that void * passed in needs to be 16-bit aligned?
> 
> Why not let it just take a __le16 *? Because in many use-cases the pointer just
> points to an array of bytes?
> 
> For the unaligned case, e.g. get_unaligned_le16(), I can understand a bit the
> rationale about using void * (a typical use-case is accessing a little endian
> 16-bit value in the middle of an arrays of bytes).
> 
> However, a disadvantage is that you remove the ability of the compiler to check
> for using the wrong accessor in a (packed for the unaligned case) struct, e.g.
> 
>     struct {
> 	u8 pad;
> 	__le16 val;			/* 16-bit value */
>     } __attribute ((packed)) s;
> 
>     x = get_unaligned_le32(&s.val);	/* oops, 32-bit access */
> 

I'm starting to come around to the typechecking argument.  This would
also be a chance to fix the argument ordering in put_analigned_XXXX
that was noticed by others.  As there are already some existing users
in-tree, we could transition gradually by:

1) Introduce typed versions of get/put_unaligned_XXXX, that implies the
byteswap better:
u16 load_unaligned_le16(__le16 *)
void store_unaligned_le16(__le16 *, u16)

Then the aligned helpers could be:
le16_to_cpup -> aligned equivalent of load_unaligned_le16
store_le16(__le16 *, u16)

Implemented as (to allow constant folding)
#define store_le16(ptr, val)	(*(__le16 *)(ptr) = cpu_to_le16((u16)(val)))

> I noticed there's also a __get_unaligned_le(), which uses compile-time
> detection of the pointer time, to make sure the correct accessor is used.
> Do you intend this to be used by generic code? It's function name starts
> with double underscore, indicating otherwise.

It is not meant for generic use, it is just there as a helper for each
arch to wire up it's get_unaligned() macro depending on its endianness,
so each arch doesn't wire up its own version that may or may not have
the size checking.

Anything I missed?

Harvey

