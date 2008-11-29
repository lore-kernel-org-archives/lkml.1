Return-Path: <linux-kernel-owner+w=401wt.eu-S1755905AbYK2Kj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905AbYK2Kj3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 05:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751146AbYK2KjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 05:39:16 -0500
Received: from lazybastard.de ([212.112.238.170]:60782 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbYK2KjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 05:39:15 -0500
Date: Sat, 29 Nov 2008 11:38:36 +0100
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       David Miller <davem@davemloft.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org,
       "kernel-testers@vger.kernel.org >> Kernel Testers List" 
	<kernel-testers@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH v2 4/5] fs: Introduce SINGLE dentries for pipes, socket, anon fd
Message-ID: <20081129103836.GA11959@logfs.org>
References: <20081121083044.GL16242@elte.hu> <49267694.1030506@cosmosbay.com> <20081121.010508.40225532.davem@davemloft.net> <4926AEDB.10007@cosmosbay.com> <4926D022.5060008@cosmosbay.com> <20081121152148.GA20388@elte.hu> <4926D39D.9050603@cosmosbay.com> <20081121153453.GA23713@elte.hu> <492DDB6A.8090806@cosmosbay.com> <493100E7.3030907@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <493100E7.3030907@cosmosbay.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 29 November 2008 09:44:23 +0100, Eric Dumazet wrote:
>
> +struct dentry *d_alloc_single(const struct qstr *name, struct inode *inode)
> +{
> +	struct dentry *entry;
> +
> +	entry = d_alloc(NULL, name);
> +	if (entry) {
> +		entry->d_sb = inode->i_sb;
> +		entry->d_parent = entry;
> +		entry->d_flags |= DCACHE_SINGLE | DCACHE_DISCONNECTED;
> +		entry->d_inode = inode;
> +		fsnotify_d_instantiate(entry, inode);
> +		security_d_instantiate(entry, inode);
> +	}
> +	return entry;

Calling the struct dentry entry had me onfused a bit.  I believe
everyone else (including the code you removed) uses dentry.

> @@ -918,7 +906,7 @@ struct file *create_write_pipe(int flags)
>  	struct inode *inode;
>  	struct file *f;
>  	struct dentry *dentry;
> -	struct qstr name = { .name = "" };
> +	static const struct qstr name = { .name = "" };
>  
>  	err = -ENFILE;
>  	inode = get_pipe_inode();
...
> @@ -371,20 +358,13 @@ static int sock_alloc_fd(struct file **filep, int flags)
>  static int sock_attach_fd(struct socket *sock, struct file *file, int flags)
>  {
>  	struct dentry *dentry;
> -	struct qstr name = { .name = "" };
> +	static const struct qstr name = { .name = "" };

These two could even be combined.

And of course I realize that I comment on absolute trivialities.  On the
whole, I couldn't spot a real problem in your patches.

Jörn

-- 
Public Domain  - Free as in Beer
General Public - Free as in Speech
BSD License    - Free as in Enterprise
Shared Source  - Free as in "Work will make you..."
