Return-Path: <linux-kernel-owner+w=401wt.eu-S1752105AbZJLFTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752105AbZJLFTF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 01:19:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZJLFTD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 01:19:03 -0400
Received: from mail-vw0-f203.google.com ([209.85.212.203]:55582 "EHLO
	mail-vw0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbZJLFTC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 01:19:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=U+8dpxCJ1y4zOpwqcy0kB8PB2Uu5XSCGGqTsUlH7CY6ItdHIzdtO1MyYc1Bxm6fXfx
         0y74Wtr6TbYiuQuy+wR9HnFD8WBMb53uYD0UQPuKj0kb6KSAZFL3FtTQG4qq6PW64iR9
         Jx0o96Bm1WB1GUYdIlzvxvPLGPKTKRwMZhHbw=
MIME-Version: 1.0
In-Reply-To: <20091010160304.GA11876@feather>
References: <20091010085732.GA10923@feather>
	 <70318cbf0910100333m128e3500vb1659a55a9f49768@mail.gmail.com>
	 <20091010160304.GA11876@feather>
Date: Sun, 11 Oct 2009 22:18:24 -0700
X-Google-Sender-Auth: 5d59729902593c2c
Message-ID: <70318cbf0910112218j50a63148t2e044bc5451dc0cb@mail.gmail.com>
Subject: Re: [PATCH] New attribute designated_init: mark a struct as requiring 
	designated init
From: Christopher Li <sparse@chrisli.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: linux-sparse@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 10, 2009 at 9:03 AM, Josh Triplett <josh@joshtriplett.org> wrote:
> After getting this patch reviewed, I intended to add many such
> annotations myself.  I have patches sitting in my local Linux tree.
> (However, I don't plan to try to get the patches accepted into Linux
> until this attribute shows up in a Sparse release, since I don't want to
> make Linux require the latest Sparse from the git tree.)

I apply your patch so you can have a fair chance to pitch to the
kernel. If nobody use it, I can remove it later. I don't think you need
to wait for the patch to go into sparse release to collect feed back
from lkml.


> You *hope* that positional initialization will fail. :)  Some of these
> types of structures contain many fields with the same or similar types,
> and initializers don't inherently contain a lot of distinguishing type
> information that helps cause type errors rather than silent failures.

I am very interested to know some precedence from the kernel commit history.
If we can find such a commit which changes the structure and breaks
other initialization due to the position initialization, it will make your
case stronger as well.

> Even if the positional initialization does fail, this failure will occur
> at the time of attempting to change the structure, and many such
> failures may occur all over the tree, making such changes significantly
> more difficult.  With the designated_init attribute, sparse will warn
> when attempting to create the structure initializer.

Without sparse, you can temporary  insert some unused strange type
into the beginning of the struct. That should cause any position initializer
fail to compile. You can then find call the call site.

> With the designated_init attribute, someone making changes to a
> structure can check that Sparse produces no warnings about positional
> initializers and then know that certain types of changes can occur
> without having to check every initializer.  For instance, removing a
> field will only require checking any initializer that initializes that
> field, and the compiler will find all of those.  Adding a field that can
> safely remain NULL does not require checking any initializers.

I think the initializer is just a small part of the work if you even change
the structure. You need to make sure the *code* use these C struct
actually works as expected.

> (As an aside, though: any fundamental reason why we use that error-prone
> approach rather than allocating one extra byte and NUL-terminating
> idents?  Then we could drop the (larger) len field, and remove the
> annoying restriction on calling show_ident multiple times in the same
> statement.)

When sparse does the hash table look up, if there is collision on the
hash table entry, sparse will compare the size first before the memcmp().
That will reduce the number of the memcmp call it makes. I would like to
keep the size of struct ident. If any thing, we can NUL terminate the string
in ident to make printing easy.

Chris
