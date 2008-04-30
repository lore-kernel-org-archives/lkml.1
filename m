Return-Path: <linux-kernel-owner+w=401wt.eu-S1763556AbYD3QjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763556AbYD3QjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 12:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757725AbYD3QjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 12:39:16 -0400
Received: from filer.fsl.cs.sunysb.edu ([130.245.126.2]:51521 "EHLO
	filer.fsl.cs.sunysb.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756383AbYD3QjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 12:39:14 -0400
Date: Wed, 30 Apr 2008 12:35:07 -0400
Message-Id: <200804301635.m3UGZ7gn006259@agora.fsl.cs.sunysb.edu>
From: Erez Zadok <ezk@cs.sunysb.edu>
To: "NAGABHUSHAN BS" <bsn.0007@gmail.com>
Cc: "Erez Zadok" <ezk@cs.sunysb.edu>, libc-alpha@sourceware.org,
       "Jan Blunck" <jblunck@suse.de>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       "Christoph Hellwig" <hch@lst.de>, "Ulrich Drepper" <drepper@redhat.com>,
       "Mingming Cao" <cmm@us.ibm.com>, "Dave Hansen" <haveblue@us.ibm.com>,
       "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       bharata@linux.vnet.ibm.com, "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [RFC PATCH 0/2] Union Mount: Directory listing in glibc 
In-reply-to: Your message of "Wed, 30 Apr 2008 11:37:10 +0530."
             <c810d5090804292307y2884b169t5c27b50fb7c94c30@mail.gmail.com> 
X-MailKey: Erez_Zadok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In message <c810d5090804292307y2884b169t5c27b50fb7c94c30@mail.gmail.com>, "NAGABHUSHAN BS" writes:
> On Tue, Apr 29, 2008 at 9:19 PM, Erez Zadok <ezk@cs.sunysb.edu> wrote:
> > In message <20080429133201.GA9938@localhost.localdomain>, bsn.0007@gmail.com writes:
[...]

> >  You might consider using a hash table instead of a list; it'll be
> >  faster in case where there are a lot of whiteouts/duplicates to
> >  process.
> >
> 
> Yes, hash table was one of the things i had considered  to use as a
> cache. But i am not completely sure how this would support seekdir.
> Any suggestions are greatly welcome.
> 
> Regards Nagabhushan

Here's one idea:

1. Your main data structure is a linear array of struct dirents.  You
   perform seekdir/readdir on this linear structure, which should be
   trivial.  Each time you find a dirent which definitely needs to go into
   this structure, you append to it.  If you're about to run out of space in
   it, you can realloc it 2x its previous size (a common technique).  This
   structure remains cached in memory for as long as the directory is open.

   Optimization 1: you can keep it cached past close(fd), b/c recursive
   programs like /bin/find may close and reopen a directory several times.
   But you'll need to determine if the directory's mtime had changed and if
   so, purge the cached content and reconstruct it.

   Optimization 2: if you can do a stat(2) on each directory in the union,
   and sum their total size, that'll provide you with an upper bound on the
   size of your dirent cache.  In that case, you can forego the realloc I
   mentioned, and just malloc one large array at once.  This could be more
   efficient than realloc'ing for two reasons: (a) realloc may have to
   memcpy data, which you can avoid; and (b) the rest of the malloc'ed
   array, near its end, may be unused, but as long as you don't touch it,
   it'll be one large-ish extent of virtual memory for which physical page
   frames won't be actually needed.  Even better, you can realloc() that
   large malloc'ed area to cut back on its size to exactly what you need.

2. During the construction of the dirent array above, you keep two hash
   tables:

2a. HT1 is used for duplicate elimination.  It contains POINTERS ONLY (or
    offsets) into the dirent cache buffer.  You add entries into it each
    time you append a name to the dirent cache array.  This HT1 allows you
    to quickly find out if a string name had been seen before.  When you're
    done constructing the dirent cache, free(HT1).

2b. HT2 is used for whiteouts.  It contains the actual strings of whited-out
    entries you've seen, which you add each time you find a whiteout.  You
    look this HT2 each time you need to determine if an entry you're about
    to add to the dirent cache had been whited-out or not.  When you're done
    constructing the dirent cache, free(HT2).

Hope you can use this as a starting point.

Cheers,
Erez.
