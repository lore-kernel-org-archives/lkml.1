Return-Path: <linux-kernel-owner+w=401wt.eu-S1765202AbZDBWtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765202AbZDBWtS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 18:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758607AbZDBWtE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 18:49:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47308 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755363AbZDBWtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 18:49:01 -0400
Date: Thu, 2 Apr 2009 15:42:51 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Jeff Garzik <jeff@garzik.org>
cc: Andrew Morton <akpm@linux-foundation.org>, David Rees <drees76@gmail.com>,
       Janne Grunau <j@jannau.net>,
       Lennart Sorensen <lsorense@csclub.uwaterloo.ca>,
       Theodore Tso <tytso@mit.edu>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
In-Reply-To: <49D53787.9060503@garzik.org>
Message-ID: <alpine.LFD.2.00.0904021516540.4130@localhost.localdomain>
References: <20090325183011.GN32307@mit.edu> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain>
 <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <20090401210337.GB3797@csclub.uwaterloo.ca> <20090402110532.GA5132@aniel>
 <72dbd3150904020929w46c6dc0bs4028c49dd8fa8c56@mail.gmail.com> <20090402094247.9d7ac19f.akpm@linux-foundation.org> <alpine.LFD.2.00.0904020947310.4130@localhost.localdomain> <alpine.LFD.2.00.0904020959490.4130@localhost.localdomain>
 <49D53787.9060503@garzik.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2 Apr 2009, Jeff Garzik wrote:
> 
> Dumb VM question, then:  I understand the logic behind the write-throttling
> part (some of my own userland code does something similar), but,
> 
> Does this imply adding fadvise to your overwrite.c example is (a) not
> noticable, (b) potentially less efficient, (c) potentially more efficient?

For _that_ particular load it was more of a "it wasn't the issue". I 
wanted to get timely writeouts, because otherwise they bunch up and become 
unmanageable (with even the people who are not actually writing end up 
waiting for the writeouts). 

Once the pages are clean, it just didn't matter. The VM did the balancing 
right enough that I stopped caring. With other access patterns (ie if the 
pages ended up on the active list) the situation might have been 
different.

> Or IOW, does fadvise purely put pages on the cold list as your 
> sync_file_range incantation does, or something different?

sync_file_range() doesn't actually put the pages on the inactive list, but 
since the program was just a streaming one, they never even left it.

But no, fadvise actually tries to actually invalidate the pages (ie gets 
rid of them, as opposed to moving them to the inactive list).

Another note: I literally used that program just for whole-disk testing, 
so the behavior on an actual filesystem may or may not match. But I just 
tested on ext3 on my desktop, and got

     1.734 GB written in 30.38 (58 MB/s)           

until I ^C'd it, and I didn't have any sound skipping or anything like 
that. Of course, that's with those nice Intel SSD's, so that doesn't 
really say anything.

Feel free to give it a try. It _should_ maintain good write speed while 
not disturbing the system much. But I bet if you added the "fadvise()" it 
would disturb things even _less_.

My only point is really that you _can_ do streaming writes well, but at 
the same time I do think the kernel makes it too hard to do it with 
"simple" applications. I'd love to get the same kind of high-speed 
streaming behavior by just doing a simple "dd if=/dev/zero of=bigfile"

And I really think we should be able to.

And no, we clearly are _not_ able to do that now. I just tried with "dd", 
and created a 1.7G file that way, and it was stuttering - even with my 
nice SSD setup. I'm in my MUA writing this email (obviously), and in the 
middle it just totally hung for about half a minute - because it was 
obviously doing some fsync() for temporary saving etc while the "sync" was 
going on.

With the "overwrite.c" thing, I do get short pauses when my MUA does 
something, but they are not the kind of "oops, everything hung for several 
seconds" kind. 

(Full disclosure: 'alpine' with the local mbox on one disk - I _think_ 
that what alpine does is fsync() temporary save-files, but it might also 
be checking email in the background - I have not looked at _why_ alpine 
does an fsync, but it definitely does. And 5+ second delays are very 
annoying when writing emails - much less half a minute).

			Linus
