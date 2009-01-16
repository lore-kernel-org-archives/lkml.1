Return-Path: <linux-kernel-owner+w=401wt.eu-S933800AbZAPQuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933800AbZAPQuh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 11:50:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbZAPQuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 11:50:22 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38515 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753887AbZAPQuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 11:50:19 -0500
Date: Fri, 16 Jan 2009 08:43:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com
Subject: Re: mmotm 2009-01-14-20-31 uploaded (gfs2)
Message-Id: <20090116084352.9f35b822.akpm@linux-foundation.org>
In-Reply-To: <1232101203.3554.3.camel@localhost.localdomain>
References: <200901150432.n0F4WI66023742@imap1.linux-foundation.org>
	<496F8AED.3020604@oracle.com>
	<1232101203.3554.3.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Jan 2009 10:20:03 +0000 Steven Whitehouse <swhiteho@redhat.com> wrote:

> Hi,
> 
> On Thu, 2009-01-15 at 11:13 -0800, Randy Dunlap wrote:
> > akpm@linux-foundation.org wrote:
> > > The mm-of-the-moment snapshot 2009-01-14-20-31 has been uploaded to
> > > 
> > >    http://userweb.kernel.org/~akpm/mmotm/
> > > 
> > > and will soon be available at
> > > 
> > >    git://git.zen-sources.org/zen/mmotm.git
> > 
> > 
> > when CONFIG_FILE_LOCKING=n:
> > 
> > mmotm-2009-0114-2031/fs/gfs2/ops_file.c:746: error: 'generic_setlease' undeclared here (not in a function)
> > 
> > 
> > since generic_setlease() is a macro/define in that case.
> > 
> Hmm, it looks like I'll have to do this, in that case:
> 
> diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
> index 99d726f..4580335 100644
> --- a/fs/gfs2/ops_file.c
> +++ b/fs/gfs2/ops_file.c
> @@ -743,7 +743,9 @@ const struct file_operations *gfs2_file_fops_nolock = &(const struct file_operat
>  	.fsync		= gfs2_fsync,
>  	.splice_read	= generic_file_splice_read,
>  	.splice_write	= generic_file_splice_write,
> +#ifdef CONFIG_FILE_LOCKING
>  	.setlease	= generic_setlease,
> +#endif /* CONFIG_FILE_LOCKING */
>  };
>  
>  const struct file_operations *gfs2_dir_fops_nolock = &(const struct file_operations){
> 
> 
> which is not ideal, but I don't see any easy way to avoid the #ifdef,
> 

Take a look in fs.h:

#define generic_setlease(a, b, c) ({ -EINVAL; })

If that wasn't a stupid macro, your code would have compiled and ran
just as intended.

