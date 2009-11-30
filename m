Return-Path: <linux-kernel-owner+w=401wt.eu-S1753328AbZK3R4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbZK3R4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 12:56:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753307AbZK3R4o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 12:56:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:42891 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbZK3R4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 12:56:43 -0500
Message-ID: <4B14072C.1060509@zytor.com>
Date: Mon, 30 Nov 2009 09:55:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: using kernel headers in libc headers
References: <a36005b50911300837s6fe4da73s973ccbe7401b9989@mail.gmail.com> 	<4B13FA4E.1070901@zytor.com> <a36005b50911300943i947c91fva2b93f5f067665a1@mail.gmail.com>
In-Reply-To: <a36005b50911300943i947c91fva2b93f5f067665a1@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/30/2009 09:43 AM, Ulrich Drepper wrote:
> On Mon, Nov 30, 2009 at 09:01, H. Peter Anvin <hpa@zytor.com> wrote:
>> A better way is to factor out subsets; if <linux/sched.h> has too many
>> things, we can break out the POSIX parts into <linux/sched_posix.h> or
>> (certainly better if we have more than one of these)
>> <linux/sched/posix.h> which can also be included by <linux/sched.h>.
> 
> This is at least as undesirable.
> 
> First, there can be several different of those.  E.g., there are
> different levels of POSIX compliance and the number of growing.  There
> are also conditions like
> 
>   if POSIX version > 2001012 || GNU source
> 
> How do you express this?

Very simple: you factor it into subsets.  The above kind of stuff is
*exactly* why this has no business in the kernel headers -- it exposes
glibc internals way too deeply.

> Second, it makes it hard to impossible for developers to use the
> headers as part of the system documentation.  Many people (me
> included) look at headers and the included comments.  With your scheme
> the set of definitions (e.g., SCHED_* macros) might be spread out over
> several different headers.  Currently they are all nicely group (in
> the kernel and libc headers) and people can see what is available.

That is exactly why I said <linux/sched/foo.h> is preferrable to
<linux/sched_foo.h> -- with more than one subset then it is better to
combine them into a subdirectory so they can be rapidly found.

We already have been through the #ifdef hell once, and we are still
crawling out of it.  It was -- and is -- an utter miserable failure.
Explicitly forcing factoring into subsets and leaving it to the libc
layer to decide what subsets to invoke is the only sane option.  This is
*especially* so when you consider that you have to account for version
skew next time glibc or uclibc or whateverlibc introduces new feature
macros.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

