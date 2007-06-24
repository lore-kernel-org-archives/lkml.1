Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbXFXM6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbXFXM6V (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 08:58:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbXFXM6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 08:58:13 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:49387 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754755AbXFXM6M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 08:58:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=VYbWi5GNEcTVg7X5eQFAWyjKd4QEdeCuC23c2IxWGr/RPJiXwkz6WFOAraQdmsCR1Vic8Z/03o5IzJ0Oha6p6kqpYxQzrjTrkNlSgu7Q42qoYfclWOdJBAJpF/ynpkMnhr9mqy2gXcjVXaLqv/ZrpkDKBJLhmYUwt58wruPYuMI=
Message-ID: <91b13c310706240558p70dbaed2g570b57ab480aa974@mail.gmail.com>
Date: Sun, 24 Jun 2007 20:58:10 +0800
From: "rae l" <crquan@gmail.com>
To: "Oleg Verych" <olecom@flower.upol.cz>
Subject: Re: [PATCH] trivial: the memset operation on a automatic array variable should be optimized out by data initialization
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <E1I20Wr-00064i-T0@flower>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <467cac85.081b600a.5b88.457f@mx.google.com>
	 <E1I20Wr-00064i-T0@flower>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/23/07, Oleg Verych <olecom@flower.upol.cz> wrote:
> Why not just show actual objdump output on code (maybe with different
> oxygen atoms used in gcc), rather than *talking* about optimization and
> standards, hm?
here is the objdump output of the two object files:
As you could see, the older one used 0x38 bytes stack space while the
new one used 0x28 bytes,
and the object code is two bytes less,
I think all these benefits are the gcc's __builtin_memset optimization
than the explicit call to memset.

$ objdump -d /tmp/init.orig.o|grep -A23 -nw '<paging_init>'
525:0000000000000395 <paging_init>:
526- 395:       48 83 ec 38             sub    $0x38,%rsp
527- 399:       48 8d 54 24 10          lea    0x10(%rsp),%rdx
528- 39e:       fc                      cld
529- 39f:       31 c0                   xor    %eax,%eax
530- 3a1:       48 89 d7                mov    %rdx,%rdi
531- 3a4:       ab                      stos   %eax,%es:(%rdi)
532- 3a5:       ab                      stos   %eax,%es:(%rdi)
533- 3a6:       ab                      stos   %eax,%es:(%rdi)
534- 3a7:       ab                      stos   %eax,%es:(%rdi)
535- 3a8:       ab                      stos   %eax,%es:(%rdi)
536- 3a9:       48 89 7c 24 08          mov    %rdi,0x8(%rsp)
537- 3ae:       ab                      stos   %eax,%es:(%rdi)
538- 3af:       48 c7 44 24 10 00 10    movq   $0x1000,0x10(%rsp)
539- 3b6:       00 00
540- 3b8:       48 c7 44 24 18 00 00    movq   $0x100000,0x18(%rsp)
541- 3bf:       10 00
542- 3c1:       48 8b 05 00 00 00 00    mov    0(%rip),%rax        #
3c8 <paging_init+0x33>
543- 3c8:       48 89 44 24 20          mov    %rax,0x20(%rsp)
544- 3cd:       48 89 d7                mov    %rdx,%rdi
545- 3d0:       e8 00 00 00 00          callq  3d5 <paging_init+0x40>
546- 3d5:       48 83 c4 38             add    $0x38,%rsp
547- 3d9:       c3                      retq
548-
$ objdump -d /tmp/init.new.o|grep -A23 -nw '<paging_init>'
525:0000000000000395 <paging_init>:
526- 395:       48 83 ec 28             sub    $0x28,%rsp
527- 399:       48 89 e7                mov    %rsp,%rdi
528- 39c:       fc                      cld
529- 39d:       31 c0                   xor    %eax,%eax
530- 39f:       ab                      stos   %eax,%es:(%rdi)
531- 3a0:       ab                      stos   %eax,%es:(%rdi)
532- 3a1:       ab                      stos   %eax,%es:(%rdi)
533- 3a2:       ab                      stos   %eax,%es:(%rdi)
534- 3a3:       ab                      stos   %eax,%es:(%rdi)
535- 3a4:       ab                      stos   %eax,%es:(%rdi)
536- 3a5:       48 c7 04 24 00 10 00    movq   $0x1000,(%rsp)
537- 3ac:       00
538- 3ad:       48 c7 44 24 08 00 00    movq   $0x100000,0x8(%rsp)
539- 3b4:       10 00
540- 3b6:       48 8b 05 00 00 00 00    mov    0(%rip),%rax        #
3bd <paging_init+0x28>
541- 3bd:       48 89 44 24 10          mov    %rax,0x10(%rsp)
542- 3c2:       48 89 e7                mov    %rsp,%rdi
543- 3c5:       e8 00 00 00 00          callq  3ca <paging_init+0x35>
544- 3ca:       48 83 c4 28             add    $0x28,%rsp
545- 3ce:       c3                      retq
546-
547-00000000000003cf <alloc_low_page>:
548- 3cf:       41 56                   push   %r14


>
> I bet, that will be a key for success. And if you are interested in such
> optimizations, why not to grep whole source tree for this kind of
> things? I'm not sure one function in arch/x86_64 is only such ``unoptimized''.
> And after doing that maybe you will see, that "{}" initializer can be
> applied not only to integer values (you did init with of *long int*,
> with *int*, btw), but to structs and others.
with '{}' initializer, gcc will fill its memory with zeros.

to other potential points to be optimized, I only see this trivial as
the first point, I wonder how people gives comments on this; and if
this optimization can be tested correctly, this can be done as an
optimization example and I'll try others.

>
> Ahh, one more thing about _optimizing_ your time, i.e. not wasting one.
>
> Add to CC list people, who already did reply on you patch. Otherwise
> you are showing your disrespect for them and hiding from further
> discussion.
Thank you, I know it and I've already subscribed the linux kernel
mailing list(linux-kernel@vger.kernel.org) so that I won't miss any
further discussion about it.

>
> I think you do not, but Linux development not have an automatic system
> for patch tracking, so you are on your own with your text editor and
> e-mail client on this. Please take care for your time.
What about that?
Do you mean something such as git by "an automatic system"?

>
> --
>   frenzy
> -o--=O`C
>  #oo'L O
> <___=E M
>


-- 
Denis Cheng
Linux Application Developer
