Return-Path: <linux-kernel-owner+w=401wt.eu-S1754531AbYFCQgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbYFCQgW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 12:36:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752487AbYFCQgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 12:36:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752413AbYFCQgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 12:36:05 -0400
Date: Tue, 3 Jun 2008 09:35:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ian Kent <raven@themaw.net>
cc: Al Viro <viro@ZenIV.linux.org.uk>, Miklos Szeredi <miklos@szeredi.hu>,
       jesper@krogh.cc, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: Linux 2.6.26-rc4
In-Reply-To: <1212509263.3025.66.camel@raven.themaw.net>
Message-ID: <alpine.LFD.1.10.0806030926330.3473@woody.linux-foundation.org>
References: <alpine.LFD.1.10.0805261127030.2958@woody.linux-foundation.org>  <47107.195.41.66.226.1212486572.squirrel@mail.jabbernet.dk>  <20080603095713.GR28946@ZenIV.linux.org.uk>  <5440.195.41.66.226.1212487482.squirrel@mail.jabbernet.dk> 
 <E1K3TWc-0005gV-1l@pomaz-ex.szeredi.hu>  <20080603104035.GT28946@ZenIV.linux.org.uk>  <E1K3U1F-0005le-07@pomaz-ex.szeredi.hu>  <20080603105258.GV28946@ZenIV.linux.org.uk>  <1212499623.3025.46.camel@raven.themaw.net>  <alpine.LFD.1.10.0806030751040.3473@woody.linux-foundation.org>
 <1212509263.3025.66.camel@raven.themaw.net>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Jun 2008, Ian Kent wrote:
> 
> The code we're talking about deals with a race between expiring and
> mounting an autofs mount point at the same time. 
> 
> I'll have a closer look and see if I can make it work without turning
> the dentry negative.

Hmm.

Can you walk me through this?

If the dentry is unhashed, it means that it _either_

 - has already been deleted (rmdir'ed) or d_invalidate()'d. Right?

   I don't see why you should ever return the dentry in this case..

 - or it has not yet been hashed at all

   But then d_inode should be NULL too, no?

Anyway, as far as I can tell, you should handle the race between expiring 
and re-mounting not by unhashing at expire time (which causes these kinds 
of problems), but by setting a bit in the dentry and using the dentry 
"revalidate()" callback to wait for the revalidate.

But I don't know autofs4, so you probably have some reason. Could you 
explain it?

		Linus
