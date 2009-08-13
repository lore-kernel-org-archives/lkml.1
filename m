Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbZHMQjt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbZHMQjt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 12:39:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbZHMQjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 12:39:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:62703 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317AbZHMQjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 12:39:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Michael Schnell <mschnell@lumino.de>
Subject: Re: implementing Futex
Date: Thu, 13 Aug 2009 18:39:41 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-5-generic; KDE/4.3.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>
References: <4A842B32.5030401@lumino.de>
In-Reply-To: <4A842B32.5030401@lumino.de>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200908131839.41803.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18b+LaSrIwW7nQnNDrCuundpbyqURoojuNFLJs
 12bevDYINNHX1QMxdPZHDRWtNAfkM5ONJiYOr3gNUZ7AzIh0I1
 p1i/tmOAIYa47yrcwix3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 August 2009, Michael Schnell wrote:
> I am planning to implement a Futex on the upcoming MMU-enabled NIOS
> architecture.

Ah, I'm always interested in new architectures. Are you already using
all the asm-generic header files that we have in 2.6.31? Please tell
me if you find problems with those.

> One of the tasks is to provide the appropriate atomic user-space
> operations for the Futex implementation. I was able to successfully do
> this for the x86 user space code and we have been discussing, how to do
>  this with other archs.
> 
> Now in the Kernel code in "linux-2.6/arch/x86/include/asm/futex.h" there
> are two different implementations for some atomic operations for the  Futex:
> 
> "futex_atomic_op_inuser()"    and
> "futex_atomic_cmpxhg__inatomic()"

Common trap. Just don't look at any x86 code when implementing
a new architecture. The code isn't necessarily bad, but much of
it has either too much compatibility crap for old interfaces, or
it optimizes some functionality much more than you'd care for.

In case of futex, look at how arch/sh does it. As Mike Frysinger
mentioned in http://lkml.org/lkml/2009/7/3/70 , the asm-generic
version is currently lacking functionality and we should use
the sh version for new stuff. 

Feel free to submit a patch that implements the operations correctly
for non-SMP architectures in include/asm-generic/futex.h.

> "futex_atomic_op_inuser()" seemingly accesses user space data while
> being run in Kernel space (doing the .section __ex_table trick).
> 
> Questions:
> 
> Is this correct ?

yes.
 
> In a non-SMP environment do we need to use really atomic code here, or
> does futex_atomic_op_inuser() run with interrupt disabled, anyway?

The sh version just disables interrupts to get atomicity.

> From reading the code (futex_atomic_op_inuser() seems only to be called
> once (in futex.c) ), it seems that futex_atomic_op_inuser() is not
> really used at all. It seems that it'd only called for futex_wake, and
> here the "Operation" is derived from the last parameter of the system
> call, which the man page says is ignored.  So, are all the operations
> implemented there really necessary or just "nice to have" ?

You misread futex_wake_op(). The operation comes from the second parameter
of the syscall, not the last one.

	Arnd <><
