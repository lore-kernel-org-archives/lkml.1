Return-Path: <linux-kernel-owner+w=401wt.eu-S1753099AbYIVIkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbYIVIkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 04:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751877AbYIVIk2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 04:40:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50008 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbYIVIk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 04:40:28 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: do_generic_file_read() never gets a NULL 'filp' argument
Cc: kosaki.motohiro@jp.fujitsu.com, Krishna Kumar <krkumar2@in.ibm.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080922013338.8e1c10ff.akpm@linux-foundation.org>
References: <20080922061610.20158.86022.sendpatchset@localhost.localdomain> <20080922013338.8e1c10ff.akpm@linux-foundation.org>
Message-Id: <20080922173703.C323.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon, 22 Sep 2008 17:40:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 22 Sep 2008 11:46:10 +0530 Krishna Kumar <krkumar2@in.ibm.com> wrote:
> 
> > From: Krishna Kumar <krkumar2@in.ibm.com>
> > 
> > The 'filp' argument to do_generic_file_read() is never NULL.
> > 
> 
> How did you verify this?
> 
> NFS used to like passing NULL file*'s into VFS functions.  I don't
> recall whether it affected do_generic_file_read().

Andrew, current do_generic_file_read have filp dereference at the beginning of function.
So, I believe nobody pass to NULL.


static void do_generic_file_read(struct file *filp, loff_t *ppos,
                read_descriptor_t *desc, read_actor_t actor)
{
        struct address_space *mapping = filp->f_mapping;  /* here */
        struct inode *inode = mapping->host;
        struct file_ra_state *ra = &filp->f_ra;          /* ditto */
        pgoff_t index;
        pgoff_t last_index;
        pgoff_t prev_index;



> 
> >  mm/filemap.c |    3 +--
> >  1 file changed, 1 insertion(+), 2 deletions(-)
> > 
> > diff -ruNp 2.6.27-rc7-org/mm/filemap.c 2.6.27-rc7-new/mm/filemap.c
> > --- 2.6.27-rc7-org/mm/filemap.c	2008-09-17 12:53:25.000000000 +0530
> > +++ 2.6.27-rc7-new/mm/filemap.c	2008-09-17 12:53:59.000000000 +0530
> > @@ -1186,8 +1186,7 @@ out:
> >  	ra->prev_pos |= prev_offset;
> >  
> >  	*ppos = ((loff_t)index << PAGE_CACHE_SHIFT) + offset;
> > -	if (filp)
> > -		file_accessed(filp);
> > +	file_accessed(filp);
> >  }
> >  
> >  int file_read_actor(read_descriptor_t *desc, struct page *page,
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



