Return-Path: <linux-kernel-owner+w=401wt.eu-S1753215AbXC1IAT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbXC1IAT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 04:00:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbXC1IAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 04:00:19 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:24201 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753215AbXC1IAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 04:00:18 -0400
Date: Wed, 28 Mar 2007 12:05:48 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Arjan van de Ven <arjan@infradead.org>
Cc: akpm@osdl.org, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] Fix lseek on /proc/kcore
Message-ID: <20070328080548.GA6651@localhost.sw.ru>
References: <20070322095600.GA6816@localhost.sw.ru> <1174569275.1158.175.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1174569275.1158.175.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2007 at 02:14:35PM +0100, Arjan van de Ven wrote:
> On Thu, 2007-03-22 at 12:56 +0300, Alexey Dobriyan wrote:
> > --- a/fs/proc/inode.c
> > +++ b/fs/proc/inode.c
> > @@ -167,8 +167,9 @@ static loff_t proc_reg_llseek(struct fil
> >  	llseek = pde->proc_fops->llseek;
> >  	spin_unlock(&pde->pde_unload_lock);
> >
> > -	if (llseek)
> > -		rv = llseek(file, offset, whence);
> > +	if (!llseek)
> > +		llseek = default_llseek;
> > +	rv = llseek(file, offset, whence);
> >
>
> this has potential impact way outside kcore......
>
> did you audit all proc users to see if they can deal with lseek?

Mainline deals with lseek on proc entries as follows:
* use default_llseek()
* but if proc entry set ->llseek via ->proc_fops, use custom llseek

With introduction of proxying, ->llseek was suddenly set on all proc
entries, so default_llseek() was never used, but -E started to be
returned for all of them that were relying on default_llseek().

So this patch brings proc_reg_llseek() in sync with vfs_llseek().

