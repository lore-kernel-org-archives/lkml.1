Return-Path: <linux-kernel-owner+w=401wt.eu-S1756175AbZLEUX3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175AbZLEUX3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Dec 2009 15:23:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753590AbZLEUXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Dec 2009 15:23:23 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:47706 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752273AbZLEUXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Dec 2009 15:23:22 -0500
X-Trace: 298732445/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.111.197/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.111.197
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvoAALdPGktQKW/F/2dsb2JhbAAI1HKEMwQ
X-IronPort-AV: E=Sophos;i="4.47,347,1257120000"; 
   d="scan'208";a="298732445"
Date: Sat, 5 Dec 2009 20:23:18 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Eric Paris <eparis@redhat.com>
cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, viro@zeniv.linux.org.uk, jmorris@namei.org,
       npiggin@suse.de, zohar@us.ibm.com, jack@suse.cz, jmalicki@metacarta.com,
       dsmith@redhat.com, serue@us.ibm.com, hch@lst.de, john@johnmccutchan.com,
       rlove@rlove.org, ebiederm@xmission.com, heiko.carstens@de.ibm.com,
       penguin-kernel@I-love.SAKURA.ne.jp, mszeredi@suse.cz,
       jens.axboe@oracle.com, akpm@linux-foundation.org, matthew@wil.cx,
       hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com,
       nishimura@mxp.nes.nec.co.jp, davem@davemloft.net, arnd@arndb.de,
       eric.dumazet@gmail.com
Subject: Re: [RFC PATCH 01/15] shmem: do not call fput_filp on an initialized
 filp
In-Reply-To: <20091204204646.18286.24853.stgit@paris.rdu.redhat.com>
Message-ID: <Pine.LNX.4.64.0912052020360.6368@sister.anvils>
References: <20091204204646.18286.24853.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Dec 2009, Eric Paris wrote:

> fput_filp is supposed to be used when the filp was not used.  But in the

   put_filp

> ifndef CONFIG_MMU case shmem_setup_file could call this one an initialized

                                                          on

> filp.  It should be using fput() instead.  Since the fput() will dec the ima
> counts we also need to move the ima hook to make sure that is set up before
> the fput().
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> Acked-by: Miklos Szeredi <miklos@szeredi.hu>

Thanks,
Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

> ---
> 
>  mm/shmem.c |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 356dd99..e7f8968 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2656,12 +2656,15 @@ struct file *shmem_file_setup(const char *name, loff_t size, unsigned long flags
>  	init_file(file, shm_mnt, dentry, FMODE_WRITE | FMODE_READ,
>  		  &shmem_file_operations);
>  
> +	ima_counts_get(file);
> +
>  #ifndef CONFIG_MMU
>  	error = ramfs_nommu_expand_for_mapping(inode, size);
> -	if (error)
> -		goto close_file;
> +	if (error) {
> +		fput(file);
> +		return error;
> +	}
>  #endif
> -	ima_counts_get(file);
>  	return file;
>  
>  close_file:
