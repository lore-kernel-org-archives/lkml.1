Return-Path: <linux-kernel-owner+w=401wt.eu-S935441AbYEUNbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935441AbYEUNbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 09:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763188AbYEUNbk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 09:31:40 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:55258 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762905AbYEUNbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 09:31:39 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AroFAKjBM0hMQWqh/2dsb2JhbACBVa5k
Date: Wed, 21 May 2008 09:31:22 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix immediate asm constraint for gcc 3 x86_64
Message-ID: <20080521133122.GA18084@Krystal>
References: <482AB6C5.4060604@goop.org> <20080516124811.GC4226@Krystal> <482DFD65.10300@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <482DFD65.10300@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 09:18:43 up 82 days,  9:29,  3 users,  load average: 1.07, 1.38,
	1.21
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
>
>> It seems that include/asm-x86/immediate.h in sched-devel.git causes
>> this. gcc-3.4 does not seem to like the "i" (&name##__imv) constraint. I
>> have seen no such problem with gcc-4.1. This is weird. It seems that
>> relaxing the constraint helps fixing this, but it's not clear whether
>> fixing the code or gcc-3.4 is the correct solution... here is the fix :
>> Fix immediate asm constraint for gcc 3 x86_64
>
> It might make it compile, but it's completely *wrong* for the purpose 
> intended.
>
> It permits gcc to present the address in a register, for example, so there 
> is no guarantee that you end up with an immediate.
>
> 	-hpa

Hrm, you are right. Let's see a simple toy case which generates the
problem :

struct test_struct {
  int a;
  int b;
  int c;
};

static struct test_struct testa;

int main()
{
        asm (
             ".quad %c0\n\t"
                :
                : "i" (&testa.c));
        return 0;
}

gcc 4.1 generates :  .quad testa+8

and doesn't complain. However, gcc-3.4 stops with :
compudj@amd64:~/test$ gcc-3.4 -S -o oldgcc.S oldgcc.c
oldgcc.c: In function `main':
oldgcc.c:11: warning: asm operand 0 probably doesn't match constraints
oldgcc.c:11: error: impossible constraint in `asm'

It's understandable given that changing the "i" for a "g" constraint
changes the assembly result for :

        movl    $testa, %eax
        addq    $8, %rax
#APP
        .quad %rax

#NO_APP

Is there any way we could get a symbol assigned to &testa.c to make gcc
3 happy ?

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
