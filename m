Return-Path: <linux-kernel-owner+w=401wt.eu-S1761778AbXFTJJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761778AbXFTJJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 05:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753460AbXFTJJf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 05:09:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.180]:27913 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbXFTJJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 05:09:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=odN/3zaPfnV8I8HpuvfXmE2pfe8q0m7AgTwRUvdDW8I3BZ0H+2oI6wZgLt6vlGhFe5tV4eni85NlGVDOAmlrFI9UjzxaskRw6jGcuej9k2Y+5m3/hylC7o9gPGj96Qf5Y7qkEejW28NIy+Fq4yl9h1KHxCDAXO8rBmRs8AYrg5o=
Message-ID: <344eb09a0706200209j30ccad0k17bc994b6e637988@mail.gmail.com>
Date: Wed, 20 Jun 2007 14:39:34 +0530
From: "Bharata B Rao" <bharata.rao@gmail.com>
To: "Jan Blunck" <jblunck@suse.de>
Subject: Re: [RFC PATCH 1/4] Union mount documentation.
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       bharata@linux.vnet.ibm.com
In-Reply-To: <f5ang7$foi$4@sea.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070620055050.GB4267@in.ibm.com>
	 <20070620055157.GC4267@in.ibm.com> <f5ang7$foi$4@sea.gmane.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/20/07, Jan Blunck <jblunck@suse.de> wrote:
> On Wed, 20 Jun 2007 11:21:57 +0530, Bharata B Rao wrote:
> <snip>
> Well done. I like your approach much more than the simple chaining of
> dentries. When I told you about the idea of maintaining a list of
> <dentry,vfsmount> objects I always though about one big structure for all
> the layers of an union. Smaller objects that only point to the next layer
> seem to be better but make the search for the topmost layer impossible.
> You should maintain a reference to the topmost struct union_mount though.

Even in our last version I didn't understand clearly why you had
pointers from the bottom layers to the topmost layer. Could you please
explain under what circumstances there needs to be a bottom to top
traversal ?

>
> > +5. Union stack: destroying
> > +--------------------------
> > +In addition to storing the union_mounts in a hash table for quick
> > lookups, +they are also stored as a list, headed at vsmount->mnt_union.
> > So, all +union_mounts that occur under a vfsmount (starting from the
> > mountpoint +followed by the subdir unions) are stored within the
> > vfsmount. During +umount (specifically, during the last mntput()), this
> > list is traversed +to destroy all union stacks under this vfsmount. +
> > +Hence, all union stacks under a vfsmount continue to exist until the
> > +vfsmount is unmounted. It may be noted that the union_mount structure
> > +holds a reference to the current dentry also. Becasue of this, for
> > +subdir unions, both the top and bottom level dentries become pinned
> > +till the upper layer filesystem is unmounted. Is this behaviour
> > +acceptable ? Would this lead to a lot of pinned dentries over a period
> > +of time ? (CHECK) If we don't do this, the top layer dentry might go
> > +out of cache, during which time we have no means to release the
> > +corresponding union_mount and the union_mount becomes stale. Would it
> > +be necessary and worthwhile to add intelligence to prune_dcache() to
> > +prune unused union_mounts thereby releasing the dentries ? +
> > +As noted above, we hold the refernce to current dentry from union_mount
> > +but don't get a reference to the corresponding vfsmount. We depend on
> > +the user of the union stack to hold the reference to the topmost
> > vfsmount +until he is done with the stack traversal. Not holding a
> > reference to the +top vfsmount from within union_mount allows us to free
> > all the union_mounts +from last mntput of the top vfsmount. Is this
> > approach acceptable ? +
> > +NOTE: union_mount structures are part of two lists: the hash list for
> > +quick lookups and a linked list to aid the freeing of these structures
> > +during unmount.
>
> This must changed. This is the only reason why the dentry chaining
> approach was so complex. You need a way to get rid of all unused dentries
> in a union.

The second list headed at mnt->mnt_union was added precisely  to get
rid of all the union_mounts under a vfsmount at umount time. So umount
is the time to destroy the union stack.
>
> Besides that, I wonder why you left out the rest of my code? The readdir,
> whiteout and copyup parts are orthogonal to the code for maintaining the
> union structure itself. I just rewrote most of it myself to use functions
> like follow_union_down() etc to get rid of the dentry chaining in the long
> run.

The idea was to start simple, get some feedback and concensus and add
features after that. Some of the feedback I got from our last two
posts was that the code was too complex and big to review and we had
so many patches. So this time I have started with the bare minimum so
that it becomes easier for the reviewers. I plan to add copyup and
whiteout only when there is an agreement that this approach of
unioning is acceptable.

And about readdir, I digressed from your approach a bit and made
readdir cache persistant across readdir()/getdents() calls. Also, made
readdir on union mounted directories filesystem independent unlike our
earlier approach. But again this breaks lseek as I have noted, which
needs to be fixed.

Regards,
Bharata.
-- 
"Men come and go but mountains remain" -- Ruskin Bond.
