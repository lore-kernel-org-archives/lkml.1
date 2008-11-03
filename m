Return-Path: <linux-kernel-owner+w=401wt.eu-S1755481AbYKCUco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481AbYKCUco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 15:32:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbYKCUcg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 15:32:36 -0500
Received: from ik-out-1112.google.com ([66.249.90.176]:13403 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbYKCUcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 15:32:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pTuHb6RQSMaqEfEeemkKMH/3+4nRGj4YAUoJTtS3qzezaUAkf4E1OQ5FHTeIsBi4sP
         mR6zlrAjX0UU9fjZAZmLyo4UbcbHyG2kgEHAHGLA2X8XxS9C2R99ptteCq9eCZ7P/CkS
         Xh8YLbXTSIFlTsAmxpOfY49CaWKa1FFHk+pBE=
Date: Mon, 3 Nov 2008 23:25:44 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [GIT] /proc/uptime fix
Message-ID: <20081103202544.GA3317@x200.localdomain>
References: <20081103145023.GA3986@x200.localdomain> <alpine.LFD.2.00.0811031000020.3459@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811031000020.3459@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2008 at 10:14:16AM -0800, Linus Torvalds wrote:
> On Mon, 3 Nov 2008, Alexey Dobriyan wrote:
> > 
> > Alexey Dobriyan (1):
> >       proc: revert /proc/uptime to ->read_proc hook
> 
> Ok, pulled, but it's a bit sad. 
> 
> Al: the commit is 6c87df37dcb9c6c33923707fa5191e0a65874d60, and the 
> message explains it all:
> 
>     Turned out some VMware userspace does pread(2) on /proc/uptime, but
>     seqfiles currently don't allow pread() resulting in -ESPIPE.
>     
>     Seqfiles in theory can do pread(), but this can be a long story,
>     so revert to ->read_proc until then.
>     
> and I bet that the pread() usage is just with a constant loff_t of 0, and 
> just there to avoid a simple case of "lseek+read". 
> 
> I wonder how hard it is to make seqfiles support pread.

Not hard at all, if ->read hook has information if it's called from read(2)
or pread(2) (or something equivalent).

> Maybe it's something as trivial as just flushing the buffer whenever 'pos'
> doesn't match f_pos?

> --- a/fs/seq_file.c
> +++ b/fs/seq_file.c
> @@ -48,8 +48,8 @@ int seq_open(struct file *file, const struct seq_operations *op)
>  	 */
>  	file->f_version = 0;
>  
> -	/* SEQ files support lseek, but not pread/pwrite */
> -	file->f_mode &= ~(FMODE_PREAD | FMODE_PWRITE);
> +	/* SEQ files support lseek, but not pwrite */
> +	file->f_mode &= ~(FMODE_PWRITE);

FMODE_PWRITE is aliased to FMODE_PREAD so you have to split them first. ;-)

> @@ -91,6 +91,8 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
>  		if (!m->buf)
>  			goto Enomem;
>  	}
> +	if (pos != file->f_pos)
> +		m->count = 0;
>  	/* if not empty - flush it first */
>  	if (m->count) {
>  		n = min(m->count, size);
> @@ -175,6 +177,8 @@ Done:
>  	else
>  		*ppos += copied;
>  	file->f_version = m->version;
> +	if (pos != file->f_pos)
> +		m->count = 0;
