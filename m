Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbXGHRC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbXGHRC7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 13:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbXGHRCu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 13:02:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51867 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751836AbXGHRCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 13:02:49 -0400
Date: Sun, 8 Jul 2007 10:02:30 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       drepper@redhat.com
Subject: Re: 2.6.22-rc6(mm1) Unable to handle kernel NULL pointer dereference
 - git-bisect result
In-Reply-To: <20070708152808.GA5902@gentoox2.trippelsdorf.de>
Message-ID: <alpine.LFD.0.999.0707080958280.31544@woody.linux-foundation.org>
References: <20070708051452.GA4140@gentoox2.trippelsdorf.de>
 <20070708012016.455ce8d5.akpm@linux-foundation.org>
 <20070708100911.GA4196@gentoox2.trippelsdorf.de>
 <20070708152808.GA5902@gentoox2.trippelsdorf.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 8 Jul 2007, Markus Trippelsdorf wrote:
> 
> I tested this further and it turned out that the Linus tree is also
> affected. So I ran git-bisect, after I found out that version
> 2.6.21.6 was not affected by this bug.

git-bisect is wonderful.

> gentoox2 linux # git bisect bad
> 1c710c896eb461895d3c399e15bb5f20b39c9073 is first bad commit
> commit 1c710c896eb461895d3c399e15bb5f20b39c9073
> Author: Ulrich Drepper <drepper@redhat.com>

Ok, I see what's wrong.

We're doing "vfs_permission()" and passing in "nd" to it when "times" is 
NULL, but Uli didn't even *initialize* it for the case of

	filename == NULL && dfd != AT_FDCWD

so yeah, it's broken.

I was planning on doing 2.6.22 today, so I'm actually inclined to revert 
the commit entirely, even though it looks like it's probably fairly 
trivial to fix.

But if we get a really quick and obvious fix, I guess I'll apply it. I 
have to say, the new do_utimes() code is pretty ugly compared to the old 
one exactly in the added special cases (the ones that caused this bug..)

Uli?

		Linus
