Return-Path: <linux-kernel-owner+w=401wt.eu-S1753212AbYJYSjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbYJYSjk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 14:39:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751131AbYJYSjb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 14:39:31 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:45288 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbYJYSja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 14:39:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IhRdqnkmwAEJtv47cnA4F77JpvFY22fWiaFQuIMY0oonRhBvGqClQ0DJ/PGNSIuAYV
         zhv/qJTbKWIASQcxrqwbJLkL8yr5axdJSIGIei5f9+X25u3irrJ7Q2LYhHKDpTRJmXrG
         Y69W/BdTUCkflCr4H0rUZYA4iMRDFlnzWZxG8=
Date: Sat, 25 Oct 2008 20:39:09 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.28-rc1 regression] wmifinfo dockapp takes 100% of cpu
	(bisected)
Message-ID: <20081025183905.GC10932@joi>
References: <20081025094043.GA4438@localhost.aei.mpg.de> <490327B6.2090903@linux.intel.com> <20081025071348.63c426d9@infradead.org> <20081025162503.GA4001@localhost.aei.mpg.de> <20081025180322.GA10932@joi> <20081025182929.GA3921@localhost.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081025182929.GA3921@localhost.aei.mpg.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

one more thing:

On Sat, Oct 25, 2008 at 08:29:29PM +0200, Carlos R. Mafra wrote:
> > > > diff --git a/fs/compat.c b/fs/compat.c
> > > > index fe3c9bf..95ceee6 100644
> > > > --- a/fs/compat.c
> > > > +++ b/fs/compat.c
> > > > @@ -1680,9 +1680,16 @@ asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
> > > >  	int ret;
> > > >  
> > > >  	if (tvp) {
> > > > +		int i;

"i" should be initialized to 0

> > > >  		if (copy_from_user(&tv, tvp, sizeof(tv)))
> > > >  			return -EFAULT;
> > > >  
> > > > +		while (tv.tv_usec > USEC_PER_SEC && i < 1000) {
> >                                   ^ 
> > should be >=
> > 
> > > > +			i++;
> > > > +			tv.tv_sec ++;
> > > > +			tv.tv_usec -= USEC_PER_SEC;
> > > > +		}
> > > > +
> > > >  		to = &end_time;
> > > >  		if (poll_select_set_timeout(to, tv.tv_sec,
> > > >  					    tv.tv_usec * NSEC_PER_USEC))
> > > > diff --git a/fs/select.c b/fs/select.c
> > > > index 448e440..e4e7cdb 100644
> > > > --- a/fs/select.c
> > > > +++ b/fs/select.c
> > > > @@ -515,9 +515,16 @@ asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
> > > >  	int ret;
> > > >  
> > > >  	if (tvp) {
> > > > +		int i = 0;
> > > >  		if (copy_from_user(&tv, tvp, sizeof(tv)))
> > > >  			return -EFAULT;
> > > >  
> > > > +		while (tv.tv_usec > USEC_PER_SEC && i < 1000) {
> > 
> > and here too
> 
> 
> Yes, changing to >= solves the problem here.
> 
> Thanks Arjan and Marcin!
> 
> 
> > > > +			i++;
> > > > +			tv.tv_sec ++;
> > > > +			tv.tv_usec -= USEC_PER_SEC;
> > > > +		}
> > > > +
> > > >  		to = &end_time;
> > > >  		if (poll_select_set_timeout(to, tv.tv_sec,
> > > >  					    tv.tv_usec * NSEC_PER_USEC))
> > > > 
> > > > -- 
