Return-Path: <linux-kernel-owner+w=401wt.eu-S1760132AbZFJMrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760132AbZFJMrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 08:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759242AbZFJMr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 08:47:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757080AbZFJMr1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 08:47:27 -0400
Date: Wed, 10 Jun 2009 14:47:27 +0200
From: Nick Piggin <npiggin@suse.de>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] [0/16] HWPOISON: Intro
Message-ID: <20090610124727.GB22161@wotan.suse.de>
References: <20090603846.816684333@firstfloor.org> <20090609102014.GG14820@wotan.suse.de> <20090610090703.GF6597@localhost> <20090610091807.GA18582@wotan.suse.de> <20090610094526.GB32584@localhost> <20090610111541.GC3876@wotan.suse.de> <20090610123600.GD5657@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090610123600.GD5657@localhost>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 10, 2009 at 08:36:00PM +0800, Wu Fengguang wrote:
> On Wed, Jun 10, 2009 at 07:15:41PM +0800, Nick Piggin wrote:
> > > We can make read() IO succeed even if the relevant pages are corrupted
> > > - they can be isolated transparent to user space readers :-)
> > 
> > But if the page was dirty and you throw out the dirty data,
> > then next read will give inconsistent data.
> 
> Yup. That's a big problem - the application won't get any error
> feedback here if it doesn't call fsync() to commit IO.

Right.


> > > > So even if we did change existing EIO semantics then the
> > > > memory corruption case of throwing away dirty data is still
> > > > going to be "different" (wrong, I would say).
> > > 
> > > Oh well.
> > 
> > Well I just think SIGKILL is the much safer behaviour to
> > start with (and matches behaviour with mmapped pagecache
> > and anon), and does not introduce these different semantics.
> 
> So what?  SIGKILL any future processes visiting the corrupted file?
> Or better to return EIO to them? Either way we'll be maintaining
> a consistent AS_EIO_HWPOISON bit.

If you don't throw the page out of the pagecache, it could
be left in there as a marker to SIGKILL anybody who tries to
access that page. OTOH this might present some other
difficulties regarding supression of writeback etc. Not
quite sure.

Of course the safest mode, IMO, is to panic the kernel in
situations like this (eg. corruption in dirty pagecache). I
would almost like to see that made as the default mode. That
avoids all questions of how exactly to handle these things.
Then if you can subsequently justify what kind of application
or case would work better with a particular behaviour (such
as throw away the data) then we can discuss and merge that.


> > > 1) under read IO hwpoison pages can be hidden to user space
> > 
> > I mean for cases where the recovery cannot be transparent
> > (ie. error in dirty page).
> 
> OK. That's a good point.
> 
> > > 2) under write IO hwpoison pages are normally committed by pdflush,
> > >    so cannot find the impacted application to kill at all.
> > 
> > Correct.
> > 
> > > 3) fsync() users can be caught though. But then the application
> > >    have the option to check its return code. If it doesn't do it,
> > >    it may well don't care. So why kill it?
> > 
> > Well if it does not check, then we cannot find it to kill
> > it anyway. If it does care (and hence check with fsync),
> > then we could kill it.
> 
> If it really care, it will check EIO after fsync ;)
> But yes, if it moderately care, it may ignore the return value.
> 
> So SIGKILL on fsync() seems to be a good option.
> 
> > > Think about a multimedia server. Shall we kill the daemon if some IO
> > > page in the movie get corrupted?
> > 
> > My multimedia server is using mmap for data...
> > 
> > > And a mission critical server? 
> > 
> > Mission critical server should be killed too because it
> > likely does not understand this semantic of throwing out
> > dirty data page. It should be detected and restarted and
> > should recover or fail over to another server.
> 
> Sorry for the confusion. I meant one server may want to survive,
> while another want to kill (and restart service).

Yes I just don't think even a really good admin will know
what to choose. At which point might as well remove the option
and just try to implement something sane...

But maybe you can write some good documentation for it, I will
stand corrected ;) 

> > > Obviously the admin will want the right to choose.
> > 
> > I don't know if they are equipped to really know. Do they
> > know that their application will correctly handle these
> > semantics of throwing out dirty data? It is potentially
> > much more dangerous to do this exactly because it can confuse
> > the case where it matters most (ie. ones that care about
> > data integrity).
> > 
> > It just seems like killing is far less controversial and
> > simpler. Start with that and it should do the right thing
> > for most people anyway. We could discuss possible ways
> > to recover in another patch if you want to do this
> > EIO thing.
> 
> OK, we can
>         - kill fsync() users
>         - and then return EIO for later read()/write()s
>         - forget about the EIO condition on last file close()
> Do you agree?

I really don't know ;) Anything I can think could be wrong
for a given situation. panic seems like the best default
option to me.

I don't want to sound like I'm quibbling. I don't actually
care too much what options are implemented so long as each
is justified and documented, and so long as the default is a
sane one.

Thanks,
Nick
