Return-Path: <linux-kernel-owner+w=401wt.eu-S1946433AbXBINGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946433AbXBINGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 08:06:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946436AbXBINGk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 08:06:40 -0500
Received: from postfix2-g20.free.fr ([212.27.60.43]:50012 "EHLO
	postfix2-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946433AbXBINGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 08:06:39 -0500
Message-ID: <1171029910.45cc7f967fdfe@imp.free.fr>
Date: Fri, 09 Feb 2007 15:05:10 +0100
From: deweerdt@free.fr
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Frederik Deweerdt <deweerdt@free.fr>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de
Subject: Re: -mm merge plans for 2.6.21
References: <20070208150710.1324f6b4.akpm@linux-foundation.org>  <Pine.LNX.4.61.0702090023270.24888@yvahk01.tjqt.qr>  <20070209105737.GF5785@slug>  <1171020273.8675.150.camel@laptopd505.fenrus.org>  <20070209033936.41be141b.akpm@linux-foundation.org> <1171024332.8675.155.camel@laptopd505.fenrus.org>
In-Reply-To: <1171024332.8675.155.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
User-Agent: Internet Messaging Program (IMP) 3.2.5
X-Originating-IP: 217.128.241.130
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Arjan van de Ven <arjan@infradead.org>:

>
> >
> > As long as nobody takes the address of them (which wouldn't compile today
> > anyway) then the compiler should be able to not allocate store for these.
> > That they're const might help too.
>
> are you really sure?
I've run some tests, and the compiler seems to do the right thing -I must admit,
that I trusted the compiler to do it blindly on my first attempt :)- , see
below:
> cat flag.h
static const int __attribute__((__deprecated__)) SA_INTERRUPT = 0x123456;
> cat use_flag.c
#include <stdio.h>
#include "flag.h"

int main()
{
        int flags = SA_INTERRUPT;
        printf("%d", flags);
}
> cat dont_use_flag.c
#include <stdio.h>
#include "flag.h"

int main()
{
        int flags = 0;
        printf("%d", flags);
}
> gcc --version
gcc (GCC) 4.1.1 (Gentoo 4.1.1-r3)
> for i in  *use_flag.c; do gcc -o $(echo $i | sed 's/.c//') -O2 -g $i; done
use_flag.c: In function 'main':
use_flag.c:6: warning: 'SA_INTERRUPT' is deprecated (declared at flag.h:1)
> size *use_flag
   text    data     bss     dec     hex filename
    897     260       4    1161     489 dont_use_flag
    897     260       4    1161     489 use_flag

# The relevant parts of the compiled code, see how the flag is replaced with
# the const value in the code. It does not result in a code size increment.
> objdump -d {dont_,}use_flag | grep -A11 '<main>'
080483b0 <main>:
 80483b0:       8d 4c 24 04             lea    0x4(%esp),%ecx
 80483b4:       83 e4 f0                and    $0xfffffff0,%esp
 80483b7:       ff 71 fc                pushl  0xfffffffc(%ecx)
 80483ba:       31 c0                   xor    %eax,%eax
 80483bc:       55                      push   %ebp
 80483bd:       89 e5                   mov    %esp,%ebp
 80483bf:       51                      push   %ecx
 80483c0:       83 ec 14                sub    $0x14,%esp
 80483c3:       89 44 24 04             mov    %eax,0x4(%esp)
 80483c7:       c7 04 24 b8 84 04 08    movl   $0x80484b8,(%esp)
 80483ce:       e8 05 ff ff ff          call   80482d8 <printf@plt>
--
080483b0 <main>:
 80483b0:       8d 4c 24 04             lea    0x4(%esp),%ecx
 80483b4:       83 e4 f0                and    $0xfffffff0,%esp
 80483b7:       ff 71 fc                pushl  0xfffffffc(%ecx)
 80483ba:       b8 56 34 12 00          mov    $0x123456,%eax
 80483bf:       55                      push   %ebp
 80483c0:       89 e5                   mov    %esp,%ebp
 80483c2:       51                      push   %ecx
 80483c3:       83 ec 14                sub    $0x14,%esp
 80483c6:       89 44 24 04             mov    %eax,0x4(%esp)
 80483ca:       c7 04 24 b8 84 04 08    movl   $0x80484b8,(%esp)
 80483d1:       e8 02 ff ff ff          call   80482d8 <printf@plt>


======== With 3.4.3 ==========

$ gcc --version
gcc (GCC) 3.4.3 20050227 (Red Hat 3.4.3-22.fc3)
$ size {dont_,}use_flag
   text    data     bss     dec     hex filename
    851     256       4    1111     457 dont_use_flag
    855     256       4    1115     45b use_flag
[def@bigboss ~]$ objdump -d {dont_,}use_flag | grep -A11 '<main>'
08048368 <main>:
 8048368:       55                      push   %ebp
 8048369:       89 e5                   mov    %esp,%ebp
 804836b:       83 ec 08                sub    $0x8,%esp
 804836e:       83 e4 f0                and    $0xfffffff0,%esp
 8048371:       83 ec 18                sub    $0x18,%esp
 8048374:       6a 00                   push   $0x0
 8048376:       68 64 84 04 08          push   $0x8048464
 804837b:       e8 30 ff ff ff          call   80482b0 <printf@plt>

--
08048368 <main>:
 8048368:       55                      push   %ebp
 8048369:       89 e5                   mov    %esp,%ebp
 804836b:       83 ec 08                sub    $0x8,%esp
 804836e:       83 e4 f0                and    $0xfffffff0,%esp
 8048371:       83 ec 18                sub    $0x18,%esp
 8048374:       68 56 34 12 00          push   $0x123456
 8048379:       68 68 84 04 08          push   $0x8048468
 804837e:       e8 2d ff ff ff          call   80482b0 <printf@plt>

So I'd say that both in 3.4.3 and 4.1.1, no extra space is needed for the "const
static int" flag.

Regards,
Frederik
