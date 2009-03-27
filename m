Return-Path: <linux-kernel-owner+w=401wt.eu-S1756525AbZC0FOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525AbZC0FOD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 01:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751377AbZC0FNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 01:13:52 -0400
Received: from thunk.org ([69.25.196.29]:50534 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327AbZC0FNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 01:13:51 -0400
Date: Fri, 27 Mar 2009 01:13:39 -0400
From: Theodore Tso <tytso@mit.edu>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327051338.GP6239@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090327032301.GN6239@mit.edu> <20090327034705.GA16888@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090327034705.GA16888@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 03:47:05AM +0000, Matthew Garrett wrote:
> Oh, for the love of a whole range of mythological figures. ext3 didn't 
> train application programmers that they could be careless about fsync(). 
> It gave them functionality that they wanted, ie the ability to do things 
> like rename a file over another one with the expectation that these 
> operations would actually occur in the same order that they were 
> generated. More to the point, it let them do this *without* having to 
> call fsync(), resulting in a significant improvement in filesystem 
> usability.

Matthew, 

There were plenty of applications that were written for Unix *and*
Linux systems before ext3 existed, and they worked just fine.  Back
then, people were drilled into the fact that they needed to use
fsync(), and fsync() wan't expensive, so there wasn't a big deal in
terms of usability.  The fact that fsync() was expensive was precisely
because of ext3's data=ordered problem.  Writing files safely meant
that you had to check error returns from fsync() *and* close().  

In fact, if you care about making sure that data doesn't get lost due
to disk errors, you *must* call fsync().  Pavel may have complained
that fsync() can sometimes drop errors if some other process also has
the file open and calls fsync() --- but if you don't, and you rely on
ext3 to magically write the data blocks out as a side effect of the
commit in data=ordered mode, there's no way to signal the write error
to the application, and you are *guaranteed * to lose the I/O error
indication.

I can tell you quite authoritatively that we didn't implement
data=ordered to make life easier for application writers, and
application writers didn't come to ext3 developers asking for this
convenience.  It may have **accidentally** given them convenience that
they wanted, but it also made fsync() slow.  

> I'm utterly and screamingly bored of this "Blame userspace" attitude. 

I'm not blaming userspace.  I'm blaming ourselves, for implementing an
attractive nuisance, and not realizing that we had implemented an
attractive nuisance; which years later, is also responsible for these
latency problems, both with and without fsync() ---- *and* which have
also traied people into believing that fsync() is always expensive,
and must be avoided at all costs --- which had not previously been
true!

If I had to do it all over again, I would have argued with Stephen
about making data=writeback the default, which would have provided
behaviour on crash just like ext2, except that we wouldn't have to
fsck the partition afterwards.  Back then, people lived with the
potential security exposure on a crash, and they lived with the fact
that you had to use fsync(), or manually type "sync", if you wanted to
guarantee that data would be safely written to disk.  And you know
what?  Things had been this way with Unix systems for 31 years before
ext3 came on the scene, and things worked pretty well during those
three decades.

So again, let it make it clear, I'm not "blaming userspace".  I'm
blaming ext3 data=ordered mode.  But it's trained application writers
to program systems a certain way, and it's trained them to assume that
fsync() is always evil, and they outnumber us kernel programmers, and
so we are where we are.  And data=ordered mode is also responsible for
these write latency problems which seems to make Ingo so cranky ---
and rightly so.  It all comes from the same source.

						- Ted
