Return-Path: <linux-kernel-owner+w=401wt.eu-S1761469AbXK2AXN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469AbXK2AXN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 19:23:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755179AbXK2AW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 19:22:59 -0500
Received: from mx1.redhat.com ([66.187.233.31]:43599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbXK2AW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 19:22:58 -0500
Date: Wed, 28 Nov 2007 22:22:47 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: void* arithmnetic
Message-ID: <20071129002247.GA12069@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	=?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>,
	linux-kernel@vger.kernel.org
References: <20071129010531.22b3a71f@werewolf>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071129010531.22b3a71f@werewolf>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Nov 29, 2007 at 01:05:31AM +0100, J.A. Magallón escreveu:
> Hi all...
> 
> Since begin of the ages the build of the nvidia driver says things like
> this:
> 
> include/asm/compat.h:210: warning: pointer of type 'void *' used in arithmetic
> 
> There are several of this warnings. The code in question for this example
> is:
> 
> static __inline__ void __user *compat_alloc_user_space(long len)
> {
>     struct pt_regs *regs = task_pt_regs(current);
>     return (void __user *)regs->rsp - len;
> }
> 
> As this is dealing with mem blocks, I suppose it's counting in bytes, so
> we could do something like:
> 
>    return (void __user *)((u8*)regs->rsp - len);
> 
> so the arithmetic knows how to inc/dec for each unity...
> I think the warning is correct and that void* arithmetic is undefined in C,
> isn't it ?

Yes, but not in gcc, the language the kernel is written 8)

It is allowed and the size of a void is 1. -Wpointer-arith disables
this.

[acme@doppio ~]$ cat voidptr.c
#include <stdio.h>

int main(int argc, char *argv[])
{
        void *ptr = argv[argc - 1];

        puts(ptr + 4);
        return 0;
}
[acme@doppio ~]$ gcc -Wall voidptr.c -o voidptr
[acme@doppio ~]$ ./a Magallón
llón
[acme@doppio ~]$ gcc -Wall -Wpointer-arith voidptr.c -o voidptr
voidptr.c: In function ‘main’:
voidptr.c:7: warning: pointer of type ‘void *’ used in arithmetic
[acme@doppio ~]$ ./a Magallón
llón
[acme@doppio ~]$

- Arnaldo
