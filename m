Return-Path: <linux-kernel-owner+w=401wt.eu-S1755568AbZGGNaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbZGGNaq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 09:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756895AbZGGNaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 09:30:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50724 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755828AbZGGNaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 09:30:16 -0400
Date: Tue, 7 Jul 2009 15:30:14 +0200
From: Nick Piggin <npiggin@suse.de>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
       Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [rfc][patch 3/3] fs: convert ext2,tmpfs to new truncate
Message-ID: <20090707133014.GA2714@wotan.suse.de>
References: <20090706165438.GQ2714@wotan.suse.de> <20090706165629.GS2714@wotan.suse.de> <4A533559.90303@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A533559.90303@panasas.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 02:45:29PM +0300, Boaz Harrosh wrote:
> On 07/06/2009 07:56 PM, Nick Piggin wrote:
> > Convert filemap_xip.c, buffer.c, and some filesystems to the new truncate
> > convention. Converting generic helpers is using some ugly code (testing
> > for i_op->ftruncate) to distinguish new and old callers... better
> > alternative might be just define a new function for these guys.
> > @@ -770,13 +793,22 @@ ext2_nobh_write_begin(struct file *file,
> >  		loff_t pos, unsigned len, unsigned flags,
> >  		struct page **pagep, void **fsdata)
> >  {
> > +	int ret;
> > +
> >  	/*
> >  	 * Dir-in-pagecache still uses ext2_write_begin. Would have to rework
> >  	 * directory handling code to pass around offsets rather than struct
> >  	 * pages in order to make this work easily.
> >  	 */
> > -	return nobh_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
> > +	ret = nobh_write_begin(file, mapping, pos, len, flags, pagep, fsdata,
> >  							ext2_get_block);
> > +	if (ret < 0) {
> > +		loff_t isize;
> > +		isize = i_size_read(inode);
> 
> Unlike the other places you use i_size_read() here, please explain what is the
> locking rules for this?
> 
> Did your patchset change things in this regard?

i_mutex should protect i_size. I was doing a bit of cutting and pasting
so it probably isn't perfect. I'll double check.


