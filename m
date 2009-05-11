Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbZEKTBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbZEKTBz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 15:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753190AbZEKTBr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 15:01:47 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48222 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753118AbZEKTBq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 15:01:46 -0400
Message-ID: <4A0875E5.9080005@suse.com>
Date: Mon, 11 May 2009 15:00:53 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] dup2: Fix return value with oldfd == newfd and invalid
 fd
References: <4A086D9E.60308@suse.com> <alpine.LFD.2.01.0905111135560.3586@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0905111135560.3586@localhost.localdomain>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Linus Torvalds wrote:
> 
> On Mon, 11 May 2009, Jeff Mahoney wrote:
>>  The return value of dup2 when oldfd == newfd and the fd isn't valid is not
>>  getting properly sign extended. We end up with 4294967287 instead of -EBADF.
> 
> Indeed.
> 
>>  This patch uses a signed int for the error value so it is properly extended.
> 
> However, I'd rather move the new variable into the block where it is used, 
> and keep the whole corner-case thing self-contained.
> 
> So can you verify that this trivial variation on the patch is ok by you, 
> and I'll commit it as yours with your message? (I realize it's really 
> trivial, and I could just do this myself, but good to get the change 
> ack'ed anyway).

Oh, of course. That's fine with me.

- -Jeff

> 
> 		Linus
> 
> ---
>  fs/fcntl.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/fcntl.c b/fs/fcntl.c
> index cc8e4de..1ad7031 100644
> --- a/fs/fcntl.c
> +++ b/fs/fcntl.c
> @@ -117,11 +117,13 @@ SYSCALL_DEFINE2(dup2, unsigned int, oldfd, unsigned int, newfd)
>  {
>  	if (unlikely(newfd == oldfd)) { /* corner case */
>  		struct files_struct *files = current->files;
> +		int retval = oldfd;
> +
>  		rcu_read_lock();
>  		if (!fcheck_files(files, oldfd))
> -			oldfd = -EBADF;
> +			retval = -EBADF;
>  		rcu_read_unlock();
> -		return oldfd;
> +		return retval;
>  	}
>  	return sys_dup3(oldfd, newfd, 0);
>  }


- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkoIdeUACgkQLPWxlyuTD7J8AACgmhqZUznCzrN25qBX6CzexXBu
NkcAn0qOA99rP6c72k+xs7ZRCbhLKKnR
=/rzV
-----END PGP SIGNATURE-----
