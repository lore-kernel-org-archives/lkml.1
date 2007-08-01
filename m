Return-Path: <linux-kernel-owner+w=401wt.eu-S1762501AbXHAILq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762501AbXHAILq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 04:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757217AbXHAIL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 04:11:28 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:26982 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757649AbXHAILZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 04:11:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hR1Cp+Hw1lTEO19B+U3mTqxbNMl0nrkIcsXfTLtnI/zz8Yew6XspZ3yWWiYXoYuTyETumv6Y6GOGgxr4IH8w7xKJc9IXV5ucfJuI28J8g/snbIpAkKdCdGkuit63cmtbnDgn9E1BH8/NTmzSvXfLlRhTCjUMOygMO1h4BPc+sDo=
Message-ID: <a56dfcf00708010111n4b862a11wf91fe9677ee46143@mail.gmail.com>
Date: Wed, 1 Aug 2007 04:11:23 -0400
From: "Dan Merillat" <dan.merillat@gmail.com>
To: "Eric Sandeen" <sandeen@sandeen.net>
Subject: Re: [PATCH][RFC] 4K stacks default, not a debug thing any more...?
Cc: "Satyam Sharma" <satyam.sharma@gmail.com>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Andrea Arcangeli" <andrea@suse.de>, "Matt Mackall" <mpm@selenic.com>,
       "Rene Herman" <rene.herman@gmail.com>, "Ray Lee" <ray-lk@madrabbit.org>,
       "Bodo Eggert" <7eggert@gmx.de>, "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "William Lee Irwin III" <wli@holomorphy.com>,
       "David Chinner" <dgc@sgi.com>, "Arjan van de Ven" <arjan@infradead.org>
In-Reply-To: <46B003A3.1090507@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469BF104.1040703@gmail.com>
	 <20070719013955.1bedc423@the-village.bc.nu>
	 <20070719013358.GD29728@v2.random> <20070719013725.GP11115@waste.org>
	 <20070719112436.GG29728@v2.random>
	 <20070719124419.48c3d610@the-village.bc.nu>
	 <46A9ECD5.3050801@sandeen.net>
	 <20070727183807.2d7dbe7b@the-village.bc.nu>
	 <a781481a0707271131j3ab89470o4dea2fe2624fca32@mail.gmail.com>
	 <46B003A3.1090507@sandeen.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/31/07, Eric Sandeen <sandeen@sandeen.net> wrote:

> No, what I had did only that, so it was still a matter of probabilities...

How expensive would it be to allocate two , then use the MMU mark the
second page unwritable? Hardware wise it should be possible,  (for
constant 4k pagesizes, I have not worked with variable pagesize MMUs)
and since it's a per-context-switch constant operation, it would be a
special case in the fault handler rather then adding another entry to
the VM for every process.

Using large hardware pages to cover the kernel mapping could be worked
around by leaving the area where the current process stack resides
mapped via 4k pages.  Of course, I haven't touched a modern PC MMU in
ages, so I could be missing something fundamentally difficult.

The other issue is with the layered IO design - no matter what we
configure the stack size to, it is still possible to create a set of
translation layers that will cause it to crash regularly:  XFS on
dm_crypt on loop on XFS on dm_crypt on loop on ad infinitum.

That said, I'm missing something here - why is the stack growing?
Filesystems should be issuing bios with callbacks, so they should be
back off the stack, same with dm, loop, etc.   Am I missing step where
they use a wrapper function that pretends to be syncronous?
