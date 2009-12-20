Return-Path: <linux-kernel-owner+w=401wt.eu-S1755359AbZLTQOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbZLTQOa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Dec 2009 11:14:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753950AbZLTQO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Dec 2009 11:14:29 -0500
Received: from 1wt.eu ([62.212.114.60]:52838 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827AbZLTQO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Dec 2009 11:14:29 -0500
Date: Sun, 20 Dec 2009 17:14:22 +0100
From: Willy Tarreau <w@1wt.eu>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Nikolai ZHUBR <zhubr@mail.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: epoll'ing tcp sockets for reading
Message-ID: <20091220161422.GH32739@1wt.eu>
References: <1257480306.20091219150206@mail.ru> <alpine.DEB.2.00.0912190953160.4482@makko.or.mcafeemobile.com> <203216314.20091220013854@mail.ru> <alpine.DEB.2.00.0912191437530.4482@makko.or.mcafeemobile.com> <1059651918.20091220032610@mail.ru> <alpine.DEB.2.00.0912200750280.9679@makko.or.mcafeemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.0912200750280.9679@makko.or.mcafeemobile.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Davide,

On Sun, Dec 20, 2009 at 07:54:09AM -0800, Davide Libenzi wrote:
> On Sun, 20 Dec 2009, Nikolai ZHUBR wrote:
> 
> > Sunday, December 20, 2009, 1:56:22 AM, Davide Libenzi wrote:
> > [trim]
> > > The kernel cannot make decisions based on something whose knowledge is 
> > > userspace bound.
> > I didn't mean that. I just meant it would be usefull to let the caller
> > of epoll know also the size of data related to specific EPOLLIN event in
> > some "atomic" manner immediately, because the kernel probably knows this
> > size already.
> > The same thing can approximately be "emulated" by requesting FIOREAD for
> > all EPOLLIN-ready sockets just after epoll returns, before any other work.
> > It just would look not very elegant IMHO.
> 
> No such a thing of "atomic matter", since by the time you read the event, 
> more data might have come. It's just flawed, you see that?

I think that what Nikolai meant was the ability to wake up as soon as
there are *at least* XXX bytes ready. But while I can understand why
it would in theory save some code, in practice he would still have to
properly handle corner cases, which would defeat the original purpose
of his modification :

  - if he waits for larger data than the socket buffer can handle, he
    will never wake up ;

  - if my memory serves me right, the copy_and_cksum() code only knows
    whether a segment is correct during its transfer to userland, which
    means that epoll() could very well wake up with XXX apparent bytes
    ready, but the read would fail before XXX due to an invalid checksum
    on an intermediate segment. So the code would still have to take
    care of that situation anyway.

The last point implies the complete implementation of the code he wants
to avoid anyway, and the first one implies it will be hard to know when
this would work and when this would not. This means that while at first
glance this behaviour could be useful, it would in practice be useless.

Regards,
Willy

