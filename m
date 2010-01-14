Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732Ab0ANA1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732Ab0ANA1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 19:27:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756676Ab0ANA1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 19:27:16 -0500
Received: from science.horizon.com ([71.41.210.146]:19166 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755197Ab0ANA1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 19:27:16 -0500
Date: 13 Jan 2010 19:27:08 -0500
Message-ID: <20100114002708.4154.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: hpa@zytor.com, linux@horizon.com
Subject: Re: x86-32: clean up rwsem inline asm statements
Cc: linux-kernel@vger.kernel.org, schwab@linux-m68k.org,
       torvalds@linux-foundation.org
In-Reply-To: <4B4E3549.7060405@zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There are a number of things that can be done better... for one thing,
> "+m" (sem->count) and "a" (sem) is just bloody wrong.  The right thing
> would be "a" (&sem->count) for proper robustness.

Actually, no.  The "+m" (sem->count) is telling GCC that sem->count is
updated; "a" (&sem->count) does *not* tell it to invalidate cached
copies of sem->count that it may have lying around.

However, we can't just use "+m" (sem->count) because GCC has a poor
grasp on the concept of atomic operations; as far as it is concerned,
it is exactly equivalent to copying the value into a stack slot, do the
operation there, and copy it back.

(It's much more likely to do that with "g" operand constraints, but it has
been known to point to a stack copy that it's made for some other reason.)

The current situation is, as far as I can remember the previous discussion
on the subject, the simplest way to explain to GCC just what it needs to do.

> There is no real point in being concerned about the type of immediates,
> because the immediate type isn't really used... it shows up as a literal
> in the assembly language.  However, if you're really concerned, the
> right thing to do is to do a cast in C, not playing games with the assembly.

Ah, right, sorry; I remembered having this problem, but it was with
register operands.
