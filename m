Return-Path: <linux-kernel-owner+w=401wt.eu-S1755890AbZFCXZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755890AbZFCXZn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 19:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665AbZFCXZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 19:25:33 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:37042 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752949AbZFCXZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 19:25:32 -0400
Subject: Re: [PATCH 23/23] vfs: Teach readahead to use the file_hotplug_lock
From: Badari Pulavarty <pbadari@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org, linux-mm@kvack.org,
       linux-fsdevel@vger.kernel.org, Hugh Dickins <hugh@veritas.com>,
       Tejun Heo <tj@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>, Nick Piggin <npiggin@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>,
       "Eric W. Biederman" <ebiederm@maxwell.aristanetworks.com>,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
In-Reply-To: <1243893048-17031-23-git-send-email-ebiederm@xmission.com>
References: <m1oct739xu.fsf@fess.ebiederm.org>
	 <1243893048-17031-23-git-send-email-ebiederm@xmission.com>
Content-Type: text/plain
Date: Wed, 03 Jun 2009 16:25:29 -0700
Message-Id: <1244071529.6383.11.camel@badari-desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-01 at 14:50 -0700, Eric W. Biederman wrote:
> From: Eric W. Biederman <ebiederm@maxwell.aristanetworks.com>
> 
> Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
> ---
>  mm/filemap.c |   25 ++++++++++++++++---------
>  1 files changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 379ff0b..5016aa5 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1402,16 +1402,23 @@ SYSCALL_DEFINE(readahead)(int fd, loff_t offset, size_t count)
>  
>  	ret = -EBADF;
>  	file = fget(fd);
> -	if (file) {
> -		if (file->f_mode & FMODE_READ) {
> -			struct address_space *mapping = file->f_mapping;
> -			pgoff_t start = offset >> PAGE_CACHE_SHIFT;
> -			pgoff_t end = (offset + count - 1) >> PAGE_CACHE_SHIFT;
> -			unsigned long len = end - start + 1;
> -			ret = do_readahead(mapping, file, start, len);
> -		}
> -		fput(file);
> +	if (!file)
> +		goto out;
> +
> +	if (!(file->f_mode & FMODE_READ))
> +		goto out_fput;
> +

To be consistent with others, don't you want to do
	  ret = -EIO;
here ?
> +	if (file_hotplug_read_trylock(file)) {
> +		struct address_space *mapping = file->f_mapping;
> +		pgoff_t start = offset >> PAGE_CACHE_SHIFT;
> +		pgoff_t end = (offset + count - 1) >> PAGE_CACHE_SHIFT;
> +		unsigned long len = end - start + 1;
> +		ret = do_readahead(mapping, file, start, len);
> +		file_hotplug_read_unlock(file);
>  	}
> +out_fput:
> +	fput(file);
> +out:
>  	return ret;
>  }
>  #ifdef CONFIG_HAVE_SYSCALL_WRAPPERS

Thanks,
Badari

