Return-Path: <linux-kernel-owner+w=401wt.eu-S1759229AbYJIPAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759229AbYJIPAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 11:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753336AbYJIPAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 11:00:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753179AbYJIPAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 11:00:17 -0400
Date: Thu, 9 Oct 2008 07:58:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Wilcox <matthew@wil.cx>
cc: Pavel Machek <pavel@suse.cz>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
       "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit
 arch
In-Reply-To: <20081009130131.GV25780@parisc-linux.org>
Message-ID: <alpine.LFD.2.00.0810090744110.3210@nehalem.linux-foundation.org>
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2> <20081007105056.16d9e785.akpm@linux-foundation.org> <1223405963.26330.83.camel@lappy.programming.kicks-ass.net> <200810081335.44576.nickpiggin@yahoo.com.au> <20081008025209.GO25780@parisc-linux.org>
 <20081009122319.GC1623@ucw.cz> <20081009130131.GV25780@parisc-linux.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 9 Oct 2008, Matthew Wilcox wrote:
> On Thu, Oct 09, 2008 at 02:23:19PM +0200, Pavel Machek wrote:
> >
> > We have append-only files, and normal users should not be able to work
> > around that restriction.
> 
> Is it possible to work around this restriction by exploiting this?

No, I don't think it is.

Because we had various nasty races, and various broken filesystems using 
"f->f_pos" directly (and then pread/pwrite not working), we fixed things 
many years ago, and nobody should use "f_pos" directly any more for any 
regular file access.

Oh, you'll see a _lot_ of f_pos accesses if you grep for them in low-level 
filesystems, but they should be for directory accesses, that are all under 
i_mutex. And O_APPEND obviously doesn't enter into it anyway.

So for regular IO, all the filesystems should never touch f_pos directly 
at all, they only ever touch a local "pos" that gets cached, and then at 
the end of the write sys_write() will write it back with file_pos_write(). 
That function was done exactly so that we _could_ do locking if we cared. 
Nobody ever did.

So even though filesystems get passed a _pointer_ to the position, it's 
all actually a pointer to just a private per-thread, on-stack entry.

The reason for that is that we really used to have bugs where the 
low-level filesystem assumed that "*pos" didn't change from under it while 
the access was going on (reading it multiple times and comparing against 
i_size etc), and exactly due to things like O_APPEND races against lseek.

So I think f_pos is fine. Yes, yes, if two threads or processes access the 
same file pointer concurrently, that means that f_pos at the end may be 
crazy, but that really is true regardless of whether you are able to hit 
the *very* small race of updating the 32-bit lower/upper fields in some 
mixed manner. No sane user program can possibly really care, since it 
would already be getting random offsets.

(Yeah, yeah, I could see some really crazy code that can do retries with 
optimistic locking in user space and could possibly see this as a bug, but 
that really is totally insane code, and I doubt you could write such a 
crazy thing to actually work).

			Linus
