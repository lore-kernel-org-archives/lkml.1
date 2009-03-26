Return-Path: <linux-kernel-owner+w=401wt.eu-S1758073AbZCZRtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758073AbZCZRtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 13:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbZCZRtK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 13:49:10 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:46555 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbZCZRtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 13:49:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bHaYjas67JFdFnJPUbhw18bQl6E1HuilTy4h8EKWvED+wWSxmO4imio4weqDuNW+Cr
         BEN6SZ/CDmDZIZvKcwNxGSONlcDhO+yBuHinUEw/gjwPNQmZJ+8GGhBKkt1aYQaq5HJJ
         leyoHLLjpNPjFc18jE53VXWK/qFp+sh6YPdgY=
Date: Thu, 26 Mar 2009 20:56:29 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Frans Pop <elendil@planet.nl>, mingo@elte.hu, tytso@mit.edu,
       jack@suse.cz, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       a.p.zijlstra@chello.nl, npiggin@suse.de, jens.axboe@oracle.com,
       drees76@gmail.com, jesper@krogh.cc, linux-kernel@vger.kernel.org,
       oleg@redhat.com, roland@redhat.com, willy@linux.intel.com,
       vaurora@redhat.com
Subject: Re: [PATCH] Allow relatime to update atime once a day
Message-ID: <20090326175629.GA13742@x200.localdomain>
References: <20090325235041.GA11024@duck.suse.cz> <20090326090630.GA9369@elte.hu> <20090326113705.GV32307@mit.edu> <20090326140312.GB14822@elte.hu> <20090326140312.GB14822@elte.hu> <20090326073013.2fa83178.akpm@linux-foundation.org> <200903261632.42439.elendil@planet.nl> <20090326084733.156c4910.akpm@linux-foundation.org> <alpine.LFD.2.00.0903260912270.3032@localhost.localdomain> <20090326173214.GA7198@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090326173214.GA7198@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 05:32:14PM +0000, Matthew Garrett wrote:
> Allow atime to be updated once per day even with relatime. This lets
> utilities like tmpreaper (which delete files based on last access time)
> continue working, making relatime a plausible default for distributions.

> +/*
> + * With relative atime, only update atime if the previous atime is
> + * earlier than either the ctime or mtime or if at least a day has
> + * passed since the last atime update.
> + */
> +static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
> +			     struct timespec now)
> +{
> +
> +	if (!(mnt->mnt_flags & MNT_RELATIME))
> +		return 1;
> +	/*
> +	 * Is mtime younger than atime? If yes, update atime:
> +	 */
> +	if (timespec_compare(&inode->i_mtime, &inode->i_atime) >= 0)
> +		return 1;
> +	/*
> +	 * Is ctime younger than atime? If yes, update atime:
> +	 */
> +	if (timespec_compare(&inode->i_ctime, &inode->i_atime) >= 0)
> +		return 1;
> +
> +	/*
> +	 * Is the previous atime value older than a day? If yes,
> +	 * update atime:
> +	 */
> +	if ((long)(now.tv_sec - inode->i_atime.tv_sec) >= 24*60*60)
> +		return 1;
> +	/*
> +	 * Good, we can skip the atime update:
> +	 */
> +	return 0;
> +}

Good example of overcommented code.
