Return-Path: <linux-kernel-owner+w=401wt.eu-S932123AbZKKXqi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123AbZKKXqi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 18:46:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757528AbZKKXqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 18:46:37 -0500
Received: from mail-fx0-f221.google.com ([209.85.220.221]:47515 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756222AbZKKXqg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 18:46:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=V50L6/F/mGpmXrs0ASoT3zpq8MWGykzpwDgIXCJ64lO1tMSD7r7tLKN47fBRPj2fUI
         DSaqadggjaDB3OMEztWu1i1GvIBpaV7ASuIsk+ONkhcETBT+tczb1b4MOsOtpt89H8UG
         ocFlgt3InXjsdVljTh5jvvrJIzZhTlLawXUyg=
MIME-Version: 1.0
In-Reply-To: <1257762136-17593-1-git-send-email-Joakim.Tjernlund@transmode.se>
References: <1257762136-17593-1-git-send-email-Joakim.Tjernlund@transmode.se>
Date: Thu, 12 Nov 2009 00:46:41 +0100
Message-ID: <25e057c00911111546w414cbebbx5e7142866b925f65@mail.gmail.com>
Subject: Re: [PATCH] zlib: Optimize inffast even more
From: roel kluin <roel.kluin@gmail.com>
To: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Cc: akpm@linux-foundation.org, Richard Purdie <rpurdie@rpsys.net>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id nABNks16012225

On Mon, Nov 9, 2009 at 11:22 AM, Joakim Tjernlund<Joakim.Tjernlund@transmode.se> wrote:> This improves zlib: Optimize inffast when copying direct from output> and gives another 3-4% improvement for my MPC8321 target.> Does not need CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS,> uses get_unaligned() but only in one place.> The copy loop just above this one can also use this> optimization, but I havn't done so as I have not tested if it> is a win there too.>> Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>> ---

> @@ -240,52 +243,49 @@ void inflate_fast(z_streamp strm, unsigned start)>                 }>                 else {>                     from = out - dist;          /* copy direct from output */> -#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS>                     /* minimum length is three */>                    if (dist > 2 ) {> -                       unsigned short *sout = (unsigned short *)(out - OFF);> -                       unsigned short *sfrom = (unsigned short *)(from - OFF);> -                       unsigned long loops = len >> 1;> +                       unsigned short *sout;> +                       unsigned short *sfrom;> +                       unsigned long loops;>> +                       /* Align out addr, only sfrom might be unaligned */> +                       if (!((long)(out - 1 + OFF)) & 1) {
I think this is wrong
did you mean
if (!((long)(out - 1 + OFF) & 1))
> +                           PUP(out) = PUP(from);> +                           len--;> +                       }> +                       sout = (unsigned short *)(out - OFF);> +                       sfrom = (unsigned short *)(from - OFF);> +                       loops = len >> 1;>                        do> -                           PUP(sout) = PUP(sfrom);> +                           PUP(sout) = UP_UNALIGNED(sfrom);>                        while (--loops);>                        out = (unsigned char *)sout + OFF;>                        from = (unsigned char *)sfrom + OFF;>                        if (len & 1)>                            PUP(out) = PUP(from);> -                   } else if (dist == 2) {> -                       unsigned short *sout = (unsigned short *)(out - OFF);> +                   } else { /* dist == 1 or dist == 2 */> +                       unsigned short *sout;>                        unsigned short pat16;> -                       unsigned long loops = len >> 1;> +                       unsigned long loops;>> +                       /* Align out addr */> +                       if (!((long)(out - 1 + OFF)) & 1) {
and
if (!((long)(out - 1 + OFF) & 1))
> +                           PUP(out) = PUP(from);> +                           len--;> +                       }> +                       sout = (unsigned short *)(out - OFF);>                        pat16 = *(sout-2+2*OFF);> +                       if (dist == 1)> +                           pat16 = (pat16 & 0xff) | ((pat16 & 0xff ) << 8);> +                       loops = len >> 1;>                        do>                            PUP(sout) = pat16;>                        while (--loops);>                        out = (unsigned char *)sout + OFF;>                        if (len & 1)>                            PUP(out) = PUP(from);> -                   } else {> -                       unsigned char pat8 = *(out - 1 + OFF);> -> -                       do {> -                           PUP(out) = pat8;> -                       } while (--len);>                    }> -#else> -                    do {                        /* minimum length is three */> -                        PUP(out) = PUP(from);> -                        PUP(out) = PUP(from);> -                        PUP(out) = PUP(from);> -                        len -= 3;> -                    } while (len > 2);> -                    if (len) {> -                        PUP(out) = PUP(from);> -                        if (len > 1)> -                            PUP(out) = PUP(from);> -                    }> -#endif>                 }>             }>             else if ((op & 64) == 0) {          /* 2nd level distance code */> --> 1.6.4.4>> --> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in> the body of a message to majordomo@vger.kernel.org> More majordomo info at  http://vger.kernel.org/majordomo-info.html> Please read the FAQ at  http://www.tux.org/lkml/>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
