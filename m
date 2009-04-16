Return-Path: <linux-kernel-owner+w=401wt.eu-S1756505AbZDPOgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505AbZDPOgo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Apr 2009 10:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754584AbZDPOge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Apr 2009 10:36:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50809 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752501AbZDPOgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Apr 2009 10:36:33 -0400
Date: Thu, 16 Apr 2009 10:36:26 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>,
       viro@zeniv.linux.org.uk
Subject: Re: [PATCH -tip] remove the BKL: Replace BKL in mount/umount
	syscalls with a mutex
Message-ID: <20090416143626.GA17683@infradead.org>
References: <1239892078-6039-1-git-send-email-abogani@texware.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239892078-6039-1-git-send-email-abogani@texware.it>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 16, 2009 at 04:27:58PM +0200, Alessio Igor Bogani wrote:
> Replace ths BKL in sys_mount()/sys_umount() syscalls with a regular mutex.

Could you try to explain what these actuall try to protect?

>  	unsigned long tmp = ((unsigned long)mnt / L1_CACHE_BYTES);
> @@ -1073,9 +1075,9 @@ static int do_umount(struct vfsmount *mnt, int flags)
>  	 */
>  
>  	if (flags & MNT_FORCE && sb->s_op->umount_begin) {
> -		lock_kernel();
> +		mutex_lock(&mount_lock);
>  		sb->s_op->umount_begin(sb);
> -		unlock_kernel();
> +		mutex_unlock(&mount_lock);

This is a very easy case, just move the lock into ->umount_begin.  And
then ping the maintainers of the 5 instances actually making use of it -
I suspect none of them actually require it.

> @@ -1094,9 +1096,9 @@ static int do_umount(struct vfsmount *mnt, int flags)
>  		 */
>  		down_write(&sb->s_umount);
>  		if (!(sb->s_flags & MS_RDONLY)) {
> -			lock_kernel();
> +			mutex_lock(&mount_lock);
>  			retval = do_remount_sb(sb, MS_RDONLY, NULL, 0);
> -			unlock_kernel();
> +			mutex_unlock(&mount_lock);

I suspect moving lock_kernel down into ->remount_fs is the much better
option.  Will require some audit of do_remount_sb, though.

> -	lock_kernel();
> +	mutex_lock(&mount_lock);
>  	retval = do_mount((char *)dev_page, dir_page, (char *)type_page,
>  			  flags, (void *)data_page);
> -	unlock_kernel();
> +	mutex_unlock(&mount_lock);

Again, much better to push it down and probably eliminate it completely
for all sane filesystems.

