Return-Path: <linux-kernel-owner+w=401wt.eu-S1758433AbZGIHvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433AbZGIHvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 03:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754896AbZGIHvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 03:51:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:45737 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407AbZGIHvF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 03:51:05 -0400
Date: Thu, 9 Jul 2009 09:51:00 +0200
From: Nick Piggin <npiggin@suse.de>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org
Subject: Re: [rfc][patch 3/4] fs: new truncate sequence
Message-ID: <20090709075100.GU2714@wotan.suse.de>
References: <20090707144823.GE2714@wotan.suse.de> <20090707145820.GA9976@infradead.org> <20090707150257.GG2714@wotan.suse.de> <20090707150758.GA18075@infradead.org> <20090707154809.GH2714@wotan.suse.de> <20090707163042.GA14947@infradead.org> <20090708063225.GL2714@wotan.suse.de> <20090708104701.GA31419@infradead.org> <20090708123412.GQ2714@wotan.suse.de> <4A54C435.1000503@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A54C435.1000503@panasas.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 08, 2009 at 07:07:17PM +0300, Boaz Harrosh wrote:
> On 07/08/2009 03:34 PM, Nick Piggin wrote:
> > On Wed, Jul 08, 2009 at 06:47:01AM -0400, Christoph Hellwig wrote:
> > Index: linux-2.6/fs/attr.c
> > ===================================================================
> > --- linux-2.6.orig/fs/attr.c
> > +++ linux-2.6/fs/attr.c
> > @@ -112,7 +112,12 @@ int inode_setattr(struct inode * inode,
> >  
> >  	if (ia_valid & ATTR_SIZE &&
> >  	    attr->ia_size != i_size_read(inode)) {
> > -		int error = vmtruncate(inode, attr->ia_size);
> > +		int error;
> > +
> > +		if (inode->i_op->new_truncate)
> > +			error = simple_setsize(inode, attr->ia_size);
> 
> I don't understand this branch.
> If a filesystem has been converted to set "i_op->new_truncate=true"
> then it must have been converted to intersect ->setattr and has set
> the i_size (And needs to clear ATTR_SIZE, why?)
> 
> All other cases of systems not converted, or systems that do not have
> ->truncate will fall to the "else" part.
> 
> before the removal of i_op->new_truncate you will need to do something
> with the systems that do not have ->truncate which will be a 
> .setattr = simple_setattr or something
> 
> So I don't understand this conditional

inode_setattr *is* our "simple_setattr".

