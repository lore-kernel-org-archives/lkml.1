Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639Ab0AHBWj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab0AHBWj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 20:22:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754624Ab0AHBWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 20:22:38 -0500
Received: from mx2.netapp.com ([216.240.18.37]:4604 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754594Ab0AHBWi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 20:22:38 -0500
X-IronPort-AV: E=Sophos;i="4.49,238,1262592000"; 
   d="scan'208";a="298903557"
Subject: Re: [GIT PULL] Please pull NFS client bugfixes....
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1001071707430.7821@localhost.localdomain>
References: <1262896174.2659.3.camel@localhost>
	 <87zl4pmxzp.fsf@basil.nowhere.org> <1262901198.2659.38.camel@localhost>
	 <20100107235149.GD16076@basil.fritz.box>
	 <1262909682.2659.45.camel@localhost>
	 <alpine.LFD.2.00.1001071633200.7821@localhost.localdomain>
	 <1262912601.2659.89.camel@localhost>
	 <alpine.LFD.2.00.1001071707430.7821@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Organization: NetApp
Date: Thu, 07 Jan 2010 20:22:32 -0500
Message-ID: <1262913752.2659.100.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
X-OriginalArrivalTime: 08 Jan 2010 01:22:37.0625 (UTC) FILETIME=[104BCA90:01CA9001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-07 at 17:12 -0800, Linus Torvalds wrote: 
> 
> On Thu, 7 Jan 2010, Trond Myklebust wrote:
> > > 
> > > Because it means that you can trivially take page faults before the thing 
> > > is validated (think threads).
> > 
> > Which would mean that another process/thread already has part of the
> > file mmapped on the same client. I'm not arguing that have to revalidate
> > in _that_ case.
> 
> No, I'm talking about the new mapping. Nothing else.
> 
> If the mmap'ing thread releases mmap_sem, and then does the revalidate, 
> then you can have
> 
> 	thread1				thread2
> 	-------				-------
> 
> 	mmap
> 	map it in
> 	release mmap_sem
> 					page-fault the mapping before it got validated
> 	->post_mmap()
> 	revalidate outside mmap_sem
> 
> See? No "already part of the file mmapped" case at all. The exact mmap 
> that you just set up - without the revalidation having happened.
> 
> In fact, because of this kind of _fundamental_ race, I don't see why I 
> would ever accept any patches that add multiple mmap() down-calls at 
> different phases to the filesystem at the VFS layer.
> 
> A filesystem that depends on the different phases would be a fundamentally 
> buggy filesystem. Right now mmap is "atomic", and you can pre-populate (or 
> pre-verify, like NFS does) the mapping in the _knowledge_ that there are 
> no page faults that will populate it concurrently. Exactly because we hold 
> the mmap_sem for writing.

I don't think anyone has been advocating doing the revalidation _after_
the call to mmap_region(). All I want is to be able to do it as part of
the mmap() syscall. It would be quite OK to add a ->pre_mmap() (which is
what I believe Peter's patches do).

All I want to ensure is that people who use non-posix-lock based
synchronisation can set the 'noac' flag, and be assured that if mmap()
is called _after_ they have grabbed their lock, then the page cache will
be duly revalidated (under the lock), and the fresh data will be made
available.

Trond
