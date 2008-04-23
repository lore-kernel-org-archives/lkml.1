Return-Path: <linux-kernel-owner+w=401wt.eu-S1754362AbYDWR2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754362AbYDWR2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 13:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbYDWR2g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 13:28:36 -0400
Received: from rv-out-0708.google.com ([209.85.198.240]:2345 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751916AbYDWR2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 13:28:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=qgallMiaVm6WOqesSHPgvWmkWsPyGwxiTYAS4troDhTyXoZyP43iZts4BSMqLBd6uir5Y7Bm7Jf1MOjixu28RtWg4NhHaN21y1dndx14N2UBe9ZaLJ80tdpdNRbIu6qovvhmbbG7PooGWNFq2r46iASCHBynHlcyhjQ8sEaDpgU=
Message-ID: <c4e36d110804231028t2f5096e3y924a28ceb6d45c06@mail.gmail.com>
Date: Wed, 23 Apr 2008 19:28:34 +0200
From: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, "Jiri Slaby" <jirislaby@gmail.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, paulmck@linux.vnet.ibm.com,
       "David Miller" <davem@davemloft.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <84144f020804230958h66d7f244gd90f832d403758e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>
	 <200804220254.45251.rjw@sisk.pl>
	 <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org>
	 <480DB493.6080004@gmail.com> <20080422095315.GA28014@elte.hu>
	 <c4e36d110804221135v1dbfaf1bn4557052d1ead6060@mail.gmail.com>
	 <alpine.LFD.1.10.0804221144130.2779@woody.linux-foundation.org>
	 <c4e36d110804230150n796c2733x5880b8e24ebc9da8@mail.gmail.com>
	 <alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org>
	 <84144f020804230958h66d7f244gd90f832d403758e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m3NHSvEB025022

2008/4/23, Pekka Enberg <penberg@cs.helsinki.fi>:> On Wed, Apr 23, 2008 at 6:53 PM, Linus Torvalds>  <torvalds@linux-foundation.org> wrote:>  >    Padding 0xffff8100201a0000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk>  >    ....>  >    Padding 0xffff8100201a71a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk“ê>  >    Padding 0xffff8100201a71b0:  cc cc cc cc cc cc cc cc 00 00 1a 20 00 81 ff ff –ú–ú–ú–ú–ú–ú–ú–ú......—è—è>  >    Padding 0xffff8100201a71c0:  cd 70 17 a0 ff ff ff ff 00 00 00 00 73 05 00 00 –ùp..—è—è—è—è....s...>  >    Padding 0xffff8100201a71d0:  b6 54 58 00 01 00 00 00 d5 71 26 81 ff ff ff ff ¬∂TX.....–•q&.—è—è—è—è>  >>  >    Padding 0xffff8100201a71e0:  00 00 00 00 7c 05 00 00 97 54 58 00 01 00 00 00 ....|....TX.....>  >>  >    which in turn is interesting because it very much looks like SLUB>  >    re-used a page for something else (the values that things got>  >    overwritten by are largely SLUB's own poison bytes: 6b is POISON_FREE,>  >    the a5 at the end of the list of 6b's is POISON_END, while cc is>  >    SLUB_RED_ACTIVE).>  >>  >  To me, that pattern looks like an order-3 allocation (correct: that's what>  >  kmalloc-4096 is supposed to be using!) got released, and the stuff at the>  >  end (with slub debugging, there's only room for 7 4096-byte allocations>  >  there, so 71b0 is past the end) in that SLUB debug info.>  >>  >  The first word of that busy allocation is ffff8100201a0000, which is also>  >  the base pointer to the whole order-3 page ("Free pointer"), followed by>  >  the SLAB tracking data.>>> Is the POISON_FREE ("6b") region really contiguous Zdenek? The problem>  here is that the object looks to be 29104 bytes that is subject to>  kmalloc_large() which by-passes SLUB poisoning completely.>

No - it was simply cutted - here is carefully selected same log withall different areas.
Zdenek

Padding 0xffff8100201a0000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b6b 6b kkkkkkkkkkkkkkkk201a0010:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
201a0ba0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk201a0bb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk201a0bc0:  01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................201a0bd0:  00 00 00 00 00 00 00 00 6b 6b 6b 6b 6b 6b 6b 6b ........kkkkkkkk201a0be0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk201a0bf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
201a0fe0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk201a0ff0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk¬•201a1000:  cc cc cc cc cc cc cc cc d8 30 1a 20 00 81 ff ff √å√å√å√å√å√å√å√å√ò0....√ø√ø201a1010:  cd 70 17 a0 ff ff ff ff 00 00 00 00 73 05 00 00 √çp..√ø√ø√ø√ø....s...201a1020:  b6 54 58 00 01 00 00 00 d5 71 26 81 ff ff ff ff ¬∂TX.....√ïq&.√ø√ø√ø√ø201a1030:  00 00 00 00 00 00 00 00 8c 54 58 00 01 00 00 00 .........TX.....201a1040:  5a 5a 5a 5a 5a 5a 5a 5a 6b 6b 6b 6b 6b 6b 6b 6b ZZZZZZZZkkkkkkkk201a1050:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
201a1be0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk201a1bf0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk201a1c00:  6b 6b 6b 6b 6b 6b 6b 6b 01 00 00 00 00 00 00 00 kkkkkkkk........201a1c10:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................201a1c20:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk201a1c30:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
201a2020:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk201a2030:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk201a2040:  6b 6b 6b 6b 6b 6b 6b a5 cc cc cc cc cc cc cc cc kkkkkkk¬•√å√å√å√å√å√å√å√å201a2050:  68 51 1a 20 00 81 ff ff cd 70 17 a0 ff ff ff ff hQ....√ø√ø√çp..√ø√ø√ø√ø201a2060:  00 00 00 00 73 05 00 00 b6 54 58 00 01 00 00 00 ....s...¬∂TX.....201a2070:  d5 71 26 81 ff ff ff ff 00 00 00 00 00 00 00 00 √ïq&.√ø√ø√ø√ø........201a2080:  97 54 58 00 01 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a .TX.....ZZZZZZZZ201a2090:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
201a2c40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk201a2c50:  01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................201a2c60:  00 00 00 00 00 00 00 00 6b 6b 6b 6b 6b 6b 6b 6b ........kkkkkkkk201a2c70:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
201a3070:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk201a3080:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk¬•201a3090:  cc cc cc cc cc cc cc cc 00 00 00 00 00 00 00 00 √å√å√å√å√å√å√å√å........201a30a0:  cd 70 17 a0 ff ff ff ff 00 00 00 00 73 05 00 00 √çp..√ø√ø√ø√ø....s...201a30b0:  5b 4c 58 00 01 00 00 00 d5 71 26 81 ff ff ff ff [LX.....√ïq&.√ø√ø√ø√ø201a30c0:  00 00 00 00 7c 05 00 00 f3 4b 58 00 01 00 00 00 ....|...√≥KX.....201a30d0:  5a 5a 5a 5a 5a 5a 5a 5a 6b 6b 6b 6b 6b 6b 6b 6b ZZZZZZZZkkkkkkkk201a30e0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
201a3c80:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk201a3c90:  6b 6b 6b 6b 6b 6b 6b 6b 01 00 00 00 00 00 00 00 kkkkkkkk........201a3ca0:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................201a3cb0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
201a40c0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk201a40d0:  6b 6b 6b 6b 6b 6b 6b a5 cc cc cc cc cc cc cc cc kkkkkkk¬•√å√å√å√å√å√å√å√å201a40e0:  20 41 1a 20 00 81 ff ff cd 70 17 a0 ff ff ff ff .A....√ø√ø√çp..√ø√ø√ø√ø201a40f0:  00 00 00 00 73 05 00 00 b6 54 58 00 01 00 00 00 ....s...¬∂TX.....201a4100:  d5 71 26 81 ff ff ff ff 00 00 00 00 7c 05 00 00 √ïq&.√ø√ø√ø√ø....|...201a4110:  87 54 58 00 01 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a .TX.....ZZZZZZZZ201a4120:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
201a4cd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk201a4ce0:  01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................201a4cf0:  00 00 00 00 00 00 00 00 6b 6b 6b 6b 6b 6b 6b 6b ........kkkkkkkk201a4d00:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
201a5100:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk201a5110:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk¬•201a5120:  cc cc cc cc cc cc cc cc 00 00 00 00 00 00 00 00 √å√å√å√å√å√å√å√å........201a5130:  cd 70 17 a0 ff ff ff ff 00 00 00 00 73 05 00 00 √çp..√ø√ø√ø√ø....s...201a5140:  b6 54 58 00 01 00 00 00 d5 71 26 81 ff ff ff ff ¬∂TX.....√ïq&.√ø√ø√ø√ø201a5150:  00 00 00 00 00 00 00 00 86 54 58 00 01 00 00 00 .........TX.....201a5160:  5a 5a 5a 5a 5a 5a 5a 5a 6b 6b 6b 6b 6b 6b 6b 6b ZZZZZZZZkkkkkkkk201a5170:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
201a5d10:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk201a5d20:  6b 6b 6b 6b 6b 6b 6b 6b 01 00 00 00 00 00 00 00 kkkkkkkk........201a5d30:  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................201a5d40:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
201a6150:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk201a6160:  6b 6b 6b 6b 6b 6b 6b a5 cc cc cc cc cc cc cc cc kkkkkkk¬•√å√å√å√å√å√å√å√å201a6170:  b0 61 1a 20 00 81 ff ff cd 70 17 a0 ff ff ff ff ¬∞a....√ø√ø√çp..√ø√ø√ø√ø201a6180:  00 00 00 00 73 05 00 00 b6 54 58 00 01 00 00 00 ....s...¬∂TX.....201a6190:  d5 71 26 81 ff ff ff ff 00 00 00 00 00 00 00 00 √ïq&.√ø√ø√ø√ø........201a61a0:  97 54 58 00 01 00 00 00 5a 5a 5a 5a 5a 5a 5a 5a .TX.....ZZZZZZZZ201a61b0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
201a6d60:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk201a6d70:  01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ................201a6d80:  00 00 00 00 00 00 00 00 6b 6b 6b 6b 6b 6b 6b 6b ........kkkkkkkk201a6d90:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
201a7190:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk201a71a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkk¬•201a71b0:  cc cc cc cc cc cc cc cc 00 00 1a 20 00 81 ff ff √å√å√å√å√å√å√å√å......√ø√ø201a71c0:  cd 70 17 a0 ff ff ff ff 00 00 00 00 73 05 00 00 √çp..√ø√ø√ø√ø....s...201a71d0:  b6 54 58 00 01 00 00 00 d5 71 26 81 ff ff ff ff ¬∂TX.....√ïq&.√ø√ø√ø√ø201a71e0:  00 00 00 00 7c 05 00 00 97 54 58 00 01 00 00 00 ....|....TX.....Padding 0xffff8100201a71f0:  5a 5a 5a 5a 5a 5a 5a 5a      ZZZZZZZZFIX kmalloc-4096: Restoring 0xffff8100201a0000-0xffff8100201a7e16=0x5aˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
