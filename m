Return-Path: <linux-kernel-owner+w=401wt.eu-S1754618Ab0AHBMv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754618Ab0AHBMv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 20:12:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594Ab0AHBMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 20:12:51 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32951 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754168Ab0AHBMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 20:12:50 -0500
Date: Thu, 7 Jan 2010 17:12:29 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Trond Myklebust <Trond.Myklebust@netapp.com>
cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Please pull NFS client bugfixes....
In-Reply-To: <1262912601.2659.89.camel@localhost>
Message-ID: <alpine.LFD.2.00.1001071707430.7821@localhost.localdomain>
References: <1262896174.2659.3.camel@localhost>  <87zl4pmxzp.fsf@basil.nowhere.org> <1262901198.2659.38.camel@localhost>  <20100107235149.GD16076@basil.fritz.box>  <1262909682.2659.45.camel@localhost>  <alpine.LFD.2.00.1001071633200.7821@localhost.localdomain>
 <1262912601.2659.89.camel@localhost>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Jan 2010, Trond Myklebust wrote:
> > 
> > Because it means that you can trivially take page faults before the thing 
> > is validated (think threads).
> 
> Which would mean that another process/thread already has part of the
> file mmapped on the same client. I'm not arguing that have to revalidate
> in _that_ case.

No, I'm talking about the new mapping. Nothing else.

If the mmap'ing thread releases mmap_sem, and then does the revalidate, 
then you can have

	thread1				thread2
	-------				-------

	mmap
	map it in
	release mmap_sem
					page-fault the mapping before it got validated
	->post_mmap()
	revalidate outside mmap_sem

See? No "already part of the file mmapped" case at all. The exact mmap 
that you just set up - without the revalidation having happened.

In fact, because of this kind of _fundamental_ race, I don't see why I 
would ever accept any patches that add multiple mmap() down-calls at 
different phases to the filesystem at the VFS layer.

A filesystem that depends on the different phases would be a fundamentally 
buggy filesystem. Right now mmap is "atomic", and you can pre-populate (or 
pre-verify, like NFS does) the mapping in the _knowledge_ that there are 
no page faults that will populate it concurrently. Exactly because we hold 
the mmap_sem for writing.

				Linus
