Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbZD1STn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbZD1STn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 14:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbZD1STa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 14:19:30 -0400
Received: from mail-out2.uio.no ([129.240.10.58]:53968 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbZD1ST2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 14:19:28 -0400
Subject: Re: [PATCH] lockd: fix FILE_LOCKING=n build error
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Matthew Wilcox <matthew@wil.cx>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <49F7421A.1090709@oracle.com>
References: <20090428165343.2e357d7a.sfr@canb.auug.org.au>
	 <49F71F4A.3080908@oracle.com> <20090428172137.GA22451@fieldses.org>
	 <49F7421A.1090709@oracle.com>
Content-Type: text/plain
Date: Tue, 28 Apr 2009 14:15:54 -0400
Message-Id: <1240942554.7376.38.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 8 msgs/h 1 sum rcpts/h 11 sum msgs/h 1 total rcpts 96 max rcpts/h 12 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=_BLID_, uiouri=_URIID_)
X-UiO-Scanned: 42E68724C6C8CAEE5BAC53400DE7844F8893DB24
X-UiO-SPAM-Test: remote_host: 71.227.91.12 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 1 total 210 max/h 5 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-04-28 at 10:51 -0700, Randy Dunlap wrote:
> J. Bruce Fields wrote:
> > On Tue, Apr 28, 2009 at 08:22:50AM -0700, Randy Dunlap wrote:
> >> From: Randy Dunlap <randy.dunlap@oracle.com>
> >>
> >> lockd/svclock.c is missing a header file <linux/fs.h>.
> >>
> >> <linux/fs.h> is missing a definition of locks_release_private()
> >> for the config case of FILE_LOCKING=n, causing a build error:
> >>
> >> fs/lockd/svclock.c:330: error: implicit declaration of function 'locks_release_private'
> > 
> > LOCKD without FILE_LOCKING doesn't really make sense; would it be better
> > to add a config dependency?
> 
> 
> I just tried a patch like the one below instead of the first one,
> but it has build errors too, so more Makefile/Kconfig work is
> needed (by someone who knows what interfaces are needed here):
> 
> 
> fs/built-in.o: In function `nfs_start_lockd':
> client.c:(.text+0xe8848): undefined reference to `nlmclnt_init'
> fs/built-in.o: In function `nfs_destroy_server':
> client.c:(.text+0xe8885): undefined reference to `nlmclnt_done'
> fs/built-in.o: In function `nfs_proc_lock':
> proc.c:(.text+0xf735f): undefined reference to `nlmclnt_proc'
> fs/built-in.o: In function `nfs3_proc_lock':
> nfs3proc.c:(.text+0xfd1df): undefined reference to `nlmclnt_proc'
> 
> 
> 
> 
> lockd without FILE_LOCKING doesn't make sense, so make LOCKD and
> LOCKD_V4 depend on FILE_LOCKING.
> ---
>  fs/Kconfig     |    2 ++
>  fs/nfs/Kconfig |    2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> --- linux-next-20090428.orig/fs/Kconfig
> +++ linux-next-20090428/fs/Kconfig
> @@ -226,10 +226,12 @@ source "fs/nfsd/Kconfig"
>  
>  config LOCKD
>  	tristate
> +	depends on FILE_LOCKING
>  
>  config LOCKD_V4
>  	bool
>  	depends on NFSD_V3 || NFS_V3
> +	depends on FILE_LOCKING
>  	default y
>  
>  config EXPORTFS
> --- linux-next-20090428.orig/fs/nfs/Kconfig
> +++ linux-next-20090428/fs/nfs/Kconfig
> @@ -1,7 +1,7 @@
>  config NFS_FS
>  	tristate "NFS client support"
>  	depends on INET
> -	select LOCKD
> +	select LOCKD if FILE_LOCKING
>  	select SUNRPC
>  	select NFS_ACL_SUPPORT if NFS_V3_ACL
>  	help

Until someone finds time to go through the code and add in all the
CONFIG_FILE_LOCKING special cases, the above needs to be a 'depends on
INET && FILE_LOCKING'.

Trond

