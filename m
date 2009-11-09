Return-Path: <linux-kernel-owner+w=401wt.eu-S1755521AbZKIXik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521AbZKIXik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 18:38:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755099AbZKIXij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 18:38:39 -0500
Received: from tomts5.bellnexxia.net ([209.226.175.25]:35988 "EHLO
	tomts5-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbZKIXii convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 18:38:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjkFAC42+EpGGN1W/2dsb2JhbACBTtwdhD4EgWg
Date: Mon, 9 Nov 2009 18:38:42 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ian Lance Taylor <iant@google.com>, gcc-help@gcc.gnu.org
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: Userspace Tracepoints, -fPIC -m32 question
Message-ID: <20091109233842.GA4683@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 18:27:47 up 83 days, 10:17,  4 users,  load average: 0.52, 0.30,
	0.26
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been looking into the problem explained below for a while, and have
a hard time figuring out if it is actually possible to pass a C pointer
as gcc inline assembly immediate operand in a way that works with -fPIC
on 32-bit i386. It works fine for x86_64 (both with and w/o -fPIC) and
with 32-bit i386 w/o fPIC.

The problem on 32-bit i386 with fPIC is that the assembly generated
should contain a GOTOFF relocation because the address seems to be
treated as a global symbol. e.g., using a "m" (var) operand turns the
code presented in the forwarded message (below) into:

        .long var.1195@GOTOFF(%ecx), (1f)

Ideas and comments would be very welcome.

Thanks,

Mathieu

----- Forwarded message from Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca> -----

Date: Mon, 09 Nov 2009 16:23:10 -0500
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
From: Pierre-Marc Fournier <pierre-marc.fournier@polymtl.ca>
Subject: Questions about position-independent  code

Hi Mathieu,

Perhaps you can help with an issue I have concerning
position-independent code on x86. Or maybe you know someone who could help.

Consider the code below. It compiles perfectly well on x86-64 with or
without -fPIC.

However, on x86-32, it compiles only when the -fPIC option is not
specified. Otherwise, gcc gives the following error:

immprob.c: In function 'func':
immprob.c:15: warning: asm operand 0 probably doesn't match constraints
immprob.c:15: error: impossible constraint in 'asm'


My questions:
- Is it important to generated PIC code for libraries on x86-32? It
seems to work perfectly well to make them as non-PIC. Libtool on my
system does however put the -fPIC flag to gcc when building libraries on
x86-32.

- Assuming it is important to make PIC libraries on x86-32, can I get
the address of "var" to be but statically in the __my_section section on
this architecture?

Thanks

pmf

---

#if x86_64
#define _ASM_PTR ".quad "
#else
#define _ASM_PTR ".long "
#endif

struct mystruct {
	int myint;
};

int func()
{
        static struct mystruct var __attribute__((section("mysec2")))
		= { 0 };

        asm (".section __my_section,\"aw\",@progbits\n\t"
             _ASM_PTR "%c[addr], (1f)\n\t"
             ".previous\n\t"
             "1:\n\t"
             :: [addr] "i" (&var)
        );

        return 0;
}

	

----- End forwarded message -----

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
