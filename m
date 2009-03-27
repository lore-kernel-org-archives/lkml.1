Return-Path: <linux-kernel-owner+w=401wt.eu-S1753434AbZC0F6S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753434AbZC0F6S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 01:58:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751102AbZC0F6D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 01:58:03 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:44843 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285AbZC0F6B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 01:58:01 -0400
Date: Fri, 27 Mar 2009 05:57:50 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Theodore Tso <tytso@mit.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327055750.GA18065@srcf.ucam.org>
References: <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090327032301.GN6239@mit.edu> <20090327034705.GA16888@srcf.ucam.org> <20090327051338.GP6239@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090327051338.GP6239@mit.edu>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 27, 2009 at 01:13:39AM -0400, Theodore Tso wrote:

> There were plenty of applications that were written for Unix *and*
> Linux systems before ext3 existed, and they worked just fine.  Back
> then, people were drilled into the fact that they needed to use
> fsync(), and fsync() wan't expensive, so there wasn't a big deal in
> terms of usability.  The fact that fsync() was expensive was precisely
> because of ext3's data=ordered problem.  Writing files safely meant
> that you had to check error returns from fsync() *and* close().  

And now life is better. UNIX's error handling has always meant that it's 
effectively impossible to ensure that data hits disk if you wander into 
a variety of error conditions, and by and large it's simply not worth 
worrying about them. You're generally more likely to hit a kernel bug or 
suffer hardware failure than find an error condition that can actually 
be handled in a sensible way, and the probability/effectiveness ratio is 
sufficiently low that there are better ways to spend your time unless 
you're writing absolutely mission critical code. So let's not focus on 
the risk of data loss from failing to check certain error conditions. 
It's a tiny risk compared to power loss.

> I can tell you quite authoritatively that we didn't implement
> data=ordered to make life easier for application writers, and
> application writers didn't come to ext3 developers asking for this
> convenience.  It may have **accidentally** given them convenience that
> they wanted, but it also made fsync() slow.  

It not only gave them that convenience, it *guaranteed* that 
convenience. And with ext3 being the standard filesystem in the Linux 
world, and every other POSIX system being by and large irrelevant[1], 
the real world effect of that was that Linux gave you that guarantee. 

> > I'm utterly and screamingly bored of this "Blame userspace" attitude. 
> 
> I'm not blaming userspace.  I'm blaming ourselves, for implementing an
> attractive nuisance, and not realizing that we had implemented an
> attractive nuisance; which years later, is also responsible for these
> latency problems, both with and without fsync() ---- *and* which have
> also traied people into believing that fsync() is always expensive,
> and must be avoided at all costs --- which had not previously been
> true!

But you're still arguing that applications should start using fsync(). 
I'm arguing that not only is this pointless (most of this code will 
never be "fixed") but it's also regressive. In most cases applications 
don't want the guarantees that fsync() makes, and given that we're going 
to have people running on ext3 for years to come they also don't want 
the performance hit that fsync() brings. Filesystems should just do the 
right thing, rather than losing people's data and then claiming that 
it's fine because POSIX said they could.

> If I had to do it all over again, I would have argued with Stephen
> about making data=writeback the default, which would have provided
> behaviour on crash just like ext2, except that we wouldn't have to
> fsck the partition afterwards.  Back then, people lived with the
> potential security exposure on a crash, and they lived with the fact
> that you had to use fsync(), or manually type "sync", if you wanted to
> guarantee that data would be safely written to disk.  And you know
> what?  Things had been this way with Unix systems for 31 years before
> ext3 came on the scene, and things worked pretty well during those
> three decades.

Well, no. fsync() didn't appear in early Unix, so what people were 
actually willing to live with was restoring from backups if the system 
crashed. I'd argue that things are somewhat better these days, 
especially now that we're used to filesystems that don't require us to 
fsync(), close(), fsync the directory and possibly jump through even 
more hoops if faced with a pathological interpretation of POSIX. 
Progress is a good thing. The initial behaviour of ext4 in this respect 
wasn't progress.

And, really, I'm kind of amused at someone arguing for a given behaviour 
on the basis of POSIX while also suggesting that sync() is in any way 
helpful for guaranteeing that data is on disk.

> So again, let it make it clear, I'm not "blaming userspace".  I'm
> blaming ext3 data=ordered mode.  But it's trained application writers
> to program systems a certain way, and it's trained them to assume that
> fsync() is always evil, and they outnumber us kernel programmers, and
> so we are where we are.  And data=ordered mode is also responsible for
> these write latency problems which seems to make Ingo so cranky ---
> and rightly so.  It all comes from the same source.

No. People continue to use fsync() where fsync() should be used - for 
guaranteeing that given information has hit disk. The problem is that 
you're arguing that application should use fsync() even when they don't 
want or need that guarantee. If anything, ext3 has been helpful in 
encouraging people to only use fsync() when they really need to - and 
that's a win for everyone.

[1] MacOS has users, but it's not a significant market for pure POSIX 
applications so isn't really an interesting counterexample
-- 
Matthew Garrett | mjg59@srcf.ucam.org
