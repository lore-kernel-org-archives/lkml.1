Return-Path: <linux-kernel-owner+w=401wt.eu-S1752506AbZELTJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbZELTJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 15:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753759AbZELTI6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 15:08:58 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:58189 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbZELTI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 15:08:57 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 12 May 2009 12:03:54 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@makko.or.mcafeemobile.com
To: rohit verma <rohit.170309@gmail.com>
cc: Hiroyuki.Mach@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: epoll_create(0) becomes not to fail (Re: issue with epoll system
  call)
In-Reply-To: <d51f89b0905112354k566d6de9lad4351d1ebc71759@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0905121203250.29869@makko.or.mcafeemobile.com>
References: <feaf5ed90905080049j78a4ab54x53ce65f22a3ea6a4@mail.gmail.com> <d51f89b0905112354k566d6de9lad4351d1ebc71759@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-1551575365-1242155035=:29869"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-1551575365-1242155035=:29869
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 12 May 2009, rohit verma wrote:

> hi,
> 
> I have created a patch for epoll_create syscall as shown below. Plz
> have a check and
> get back to me.

Never mind. I'll submit myself ..




> 
> diff a/fs/eventpoll.c   b/fs/eventpoll.c
> 
> 
> 
> --- eventpoll_orig.c    2009-05-12 12:07:27.000000000 +0530
> +++ eventpoll.c 2009-05-12 12:10:14.000000000 +0530
> @@ -1136,7 +1136,7 @@
>  SYSCALL_DEFINE1(epoll_create, int, size)
>  {
> -       if (size < 0)
> +       if (size <= 0)
>                 return -EINVAL;
>         return sys_epoll_create1(0);
> 
> 
> 
> Since there might be some formatting problems, i'm also attaching the
> patch in this
> mail.
> 
> Regards,
> Rohit
> 
> 
> 
> On Fri, May 8, 2009 at 1:19 PM, Hiroyuki Machida
> <Hiroyuki.Mach@gmail.com> wrote:
> >
> > Hi  Verma,
> >
> > I think your point is right. but descriptions looks not straight forward.
> > And title of the message is very confusable.
> > I think descriptions like following would be easy to understand, and
> > you should attach a your signed-off patch to fix the bug.
> >
> >
> > Thanks,
> > Hiro
> >
> > ----
> >
> > The following patch changed behavior of epoll_create(0);
> >
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9fe5ad9c8cef9ad5873d8ee55d1cf00d9b607df0;hp=e38b36f325153eaadd1c2a7abc5762079233e540
> >
> >
> > Before applying the patch,
> > sys_epoll_create2(int size, int flags)
> > returned -EINVAL,  with size=0;
> >
> > But,  if-condtion which is introduced in sys_epoll_create() by this patch,
> > looks to fail to consider case of size==0 as follows;
> >
> >  asmlinkage long sys_epoll_create(int size)
> >  {
> > -       return sys_epoll_create2(size, 0);
> > +       if (size < 0)
> > +               return -EINVAL;
> > +
> > +       return sys_epoll_create1(0);
> >  }
> >
> >
> > ---
> > Hiroyuki Machida
> >
> >
> >
> > On Thu, May 7, 2009 at 4:10 PM, rohit verma <rohit.170309@gmail.com> wrote:
> > > hi all,
> > >
> > > The man pages of epoll_create says - "Since Linux 2.6.8, the size
> > > argument is unused.  (The kernel dynamically sizes the required data
> > > structures without needing this initial hint.)" .
> > >
> > > Also, it says that the syscall returns EINVAL , when size is not
> > > positive. (i.e For, any value greater than 0, the kernel dynamically
> > > sizes the required data stuctures). When size is zero or less than
> > > zero, it has to return with error as EINVAL.
> > >
> > > the link:  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9fe5ad9c8cef9ad5873d8ee55d1cf00d9b607df0;hp=e38b36f325153eaadd1c2a7abc5762079233e540
> > >
> > > shows the latest patch of the epoll syscall. here , the syscall says:
> > >
> > > asmlinkage long sys_epoll_create(int size)
> > > {
> > > - return sys_epoll_create2(size,0);
> > > + if (size < 0)
> > > +  return -EINVAL;
> > > +
> > > +return sys_epoll_create1(0);
> > > }
> > >
> > > So if size = 0, it returns success which might not be the expected
> > > result. So i feel that the condition check should be
> > > " if (size <= 0) ". could u please check on this and reply me..
> > >
> > > Thank you,
> > >
> > > Regards,
> > > rohit
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> > >
> 


- Davide


--8323329-1551575365-1242155035=:29869--
