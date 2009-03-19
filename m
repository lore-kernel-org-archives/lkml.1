Return-Path: <linux-kernel-owner+w=401wt.eu-S1753378AbZCSPqH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbZCSPqH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 11:46:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZCSPpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 11:45:52 -0400
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:55902 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbZCSPpw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 11:45:52 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: Q: NFSD readdir in linux-2.6.28 
To: Matthew Wilcox <matthew@wil.cx>
Cc: David Woodhouse <dwmw2@infradead.org>, Al Viro <viro@zeniv.linux.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20090319153704.GZ14127@parisc-linux.org>
References: <8036.1237474444@jrobl> <1237475837.16359.106.camel@macbook.infradead.org> <20090319153704.GZ14127@parisc-linux.org>
Date: Fri, 20 Mar 2009 00:45:09 +0900
Message-ID: <9148.1237477509@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Matthew Wilcox:
> > I _think_ it's sufficient to make the affected callers of
> > lookup_one_len() lock the parent's i_mutex for themselves before calling
> > it. I'll take a closer look...
> 
> Should we also add this?
	:::
> @@ -1244,6 +1244,7 @@ struct dentry *lookup_one_len(const char *name, struct dentry *base, int len)
>  	int err;
>  	struct qstr this;
>  
> +	BUG_ON(!mutex_is_locked(&base->d_inode->i_mutex));
>  	err = __lookup_one_len(name, &this, base, len);

That was how I found this problem actually. :-)
I implemented very similar debug code in aufs which is compiled when
CONFIG_AUFS_DEBUG is enabled.

(in aufs header files)
#ifdef CONFIG_AUFS_DEBUG
#define AuDebugOn(a)		BUG_ON(a)
	:::
#endif

/* to debug easier, do not make them inlined functions */
#define MtxMustLock(mtx)	AuDebugOn(!mutex_is_locked(mtx))
#define IMustLock(i)		MtxMustLock(&(i)->i_mutex)

(in ->lookup of aufs)
static struct dentry *aufs_lookup(struct inode *dir, struct dentry *dentry,
				  struct nameidata *nd)
{
	:::
	IMustLock(dir);


J. R. Okajima
