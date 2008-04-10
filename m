Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbYDJQUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbYDJQUm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 12:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755867AbYDJQUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 12:20:34 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51359 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573AbYDJQUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 12:20:33 -0400
Date: Thu, 10 Apr 2008 12:20:31 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Andy Whitcroft <apw@shadowen.org>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, akpm@linux-foundation.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Jan Beulich <jbeulich@novell.com>, Thomas Gleixner <tglx@linutronix.de>,
       pinskia@gcc.gnu.org
Subject: Re: [PATCH] pop previous section in alternative.c
In-Reply-To: <47FE3B24.4020301@zytor.com>
Message-ID: <Pine.LNX.4.58.0804101219170.7952@gandalf.stny.rr.com>
References: <Pine.LNX.4.58.0804091859400.31879@gandalf.stny.rr.com>
 <Pine.LNX.4.58.0804091906040.31970@gandalf.stny.rr.com> <47FD5D42.5000603@zytor.com>
 <87wsn6m6zt.fsf@basil.nowhere.org> <20080410094637.GW17915@shadowen.org>
 <Pine.LNX.4.58.0804101007510.5673@gandalf.stny.rr.com>
 <20080410144114.GH10019@one.firstfloor.org>
 <alpine.LFD.1.00.0804100741430.3143@woody.linux-foundation.org>
 <20080410150544.GI10019@one.firstfloor.org>
 <alpine.LFD.1.00.0804100811400.3143@woody.linux-foundation.org>
 <47FE3B24.4020301@zytor.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Apr 2008, H. Peter Anvin wrote:

> Linus Torvalds wrote:
> >
> > That would mark gcc itself as buggy, because gcc will move some things
> > into the #APP/#NO_APP thing, and sometimes doesn't end the #APP at all!
> >
>
> That is quite buggy indeed, since the whole #APP and #NO_APP string set
> are arbitrary strings that are part of the gcc configuration, marked as
> "what to insert before user assembly" and "what to insert after user
> assembly."  They are not guaranteed to be simple comments, in fact.
>
> In fact, gas *is* sensitive to #APP ... #NO_APP, so they are not simple
> comments.

Looking at the output below, shows that testing .sections in between
#APP and #NO_APP would in fact catch this bug.

-- Steve

.Ltext0:
#APP
                .section .rodata, "a"
intelnops: .byte 0x90
.byte 0x89,0xf6
.byte 0x8d,0x76,0x00
.byte 0x8d,0x74,0x26,0x00
.byte 0x90
.byte 0x8d,0x74,0x26,0x00
.byte 0x8d,0xb6,0x00,0x00,0x00,0x00
.byte 0x8d,0xb4,0x26,0x00,0x00,0x00,0x00
.byte 0x90
.byte 0x8d,0xb4,0x26,0x00,0x00,0x00,0x00

                .section .rodata, "a"
k8nops: .byte 0x90
.byte 0x66,0x90
.byte 0x66,0x66,0x90
.byte 0x66,0x66,0x66,0x90
.byte 0x66,0x66,0x90
.byte 0x66,0x90
.byte 0x66,0x66,0x90
.byte 0x66,0x66,0x90
.byte 0x66,0x66,0x66,0x90
.byte 0x66,0x66,0x90
.byte 0x66,0x66,0x66,0x90
.byte 0x66,0x66,0x66,0x90

                .section .rodata, "a"
k7nops: .byte 0x90
.byte 0x8b,0xc0
.byte 0x8d,0x04,0x20
.byte 0x8d,0x44,0x20,0x00
.byte 0x8d,0x44,0x20,0x00
.byte 0x90
.byte 0x8d,0x80,0,0,0,0
.byte 0x8D,0x04,0x05,0,0,0,0
.byte 0x8D,0x04,0x05,0,0,0,0
.byte 0x90

                .section .rodata, "a"
p6nops: .byte 0x90
.byte 0x66,0x90
.byte 0x0f,0x1f,0x00
.byte 0x0f,0x1f,0x40,0
.byte 0x0f,0x1f,0x44,0x00,0
.byte 0x66,0x0f,0x1f,0x44,0x00,0
.byte 0x0f,0x1f,0x80,0,0,0,0
.byte 0x0f,0x1f,0x84,0x00,0,0,0,0

#NO_APP
        .type   constant_test_bit, @function
constant_test_bit:
.LFB30:

