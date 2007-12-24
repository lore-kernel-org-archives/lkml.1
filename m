Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbXLXONl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbXLXONl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Dec 2007 09:13:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXLXONd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Dec 2007 09:13:33 -0500
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:32837 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752057AbXLXONd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Dec 2007 09:13:33 -0500
X-Greylist: delayed 4486 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Dec 2007 09:13:33 EST
Subject: Re: Possible fix for lockup in drop_caches
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: den@openvz.org, lkml <linux-kernel@vger.kernel.org>,
       Michael Rubin <mrubin@google.com>
In-Reply-To: <20071222020611.9e4e78dd.akpm@linux-foundation.org>
References: <1197893602.2866.13.camel@castor.localdomain>
	 <20071222020611.9e4e78dd.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Mon, 24 Dec 2007 12:58:43 +0000
Message-Id: <1198501123.2914.13.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 (2.12.2-2.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 2007-12-22 at 02:06 -0800, Andrew Morton wrote:
> On Mon, 17 Dec 2007 12:13:22 +0000 richard <richard@rsk.demon.co.uk> wrote:
> 
> >     fix lockup in when calling drop_caches
> >     
> >     calling /proc/sys/vm/drop_caches can hang due to a AB/BA lock dependency
> >     between j_list_lock and the inode_lock. This patch moves the redirtying of the buffer head out
> >     from under the j_list_lock.
> >     
> >     based on a suggestion by Andrew Morton.
> >     
> 
> Oh boy.  Do we really want to add all this stuff to JBD just for
> drop_caches which is a silly root-only broken-in-22-other-ways thing?

It did end up with a lot of code but I was hoping that not taking 2
locks at the same time would have a positive performance benefit, not
just fix the lockup. But, so far I've not been able to find a benchmark
to show any consistent difference.

However, I'm getting some interesting numbers from iozone that suggest
this patch improves write performance when the buffers are small enough
to fit into memory, _but_ the results are very variable. I'm not sure
why the iozone results are so inconsistent, maybe oprofile will help.
Anyway more testing is needed :)   

> Michael, might your convert-inode-lists-to-tree patches eliminate the need
> for taking inode_lock in drop_pagecache_sb()?  Probably not, as it uses an
> rbtree.  It would have been possible if it was using a radix-tree, I
> suspect..
> 
> > -void __journal_unfile_buffer(struct journal_head *jh)
> > +void __journal_unfile_buffer(struct journal_head *jh,
> > +		struct buffer_head **dirty_bh)
> >  {
> > -	__journal_temp_unlink_buffer(jh);
> > +	__journal_temp_unlink_buffer(jh, dirty_bh);
> >  	jh->b_transaction = NULL;
> >  }
> 
> I suspect the code would end up simpler if __journal_unfile_buffer() were
> to take an additional ref on the bh which it placed at *dirty_bh.
> 
> Callers of __journal_unfile_buffer() could then call
> 
> void handle_dirty_bh(struct buffer_head *bh)
> {
> 	if (bh) {
> 		jbd_mark_buffer_dirty(bh);
> 		put_bh(bh);
> 	}
> }

thanks for the suggestion, that looks like a really clean approach, I'll
give it a try.

cheers
Richard 


