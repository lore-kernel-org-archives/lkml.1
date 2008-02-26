Return-Path: <linux-kernel-owner+w=401wt.eu-S1764183AbYBZTES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764183AbYBZTES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 14:04:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761092AbYBZTEH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 14:04:07 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:54330 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760949AbYBZTEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 14:04:06 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 26 Feb 2008 11:04:03 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Michael Kerrisk <mtk.manpages@googlemail.com>
cc: Pierre Habouzit <madcoder@debian.org>, lkml <linux-kernel@vger.kernel.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Marc Lehmann <schmorp@schmorp.de>,
       David Schwartz <davids@webmaster.com>
Subject: Re: epoll and shared fd's
In-Reply-To: <47C42CB3.8040500@gmail.com>
Message-ID: <Pine.LNX.4.64.0802261054041.27243@alien.or.mcafeemobile.com>
References: <20080118134318.GD9607@artemis.madism.org> 
 <Pine.LNX.4.64.0801181257240.24685@alien.or.mcafeemobile.com> 
 <20080124084001.GB7356@artemis.madism.org> 
 <Pine.LNX.4.64.0801241556130.29058@alien.or.mcafeemobile.com>
 <517f3f820801252337lcd4b0a0hde7359dc46a947dd@mail.gmail.com>
 <Pine.LNX.4.64.0801261308270.10472@alien.or.mcafeemobile.com>
 <47C42CB3.8040500@gmail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Feb 2008, Michael Kerrisk wrote:

> Following up after quite some time:
> 
> Davide Libenzi wrote:
> > On Sat, 26 Jan 2008, Michael Kerrisk wrote:
> > 
> >> On Jan 25, 2008 12:57 AM, Davide Libenzi <davidel@xmailserver.org> wrote:
> >>> On Thu, 24 Jan 2008, Pierre Habouzit wrote:
> >>>
> >>>> On Fri, Jan 18, 2008 at 09:10:18PM +0000, Davide Libenzi wrote:
> >>>>> On Fri, 18 Jan 2008, Pierre Habouzit wrote:
> >>>>>
> >>>>>>   Hi,
> >>>>>>
> >>>>>>   I just came across a strange behavior of epoll that seems to
> >>>>>> contradict the documentation. Here is what happens:
> >>>>>>
> >>>>>> * I have two processes P1 and P2, P1 accept()s connections, and send the
> >>>>>>   resulting file descriptors to P2 through a unix socket.
> >>>>>>
> >>>>>> * P2 registers the received socket in his epollfd.
> >>>>>>
> >>>>>>   [time passes]
> >>>>>>
> >>>>>> * P2 is done with the socket and closes it
> >>>>>>
> >>>>>> * P2 gets events for the socket again !
> >>>>>>
> >>>>>>
> >>>>>>   Though the documentation says that if a process closes a file
> >>>>>> descriptor, it gets unregistered. And yes I'm sure that P2 doens't dup()
> >>>>>> the file descriptor. Though (because of a bug) it was still open in
> >>>>>> P1[0], hence the referenced socket still live at the kernel level.
> >>>>>>
> >>>>>>   Of course the userland workaround is to force the EPOLL_CTL_DEL before
> >>>>>> the close, which I now do, but costs me a syscall where I wanted to
> >>>>>> spare one :|
> >>>>> For epoll, a close is when the kernel file* is released (that is, when all
> >>>>> its instances are gone).
> >>>>> We could put a special handling in filp_close(), but I don't think is a
> >>>>> good idea, and we're better live with the current behaviour.
> >>>>   Okay, maybe updating the linux manpages to be more clear about that is
> >>>> the way to go then. Thanks
> >>> Sure. I'll send Michael Kerrisk and updated statement for the A6 answer in
> >>> the epoll man page.
> >> Thanks Davide -- yes please send me a patch.
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> >>
> > 
> > Something like the one below ...
> > 
> > 
> > - Davide
> > 
> > 
> > 
> > --- epoll.4	2008-01-26 12:58:21.000000000 -0800
> > +++ epoll.4.new	2008-01-26 13:06:36.000000000 -0800
> > @@ -285,7 +285,19 @@
> >  sets automatically?
> >  .TP
> >  .B A6
> > -Yes.
> > +A file descriptor is the userspace counterpart of an internal kernel handle.
> > +Every time a process calls functions liks
> > +.BR dup (2),
> > +.BR dup2 (2)
> > +or
> > +.BR fork (2),
> > +a new file descriptor referring to the same internal kernel handle is
> > +created. The internal kernel handle remains alive until all the userspace
> > +file descriptors have been closed.
> > +The
> > +.BR epoll (4)
> > +interface automatically removes the internal kernel handle from the set,
> > +once all the file descriptor instances have been closed.
> >  .TP
> >  .B Q7
> >  If more than one event occurs between
> 
> Davide,
> 
> Two points.
> 
> a) I did a
> 
> s/internal kernel handle/open file description/
> 
> since that is the POSIX term for the internal handle.
> 
> b) It seems to me that you text doesn't quite make the point explicit
> enough.  I've tried to rewrite it; could you please check:
> 
>        A6     Yes, but be aware of the following point.  A  file
>               descriptor is a reference to an open file descrip-
>               tion (see  open(2)).   Whenever  a  descriptor  is
>               duplicated  via dup(2), dup2(2), fcntl(2) F_DUPFD,
>               or fork(2), a new file descriptor referring to the
>               same  open  file  description is created.  An open
>               file description continues to exist until all file
>               descriptors referring to it have been closed.  The
>               epoll  interface  automatically  removes  a   file
>               descriptor  from  an  epoll set only after all the
>               file descriptors referring to the underlying  open
>               file  handle  have  been  closed.  This means that
>               even after a file descriptor that is  part  of  an
>               epoll  set has been closed, events may be reported
>               for that file descriptor if other file descriptors
>               referring  to the same underlying file description
>               remain open.
> 
> Does that seem okay?  I plan to include the text in man-pages-2.79.

I agree with Bodo, it is kinda confusing. The name "open file description",
even though POSIX, looks very similar to "file descriptor".
I honestly don't know how more easily such concept could be expressed. 
IMHO at least "internal kernel handle" does not play look-alike games with 
"file descriptor".



> Was there some reason why removing a file descriptor couldn't have been
> made to do the "expected" thing (i.e., remove notifications for that file
> descriptor, regardless of whether the underlying file description remains
> open)?

That'd mean placing an eventpoll custom hook into sys_close(). Looks very 
bad to me, and probably will look even worse to other kernel folks.
Is not much a performance issue (a check to see if a file* is an eventpoll 
file is as easy as comparing the f_op pointer), but a design/style issue.
On top of that, the interface is already out by many years, so changing it 
will like going to cause problems.



- Davide


