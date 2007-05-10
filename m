Return-Path: <linux-kernel-owner+w=401wt.eu-S1760848AbXEJUY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760848AbXEJUY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 16:24:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756227AbXEJUYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 16:24:19 -0400
Received: from atlrel6.hp.com ([156.153.255.205]:60750 "EHLO atlrel6.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755383AbXEJUYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 16:24:18 -0400
Subject: Re: post 2.6.21 regression in F_GETLK
From: Doug Chapman <doug.chapman@hp.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
       Marc Eshel <eshel@almaden.ibm.com>
In-Reply-To: <20070510193859.GR13719@fieldses.org>
References: <1178823375.7247.11.camel@dchapman.boston.redhat.com>
	 <20070510193050.GQ13719@fieldses.org> <20070510193859.GR13719@fieldses.org>
Content-Type: text/plain
Date: Thu, 10 May 2007 16:24:07 -0400
Message-Id: <1178828647.7247.16.camel@dchapman.boston.redhat.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-34.el4) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-10 at 15:38 -0400, J. Bruce Fields wrote:
> On Thu, May 10, 2007 at 03:30:50PM -0400, bfields wrote:
> > On Thu, May 10, 2007 at 02:56:15PM -0400, Doug Chapman wrote:
> > > A recent regression (introduced after 2.6.21) was caught by the LTP test
> > > fcntl11.  It appears that F_GETLK is not properly checking for existing
> > > F_RDLCK and allows taking out a write lock.
> > 
> > Ouch.
> > 
> > > This can be demonstrated by either running fcntl11 from the LTP suite or
> > > I have hacked up a much shorter version which demonstrates the issue and
> > > am attaching it.
> > > 
> > > Using git bisect I came up with this commit as the one that introduced
> > > the issue.
> > 
> > Thanks for the report--investigating....
> 
> Argh.  Looks like a cut-n-paste error.  Does this fix it?
> 
> --b.
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index 671a034..909f454 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -1632,6 +1632,7 @@ static int posix_lock_to_flock(struct flock *flock, struct file_lock *fl)
>  	flock->l_len = fl->fl_end == OFFSET_MAX ? 0 :
>  		fl->fl_end - fl->fl_start + 1;
>  	flock->l_whence = 0;
> +	flock->l_type = fl->fl_type;
>  	return 0;
>  }
>  

Bruce,

This doesn't fix the problem but it does look like it should be there.
I imagine this would have been the next bug we tripped over once the
original one is fixed.

- Doug


