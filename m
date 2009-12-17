Return-Path: <linux-kernel-owner+w=401wt.eu-S1764203AbZLQJ3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764203AbZLQJ3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 04:29:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762364AbZLQJ3r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 04:29:47 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:33711 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759054AbZLQJ3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 04:29:45 -0500
Date: Thu, 17 Dec 2009 09:29:42 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [PATCH] direct_io: fix use after free in __blockdev_direct_IO
Message-ID: <20091217092942.GX14381@ZenIV.linux.org.uk>
References: <1261039772-18403-1-git-send-email-dfeng@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1261039772-18403-1-git-send-email-dfeng@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 17, 2009 at 04:49:32PM +0800, Xiaotian Feng wrote:
> @@ -1197,7 +1200,11 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
>  		(end > i_size_read(inode)));
>  
>  	retval = direct_io_worker(rw, iocb, inode, iov, offset,
> -				nr_segs, blkbits, get_block, end_io, dio);
> +				  nr_segs, blkbits, get_block, end_io,
> +				  dio, &dio_freed);
> +
> +	if (dio_freed)
> +		goto out;

Um... I'm not sure that this would be the right fix.  How about simple
s/dio->flags/flags/ in the line below?
