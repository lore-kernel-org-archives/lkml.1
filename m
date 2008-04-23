Return-Path: <linux-kernel-owner+w=401wt.eu-S1754292AbYDWQ7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754292AbYDWQ7H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 12:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbYDWQ6y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 12:58:54 -0400
Received: from el-out-1112.google.com ([209.85.162.180]:16555 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342AbYDWQ6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 12:58:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=Cok2wcDBNM6tk7F5YgU44cCjopC9VMLCQnxTbPsfOmZzbQK7q7LvlY2BEWYyiEYtq7mBwFQPKprur/Ndvf+i8G6bfttaCz/1h3nVHwu5SRM86KKXdiGSwe3V9cvmjb/xuXEDtJ2x4iP7UfwheV9G3S0b7Syc7eyKxlXrLXtP+DM=
Message-ID: <84144f020804230958h66d7f244gd90f832d403758e@mail.gmail.com>
Date: Wed, 23 Apr 2008 19:58:50 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: 2.6.25-git2: BUG: unable to handle kernel paging request at ffffffffffffffff
Cc: "Zdenek Kabelac" <zdenek.kabelac@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Jiri Slaby" <jirislaby@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       paulmck@linux.vnet.ibm.com, "David Miller" <davem@davemloft.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
       herbert@gondor.apana.org.au, "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
References: <alpine.LFD.1.10.0804201410090.2779@woody.linux-foundation.org>
	 <480D208A.9050909@gmail.com> <200804220254.45251.rjw@sisk.pl>
	 <alpine.LFD.1.10.0804211759030.2779@woody.linux-foundation.org>
	 <480DB493.6080004@gmail.com> <20080422095315.GA28014@elte.hu>
	 <c4e36d110804221135v1dbfaf1bn4557052d1ead6060@mail.gmail.com>
	 <alpine.LFD.1.10.0804221144130.2779@woody.linux-foundation.org>
	 <c4e36d110804230150n796c2733x5880b8e24ebc9da8@mail.gmail.com>
	 <alpine.LFD.1.10.0804230746480.2779@woody.linux-foundation.org>
X-Google-Sender-Auth: 89f5b649ba4101bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m3NGxEEB024349

On Wed, Apr 23, 2008 at 6:53 PM, Linus Torvalds<torvalds@linux-foundation.org> wrote:>    Padding 0xffff8100201a0000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk>    ....>    Padding 0xffff8100201a71a0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5 kkkkkkkkkkkkkkkÒ>    Padding 0xffff8100201a71b0:  cc cc cc cc cc cc cc cc 00 00 1a 20 00 81 ff ff ĞœĞœĞœĞœĞœĞœĞœĞœ......ÑÑ>    Padding 0xffff8100201a71c0:  cd 70 17 a0 ff ff ff ff 00 00 00 00 73 05 00 00 Ğp..ÑÑÑÑ....s...>    Padding 0xffff8100201a71d0:  b6 54 58 00 01 00 00 00 d5 71 26 81 ff ff ff ff Â¶TX.....Ğ¥q&.ÑÑÑÑ>>    Padding 0xffff8100201a71e0:  00 00 00 00 7c 05 00 00 97 54 58 00 01 00 00 00 ....|....TX.....>>    which in turn is interesting because it very much looks like SLUB>    re-used a page for something else (the values that things got>    overwritten by are largely SLUB's own poison bytes: 6b is POISON_FREE,>    the a5 at the end of the list of 6b's is POISON_END, while cc is>    SLUB_RED_ACTIVE).>>  To me, that pattern looks like an order-3 allocation (correct: that's what>  kmalloc-4096 is supposed to be using!) got released, and the stuff at the>  end (with slub debugging, there's only room for 7 4096-byte allocations>  there, so 71b0 is past the end) in that SLUB debug info.>>  The first word of that busy allocation is ffff8100201a0000, which is also>  the base pointer to the whole order-3 page ("Free pointer"), followed by>  the SLAB tracking data.
Is the POISON_FREE ("6b") region really contiguous Zdenek? The problemhere is that the object looks to be 29104 bytes that is subject tokmalloc_large() which by-passes SLUB poisoning completely.
                        Pekkaÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
