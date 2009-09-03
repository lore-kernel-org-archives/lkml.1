Return-Path: <linux-kernel-owner+w=401wt.eu-S1752435AbZICMyp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbZICMyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 08:54:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752194AbZICMyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 08:54:45 -0400
Received: from smtp.df.ru ([195.42.160.16]:56822 "EHLO smtp.df.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159AbZICMyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 08:54:44 -0400
X-Greylist: delayed 1408 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Sep 2009 08:54:43 EDT
Date: Thu, 3 Sep 2009 16:32:14 +0400
From: Alexey Vlasov <renton@renton.name>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
Subject: Re: [PATCH] Report file size for deleted files; was Re: Counters
	in df, du
Message-ID: <20090903123214.GA5277@beaver.vrungel.ru>
References: <20090713081106.GA5569@beaver.vrungel.ru> <87fxd19cfq.fsf@basil.nowhere.org> <20090713113252.GB5569@beaver.vrungel.ru> <20090713115917.GA27684@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <20090713115917.GA27684@basil.fritz.box>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi Kleen.

Patch can hardly hellp, because there is another problem. Proc shows
neither the size of deleted files, nor what he's full with /tmp.

On Mon, Jul 13, 2009 at 01:59:17PM +0200, Andi Kleen wrote:
> > But you can see the file date, these are new files and by next search
> 
> I appended a patch that reports the size.
> 
> -Andi
> 
> ---
> 
> VFS: Report file size for deleted files in /proc
> 
> It's useful to know how big deleted files are, in case a file system
> is filled up unexpectedly and the admin wants to track down which
> process is the culprit. This patch reports the file size 
> in addition to (deleted) for /proc/*/fd links.
> 
> This modifies a public interface, but it's reasonable to assume
> that noone relies on the particular format here.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> 
> ---
>  fs/dcache.c |   14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> Index: linux-2.6.31-rc1-ak/fs/dcache.c
> ===================================================================
> --- linux-2.6.31-rc1-ak.orig/fs/dcache.c
> +++ linux-2.6.31-rc1-ak/fs/dcache.c
> @@ -1910,9 +1910,19 @@ char *__d_path(const struct path *path,
>  
>  	spin_lock(&vfsmount_lock);
>  	prepend(&end, &buflen, "\0", 1);
> -	if (d_unlinked(dentry) &&
> -		(prepend(&end, &buflen, " (deleted)", 10) != 0))
> +	if (d_unlinked(dentry)) {
> +		char buf[40];
> +		int n;
> +		if (dentry->d_inode) { /* check needed? */
> +			n = snprintf(buf, sizeof buf, " (deleted; size %lluK)",
> +					dentry->d_inode->i_size >> 10);
> +		} else {
> +			strcpy(buf, " (deleted)");
> +			n = 10;
> +		}
> +		if (prepend(&end, &buflen, buf, n) != 0)
>  			goto Elong;
> +	}
>  
>  	if (buflen < 1)
>  		goto Elong;
> 
> -- 
> ak@linux.intel.com -- Speaking for myself only.

-- 
BRGDS. Alexey Vlasov.
