Return-Path: <linux-kernel-owner+w=401wt.eu-S1423277AbXBHTxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423277AbXBHTxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 14:53:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423297AbXBHTxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 14:53:54 -0500
Received: from smtp.osdl.org ([65.172.181.24]:36449 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423277AbXBHTxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 14:53:53 -0500
Date: Thu, 8 Feb 2007 11:53:38 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: somebody dropped a (warning) bomb
In-Reply-To: <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.64.0702081145470.8424@woody.linux-foundation.org>
References: <45CB3B28.60102@garzik.org> <Pine.LNX.4.64.0702080819350.8424@woody.linux-foundation.org>
 <Pine.LNX.4.61.0702081851310.1364@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Feb 2007, Jan Engelhardt wrote:
> 
> I generally have to agree with you about the unsigned char* vs char*. It 
> is a problem of the C language that char can be signed and unsigned, and 
> that people, as a result, have used it for storing 
> "shorter_than_short_t"s.
> 
> What C needs is a distinction between char and int8_t, rendering "char" 
> an unsigned at all times basically and making "unsigned char" and 
> "signed char" illegal types in turn.

No, it's really more fundamental than that.

Exactly because "char *" doesn't have a defined sign, only a TOTALLY 
INCOMPETENT compiler will warn about its signedness.

The user has clearly stated "I don't care about the sign". If a compiler 
complains about us passing "unsigned char *" (or, if "char" is naturally 
unsigned on that platform, "signed char *") to strcmp then that compiler 
IS BROKEN. Because "strcmp()" takes "char *", which simply DOES NOT HAVE a 
uniquely defined sign. 

That's why we can't have -Wpointer-sign on by default. The gcc warning is 
simply *crap*.

If you were to have

	extern int strcmp(signed char *);

and would pass *that* an "unsigned char", it would be a real and valid 
sign error. But just plain "char *" isn't signed or unsigned. It's 
"implementation defined", and as such, if the programmer used it, the 
programmer clearly doesn't care. If he cared, he would just state the 
signedness explicitly.

It really is that simple. gcc is broken. The C language isn't, it's purely 
a broken compiler issue.

The other things in the kernel I'd be willing to fix up. But I simply 
refuse to work around a known-buggy warning.

		Linus
