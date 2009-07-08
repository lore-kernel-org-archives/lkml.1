Return-Path: <linux-kernel-owner+w=401wt.eu-S1759051AbZGHG1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759051AbZGHG1s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 02:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756098AbZGHG1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 02:27:37 -0400
Received: from smtp239.poczta.interia.pl ([217.74.64.239]:31856 "EHLO
	smtp239.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755880AbZGHG1g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 02:27:36 -0400
Date: 08 Jul 2009 08:27:28 +0200
From: krzysztof.h1@poczta.fm
Subject: =?UTF-8?q?Re:_Re:_matroxfb:_fix_regression_with_uninitalized_fb=5Finfo->mm=5Flock_mutex_(second_head)?=
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Linux-fbdev-devel <linux-fbdev-devel@lists.sourceforge.net>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       a.p.zijlstra@chello.nl, rjw@sisk.pl, stable@kernel.org
MIME-Version: 1.0
Content-Type: TEXT/plain; CHARSET=ISO-8859-2
Content-Transfer-Encoding: 8BIT
X-ORIGINATE-IP: 83.17.101.58
IMPORTANCE: Normal
X-MSMAIL-PRIORITY: Normal
X-PRIORITY: 3
X-Mailer: PSE3
Message-Id: <20090708062729.E32231B00E2@f41.poczta.interia.pl>
X-EMID: d4240acc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds napisa³(a):
> 
> 
> On Tue, 7 Jul 2009, Krzysztof Helt wrote:
> > 
> > Remove redundant locking by the mm_lock mutex before a second head of
> matrox 
> > framebuffer is registered.
> 
> Why do you write misleading commentary like this.
> 

I have not intention to mislead someone. English is not my primary language and this can be a source of this unfortunate wording.

> > +/*
> > + * This function is called before the register_framebuffer so
> > + * no locking is needed.
> > + */
> 
> Or this?
> 
> It&#039;s not about "needed". The locking is not only not needed, it would be 
> BUGGY.
> 
> And it&#039;s not "redundant". That implies that it&#039;s done somewhere else. It&#039;s
> 
> more than "not needed" - it would be actively buggy to lock things there.
> 
> I really don&#039;t like how you&#039;re approaching this. You&#039;re ignoring the real
> 
> issues I ask you, you&#039;re writing misleading comments and commit messages,
> 
> and the end result is fragile code. I still don&#039;t understand why you 
> insist on initializing those things late, which is the primary problem 
> here.
> 

The mm_lock mutex is used only inside the fb_mmap() function and driver's specific code. The fb_mmap() 
cannot be called before a framebuffer is registered. That's why it is enough to initialize the mutex
just before registering the framebuffer (or inside the register_framebuffer()). A current approach 
allows for statically declared fb_info structures (you consider it wrong).

It is easy to find affected drivers: "grep -rl mm_lock drivers/video/*". I went too far with some
drivers and added mm_lock mutex to functions which are called only from a probing function. They do
not need any locking yet. This is similar as marking them as __init or __devinit which makes incorrect
calling them after driver initialization. Some of these functions are so short they can be unrolled
into the probing functions. Does it make removal of the unneeded mutexing correct then?

All other drivers just have, let's say, inefficient code - calling a function which is called just
a moment later or set values which are not used before set again later (i810fb, matroxfb, sisfb).
The mm_lock patch converted this inefficient code into broken code. 

I understand you choose different approach. In order to keep this inefficient code in place you 
decided to change some correctly working legacy drivers and disallow statically declared fb_info 
structures. I see I cannot convince you it is worse solution so I am not trying any more.

However, you can still count my patches as small code improvements.

My fault is that I haven't tested the patch on a hardware and driver with added mm_lock mutex and
broken by this (like sisfb or matroxfb). I have not known I broke them.

Regards,
Krzysztof

----------------------------------------------------------------------
Teraz AC/OC + ubezpieczenie kosztow leczenia za granica
http://link.interia.pl/f2230

