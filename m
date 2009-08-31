Return-Path: <linux-kernel-owner+w=401wt.eu-S1752118AbZHaPLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbZHaPLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 11:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751848AbZHaPLD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 11:11:03 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39435 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbZHaPLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 11:11:03 -0400
Date: Mon, 31 Aug 2009 11:10:45 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@linux.intel.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       Christoph Hellwig <hch@infradead.org>,
       Valerie Aurora <vaurora@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH mmotm] vfs: optimize touch_time too fix
Message-ID: <20090831151045.GA23901@infradead.org>
References: <Pine.LNX.4.64.0908311558220.4384@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0908311558220.4384@sister.anvils>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 04:03:02PM +0100, Hugh Dickins wrote:
> Recent mmotms give me WARNING: at fs/namespace.c:612 mntput_no_expire()+...
> when unmounting: __mntput()'s WARN_ON(count_mnt_writers(mnt)).
> 
> That's because vfs-optimize-touch_time-too.patch inverted the sense
> of mnt_want_write_file(), which is error-returning, not a boolean.
> 
> Presumably filetime updates went missing too, but I didn't notice those.
> 
> Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
> ---
> 
>  fs/inode.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- mmotm/fs/inode.c	2009-08-28 10:07:56.000000000 +0100
> +++ linux/fs/inode.c	2009-08-31 14:08:24.000000000 +0100
> @@ -1481,7 +1481,7 @@ void file_update_time(struct file *file)
>  		return;
>  
>  	/* Finally allowed to write? Takes lock. */
> -	if (!mnt_want_write_file(file))
> +	if (mnt_want_write_file(file))

Eeek.  having an error return from a function called want_foo is rather
strange.  It's a name the implies a bolean return value.

