Return-Path: <linux-kernel-owner+w=401wt.eu-S1760820AbXGPTHk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760820AbXGPTHk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 15:07:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbXGPTHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 15:07:32 -0400
Received: from mail4.iitk.ac.in ([203.197.196.4]:54256 "EHLO mail4.iitk.ac.in"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752056AbXGPTHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 15:07:31 -0400
X-Virus-Scanner: This message was checked by NOD32 Antivirus system
	for Linux Server. For more information on NOD32 Antivirus System,
	please, visit our website: http://www.nod32.com/.
Date: Tue, 17 Jul 2007 01:00:42 +0530 (IST)
From: Satyam Sharma <ssatyam@cse.iitk.ac.in>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>, Ulrich Drepper <drepper@redhat.com>
Subject: Re: [PATCH] utime(s): Honour CAP_FOWNER when times==NULL
In-Reply-To: <alpine.LFD.0.999.0707161142210.20061@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0707170054100.2005@cselinux1.cse.iitk.ac.in>
References: <20070716185423.1607.78787.sendpatchset@cselinux1.cse.iitk.ac.i
 n> <alpine.LFD.0.999.0707161142210.20061@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2007, Linus Torvalds wrote:
> 
> 
> On Tue, 17 Jul 2007, Satyam Sharma wrote:
> >
> > [PATCH] utime(s): Honour CAP_FOWNER when times==NULL
> > 
> > do_utimes() does not honour CAP_FOWNER when times==NULL.
> > Trivial and obvious one-line fix.
> 
> Ahh, ok. Is this old, or was it introduced recently (I'm looking at my 
> recent change to that area, it doesn't seem to introduce this)?

Old, I'd think. Note that this issue was hidden behind the fact that
we would call vfs_permission()->generic_permission() anyway even if
that check failed.

Now generic_permission() returns 0 (success) if capable(CAP_DAC_OVERRIDE)
and -EACCES otherwise (that's for MAY_WRITE tests, which is what this
one is). Now I suspect most (all?) common userspace programs out there
just don't ever have a capable(CAP_DAC_OVERRIDE) && !capable(CAP_FOWNER)
kind of capability mix, so we never saw this before.

[ That does not mean this is not an issue, of course, though. ]

> IOW, how did you even notice this?

Just code inspection. In fact I got interested in following this
codepath precisely after the recent discussion on this list ...

> Also, while your one-liner looks correct, it does make me wonder: the 
> whole
> 
> 	if ((current->fsuid != inode->i_uid) && !capable(CAP_FOWNER))
> 
> test is a rather common test, and in fact, arguably, every time you see 
> one part of it, you should probably see the other. Would it make sense to 
> make a helper inline function to do this, and replace all users? Doing a
> 
> 	git grep 'fsuid.*\<i_uid\>'
> 
> seems to show quite a few cases of this pattern..

Yes, I thought of writing a helper function for this myself. The semantics
of CAP_FOWNER sort of justify that, but probably better to get Al's views
on this first.

Satyam
