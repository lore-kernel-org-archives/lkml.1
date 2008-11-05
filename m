Return-Path: <linux-kernel-owner+w=401wt.eu-S1755203AbYKEVrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbYKEVrS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 16:47:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbYKEVrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 16:47:08 -0500
Received: from mail.fieldses.org ([66.93.2.214]:46692 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115AbYKEVrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 16:47:07 -0500
Date: Wed, 5 Nov 2008 16:46:55 -0500
To: Doug Nazar <nazard@dragoninc.ca>
Cc: "'David Woodhouse'" <David.Woodhouse@intel.com>,
       "'Al Viro'" <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.28-rc3 truncates nfsd results
Message-ID: <20081105214655.GK1455@fieldses.org>
References: <000301c93eaa$fae98460$f0bc8d20$@ca> <20081104223000.GG10974@fieldses.org> <004a01c93f37$f2a09090$d7e1b1b0$@ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <004a01c93f37$f2a09090$d7e1b1b0$@ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2008 at 06:16:28AM -0500, Doug Nazar wrote:
> 
> 
> > From: J. Bruce Fields [mailto:bfields@fieldses.org]
> > On Tue, Nov 04, 2008 at 01:27:23PM -0500, Doug Nazar wrote:
> > > Commit 8d7c4203 "nfsd: fix failure to set eof in readdir in some situations"
> > > breaks the nfsd server. Bisected it back to this commit and reverting it
> > > fixes the problem.
> > >
> > > However, it only happens on certain machines even with the same kernel &
> > > filesystem (ext3). I've two groups of similar computers, each group running
> > > identical kernels. The ones listing only ~250 files are of course in error.
> > > Eldritch is running 2.6.28-rc3 with that commit reverted. With 2.8.28-rc3 it
> > > showed the incorrect number.
> > 
> > Well, that's strange; it must be staring me in the face, but I don't see
> > the problem (and can't reproduce it).  Can you watch for the readdir
> > with wireshark and see if it's returning an error on the readdir?  Or is
> > it  just returning succesfully with eof set after the first ~250
> > entries?
> 
> Ok, think I've figured it out. 

Awesome, good job working this out.

Anyone know where to find the best documentation of the vfs_readdir
semantics?  I obviously didn't understand it as well as I should.

> The computers showing the issue are not using dir_index. This causes
> ext3 to read a block at a time, which then means we can end up with
> buf.full==0 but not finished reading the directory. Before 8d7c4203,
> we'd always get called again because we never set nfserr_eof which
> papered over it.

OK, so if I'm understanding you correctly: there was also (as of
c002a6c797 "Optimise NFS readdir hack slightly"?) a performance
regression which could force the client to do more round trips to the
server to read the whole directory?

> I think the correct solution is to move nfserr_eof into the loop and
> remove the buf.full check so that we loop until buf.used==0.  The
> following seems to do the right thing and reduces the network traffic
> since we now ensure each buffer is full.
> 
> Tested on an empty directory & large directory, eof is properly sent
> and no short buffers.

Thanks, looking....

--b.

> 
> diff --git a/fs/nfsd/vfs.c b/fs/nfsd/vfs.c
> index 848a03e..4433c8f 100644
> --- a/fs/nfsd/vfs.c
> +++ b/fs/nfsd/vfs.c
> @@ -1875,11 +1875,11 @@ static int nfsd_buffered_readdir(struct file *file, filldir_t func,
>  		return -ENOMEM;
>  
>  	offset = *offsetp;
> -	cdp->err = nfserr_eof; /* will be cleared on successful read */
>  
>  	while (1) {
>  		unsigned int reclen;
>  
> +		cdp->err = nfserr_eof; /* will be cleared on successful read */
>  		buf.used = 0;
>  		buf.full = 0;
>  
> @@ -1912,9 +1912,6 @@ static int nfsd_buffered_readdir(struct file *file, filldir_t func,
>  			de = (struct buffered_dirent *)((char *)de + reclen);
>  		}
>  		offset = vfs_llseek(file, 0, SEEK_CUR);
> -		cdp->err = nfserr_eof;
> -		if (!buf.full)
> -			break;
>  	}
>  
>   done:
> 
> 
> 
