Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbYJYS2r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbYJYS2r (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2008 14:28:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbYJYS2j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Oct 2008 14:28:39 -0400
Received: from mu-out-0910.google.com ([209.85.134.186]:29612 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbYJYS2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2008 14:28:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZdDru2XlqaMHxo+2Ym739Gdk658+F4K2J8+s5OJeEb3cOKIuhXJ9lXY7tUAj4TIWQW
         PibS6Ea/I8qXjicEyMN8fsWx/+u6WS56VZqwVtnWoRy/psMBVKo5ylFrcS7nMDUbiAkT
         sTdktn7NRmu/fqRPUtQxMQ8v76om8aF15gkiQ=
Date: Sat, 25 Oct 2008 20:29:29 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.28-rc1 regression] wmifinfo dockapp takes 100% of cpu
	(bisected)
Message-ID: <20081025182929.GA3921@localhost.aei.mpg.de>
References: <20081025094043.GA4438@localhost.aei.mpg.de> <490327B6.2090903@linux.intel.com> <20081025071348.63c426d9@infradead.org> <20081025162503.GA4001@localhost.aei.mpg.de> <20081025180322.GA10932@joi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081025180322.GA10932@joi>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 25.Oct'08 at 20:03:27 +0200, Marcin Slusarz wrote:
> On Sat, Oct 25, 2008 at 06:25:05PM +0200, Carlos R. Mafra wrote:
> > On Sat 25.Oct'08 at  7:13:48 -0700, Arjan van de Ven wrote:
> > > On Sat, 25 Oct 2008 07:05:42 -0700
> > > Arjan van de Ven <arjan@linux.intel.com> wrote:
> > > 
> > > > Carlos R. Mafra wrote:
> > > > 
> > > > 
> > > > Hi,
> > > > 
> > > > the line below is the key one:
> > > > 
> > > > > select(4, [3], NULL, NULL, {0, 5000000}) = -1 EINVAL (Invalid
> > > > > argument)
> > > > 
> > > > the application gives us an invalid timeval; it should have been (5,
> > > > 0) However, if the kernel accepted this before the kernel needs to
> > > > now also accept it obviously, I'll look into it
> > > 
> > > This patch should fix it; I'm a bit worried that I need to fix up
> > > userlands "mess", but ok. I also checked all other converted functions,
> > > and only select has this problem. The problem is that the conversion
> > > from microseconds to nanoseconds is overflowing ;-(
> > > 
> > > can you give this one a test?
> > 
> > Your patch did not solve it.
> > 
> > But you are right that the program I use is a mess, it was doing
> > 
> >     tv.tv_sec = 0;
> >     tv.tv_usec = 5000000L;
> > 
> > So I changed it to
> > 
> >     tv.tv_sec = 5;
> >     tv.tv_usec = 0;
> > 
> > and it worked (with and without your patch).
> > 
> > From what I understand this is what your patch does,
> > so it is strange that it didn't work...
> > 
> > > diff --git a/fs/compat.c b/fs/compat.c
> > > index fe3c9bf..95ceee6 100644
> > > --- a/fs/compat.c
> > > +++ b/fs/compat.c
> > > @@ -1680,9 +1680,16 @@ asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
> > >  	int ret;
> > >  
> > >  	if (tvp) {
> > > +		int i;
> > >  		if (copy_from_user(&tv, tvp, sizeof(tv)))
> > >  			return -EFAULT;
> > >  
> > > +		while (tv.tv_usec > USEC_PER_SEC && i < 1000) {
>                                   ^ 
> should be >=
> 
> > > +			i++;
> > > +			tv.tv_sec ++;
> > > +			tv.tv_usec -= USEC_PER_SEC;
> > > +		}
> > > +
> > >  		to = &end_time;
> > >  		if (poll_select_set_timeout(to, tv.tv_sec,
> > >  					    tv.tv_usec * NSEC_PER_USEC))
> > > diff --git a/fs/select.c b/fs/select.c
> > > index 448e440..e4e7cdb 100644
> > > --- a/fs/select.c
> > > +++ b/fs/select.c
> > > @@ -515,9 +515,16 @@ asmlinkage long sys_select(int n, fd_set __user *inp, fd_set __user *outp,
> > >  	int ret;
> > >  
> > >  	if (tvp) {
> > > +		int i = 0;
> > >  		if (copy_from_user(&tv, tvp, sizeof(tv)))
> > >  			return -EFAULT;
> > >  
> > > +		while (tv.tv_usec > USEC_PER_SEC && i < 1000) {
> 
> and here too


Yes, changing to >= solves the problem here.

Thanks Arjan and Marcin!


> > > +			i++;
> > > +			tv.tv_sec ++;
> > > +			tv.tv_usec -= USEC_PER_SEC;
> > > +		}
> > > +
> > >  		to = &end_time;
> > >  		if (poll_select_set_timeout(to, tv.tv_sec,
> > >  					    tv.tv_usec * NSEC_PER_USEC))
> > > 
> > > -- 
