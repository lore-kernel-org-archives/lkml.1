Return-Path: <linux-kernel-owner+w=401wt.eu-S1754640AbYAQAgz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754640AbYAQAgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 19:36:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750861AbYAQAgr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 19:36:47 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:40885 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750943AbYAQAgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 19:36:46 -0500
Date: Wed, 16 Jan 2008 19:36:30 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Thomas Gleixner <tglx@linutronix.de>, Tim Bird <tim.bird@am.sony.com>,
       Sam Ravnborg <sam@ravnborg.org>, "Frank Ch. Eigler" <fche@redhat.com>,
       Steven Rostedt <srostedt@redhat.com>, Paul Mackerras <paulus@samba.org>,
       Daniel Walker <dwalker@mvista.com>
Subject: Re: [RFC PATCH 16/22 -v2] add get_monotonic_cycles
In-Reply-To: <Pine.LNX.4.58.0801161845130.17781@gandalf.stny.rr.com>
Message-ID: <Pine.LNX.4.58.0801161934500.17781@gandalf.stny.rr.com>
References: <20080109233044.777564395@goodmis.org> <20080115214636.GD17439@Krystal>
 <Pine.LNX.4.58.0801151658190.29090@gandalf.stny.rr.com> <20080115220824.GB22242@Krystal>
 <Pine.LNX.4.58.0801151717250.29090@gandalf.stny.rr.com> <20080116031730.GA2164@Krystal>
 <Pine.LNX.4.58.0801152238130.19680@gandalf.stny.rr.com> <20080116145604.GB31329@Krystal>
 <1f1b08da0801161436k4a7ac1e3kd83590951e7bebb9@mail.gmail.com>
 <1200523867.6127.5.camel@localhost.localdomain> <20080116233927.GB23895@Krystal>
 <Pine.LNX.4.58.0801161845130.17781@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jan 2008, Steven Rostedt wrote:
> On Wed, 16 Jan 2008, Mathieu Desnoyers wrote:
> >
> > !0 is not necessarily 1. This is why I use cpu_synth->index ? 0 : 1 in
>
> How about simply "cpu_synth->index ^ 1"? Seems the best choice if you ask
> me, if all you are doing is changing it from 1 to zero and back to 1.
>

FYI:

rostedt@bilbo:~/c$ cat flipme.c
int flip1 (int x)
{
        return !x;
}

int flip2 (int x)
{
        return x ? 0 : 1;
}

int flip3(int x)
{
        return x ^ 1;
}
rostedt@bilbo:~/c$ gcc -O2 -c flipme.c
rostedt@bilbo:~/c$ objdump -d flipme.o

flipme.o:     file format elf32-i386

Disassembly of section .text:

00000000 <flip1>:
   0:   55                      push   %ebp
   1:   31 c0                   xor    %eax,%eax
   3:   89 e5                   mov    %esp,%ebp
   5:   83 7d 08 00             cmpl   $0x0,0x8(%ebp)
   9:   5d                      pop    %ebp
   a:   0f 94 c0                sete   %al
   d:   c3                      ret
   e:   66 90                   xchg   %ax,%ax

00000010 <flip2>:
  10:   55                      push   %ebp
  11:   31 c0                   xor    %eax,%eax
  13:   89 e5                   mov    %esp,%ebp
  15:   83 7d 08 00             cmpl   $0x0,0x8(%ebp)
  19:   5d                      pop    %ebp
  1a:   0f 94 c0                sete   %al
  1d:   c3                      ret
  1e:   66 90                   xchg   %ax,%ax

00000020 <flip3>:
  20:   55                      push   %ebp
  21:   89 e5                   mov    %esp,%ebp
  23:   8b 45 08                mov    0x8(%ebp),%eax
  26:   5d                      pop    %ebp
  27:   83 f0 01                xor    $0x1,%eax
  2a:   c3                      ret


So, if you know for sure that x is only 1 or 0, then using x ^ 1 to invert
it, seems the most efficient.

-- Steve

