Return-Path: <linux-kernel-owner+w=401wt.eu-S1763756AbXGPUph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763756AbXGPUph (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 16:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756554AbXGPUp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 16:45:28 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:40350 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756399AbXGPUp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 16:45:27 -0400
Date: Mon, 16 Jul 2007 21:45:23 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH] utime(s): Honour CAP_FOWNER when times==NULL
Message-ID: <20070716204523.GJ21668@ftp.linux.org.uk>
References: <20070716185423.1607.78787.sendpatchset@cselinux1.cse.iitk.ac.in> <alpine.LFD.0.999.0707161142210.20061@woody.linux-foundation.org> <Pine.LNX.4.64.0707170054100.2005@cselinux1.cse.iitk.ac.in>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707170054100.2005@cselinux1.cse.iitk.ac.in>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 01:00:42AM +0530, Satyam Sharma wrote:
> > 	if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> > 
> > test is a rather common test, and in fact, arguably, every time you see 
> > one part of it, you should probably see the other. Would it make sense to 
> > make a helper inline function to do this, and replace all users? Doing a
> > 
> > 	git grep 'fsuid.*\<i_uid\>'
> > 
> > seems to show quite a few cases of this pattern..
> 
> Yes, I thought of writing a helper function for this myself. The semantics
> of CAP_FOWNER sort of justify that, but probably better to get Al's views
> on this first.

Helper makes sense (and most of these places will become its call), but...
E.g. IIRC the change of UID requires CAP_CHOWN; CAP_FOWNER is not enough.
Ditto for change of GID.  setlease() is using CAP_LEASE and that appears
to be intentional (no idea what relevant standards say here)...

I'd suggest converting the obvious cases with new helper and taking the
rest one-by-one after that.  Some of those might want CAP_FOWNER added,
some not...
