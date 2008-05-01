Return-Path: <linux-kernel-owner+w=401wt.eu-S932282AbYEATs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbYEATs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 15:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760558AbYEATsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 15:48:15 -0400
Received: from wr-out-0506.google.com ([64.233.184.224]:37432 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761231AbYEATsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 15:48:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NlAmfNV0pHtkSz/JU18cpkLsCxv8arYxjJ44iipXoXadJU05q3uZoX36ElmtYqcQFDRnuKSIR0KmxIC+VxedYO2GtNDuVddZamnhVKijRiqs9iQ3/ZzJgYMXY0VgtSxqZKytIth4OnKPn7ZClsI7/GGmLKfxOT4V3PiMT73Oe2E=
Subject: Re: [PATCH] kernel: add helpers for ascii character conversion
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080501124317.089a0d02.akpm@linux-foundation.org>
References: <1209669780.24729.151.camel@brick>
	 <20080501124317.089a0d02.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 01 May 2008 12:48:30 -0700
Message-Id: <1209671310.24729.157.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-05-01 at 12:43 -0700, Andrew Morton wrote:
> On Thu, 01 May 2008 12:23:00 -0700
> Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > Add helpers for getting an ascii hex char for the high and low
> > nibble of a byte.  Also add a small helper to get an integer
> > value from a given hex char.
> > 
> > Included here are a few of the current places that roll their
> > own versions being moved to the common helper.
> 
> ahh, someone cares ;)

Well, I have an interest in collecting bits of useful infrastructure
everyone and their dog has reimplemented somewhere in the tree.

> 
> Does this mean that
> 
> y:/usr/src/linux-2.6.25> grep -ri '"0123456789abcdef"' . | wc -l
> 40
> 
> will decrease?

Somewhat, I debated between the kernel.h route and adding an out-of-line
version to hexdump.c.  While gcc/ld has gotten better about this, may
as well make it easy.

> 
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -277,6 +277,21 @@ extern void print_hex_dump(const char *level, const char *prefix_str,
> >  extern void print_hex_dump_bytes(const char *prefix_str, int prefix_type,
> >  			const void *buf, size_t len);
> >  #define hex_asc(x)	"0123456789abcdef"[x]
> > +#define hex_asc_lo(x)	hex_asc(((x) & 0x0f))
> > +#define hex_asc_hi(x)	hex_asc(((x) & 0xf0) >> 4)
> 
> umm, this might mean that each .c file which uses hex_asc_lo/hi gets
> its own copy of "0123456789abcdef".  I believe that gcc/ld are getting
> better at handling this, but I haven't checked, and I don't know which
> versions get it right nor in which way.  etc.
> 
> So it might be better to give the kernel the One True Digitstring in
> lib/something.c and export that to modules.
> 
> > +static inline u8 hex_to_int(char ch)
> > +{
> > +	/*
> > +	 * Make ch lower-case, works only for digits and letters
> > +	 */
> > +	ch |= 0x20;
> > +	if ((ch >= 'a') && (ch <= 'f'))
> > +		return (ch - 'a' + 10);
> > +	if ((ch >= '0') && (ch <= '9'))
> > +		return (ch - '0');
> > +	return (-1);
> > +}
> 
> probably should be uninlined.
> 
> return-is-not-a-function ;)

...you didn't even blink at my last-minute change from returning int
to u8 that was, how to say, ill-advised now that I look again :(

In any event, I'll go the lib/hexdump route and send that in a bit.

Cheers,

Harvey

