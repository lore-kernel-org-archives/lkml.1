Return-Path: <linux-kernel-owner+w=401wt.eu-S1754810AbYHMHpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810AbYHMHpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 03:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYHMHpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 03:45:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59483 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbYHMHpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 03:45:22 -0400
Date: Wed, 13 Aug 2008 09:45:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Shaohua Li <shaohua.li@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch]fastboot: remove duplicate unpack_to_rootfs()
Message-ID: <20080813074503.GB398@elte.hu>
References: <1218607669.3463.9.camel@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1218607669.3463.9.camel@sli10-desk.sh.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Shaohua Li <shaohua.li@intel.com> wrote:

> we check if initrd is initramfs first and then do real unpack. The 
> check isn't required, we can directly do unpack. If initrd isn't 
> initramfs, we can remove garbage. In my laptop, this saves 0.1s boot 
> time. This penalizes non-initramfs case, but now initramfs is mostly 
> widely used.

clever concept!

a few observations about the cleanup function:

> +static void __init clean_rootfs(void)
> +{
> +	int fd = sys_open("/", O_RDONLY, 0);

can this ever fail?

> +	void *buf = malloc(1024);

no error checking for buf==NULL.

> +	struct linux_dirent64 *dirp = buf;
> +	int count;
> +
> +	memset(buf, 0, PAGE_SIZE);

overflow: clearly allocating a 1024 bytes buffer and then clearing 4096 
bytes isnt that good?

you could introduce a default-off CONFIG_DEBUG_ROOTFS_CLEANUP option 
that does two runs of unpack_to_rootfs() and inserts an artificial 
clean_rootfs() inbetween? Even if that debug patch doesnt get integrated 
its a good test for the cleanup function.

> +	count = sys_getdents64(fd, dirp, PAGE_SIZE);

... and then doing an up to 4096 bytes getdents into the buffer. A large 
enough initramfs will overflow this.

> +	while (count > 0) {
> +		while (count > 0) {
> +			struct stat st;
> +
> +			sys_newlstat(dirp->d_name, &st);

can this ever fail? If yes we should at least WARN_ON_ONCE().

> +			if (S_ISDIR(st.st_mode))
> +				sys_rmdir(dirp->d_name);
> +			else
> +				sys_unlink(dirp->d_name);
> +
> +			count -= dirp->d_reclen;

can this ever zero-underflow, with a sufficiently corrupted initramfs? 
We should check for 0 underflow to be sure.

> +			dirp = (void *)dirp + dirp->d_reclen;

likewise, we should size-overflow check this pointer. Failure modes of 
overrunning the buffer are subtle and hard to notice/track down.

> +		}
> +		dirp = buf;
> +		memset(buf, 0, 1024);
> +		count = sys_getdents64(fd, dirp, PAGE_SIZE);

overflow: we do a 4096 bytes getdents into a 1K buffer.

> +	}
> +
> +	sys_close(fd);
> +	free(buf);
> +}
> +
>  static int __init populate_rootfs(void)
>  {
>  	char *err = unpack_to_rootfs(__initramfs_start,
> @@ -531,13 +563,15 @@ static int __init populate_rootfs(void)
>  		int fd;
>  		printk(KERN_INFO "checking if image is initramfs...");
>  		err = unpack_to_rootfs((char *)initrd_start,
> -			initrd_end - initrd_start, 1);
> +			initrd_end - initrd_start, 0);
>  		if (!err) {
>  			printk(" it is\n");
> -			unpack_to_rootfs((char *)initrd_start,
> -				initrd_end - initrd_start, 0);
>  			free_initrd();
>  			return 0;
> +		} else {
> +			clean_rootfs();
> +			unpack_to_rootfs(__initramfs_start,
> +				 __initramfs_end - __initramfs_start, 0);
>  		}

the dry_run variable is now unused in unpack_to_rootfs() and could be 
eliminated.

>  		printk("it isn't (%s); looks like an initrd\n", err);
>  		fd = sys_open("/initrd.image", O_WRONLY|O_CREAT, 0700);

	Ingo
