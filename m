Return-Path: <linux-kernel-owner+w=401wt.eu-S1758215AbYFTRe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215AbYFTRe1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 13:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753970AbYFTReT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 13:34:19 -0400
Received: from mail.fieldses.org ([66.93.2.214]:56470 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753242AbYFTReT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 13:34:19 -0400
Date: Fri, 20 Jun 2008 13:34:17 -0400
To: NeilBrown <neilb@suse.de>
Cc: linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH - take 2] knfsd: nfsd: Handle ERESTARTSYS from syscalls.
Message-ID: <20080620173417.GB563@fieldses.org>
References: <20080619101025.24263.patches@notabene> <1080619001109.24338@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1080619001109.24338@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, applied (and replaced the earlier patch in the for-2.6.27 branch
at

	git://linux-nfs.org/~bfields/linux.git for-2.6.27

I saw sort of curious if I could convince myself to go through this
cycle only appending to that branch.  I guess not.  Maybe next time.)

--b.

On Thu, Jun 19, 2008 at 10:11:09AM +1000, NeilBrown wrote:
> 
> OCFS2 can return -ERESTARTSYS from write requests (and possibly
> elsewhere) if there is a signal pending.
> 
> If nfsd is shutdown (by sending a signal to each thread) while there
> is still an IO load from the client, each thread could handle one last
> request with a signal pending.  This can result in -ERESTARTSYS
> which is not understood by nfserrno() and so is reflected back to
> the client as nfserr_io aka -EIO.  This is wrong.
> 
> Instead, interpret ERESTARTSYS to mean "try again later" by returning
> nfserr_jukebox.  The client will resend and - if the server is
> restarted - the write will (hopefully) be successful and everyone will
> be happy.
> 
>  The symptom that I narrowed down to this was:
>     copy a large file via NFS to an OCFS2 filesystem, and restart
>     the nfs server during the copy.
>     The 'cp' might get an -EIO, and the file will be corrupted -
>     presumably holes in the middle where writes appeared to fail.
> 
> 
> Signed-off-by: Neil Brown <neilb@suse.de>
> 
> ### Diffstat output
>  ./fs/nfsd/nfsproc.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff .prev/fs/nfsd/nfsproc.c ./fs/nfsd/nfsproc.c
> --- .prev/fs/nfsd/nfsproc.c	2008-06-19 10:06:36.000000000 +1000
> +++ ./fs/nfsd/nfsproc.c	2008-06-19 10:07:58.000000000 +1000
> @@ -614,6 +614,7 @@ nfserrno (int errno)
>  #endif
>  		{ nfserr_stale, -ESTALE },
>  		{ nfserr_jukebox, -ETIMEDOUT },
> +		{ nfserr_jukebox, -ERESTARTSYS },
>  		{ nfserr_dropit, -EAGAIN },
>  		{ nfserr_dropit, -ENOMEM },
>  		{ nfserr_badname, -ESRCH },
