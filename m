Return-Path: <linux-kernel-owner+w=401wt.eu-S1761887AbXEOIb7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761887AbXEOIb7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 04:31:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756848AbXEOIbt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 04:31:49 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:19138 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755758AbXEOIbs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 04:31:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=NuQPQav7qvNvR657GFhaDYatpE3nISjNLfrsmWJiRQWwrKKS+WVtiVW/dWMd/iYfGvqkd8yH1e2BZsWFvYrGMp0dmxJjqG/2ocnzXGevNxTSUz8VAEK47iOlJ9HdOhEehdfiknEQzumzzwCbeOJ40X/Nh+xVtPt6rj3ysxDMsAo=
Message-ID: <4de7f8a60705150131s5f357fb1oeae1b5a9251a7c6b@mail.gmail.com>
Date: Tue, 15 May 2007 10:31:43 +0200
From: "Jan Blunck" <jblunck@suse.de>
To: bharata@linux.vnet.ibm.com
Subject: Re: [RFC][PATCH 13/14] ext3 whiteout support
Cc: "Badari Pulavarty" <pbadari@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       "Jan Blunck" <j.blunck@tu-harburg.de>
In-Reply-To: <20070515062649.GA3465@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070514093722.GB4139@in.ibm.com>
	 <20070514094450.GO4139@in.ibm.com>
	 <1179173817.2836.69.camel@dyn9047017100.beaverton.ibm.com>
	 <20070515062649.GA3465@in.ibm.com>
X-Google-Sender-Auth: 5edcb819074a637c
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/15/07, Bharata B Rao <bharata@linux.vnet.ibm.com> wrote:
> On Mon, May 14, 2007 at 01:16:57PM -0700, Badari Pulavarty wrote:
> > On Mon, 2007-05-14 at 15:14 +0530, Bharata B Rao wrote:
> > > From: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > >
> > > +static int ext3_whiteout(struct inode *dir, struct dentry *dentry)
> > > +{
> > > +   struct inode * inode;
> > > +   int err, retries = 0;
> > > +   handle_t *handle;
> > > +
> > > +retry:
> > > +   handle = ext3_journal_start(dir, EXT3_DATA_TRANS_BLOCKS(dir->i_sb) +
> > > +                                   EXT3_INDEX_EXTRA_TRANS_BLOCKS + 3 +
> > > +                                   2*EXT3_QUOTA_INIT_BLOCKS(dir->i_sb));
> > > +   if (IS_ERR(handle))
> > > +           return PTR_ERR(handle);
> > > +
> > > +   if (IS_DIRSYNC(dir))
> > > +           handle->h_sync = 1;
> > > +
> > > +   inode = ext3_new_inode (handle, dir, S_IFWHT | S_IRUGO);
> > > +   err = PTR_ERR(inode);
> > > +   if (IS_ERR(inode))
> > > +           goto out_stop;
> >
> > Don't you need to call init_special_inode() here ?
> > Or this is handled somewhere else ?
>
> Whiteout doesn't have any attributes and hence we are not explicitly
> doing init_special_inode() on this. Accesses to whiteout files are trapped
> at the VFS lookup itself and creation and deletion of whiteouts are handled
> automatically by VFS. So I believe init_special_inode() isn't necessary
> on a whiteout file.
>

I added default whiteout file operations. So calling
init_special_inode() seems to make sense.

I know the ext2/ext3 whiteout patches are not really where they should
be. I plan to use a reserved inode number to reflect the case that the
inode itself doesn't have any attributes itself. It makes sense to
have a singleton whiteout inode per superblock.
