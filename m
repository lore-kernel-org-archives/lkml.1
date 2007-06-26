Return-Path: <linux-kernel-owner+w=401wt.eu-S1754664AbXFZKDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754664AbXFZKDT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 06:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751998AbXFZKDL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 06:03:11 -0400
Received: from nz-out-0506.google.com ([64.233.162.224]:54458 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbXFZKDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 06:03:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Cy3OWZVLZ82ekRuXkzifXjgXN5G2ax+fb85HjV4o0a4gxP3lcgHX2feuGZMGjj081p/WS2cGxey4YDIKcWuEgI3brt0QTo/bzsP3N+Q9QYWhsoK7tugKGaZlNEHvT4GVUfL/linTjbGkk5aJ40z2lGXBwHF8+8k598ihJzgqKUA=
Message-ID: <e9e943910706260303l14f8a5e9n63ba0e9f7067b7f9@mail.gmail.com>
Date: Tue, 26 Jun 2007 11:03:09 +0100
From: "Duane Griffin" <duaneg@dghda.com>
To: "Roman Zippel" <zippel@linux-m68k.org>
Subject: Re: [patch 1/2] HFS+: Refactor ASCII to unicode conversion routine for later reuse
Cc: linux-kernel@vger.kernel.org, didier <did447@gmail.com>,
       "Solra Bizna" <sbizna@tejat.net>, "Daniel Drake" <dsd@gentoo.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0706251407320.1817@scrub.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070620000644.891099313@dastardly.home.dghda.com>
	 <20070620000646.186114175@dastardly.home.dghda.com>
	 <Pine.LNX.4.64.0706251407320.1817@scrub.home>
X-Google-Sender-Auth: f857095ad1be0ee1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/06/07, Roman Zippel <zippel@linux-m68k.org> wrote:
>
> I like the idea of this, but not that it generates larger code, so I
> reformatted it a little to get rid of the decomposed_uc struct which
> required an unnecessary data copy, so now the it even generates slightly
> smaller code. :)

Ah, nice one! Returning the pointer into the table is a much nicer way
of doing things.

> +               if (decompose && (dstr = decompose_unichar(c, &dsize))) {
> +                       if (outlen + dsize > HFSPLUS_MAX_STRLEN)
>                                 break;
>                         do {
> -                               ustr->unicode[outlen++] = cpu_to_be16(hfsplus_decompose_table[off++]);
> -                       } while (--size > 0);
> -                       continue;
> -               }
> -       done:
> -               ustr->unicode[outlen++] = cpu_to_be16(c);
> +                               ustr->unicode[outlen++] = cpu_to_be16(*dstr++);
> +                       } while (--dsize > 0);

Andrew's comments about the loop in the second patch apply here too, I
think. The original code did have a check for this condition, so I
guess it is a potential problem. How about this (on top of your
version of the patches):

Index: linux-2.6.21.5/fs/hfsplus/unicode.c
===================================================================
--- linux-2.6.21.5.orig/fs/hfsplus/unicode.c
+++ linux-2.6.21.5/fs/hfsplus/unicode.c
@@ -280,7 +280,9 @@ static inline u16 *decompose_unichar(wch
                return NULL;

        off = hfsplus_decompose_table[off + (uc & 0xf)];
-       *size = off & 3;
+       if ((*size = off & 3) == 0)
+               return NULL;
+
        return hfsplus_decompose_table + (off / 4);
 }

I'm using gmail to send this, so it will mess up the tabs I'm afraid :(

> bye, Roman

Cheers,
Duane.

-- 
"I never could learn to drink that blood and call it wine" - Bob Dylan
