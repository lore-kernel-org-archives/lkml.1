Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbYIAJYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbYIAJYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 05:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752859AbYIAJYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 05:24:03 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:46872 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752805AbYIAJYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 05:24:01 -0400
Date: Mon, 1 Sep 2008 11:23:48 +0200 (CEST)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Harvey Harrison <harvey.harrison@gmail.com>
cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: endianness and sparse warnings
In-Reply-To: <1220027089.16663.12.camel@brick>
Message-ID: <Pine.LNX.4.64.0809011115320.24060@vixen.sonytel.be>
References: <Pine.LNX.4.64.0808291639540.15307@vixen.sonytel.be>
 <1220027089.16663.12.camel@brick>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-1876436310-1220261028=:24060"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-1876436310-1220261028=:24060
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Fri, 29 Aug 2008, Harvey Harrison wrote:
> On Fri, 2008-08-29 at 16:54 +0200, Geert Uytterhoeven wrote:
> > With `make  C=1 CF="-D__CHECK_ENDIAN__"', you can let sparse check for bad
> > handling of endian-annotated data.
> > 
> > Unfortunately several of the accessors for endian-annotated data do not cause
> > sparse warnings.
> 
> I'll try and give some background on why the unaligned versions are implemented
> this way.
> 
> The get_unaligned helpers were meant to replace two kinds of use (using le16 as
> an example)
> 
> char *ptr;
> 
> 1 - le16_to_cpu(get_unaligned((__le16 *)ptr))
> 2 - u16 val = ptr[0] | (ptr[1] << 8)
> 
> The places where 1 was replaced with the unaligned helpers would have been fine
> with an annotated version as it already had the cast to a proper type.
> 
> The places where 2 was replaced would have required a new cast to __le16 *.
> 
> Lots of places that were using 2 are drivers that have some data area pointed
> to by a char * and they are grabbing values from there at known offsets,
> for these users, the need for extra casting was quite ugly and it was known
> exactly how many bytes and in what endianness you are reading as it is
> right in the function name so I thought it would be ok to omit the annotation
> on the parameter.
> 
> u16 foo, bar;
> char *my_data;
> 
> foo = get_unaligned_le16((__le16 *)my_data); /* if unaligned helpers were annotated */
> bar = get_unaligned_le16(my_data);	/* current version */

Indeed, if you have a void/char *, this works, and there's not much annotation
you can do here.

But please consider this case:

    struct xxx {
	u8 a;
	__le16 b;
    } __attribute__ ((packed));

    struct xxx *p;
    u16 foo = get_unaligned_le16(&p->b);

Here you could have typechecking.
Note that a `get_unaligned_le()' that handles different sizes automatically
would work.

> > Summarized:
> >   - [bl]e{16,32,64}_to_cpu() is OK
> >   - [bl]e{16,32,64}_to_cpup() (aka get_aligned_[bl]e{16,32,64}() ;-) is OK
> >   - get_unaligned_[bl]e{16,32,64} is not OK
> >   - __get_unaligned_[bl]e() is partially OK, as long as you don't use it on
> >     non-annotated data, but
> >       o it's meant for internal use only
> >       o it incorrectly causes sparse warnings when assigning the resulting
> >         value to a non-annotated variable
> 
> Almost... __get_unaligned_le16 etc are _never_ to be used...as some arches
> choose to use memmove-based implementations, and on arches where unaligned
> access is OK, they don't exist _at_all_.

So perhaps we want a public get_unaligned_[bl]e() for the case above?

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-1876436310-1220261028=:24060--
