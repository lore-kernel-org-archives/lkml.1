Return-Path: <linux-kernel-owner+w=401wt.eu-S1755010AbZGLR6m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010AbZGLR6m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jul 2009 13:58:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754322AbZGLR6d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Jul 2009 13:58:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42299 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754155AbZGLR6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jul 2009 13:58:32 -0400
Date: Sun, 12 Jul 2009 10:58:21 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Frans Pop <elendil@planet.nl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       barryn@pobox.com, bugme-daemon@bugzilla.kernel.org,
       Ian Lance Taylor <iant@google.com>
Subject: Re: [Bug 13012] 2.6.28.9 causes init to segfault on Debian etch;
 2.6.28.8 OK
In-Reply-To: <200907101659.31813.elendil@planet.nl>
Message-ID: <alpine.LFD.2.01.0907121058040.3552@localhost.localdomain>
References: <200907100928.07369.elendil@planet.nl> <200907101659.31813.elendil@planet.nl>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 10 Jul 2009, Frans Pop wrote:
> 
> Prompted by the same suggestion from Ben Hutchings I checked this too, 
> but -fno-strict-overflow was only introduced in gcc 4.2.
> So using it instead of -fwrapv *would* fix the problem for gcc 4.1, but 
> *only* because it would effectively do the same as the patch I proposed: 
> not add an option at all for gcc 4.1.
> 
> So that change seems illogical unless there are other reasons to 
> prefer -fno-strict-overflow over -fwrapv (well, it would avoid the
> gcc version check).
>
> It does however make it somewhat more logical to change the test in my 
> proposed patch to also allow -fwrapv for gcc 4.2.

Hmm. It all really makes me suspect that we should really be using
-fno-strict-overflow instead.

That not only apparently avoids the unnecessary gcc version check (by 
virtue of the option only existing in compilers that don't have the 
problem), but qutie frankly, one of the core people involved with the 
whole thing (Ian Lance Taylor) seems to think it's the better option.

See for example

	http://www.airs.com/blog/archives/120

on how gcc actually generates better code with -fno-strict-overflow.

I added Ian to the cc.

Ian: we generally do try to be careful and use explicit unsigned types for 
code that cares about overflow, but we use -fwrapv because there have been 
some cases where we didn't (and used pointer comparisons or signed 
integers).

The problem is that apparently gcc-4.1.x was literally generating buggy 
code with -fwrapv. So now the choice for us is between switching to an 
explicit version test:

	-KBUILD_CFLAGS  += $(call cc-option,-fwrapv)
	+KBUILD_CFLAGS  += $(shell if [ $(call cc-version) -ge 0402 ]; then \
	+                   echo $(call cc-option,-fwrapv); fi ;)

or just switching to -fno-strict-overflow instead:

	-KBUILD_CFLAGS  += $(call cc-option,-fwrapv)
	+KBUILD_CFLAGS  += $(call cc-option,-fno-strict-overflow)

which avoids the buggy gcc versions because it's simply not even supported 
by gcc-4.1.x (and even if that wasn't the case, possibly because only 
'wrapv' is the problematic case - apparently the difference _does_ 
matter to gcc).

>From everything I have been able to find, I really prefer the second 
version. Not only is the patch cleaner, but it looks like code generation 
is better too (for some inexplicable reason, but I suspect it's because 
-fno-strict-overflow is just saner).

		Linus
