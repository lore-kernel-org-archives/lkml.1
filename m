Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbZDSHTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbZDSHTR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Apr 2009 03:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbZDSHS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Apr 2009 03:18:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:47045 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156AbZDSHS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Apr 2009 03:18:57 -0400
Subject: Re: [PATCH] Fix i_mutex handling in nfsd readdir.
From: David Woodhouse <dwmw2@infradead.org>
To: hooanon05@yahoo.co.jp
Cc: Al Viro <viro@ZenIV.linux.org.uk>, bfields@citi.umich.edu,
       hch@infradead.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
In-Reply-To: <905.1240024314@jrobl>
References: <8036.1237474444@jrobl>
	 <1237475837.16359.106.camel@macbook.infradead.org> <8913.1237476890@jrobl>
	 <1239960739.3428.33.camel@macbook.infradead.org>
	 <20090417193233.GM26366@ZenIV.linux.org.uk>
	 <1240006620.19059.41.camel@macbook.infradead.org>
	 <20090417224350.GN26366@ZenIV.linux.org.uk>
	 <20090417225306.GO26366@ZenIV.linux.org.uk>
	 <1240013753.21423.86.camel@macbook.infradead.org>  <905.1240024314@jrobl>
Content-Type: text/plain
Date: Sun, 19 Apr 2009 08:18:49 +0100
Message-Id: <1240125529.3589.44.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-18 at 12:11 +0900, hooanon05@yahoo.co.jp wrote:
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

It's supposed to be locked. It's likely to have been locked quite
recently, so it'll be in the cache. I don't think the mutex_is_locked()
check is going to be that expensive, is it?

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

