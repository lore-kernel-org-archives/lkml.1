Return-Path: <linux-kernel-owner+w=401wt.eu-S1757881AbYH2QY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881AbYH2QY5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbYH2QYs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:24:48 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:32324 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbYH2QYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:24:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tL3F2d6WS60STRKysMWMVMBbY//bofuIDelfbjJ20fucBu2XHc9HZ5EddZSYXb3Ba1
         9ksFQX+FaYx3uTpmN2sRZpJRCOBYAbWJ0s683jlTonIg712J7iaNN8Owqy2bFj8vMmxA
         39UUulSjXiVlvy6k6CHLNXOf/zMbel10Ek3kw=
Subject: Re: endianness and sparse warnings
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0808291639540.15307@vixen.sonytel.be>
References: <Pine.LNX.4.64.0808291639540.15307@vixen.sonytel.be>
Content-Type: text/plain
Date: Fri, 29 Aug 2008 09:24:49 -0700
Message-Id: <1220027089.16663.12.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-08-29 at 16:54 +0200, Geert Uytterhoeven wrote:
> With `make  C=1 CF="-D__CHECK_ENDIAN__"', you can let sparse check for bad
> handling of endian-annotated data.
> 
> Unfortunately several of the accessors for endian-annotated data do not cause
> sparse warnings.

I'll try and give some background on why the unaligned versions are implemented
this way.

The get_unaligned helpers were meant to replace two kinds of use (using le16 as
an example)

char *ptr;

1 - le16_to_cpu(get_unaligned((__le16 *)ptr))
2 - u16 val = ptr[0] | (ptr[1] << 8)

The places where 1 was replaced with the unaligned helpers would have been fine
with an annotated version as it already had the cast to a proper type.

The places where 2 was replaced would have required a new cast to __le16 *.

Lots of places that were using 2 are drivers that have some data area pointed
to by a char * and they are grabbing values from there at known offsets,
for these users, the need for extra casting was quite ugly and it was known
exactly how many bytes and in what endianness you are reading as it is
right in the function name so I thought it would be ok to omit the annotation
on the parameter.

u16 foo, bar;
char *my_data;

foo = get_unaligned_le16((__le16 *)my_data); /* if unaligned helpers were annotated */
bar = get_unaligned_le16(my_data);	/* current version */

> 
> Summarized:
>   - [bl]e{16,32,64}_to_cpu() is OK
>   - [bl]e{16,32,64}_to_cpup() (aka get_aligned_[bl]e{16,32,64}() ;-) is OK
>   - get_unaligned_[bl]e{16,32,64} is not OK
>   - __get_unaligned_[bl]e() is partially OK, as long as you don't use it on
>     non-annotated data, but
>       o it's meant for internal use only
>       o it incorrectly causes sparse warnings when assigning the resulting
>         value to a non-annotated variable

Almost... __get_unaligned_le16 etc are _never_ to be used...as some arches
choose to use memmove-based implementations, and on arches where unaligned
access is OK, they don't exist _at_all_.

Cheers,

Harvey

