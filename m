Return-Path: <linux-kernel-owner+w=401wt.eu-S1756141AbZJ0CXV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756141AbZJ0CXV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 22:23:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753413AbZJ0CXV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 22:23:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753231AbZJ0CXT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 22:23:19 -0400
Date: Mon, 26 Oct 2009 22:23:05 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: hooanon05@yahoo.co.jp
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       Arnd Bergmann <arnd@arndb.de>, Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/40] Writable overlays (union mounts)
Message-ID: <20091027022305.GC14574@shell>
References: <1256152779-10054-1-git-send-email-vaurora@redhat.com> <8004.1256179480@jrobl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8004.1256179480@jrobl>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 11:44:40AM +0900, hooanon05@yahoo.co.jp wrote:
> 
> Hi,
> 
> Valerie Aurora:
> > Here is the current patch set for writable overlays (union mounts).
> > It needs lots of review!  Especially the bits where we do nasty things
> > with readdir().
> > 
> > Writable overlays let you mount one read-write file system
> > transparently over another read-only file system.  This is useful for
> > things like LiveCDs.  Detailed documentation and HOWTO here:
> 
> Are these issues what I have pointed out addressed?

Not in this release, no.  I just wanted to get something out there for
review.  rename() is particularly high on my list.  Thank you for
keeping track!

-VAL

> ========================================
> > ----------------------------------------------------------------------
> > I believe 'fallthru' in UnionMount is a good idea. But I am afraid it
> > may consume memory too much, particulary when the upper layer is tmpfs.
> > While one fallthru entry is small, recent LiveCD contains very many
> > files by squashfs and its size grows as DVD. If users try 'find /', then
> > many fallthru entires will be created and I am afraid it becomes memory
> > pressure.
> > How do you think about that?
> > ----------------------------------------------------------------------
> > I am afraid this issue may not be solved soon. It should be listed in a
> > longer term todo list, or no action to be taken (this is a feature).
> 
> Hm.  The fallthru entries are only essential when it comes to
> directories with mixed top/bottom entries during a readdir().  I can
> think of some ways to make fallthrus less common, or to be able to
> throw them out.  I will keep this in mind, thanks!
> 
> -VAL
> 
> ========================================
> > - link(2) doesn't work
> >   When the source file exists on the lower, it returns "Invalid
> >   cross-device link" error.
> > - Is it an expected behaviour?
> >   If UnionMount behaves as an ordinary filesystem, link(2) should work.
> >   But UnionMount is not a filesystem actually. So to return the error
> >   may be correct. I am not sure which is true.
> > 
> > Do I make my clear? 
> 
> Yes, I understand now.  This comes back to the same userland problem
> as rename(); technically userland should support fallback for this,
> but many apps assume it can't happen in the same directory.  I think
> we could make this work without copying up the file if we make a
> fallthru for the target.
> 
> In general, it might be good to have a config or mount option to
> enable/disable the EXDEV returns, and printk something when the
> workaround is triggered.  This would give us a migration path to a
> future in which userland utilities can deal with EXDEV in the same
> directory.
> 
> Both are on my todo list.
> 
> -VAL
> 
> ========================================
> > I might find a minor issue about copyup and read(2).
> > When two processes open the same file, with O_RDONLY and O_WRONLY
> > individually. One of them issues read(2), and the other issues write(2)
> > at the same time.
> > 
> > ProcessA
> > - open(O_RDONLY)
> > - read
> > 
> > ProcessB
> > - open(O_WRONLY)
> > - write
> > 
> > If read(2) executes before write(2), ProcessA gets the correct latest
> > (at that point) filedata. But if write(2) by ProcessB executes first,
> > the filedata ProcessA got may be obsoleted since it still refers to the
> > file on the lower readonly fs.
> > Users may not be aware since it is hard to know whether write(2) was
> > executed first, and this issue may be minor.
> > 
> > This scenario can happen in a single process.
> > 
> > ProcessC
> > - open(O_RDONLY)
> > - open(O_WRONLY)
> > - write
> > - read
> > 
> > This is not a race condition actually, but ProcessC will get the
> > obsoleted filedata. It will not get the filedata which it just wrote.
> > While I don't think there exists such application :-), users may think
> > it a problem.
> 
> I see what you mean!
> 
> I guess you can view it as effectively a rename() over the old file -
> it's the same as if you instead created a new file, copied all the
> data into it, and then renamed it over the old file.  Which is a very
> common method of updating files.
> 
> It will indeed be interesting to see if any applications break as a
> result of this.  Hopefully not, all the solutions I can think of are
> quite terrible.
> 
> -VAL
> 
> ========================================
> 
> I just want to confirm (and never mean to push you).
> 
> 
> J. R. Okajima
