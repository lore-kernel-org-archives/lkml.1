Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbZEONn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbZEONn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 May 2009 09:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751461AbZEONnS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 May 2009 09:43:18 -0400
Received: from mail2.shareable.org ([80.68.89.115]:48590 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751763AbZEONnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 May 2009 09:43:17 -0400
Date: Fri, 15 May 2009 14:43:15 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>, Josef Bacik <josef@redhat.com>,
       sandeen@redhat.com, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Perform check in iov_iter_fault_in_readable() by check_readable_bytes()
Message-ID: <20090515134315.GB8235@shareable.org>
References: <1242317939-15392-1-git-send-email-v.mayatskih@gmail.com> <1242317939-15392-3-git-send-email-v.mayatskih@gmail.com> <87k54iq2gv.fsf@basil.nowhere.org> <871vqqkdf0.wl%vmayatsk@redhat.com> <20090515093838.GB16682@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090515093838.GB16682@one.firstfloor.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> > ptr = mmap(0, page_size, ....);
> > ...
> > write(fd, ptr + page_size - 256, 512);
> > 
> > Write() will fail here, but it can write first 256 bytes. Previously,
> > all 512 bytes were proceeded, but last 256 bytes were zeroed, and
> > sys_write() returned 256. Not very nice too. 
> 
> Is that really something that users rely on? It looks like a seriously
> broken user program. Which one is that? (just that I can avoid it :)

A few programs set pages read-only, and rely on SIGSEGVs to trigger
mprotect() in the signal handler and thus track dirty pages.

I think the Boehm garbage collector has this option, as do some LISP
interpreters.

System calls don't trigger SIGSEGVs so they can't rely on that when
calling read().  I'm not sure how they handle that.

It would be quite nice if it were safe to call read(), get EFAULT
immediately, or a truncated read() then the next read() gets EFAULT
because it starts at a missing page boundary, and then that's a hint
for the program to consult it's data structures and do it's mprotect()
thing.

Hopefully no programs assume they can do that already, but it would be
nice if they could begin to assume it, instead of checking their data
structure in advance of every read() call.

I don't know of any program which would need the same thing with
write(), but obviously good for symmetry.

-- Jamie
