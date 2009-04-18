Return-Path: <linux-kernel-owner+w=401wt.eu-S1757071AbZDRO0E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071AbZDRO0E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 10:26:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756075AbZDROZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 10:25:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34824 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497AbZDROZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 10:25:50 -0400
Date: Sat, 18 Apr 2009 15:25:40 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: hooanon05@yahoo.co.jp
Cc: David Woodhouse <dwmw2@infradead.org>, bfields@citi.umich.edu,
       hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH] Fix i_mutex handling in nfsd readdir.
Message-ID: <20090418142540.GR26366@ZenIV.linux.org.uk>
References: <8036.1237474444@jrobl> <1237475837.16359.106.camel@macbook.infradead.org> <8913.1237476890@jrobl> <1239960739.3428.33.camel@macbook.infradead.org> <20090417193233.GM26366@ZenIV.linux.org.uk> <1240006620.19059.41.camel@macbook.infradead.org> <20090417224350.GN26366@ZenIV.linux.org.uk> <20090417225306.GO26366@ZenIV.linux.org.uk> <1240013753.21423.86.camel@macbook.infradead.org> <905.1240024314@jrobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <905.1240024314@jrobl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 18, 2009 at 12:11:54PM +0900, hooanon05@yahoo.co.jp wrote:
> 
> David Woodhouse:
> > This patch fixes it by locking the directory's i_mutex again before
> > calling the filldir functions. The original deadlocks which commit
> > 14f7dd63 was designed to avoid are still avoided, because they were due
> > to fs-internal locking, not i_mutex.
> 	:::
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -1248,6 +1248,8 @@ struct dentry *lookup_one_len(const char *name, struct dentry *base, int len)
> >  	int err;
> >  	struct qstr this;
> >  
> > +	WARN_ON_ONCE(!mutex_is_locked(&base->d_inode->i_mutex));
> > +
> >  	err = __lookup_one_len(name, &this, base, len);
> 
> I'd suggest this checking is done only when CONFIG_DEBUG_KERNEL (or
> something) is enabled. Because unconditional checking costs high for the
> well-reviewed lookup code.

Frankly, I'd rather have DEBUG_WARN... conditional on that, rather than
cluttering code with ifdefs...
