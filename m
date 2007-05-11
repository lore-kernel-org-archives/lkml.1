Return-Path: <linux-kernel-owner+w=401wt.eu-S1761179AbXEKHtm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761179AbXEKHtm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 03:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbXEKHtg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 03:49:36 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:6672 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754858AbXEKHtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 03:49:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=agStgpmVTh/bxql1HNi5DvcU1F8hlnkshAO93d8nQXlvE8yF8y6IV1Zn3d07aFlrI/hT2KwOIwmXIvllEKoRCW2rBbOsjcDfv+8hGHcQpM4cPXNBlbRsUrqkO8VK0A7dV7jMqLzy1e0SAMoP/M2MSK9UeWs732tZGIkc8Dx29DA=
Date: Fri, 11 May 2007 11:49:03 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christoph Hellwig <hch@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Ben Fennema <bfennema@falcon.csc.calpoly.edu>, Jan Kara <jack@ucw.cz>
Subject: Re: [PATCH] UDF: check for allocated memory for inode data
Message-ID: <20070511074903.GB9444@cvg>
References: <20070510140000.GA12399@cvg> <20070510154640.c0299a52.akpm@linux-foundation.org> <20070511072939.GA25727@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511072939.GA25727@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[Christoph Hellwig - Fri, May 11, 2007 at 08:29:39AM +0100]
| On Thu, May 10, 2007 at 03:46:40PM -0700, Andrew Morton wrote:
| > On Thu, 10 May 2007 18:00:00 +0400
| > Cyrill Gorcunov <gorcunov@gmail.com> wrote:
| > 
| > > This patch adds cheking for granted memory while
| > > filling up inode data to prevent possible NULL
| > > pointer usage. If there is not enough memory to
| > > fill inode data we just mark it as "bad".
| > > 
| > > Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
| > > 
| > > Please check the patch, maybe just marking inode as
| > > "bad" is not a good solution.
| > > 
| > 
| > yes, make_bad_inode() is appropriate here.
| > 
| > > 
| > > diff --git a/fs/udf/inode.c b/fs/udf/inode.c
| > > index c846155..91cddae 100644
| > > --- a/fs/udf/inode.c
| > > +++ b/fs/udf/inode.c
| > > @@ -1144,6 +1144,13 @@ static void udf_fill_inode(struct inode *inode, struct buffer_head *bh)
| > >  		UDF_I_EFE(inode) = 1;
| > >  		UDF_I_USE(inode) = 0;
| > >  		UDF_I_DATA(inode) = kmalloc(inode->i_sb->s_blocksize - sizeof(struct extendedFileEntry), GFP_KERNEL);
| > > +		if (!UDF_I_DATA(inode))
| > > +		{
| > > +			printk(KERN_ERR "udf: udf_fill_inode(ino %ld) no free memory\n",
| > > +			       inode->i_ino);
| > > +			make_bad_inode(inode);
| > > +			return;
| > > +		}
| > 
| > But please let's not add three copies of identical code.  Do something like:
| > 
| > static int udf_check_inode(struct inode *inode)
| > {
| > 	if (!UDF_I_DATA(inode)) {
| > 		printk(KERN_ERR "udf: udf_fill_inode(ino %ld) no free memory\n",
| > 			inode->i_ino);
| > 		make_bad_inode(inode);
| > 		return -1;
| > 	}
| > 	return 0;
| > }
| > 
| > 
| > 	if (udf_check_inode(inode))
| > 		return;
| > 
| > In fact you can also do the kmalloc in that helper function too:
| > 
| > static int udf_alloc_i_data(struct inode *inode, size_t size)
| > {
| > 	UDF_I_DATA(inode) = kmalloc(...);
| > 	...
| > }
| 
| And please get rid of the UDF_I_* macro for everything you touch, just
| put a
| 
| 	struct udf_inode_info *uip = UDF_I(inode);
| 
| at the beginning of the function and use the fields directly.
| 

OK, I've already sent v.2 of the patch, so v.3 will become soon ;)

		Cyrill

