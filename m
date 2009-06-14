Return-Path: <linux-kernel-owner+w=401wt.eu-S1760884AbZFNArr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760884AbZFNArr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 20:47:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752718AbZFNAri
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 20:47:38 -0400
Received: from mail-yx0-f200.google.com ([209.85.210.200]:33144 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbZFNAri convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 20:47:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=sNpkb2N+lr/N35K4NrkwjNIr4lVLGCejXi6AxuaR6g4PxrPmz0WVXPFfH4gDTEG+yU
         yDHy8uur6VjYazchVxa/oCN9p1K0xbm3SS6mzf7GZMSPkJkMU7jo0j6ImEbzsoh2N5/+
         dmvnamtI0j/PfhRRz600DvuuvuNgpD+TanvJg=
MIME-Version: 1.0
In-Reply-To: <200906132253.39879.arnd@arndb.de>
References: <1244903447-23579-1-git-send-email-vapier@gentoo.org> 
	<200906132253.39879.arnd@arndb.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sat, 13 Jun 2009 20:47:20 -0400
Message-ID: <8bd0f97a0906131747odfe851chebfef9a541fa5c58@mail.gmail.com>
Subject: Re: [PATCH] asm-generic: uaccess: fix up local access_ok() usage
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 13, 2009 at 16:53, Arnd Bergmann wrote:
> On Saturday 13 June 2009, Mike Frysinger wrote:
>> There's no reason that I can see to use the short __access_ok() form
>> directly when the access_ok() is clearer in intent and for more people,
>> expands to the same C code (i.e. always specify the first field -- access
>> type).  Not all no-mmu systems lack memory protection, so the read/write
>> could feasibly be checked.
>
> Ah, I didn't consider this. I checked all the architectures and could not
> find a case where access_ok actually evaluates the the first argument, so
> I chose the slightly terser variant. I also don't let you override
> access_ok() at this moment, which means that you don't have a choice
> to use the generic uaccess.h and still differentiate between read and
> write accesses.

well, if you dont mind a bit of cruft, you can undef it ;)
#include <asm-generic/uaccess.h>
#undef access_ok

the Blackfin port does have hardware memory protection (MPU) and it
does handle r/w/x bits, but we havent merged this into access_ok yet,
just the vma lists

> What I really got wrong was the prototype for __access_ok(), as you
> showed in your follow-up. I only tested this with the microblaze
> patch that overrides __access_ok() with an architecture specific
> version that gets this part right.

yeah, that looks good, but i'd still like the __access_ok -> access_ok

>> Also, the strnlen_user() function was missing a access_ok() check on the
>> pointer given.  We've had cases on Blackfin systems where test cases
>> caused kernel crashes here because userspace passed up a NULL/-1 pointer
>> and the kernel gladly attempted to run strlen() on it.
>
> Right, well spotted. I'll take this fix as a separate patch, ok?

np
-mike
