Return-Path: <linux-kernel-owner+w=401wt.eu-S1754170AbYBDLuV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170AbYBDLuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 06:50:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYBDLuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 06:50:08 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:45129 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbYBDLuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 06:50:06 -0500
To: linuxram@us.ibm.com
CC: miklos@szeredi.hu, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       viro@ftp.linux.org.uk, a.p.zijlstra@chello.nl
In-reply-to: <1202116505.3949.91.camel@ram.us.ibm.com> (message from Ram Pai
	on Mon, 04 Feb 2008 01:15:05 -0800)
Subject: Re: [RFC PATCH] vfs: optimization to /proc/<pid>/mountinfo patch
References: <E1JJqxt-0004r2-Vf@pomaz-ex.szeredi.hu>
	 <20080130160839.828c4363.akpm@linux-foundation.org>
	 <E1JKVY6-0001wd-BE@pomaz-ex.szeredi.hu>
	 <1201805123.10358.23.camel@ram.us.ibm.com> <1202116505.3949.91.camel@ram.us.ibm.com>
Message-Id: <E1JLzp9-0002QN-PP@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 04 Feb 2008 12:49:19 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1) reports deleted inode in dentry_path() consistent with that in __d_path()
> 2) modified __d_path() to use prepend(), reducing the size of __d_path()
> 3) moved all the functionality that reports mount information in /proc under
> 	CONFIG_PROC_FS.
> 
> Could not verify if the code would work with CONFIG_PROC_FS=n, since it was
> impossible to disable CONFIG_PROC_FS. Looking for ideas on how to disable
> CONFIG_PROC_FS.
> 	
> 
> 
> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
> ---
>  fs/dcache.c              |   59 +++++++++++++++++++----------------------------
>  fs/namespace.c           |    2 +
>  fs/seq_file.c            |    2 +
>  include/linux/dcache.h   |    3 ++
>  include/linux/seq_file.h |    3 ++
>  5 files changed, 34 insertions(+), 35 deletions(-)
> 
> Index: linux-2.6.23/fs/dcache.c
> ===================================================================
> --- linux-2.6.23.orig/fs/dcache.c
> +++ linux-2.6.23/fs/dcache.c
> @@ -1747,6 +1747,17 @@ shouldnt_be_hashed:
>  	goto shouldnt_be_hashed;
>  }
>  
> +static int prepend(char **buffer, int *buflen, const char *str,
> +			  int namelen)
> +{
> +	*buflen -= namelen;
> +	if (*buflen < 0)
> +		return 1;

This is confusing.  Should return -ENAMETOOLONG intead (see Chapter 16
in Documentation/CodingStyle).

> +	*buffer -= namelen;
> +	memcpy(*buffer, str, namelen);
> +	return 0;
> +}
> +
>  /**
>   * d_path - return the path of a dentry
>   * @dentry: dentry to report
> @@ -1768,17 +1779,11 @@ static char *__d_path(struct dentry *den
>  {
>  	char * end = buffer+buflen;
>  	char * retval;
> -	int namelen;
>  
> -	*--end = '\0';
> -	buflen--;
> -	if (!IS_ROOT(dentry) && d_unhashed(dentry)) {
> -		buflen -= 10;
> -		end -= 10;
> -		if (buflen < 0)
> +	prepend(&end, &buflen, "\0", 1);
> +	if (!IS_ROOT(dentry) && d_unhashed(dentry) &&
> +		prepend(&end, &buflen, " (deleted)", 10))

And this should test for "prepend() != 0" or "prepend() < 0" instead,
otherwise it could easily be misread as "if prepend() succeeded,
then...".

And similarly for all the later calls.

Thanks,
Miklos
