Return-Path: <linux-kernel-owner+w=401wt.eu-S1757326AbYFJSzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326AbYFJSzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 14:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYFJSy5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 14:54:57 -0400
Received: from pat.uio.no ([129.240.10.15]:35893 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753254AbYFJSy4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 14:54:56 -0400
Subject: Re: [2.6.26-rc4] mount.nfsv4/memory poisoning issues...
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jeff Layton <jlayton@redhat.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>, linux-nfs@vger.kernel.org,
       nfsv4@linux-nfs.org, Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20080604203504.62730951@tleilax.poochiereds.net>
References: <6278d2220806041633n3bfe3dd2ke9602697697228b@mail.gmail.com>
	 <20080604203504.62730951@tleilax.poochiereds.net>
Content-Type: text/plain
Date: Tue, 10 Jun 2008 14:54:48 -0400
Message-Id: <1213124088.20459.16.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 4A1681D7D7049CBFE4CE8F75022BDC0F74A41956
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 656 total 8861850 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-06-04 at 20:35 -0400, Jeff Layton wrote:
> On Thu, 5 Jun 2008 00:33:54 +0100
> "Daniel J Blueman" <daniel.blueman@gmail.com> wrote:
> 
> > Having experienced 'mount.nfs4: internal error' when mounting nfsv4 in
> > the past, I have a minimal test-case I sometimes run:
> > 
> > $ while :; do mount -t nfs4 filer:/store /store; umount /store; done
> > 
> > After ~100 iterations, I saw the 'mount.nfs4: internal error',
> > followed by symptoms of memory corruption [1], a locking issue with
> > the reporting [2] and another (related?) memory-corruption issue
> > (off-by-1?) [3]. A little analysis shows memory being overwritten by
> > (likely) a poison value, which gets complicated if it's not
> > use-after-free...
> > 
> > Anyone dare confirm this issue? NFSv4 server is x86-64 Ubuntu 8.04
> > 2.6.24-18, client U8.04 2.6.26-rc4; batteries included [4].
> > 
> > I'm happy to decode addresses, test patches etc.
> > 
> > Daniel
> > 
> 
> Looks like it fell down while trying to take down the kthread during a
> failed mount attempt. I have to wonder if I might have introduced a
> race when I changed nfs4 callback thread to kthread API. I think we may
> need the BKL around the last 2 statements in the main callback thread
> function. If you can easily reproduce this, could you test the
> following patch and let me know if it helps?
> 
> Note that this patch is entirely untested, so test it someplace
> non-critical ;-).
> 
> Signed-off-by: Jeff Layton <jlayton@redhat.com>
> 
> 
> diff --git a/fs/nfs/callback.c b/fs/nfs/callback.c
> index c1e7c83..a3e83f9 100644
> --- a/fs/nfs/callback.c
> +++ b/fs/nfs/callback.c
> @@ -90,9 +90,9 @@ nfs_callback_svc(void *vrqstp)
>  		preverr = err;
>  		svc_process(rqstp);
>  	}
> -	unlock_kernel();
>  	nfs_callback_info.task = NULL;
>  	svc_exit_thread(rqstp);
> +	unlock_kernel();
>  	return 0;
>  }

We certainly need to protect nfs_callback_info.task (and I believe I
explained this earlier), but why do we need to protect svc_exit_thread?

Also, looking at the general use of the BKL in that code, I thought we
agreed that there was no need to hold the BKL while taking the
nfs_callback_mutex?

Trond

