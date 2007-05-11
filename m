Return-Path: <linux-kernel-owner+w=401wt.eu-S1759777AbXEKH3z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759777AbXEKH3z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 03:29:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755173AbXEKH3s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 03:29:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40934 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbXEKH3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 03:29:48 -0400
Date: Fri, 11 May 2007 08:29:39 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@ucw.cz>
Subject: Re: [PATCH] UDF: check for allocated memory for inode data
Message-ID: <20070511072939.GA25727@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Cyrill Gorcunov <gorcunov@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Ben Fennema <bfennema@falcon.csc.calpoly.edu>,
	Jan Kara <jack@ucw.cz>
References: <20070510140000.GA12399@cvg> <20070510154640.c0299a52.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070510154640.c0299a52.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 03:46:40PM -0700, Andrew Morton wrote:
> On Thu, 10 May 2007 18:00:00 +0400
> Cyrill Gorcunov <gorcunov@gmail.com> wrote:
> 
> > This patch adds cheking for granted memory while
> > filling up inode data to prevent possible NULL
> > pointer usage. If there is not enough memory to
> > fill inode data we just mark it as "bad".
> > 
> > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> > 
> > Please check the patch, maybe just marking inode as
> > "bad" is not a good solution.
> > 
> 
> yes, make_bad_inode() is appropriate here.
> 
> > 
> > diff --git a/fs/udf/inode.c b/fs/udf/inode.c
> > index c846155..91cddae 100644
> > --- a/fs/udf/inode.c
> > +++ b/fs/udf/inode.c
> > @@ -1144,6 +1144,13 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
> >  		UDF_I_EFE(inode) = 1;
> >  		UDF_I_USE(inode) = 0;
> >  		UDF_I_DATA(inode) = kmalloc(inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry), GFP_KERNEL);
> > +		if (!UDF_I_DATA(inode))
> > +		{
> > +			printk(KERN_ERR "udf: udf_fill_inode(ino %ld) no free memory\n",
> > +			       inode->i_ino);
> > +			make_bad_inode(inode);
> > +			return;
> > +		}
> 
> But please let's not add three copies of identical code.  Do something like:
> 
> static int udf_check_inode(struct inode *inode)
> {
> 	if (!UDF_I_DATA(inode)) {
> 		printk(KERN_ERR "udf: udf_fill_inode(ino %ld) no free memory\n",
> 			inode->i_ino);
> 		make_bad_inode(inode);
> 		return -1;
> 	}
> 	return 0;
> }
> 
> 
> 	if (udf_check_inode(inode))
> 		return;
> 
> In fact you can also do the kmalloc in that helper function too:
> 
> static int udf_alloc_i_data(struct inode *inode, size_t size)
> {
> 	UDF_I_DATA(inode) = kmalloc(...);
> 	...
> }

And please get rid of the UDF_I_* macro for everything you touch, just
put a

	struct udf_inode_info *uip = UDF_I(inode);

at the beginning of the function and use the fields directly.
