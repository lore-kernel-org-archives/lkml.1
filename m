Return-Path: <linux-kernel-owner+w=401wt.eu-S1762622AbZJOKki@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762622AbZJOKki (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 06:40:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757035AbZJOKkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 06:40:37 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45521 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756643AbZJOKkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 06:40:36 -0400
Date: Thu, 15 Oct 2009 12:39:58 +0200
From: Nick Piggin <npiggin@suse.de>
To: Anton Blanchard <anton@samba.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jens Axboe <axboe@kernel.dk>
Subject: Re: Latest vfs scalability patch
Message-ID: <20091015103958.GA3127@wotan.suse.de>
References: <20091006064919.GB30316@wotan.suse.de> <20091015100854.GA19948@kryten>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091015100854.GA19948@kryten>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

On Thu, Oct 15, 2009 at 09:08:54PM +1100, Anton Blanchard wrote:
> 
> Hi Nick,
> 
> > Several people have been interested to test my vfs patches, so rather
> > than resend patches I have uploaded a rollup against Linus's current
> > head.
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/npiggin/patches/fs-scale/
> > 
> > I have used ext2,ext3,autofs4,nfs as well as in-memory filesystems
> > OK (although this doesn't mean there are no bugs!). Otherwise, if your
> > filesystem compiles, then there is a reasonable chance of it working,
> > or ask me and I can try updating it for the new locking.
> > 
> > I would be interested in seeing any numbers people might come up with,
> > including single-threaded performance.
> 
> Thanks for doing a rollup patch, it made it easy to test. I gave it a spin on
> a 64 core (128 thread) POWER5+ box. I started simple by looking at open/close
> performance, eg:
> 
> void testcase(void)
> {
> 	char tmpfile[] = "/tmp/testfile.XXXXXX";
> 
> 	mkstemp(tmpfile);
> 
> 	while (1) {
> 		int fd = open(tmpfile, O_RDWR);
> 		close(fd);
> 	}
> }
> 
> At first the results were 10x slower. I took a look and it appears the
> MNT_MOUNTED flag is getting cleared by a remount (I'm testing on the root
> filesystem). This fixed it:

Oh dear, thanks for that. That bugfix is needed for the patchset
I just sent to be merged.

 
> --- fs/namespace.c~	2009-10-15 04:34:02.000000000 -0500
> +++ fs/namespace.c	2009-10-15 04:35:00.000000000 -0500
> @@ -1711,7 +1711,8 @@ static int do_remount(struct path *path,
>  	else
>  		err = do_remount_sb(sb, flags, data, 0);
>  	if (!err)
> -		path->mnt->mnt_flags = mnt_flags;
> +		path->mnt->mnt_flags = mnt_flags |
> +			(path->mnt->mnt_flags & MNT_MOUNTED);
>  	up_write(&sb->s_umount);
>  	if (!err) {
>  		security_sb_post_remount(path->mnt, flags, data);
> 
> Attached is a before and after graph. Single thread performance is 20%
> faster, and we go from hitting a wall at 2 cores to scaling all the way
> to 64 cores. Nice work!!!

Nice looking graph, thanks! Did you use the rcu patch there as
well? (my open-close testing chokes RCU but your system might
be managing to keep outstanding callbacks below the threshold)
 
