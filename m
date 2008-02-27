Return-Path: <linux-kernel-owner+w=401wt.eu-S1765305AbYB0BkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765305AbYB0BkK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 20:40:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752884AbYB0Bj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 20:39:56 -0500
Received: from smtp105.sbc.mail.re2.yahoo.com ([68.142.229.100]:29393 "HELO
	smtp105.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752807AbYB0Bj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 20:39:56 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Feb 2008 20:39:55 EST
X-YMail-OSG: FhUYDRcVM1kDvX2Cj3Ou3KAwe.kKoif8.bL8RI73Ozjq8iT30ZtFnen1UPUZmRLbu6.nMtsDsiFkKgjtIJdMtlroK09eUtv.DdyAme7fSh0mLAer854A
X-Yahoo-Newman-Property: ymail-3
Subject: Re: epoll design problems with common fork/exec patterns
From: Chris =?UTF-8?Q?=22=E3=82=AF=22?= Heath <chris@heathens.co.nz>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Michael Kerrisk <mtk.manpages@googlemail.com>,
       David Schwartz <davids@webmaster.com>, dada1@cosmosbay.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
       linux-man@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0802261049040.27243@alien.or.mcafeemobile.com>
References: <MDEHLPKNGKAHNMBLJOLKAEHCHNAC.davids@webmaster.com>
	 <Pine.LNX.4.64.0710291147180.3387@alien.or.mcafeemobile.com>
	 <47C42CA7.4030607@gmail.com>
	 <Pine.LNX.4.64.0802261049040.27243@alien.or.mcafeemobile.com>
Content-Type: text/plain
Date: Tue, 26 Feb 2008 20:30:04 -0500
Message-Id: <1204075804.5238.7.camel@linux.heathens.co.nz>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-7.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-02-26 at 10:51 -0800, Davide Libenzi wrote:
> On Tue, 26 Feb 2008, Michael Kerrisk wrote:
> 
> > Davide Libenzi wrote:
> > > On Sun, 28 Oct 2007, David Schwartz wrote:
> > > 
> > >> Eric Dumazet wrote:
> > >>
> > >>> Events are not necessarly reported "by descriptors". epoll uses an opaque
> > >>> field provided by the user.
> > >>>
> > >>> It's up to the user to properly chose a tag that will makes sense
> > >>> if the user
> > >>> app is playing dup()/close() games for example.
> > >> Great. So the only issue then is that the documentation is confusing. It
> > >> frequently uses the term "fd" where it means file. For example, it says:
> > >>
> > >>               Q1     What  happens  if  you  add  the  same fd to an
> > >> epoll_set
> > >>                      twice?
> > >>
> > >>               A1     You will probably get EEXIST.  However,  it  is
> > >> possible
> > >>                      that  two  threads  may  add the same fd twice. This is
> > >> a
> > >>                      harmless condition.
> > >>
> > >> This gives no reason to think there's anything wrong with adding the same
> > >> file twice so long as you do so through different descriptors. (One can
> > >> imagine an application that does this to segregate read and write operations
> > >> to avoid a race where the descriptor is closed from under a writer due to
> > >> handling a fatal read error.) Obviously, that won't work.
> > > 
> > > I agree, that is confusing. However, you can safely add two different file 
> > > descriptors pointing to the same file*, with different event masks, and 
> > > that will work as expected.
> > 
> > So can I summarize what I understand:
> > 
> > a) Adding the same file descriptor twice to an epoll set will cause an
> > error (EEXIST).
> 
> Yes.
> 
> 
> 
> > b) In a separate message to linux-man, Chris Heath says that two threads
> > *can't* add the same fd twice to an epoll set, despite what the existing
> > man page text says.  I haven't tested that, but it sounds to me as though
> > it is likely to be true.  Can you comment please Davide?
> 
> Yes, you can't add the same fd twice. Think about a DB where "file*,fd" is 
> the key.

To clarify, the key appears to be file* plus the user-space integer that
represents the fd.


> > c) It is possible to add duplicated file descriptors referring to the same
> > underlying open file description ("file *").  As you note, this can be a
> > useful filtering technique, if the two file descriptors specify different
> > masks.
> > 
> > Assuming that is all correct, for man-pages-2.79, I've reworked the text
> > for Q1/A1 as follows:
> > 
> >        Q1     What  happens  if you add the same file descriptor
> >               to an epoll set twice?
> > 
> >        A1     You will probably get EEXIST.  However, it is pos-
> >               sible   to   add  a  duplicate  (dup(2),  dup2(2),
> >               fcntl(2) F_DUPFD, fork(2)) descriptor to the  same
> >               epoll  set.   This  can  be a useful technique for
> >               filtering events, if the duplicate  file  descrip-
> >               tors are registered with different events masks.
> > 
> > Seem okay Davide?
> 
> Looks sane to me.

I think fork(2) should not be in the above list.  fork(2) duplicates the
kernel's fd, but the user-space integer that represents the fd remains
the same, so you will get EEXIST if you try to add the fd that was
duplicated by fork.

Chris

