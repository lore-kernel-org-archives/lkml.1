Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab0APMyw (ORCPT <rfc822;list-kernel77@spinics.net>);
	Sat, 16 Jan 2010 07:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752198Ab0APMyv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jan 2010 07:54:51 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:48967 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936Ab0APMyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jan 2010 07:54:51 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Eric Paris <eparis@redhat.com>,
        Nick Piggin <npiggin@suse.de>, Andi Kleen <andi@firstfloor.org>,
        David Howells <dhowells@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 6/6] vfs: introduce FMODE_NEG_OFFSET for allowing negative f_pos
References: <20100115013954.311049665@intel.com>
	<20100115014422.959401729@intel.com>
Date: Sat, 16 Jan 2010 21:54:39 +0900
In-Reply-To: <20100115014422.959401729@intel.com> (Wu Fengguang's message of
	"Fri, 15 Jan 2010 09:40:00 +0800")
Message-ID: <87bpgurz00.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang <fengguang.wu@intel.com> writes:

> +static int
> +__negative_fpos_check(struct file *file, loff_t pos, size_t count)
> +{
> +	/*
> +	 * pos or pos+count is negative here, check overflow.
> +	 * too big "count" will be caught in rw_verify_area().
> +	 */
> +	if ((pos < 0) && (pos + count < pos))
> +		return -EOVERFLOW;
> +	if (file->f_mode & FMODE_NEG_OFFSET)
> +		return 0;
> +	return -EINVAL;
> +}
> +
>  /*
>   * rw_verify_area doesn't like huge counts. We limit
>   * them to something that fits in "int" so that others
> @@ -222,8 +236,11 @@ int rw_verify_area(int read_write, struc
>  	if (unlikely((ssize_t) count < 0))
>  		return retval;
>  	pos = *ppos;
> -	if (unlikely((pos < 0) || (loff_t) (pos + count) < 0))
> -		return retval;
> +	if (unlikely((pos < 0) || (loff_t) (pos + count) < 0)) {
> +		retval = __negative_fpos_check(file, pos, count);
> +		if (retval)
> +			return retval;
> +	}
>  
>  	if (unlikely(inode->i_flock && mandatory_lock(inode))) {
>  		retval = locks_mandatory_area(

Um... How do lseek() work? It sounds like to violate error code range.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
