Return-Path: <linux-kernel-owner+w=401wt.eu-S1756339AbZFNKSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339AbZFNKSS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 06:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754703AbZFNKSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 06:18:07 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:61588 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbZFNKSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 06:18:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=xtuARDAckzShJKoeEGgZWCaJwzyrwVwSaVDg03PSWNrleAPZJux5+zY5bnKHJgyLHk
         qlVTF5NWgQDF/7AkK4ooTgwQ/7q4I4NHVZrmfhHqdL5Xm/2GWdgmarlxZ+FBf2aUeAit
         bWFuzOWVx1/7IRXjh5Lw8rcGgtg6xJp89N14s=
MIME-Version: 1.0
In-Reply-To: <200906141210.17922.arnd@arndb.de>
References: <1244903447-23579-1-git-send-email-vapier@gentoo.org> 
	<200906132253.39879.arnd@arndb.de> <8bd0f97a0906131747odfe851chebfef9a541fa5c58@mail.gmail.com> 
	<200906141210.17922.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 14 Jun 2009 06:17:48 -0400
Message-ID: <8bd0f97a0906140317g7fcc741bwe0332dd14146c52b@mail.gmail.com>
Subject: Re: [PATCH] asm-generic: uaccess: fix up local access_ok() usage
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Robin Getz <rgetz@blackfin.uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 14, 2009 at 06:10, Arnd Bergmann wrote:
> On Sunday 14 June 2009, Mike Frysinger wrote:
>> well, if you dont mind a bit of cruft, you can undef it ;)
>> #include <asm-generic/uaccess.h>
>> #undef access_ok
>
> That will only work for the users outside of uaccess.h, so it doesn't
> solve this problem.

hmm, yeah, so that's no good

>> the Blackfin port does have hardware memory protection (MPU) and it
>> does handle r/w/x bits, but we havent merged this into access_ok yet,
>> just the vma lists
>
> Hmm, if the hardware can catch memory protection errors, why would
> you want to check them again in access_ok()? Are the checks disabled
> in kernel mode? Most implementations of access_ok only check if the
> address is a kernel or user pointer, because the kernel can access
> both on most architectures, and the MMU only protects you from
> passing invalid pointers, not valid kernel pointers.

in the Blackfin implementation, a protection violation is an
exception, exceptions cannot be nested, there is no prioritization
between exceptions, and a double exception is (hardware)
unrecoverable.  so we need to catch pointers given to us from
userspace.  if the kernel attempted to utilize that bad pointer, that
is an exception in supervisor mode which is (software) unrecoverable
-- our exception handler detects this and forces the system to panic.

>> > What I really got wrong was the prototype for __access_ok(), as you
>> > showed in your follow-up. I only tested this with the microblaze
>> > patch that overrides __access_ok() with an architecture specific
>> > version that gets this part right.
>>
>> yeah, that looks good, but i'd still like the __access_ok -> access_ok
>
> Ok, no problem. I can take that change as well, don't care much either way.

the patchset i posted obsoletes this one patch.
-mike
