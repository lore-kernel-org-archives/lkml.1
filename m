Return-Path: <linux-kernel-owner+w=401wt.eu-S1751321AbZHXEN4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbZHXEN4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 00:13:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750787AbZHXENz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 00:13:55 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:57384 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbZHXENy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 00:13:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=o0mnqN/XiaIM6WWdpZnOv7UPPKR4D/Teztit0dGeO9t1dynS/iDmRwYGw1DupQSP5a
         SG9Qh09kzXqIKsoujNgNoEsJSvntaCvht1wlOgPD80SAn3BC9YL1THNDemsmXebeWw8x
         Y9+UuRzpoT6Lud6DGVLYREtXIZOpd3GGzG/so=
MIME-Version: 1.0
In-Reply-To: <20090824105139.c2ab8403.kamezawa.hiroyu@jp.fujitsu.com>
References: <82e12e5f0908220954p7019fb3dg15f9b99bb7e55a8c@mail.gmail.com>
	 <28c262360908231844o3df95b14v15b2d4424465f033@mail.gmail.com>
	 <20090824105139.c2ab8403.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 24 Aug 2009 13:13:56 +0900
X-Google-Sender-Auth: 6e2fa1156d5c394c
Message-ID: <2f11576a0908232113w71676aatf22eb6d431501fd0@mail.gmail.com>
Subject: Re: [PATCH] mm: make munlock fast when mlock is canceled by sigkill
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Hiroaki Wakabayashi <primulaelatior@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
       Paul Menage <menage@google.com>, Ying Han <yinghan@google.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Lee Schermerhorn <lee.schermerhorn@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch is for making commit 4779280d1e (mm: make get_user_pages()
> interruptible) complete.

Yes.
commit 4779280d1e (mm: make get_user_pages() interruptible) has never
works as expected since it's born.
IOW, it was totally broken.

This patch is definitely good forward step patch.


>> > @@ -254,6 +254,7 @@ static inline void
>> > mminit_validate_memmodel_limits(unsigned long *start_pfn,
>> >  #define GUP_FLAGS_FORCE                  0x2
>> >  #define GUP_FLAGS_IGNORE_VMA_PERMISSIONS 0x4
>> >  #define GUP_FLAGS_IGNORE_SIGKILL         0x8
>> > +#define GUP_FLAGS_ALLOW_NULL             0x10
>> >
>>
>> I am worried about adding new flag whenever we need it.
>> But I think this case makes sense to me.
>> In addition, I guess ZERO page can also use this flag.
>>
>> Kame. What do you think about it?
>>
> I do welcome this !
> Then, I don't have to take care of mlock/munlock in ZERO_PAGE patch.
>
> And without this patch, munlock() does copy-on-write just for unpinning memory.
> So, this patch shows some right direction, I think.
>
> One concern is flag name, ALLOW_NULL sounds not very good.
>
>  GUP_FLAGS_NOFAULT ?
>
> I wonder we can remove a hack of FOLL_ANON for core-dump by this flag, too.

Yeah, GUP_FLAGS_NOFAULT is better.

Plus, this patch change __get_user_pages() return value meaning IOW.
after this patch, it can return following value,

 return value: 3
 pages[0]: hoge-page
 pages[1]: null
 pages[2]: fuga-page

but, it can be

 return value: 2
 pages[0]: hoge-page
 pages[1]: fuga-page

no?
