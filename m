Return-Path: <linux-kernel-owner+w=401wt.eu-S1759251AbYJ3X32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759251AbYJ3X32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 19:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758281AbYJ3X3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 19:29:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46816 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755185AbYJ3X3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 19:29:15 -0400
Date: Thu, 30 Oct 2008 16:28:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg KH <greg@kroah.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: merging other repos into linux-2.6
In-Reply-To: <20081030215734.GA18822@kroah.com>
Message-ID: <alpine.LFD.2.00.0810301619260.21084@nehalem.linux-foundation.org>
References: <20081030054944.GA19035@kroah.com> <alpine.LFD.2.00.0810301152230.3505@nehalem.linux-foundation.org> <20081030215734.GA18822@kroah.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 30 Oct 2008, Greg KH wrote:
> 
> But as for the 'bisectability' at one point in the merge, you will be
> adding a stand-alone driver into the kernel itself.  So for anyone
> traversing down that path, all you would be building would be the driver
> itself, the whole rest of the kernel is "gone".

Right. This was exactly what happened initially in the btrfs thing. And it 
was horrid.

It was horrid because it was totally unexpected for users, and causes huge 
churn and confusion when trying to check out a totally different directory 
layout (and git won't remove the old *.o files, so trust me, it _will_ be 
confusing).

But it was horrid also because if you do it the straightforward but stupid 
way (the way that git definitely does support) by using a "subdirectory 
merge" to merge the individual driver into a new location, it also makes 
the history almost totally useless. Suddenly trivial things like

	git log drivers/xyz/file.c

don't work well at all any more, because in the old history it will all be 
under the pathname "file.c" _without_ the drivers/xyz/ part. And the 
merge diff will be just one huge mess.. 

So yes, git can do it that way, but the end result is so horrible as to be 
worse than not importing the history at all!

What I got Chris Mason to do was to run

	git filter-branch --index odd-script-goes-here

with that odd script looking something like:

>       #!/bin/sh
>       exists=$(git ls-files fs/btrfs/)
>       [ -z "$exists" ] &&
>               git ls-files --stage |
>               awk -F '\t' '{ print "0 0000000000000000000000000000000000000000\t" $2 "\n" $1 "\tfs/btrfs/" $2 }' |
>               git update-index --index-info

which basically does a directory rename in the branch (obviously, in this 
case into fs/btrfs, which is not what _you_ want). That way, at least the 
directory structure of the tree you merge has the same layout, and you 
don't get _that_ particular directory jumping back and forth.

Chris also merged in the history at the 2.6.26 tree (I think), so that 
while his original history had had just a stand-alone btrfs build, the end 
result was actually *totally* bisectable. Again, you should ask him about 
any other scripts he ran.

			Linus
