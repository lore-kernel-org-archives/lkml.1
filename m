Return-Path: <linux-kernel-owner+w=401wt.eu-S1751980AbXBVWJN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751980AbXBVWJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 17:09:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751974AbXBVWJM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 17:09:12 -0500
Received: from mail-gw2.sa.eol.hu ([212.108.200.109]:45538 "EHLO
	mail-gw2.sa.eol.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbXBVWJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 17:09:11 -0500
To: staubach@redhat.com
CC: miklos@szeredi.hu, trond.myklebust@fys.uio.no, akpm@linux-foundation.org,
       hugh@veritas.com, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-reply-to: <45DE108C.6010101@redhat.com> (message from Peter Staubach on
	Thu, 22 Feb 2007 16:52:12 -0500)
Subject: Re: [PATCH] update ctime and mtime for mmaped write
References: <E1HJvdA-0003Nj-00@dorka.pomaz.szeredi.hu>	 <20070221202615.a0a167f4.akpm@linux-foundation.org>	 <E1HK8hU-0005Mq-00@dorka.pomaz.szeredi.hu> <45DDD55F.4060106@redhat.com>	 <E1HKIN1-0006RX-00@dorka.pomaz.szeredi.hu> <45DDF9C1.4090003@redhat.com>	 <E1HKKrL-0006k6-00@dorka.pomaz.szeredi.hu> <1172178253.6382.12.camel@heimdal.trondhjem.org> <E1HKLUp-0006qY-00@dorka.pomaz.szeredi.hu> <45DE108C.6010101@redhat.com>
Message-Id: <E1HKM6y-0006xN-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 22 Feb 2007 23:08:24 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Miklos Szeredi wrote:
> >>>> This still does not address the situation where a file is 'permanently'
> >>>> mmap'd, does it?
> >>>>         
> >>> So?  If application doesn't do msync, then the file times won't be
> >>> updated.  That's allowed by the standard, and so portable applications
> >>> will have to call msync.
> >>>       
> >> It is allowed, but it is clearly not useful behaviour. Nowhere is it set
> >> in stone that we should be implementing just the minimum allowed.
> >>     
> >
> > You're right.  In theory, at least.  But in practice I don't think
> > this matters.  Show me an application that writes to a shared mapping
> > then doesn't call either msync or munmap and doesn't even exit.
> >
> > If there were lot of these apps, then this bug would have been fixed
> > lots of years earlier.  In fact there are _very_ few apps writing to
> > shared mappings at all.
> >
> >   
> 
> Perhaps true, although I know of at least one customer of Red Hat who
> does have an application (or more) than uses mmap'd files and is
> suffering from this lack of appropriate semantics.  They are not
> getting files backed up which need to be.

Yeah, but I bet, that just updating the times on msync and munmap will
cure the problem.  Until you prove me wrong, this is a purely
theoretical argument.

> > Applications should be encouraged to call msync(MS_ASYNC) because:
> >
> >   - it's very fast (basically a no-op) on recent linux kernels
> >
> >   - it's the only portable way to guarantee, that the data you written
> >     will _ever_ hit the disk.
> >
> > There's really no downside to using msync(MS_ASYNC) in your
> > application, so making an effort to support applications that don't do
> > this is stupid, IMO.
> 
> It may be a no-op on recent Linux kernels, but I don't think that it
> is a no-op on other systems.

Exactly.  Which is the reason applications _have_ to call msync on
these OSs if they want data to be synchronized with the file.

There are two cases:

 1) app don't cares about it's data being synchronized with the file

 2) app does care

In the first case there's no problem if the times aren't updated,
since the app didn't care.

In the second case the a portable application has to call msync, and
on linux it doesn't even lose any performance from this, so it should
be happy.

You are trying to provide for an app that requires 1) on non-linux and
2) on linux.  Does that make any sense?

Miklos
