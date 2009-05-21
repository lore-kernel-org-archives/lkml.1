Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbZEUT1A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbZEUT1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 15:27:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbZEUT0w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 15:26:52 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:54888 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753475AbZEUT0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 15:26:51 -0400
Date: Thu, 21 May 2009 20:26:28 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       "Larry H." <research@subreption.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@osdl.org>, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [patch 0/5] Support for sanitization flag in low-level page
 allocator
Message-ID: <20090521202628.39625a5d@lxorguk.ukuu.org.uk>
In-Reply-To: <4A15A69F.3040604@redhat.com>
References: <20090520183045.GB10547@oblivion.subreption.com>
	<1242852158.6582.231.camel@laptop>
	<4A15A69F.3040604@redhat.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You don't always know this at page free time.

You do at buffer free time.

> I could see the PG_sensitive flag being used from
> userspace through mmap or madvise flags.  This way
> the sensitive memory from a program like gpg would
> be cleaned, even if gpg died in a segfault accident.

Still doesn't need a page flag - that is a vma flag which is far cheaper.
Also means you can get rid of the stupid mlock() misuse by things like
GPG to work around OS weaknesses by crypting the page if it hits
disk/swap/whatever.

> I could also imagine the suspend-to-disk code skipping
> PG_sensitive pages when storing data to disk, and
> replacing it with some magic signature so programs
> that use special PG_sensitive buffers can know that
> their crypto key disappeared after a restore.

Its irrelevant in the simple S2D case. I just patch other bits of the
suspend image to mail me the new key later. The right answer is crypted
swap combined with a hard disk password and thus a crypted and locked
suspend image. Playing the "I must not miss any page which might be
sensitive even compiler stack copies and library buffers I don't know
about" game is not going to build you a secure system - its simply
*lousy* engineering and design.

Basically though - loss of physical control means you have to assue the
recovered system is compromised. I doubt even TC is going to manage to
spot firmware compromises on your CD-ROM drive, which thanks to the film
industry creating a demand for altered firmware is a well understood
field...

The cost of doing crypto on suspend to disk relative to media speed is
basically irrelevant on a PC today. In the S2R case you might want to
crypt those pages against an electronic pure read of RAM type attack but
this is getting into serious spook territory.

