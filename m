Return-Path: <linux-kernel-owner+w=401wt.eu-S1759401AbYB1NXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759401AbYB1NXq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 08:23:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756452AbYB1NXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 08:23:38 -0500
Received: from el-out-1112.google.com ([209.85.162.182]:1410 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755927AbYB1NXh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 08:23:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JzLpyTMsytSIJrp5/8U/ymFUke6ClABVKkkrsifbl4HLkXbhm8kLkIpIGqTJraG/SWnsBV3h9oYj3BGQqklbqiYXN4P477a9hKlWvluEvXHUdem19s6mGnPblzSfVDdyAg50bzYiD0NeDQHbOiZ4qZ1hc52/92RkqgbbCiuDAn8=
Message-ID: <cfd18e0f0802280523p1bdacfc5s274387f8280238c8@mail.gmail.com>
Date: Thu, 28 Feb 2008 14:23:34 +0100
From: "Michael Kerrisk" <mtk.manpages@googlemail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: epoll design problems with common fork/exec patterns
Cc: "=?ISO-2022-JP?B?Q2hyaXMgIhskQiUvGyhCIiBIZWF0aA==?=" 
	<chris@heathens.co.nz>,
       "David Schwartz" <davids@webmaster.com>, dada1@cosmosbay.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       linux-man@vger.kernel.org
In-Reply-To: <cfd18e0f0802280512q43a457d0sc9a8dc83c51e8e1c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <MDEHLPKNGKAHNMBLJOLKAEHCHNAC.davids@webmaster.com>
	 <Pine.LNX.4.64.0710291147180.3387@alien.or.mcafeemobile.com>
	 <47C42CA7.4030607@gmail.com>
	 <Pine.LNX.4.64.0802261049040.27243@alien.or.mcafeemobile.com>
	 <1204075804.5238.7.camel@linux.heathens.co.nz>
	 <Pine.LNX.4.64.0802271131180.377@alien.or.mcafeemobile.com>
	 <cfd18e0f0802280512q43a457d0sc9a8dc83c51e8e1c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2008 at 2:12 PM, Michael Kerrisk
<mtk.manpages@googlemail.com> wrote:
>
> On Wed, Feb 27, 2008 at 8:35 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
>  > On Tue, 26 Feb 2008, Chris "ã~B¯" Heath wrote:
>  >
>  >  > On Tue, 2008-02-26 at 10:51 -0800, Davide Libenzi wrote:
>  >  > >
>  >
>  > > > Yes, you can't add the same fd twice. Think about a DB where "file*,fd" is
>  >  > > the key.
>  >  >
>  >  > To clarify, the key appears to be file* plus the user-space integer that
>  >  > represents the fd.
>  >
>  >  Yes, that's what I said.
>  >
>  >  > > > c) It is possible to add duplicated file descriptors referring to the same
>  >  > > > underlying open file description ("file *").  As you note, this can be a
>  >  > > > useful filtering technique, if the two file descriptors specify different
>  >  > > > masks.
>  >  > > >
>  >  > > > Assuming that is all correct, for man-pages-2.79, I've reworked the text
>  >  > > > for Q1/A1 as follows:
>  >  > > >
>  >  > > >        Q1     What  happens  if you add the same file descriptor
>  >  > > >               to an epoll set twice?
>  >  > > >
>  >  > > >        A1     You will probably get EEXIST.  However, it is pos-
>  >  > > >               sible   to   add  a  duplicate  (dup(2),  dup2(2),
>  >  > > >               fcntl(2) F_DUPFD, fork(2)) descriptor to the  same
>  >  > > >               epoll  set.   This  can  be a useful technique for
>  >  > > >               filtering events, if the duplicate  file  descrip-
>  >  > > >               tors are registered with different events masks.
>  >  > > >
>  >  > > > Seem okay Davide?
>  >  > >
>  >  > > Looks sane to me.
>  >  >
>  >  > I think fork(2) should not be in the above list.  fork(2) duplicates the
>  >  > kernel's fd, but the user-space integer that represents the fd remains
>  >  > the same, so you will get EEXIST if you try to add the fd that was
>  >  > duplicated by fork.
>  >
>  >  Good catch, fork(2) should not be there.
>
>  Okay -- removed.
>
>  But it is an ugly inconsistency.  On the one hand, a child process
>  cannot add the duplicate file descriptor to the epoll set.  (In every
>  other case that I can think of , descriptors duplicated by fork have
>  similar semantics to descriptors duplicated by dup() and friends.)  On
>  the other hand, the very fact that the child has a duplicate of the
>  descriptor means that even if the parent closes its descriptor, then
>  epoll_wait() in the parent will continue to receive notifications for
>  that descriptor because of the duplicated descriptor in the child.
>
>  The choice of [file *, fd] as the key for epoll sets really does seem
>  unfortunate.  Keying on [pid, fd] would have given saner semantics, it
>  seems to me.  Obviously it can't be changed now though.


Davide,

with the earlier discussion in this thread in mind, I added a Q0/A0 to
epoll.7, just make the point about keys clear:


       Q0  What is the key used to distinguish the file descrip-
           tors in an epoll set?

       A0  The key is the combination  of  the  file  descriptor
           number  and  the open file description (also known as
           "open file handle", the kernel's internal representa-
           tion of an open file).

Does that seem okay?

Cheers,

Michael

-- 
Michael Kerrisk
Maintainer of the Linux man-pages project
http://www.kernel.org/doc/man-pages/
Want to report a man-pages bug?  Look here:
http://www.kernel.org/doc/man-pages/reporting_bugs.html
