Return-Path: <linux-kernel-owner+w=401wt.eu-S1762898AbYF3QRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762898AbYF3QRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 12:17:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758717AbYF3QQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 12:16:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59519 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757549AbYF3QQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 12:16:53 -0400
Message-ID: <486906F2.5030803@firstfloor.org>
Date: Mon, 30 Jun 2008 18:16:50 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Vitaly Mayatskikh <v.mayatskih@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/3] Fix copy_user on x86_64
References: <m37icazgt0.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0806281108240.4371@hp.linux-foundation.org> <m3lk0ngdo5.fsf@gravicappa.englab.brq.redhat.com> <alpine.LFD.1.10.0806300835220.28533@hp.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0806300835220.28533@hp.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One optimization (I haven't explored) is that the startup overhead
of rep ; movs might make it worthwhile to branch to a special version
for copies larger than 8 bytes (which are optimized in uaccess
for constant counts) and smaller than the threshold.

Best heuristic unfortunately varies per CPU core (and possible
even per stepping)

> 
> and we historically haven't cared much, because the above _naturally_ 
> happens for the bulk of the important cases (copy whole pages, which 
> happens not just in the VM for COW, but also when a user reads a regular 
> file in aligned chunks). But again, for networking buffers, it _might_ 
> make sense to try to help trigger this case explicitly.

The problem (I did some measurements on that a long time ago) is that
often the source and destination alignments are different and you can't
really fix that up in copy_*_user.

That is why I dropped the original "fix up alignments" code.

One way to do that would be use a alignment hint from the user address
while allocating the destination buffer (or rather adding an offset),
so that source and destination are (mis)aligned  in the same way
and that can be fixed up then.

But that is not trivial for networking. Not sure it would be really
worth the effort.

For the file system is not feasible at all because the page cache
offsets are fixed.

-Andi
