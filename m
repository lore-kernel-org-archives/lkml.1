Return-Path: <linux-kernel-owner+w=401wt.eu-S1752563Ab0AGGQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab0AGGQb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 01:16:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751345Ab0AGGQ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 01:16:29 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:40549 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751248Ab0AGGQ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 01:16:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=eQbf+wdj87EGdH7TQLiDBsz+tM3/JzcDeCHOIoIzNpV+MWWvdAiwlDXvpXC76h6Nu/
         8NowGLOJjDODe9ffR59q8/vwRGTfta5j//uhHFNKgK0kcykEUVnSTOfk2FaZdWJZ81h0
         iMiy47vvLtsOtLXI4Ae1w9YOQTBCl/OADdILU=
MIME-Version: 1.0
Date: Wed, 6 Jan 2010 22:16:27 -0800
Message-ID: <dd18b0c31001062216m316163f4t992c000eca0f76d@mail.gmail.com>
Subject: [bisected] sys_paccept: disable paccept() causes my macbook pro to 
	have an annoying whining sound
From: Justin Mattock <justinmattock@gmail.com>
To: linux-wireless@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for a while I've been hearing this odd
annoying sound coming from my macbook pro
when the system is idle(no internet use tv/radio/web etc...)
as soon as I do anything(radio,web) the noise disappears.

here is a  url where they are experiencing the same issue:
https://help.ubuntu.com/community/MacBook1-1/Hardy
(down under whining noise);

here is is the result of my bisect:

2d4c8266774188cda7f7e612e6dfb8ad12c579d5 is the first bad commit
commit 2d4c8266774188cda7f7e612e6dfb8ad12c579d5
Author: Michael Kerrisk <mtk.manpages@googlemail.com>
Date:   Mon Sep 22 13:57:49 2008 -0700

    sys_paccept: disable paccept() until API design is resolved

    The reasons for disabling paccept() are as follows:

    * The API is more complex than needed.  There is AFAICS no demonstrated
      use case that the sigset argument of this syscall serves that couldn't
      equally be served by the use of pselect/ppoll/epoll_pwait + traditional
      accept().  Roland seems to concur with this opinion
      (http://thread.gmane.org/gmane.linux.kernel/723953/focus=732255).  I
      have (more than once) asked Ulrich to explain otherwise
      (http://thread.gmane.org/gmane.linux.kernel/723952/focus=731018), but he
      does not respond, so one is left to assume that he doesn't know of such
      a case.

    * The use of a sigset argument is not consistent with other I/O APIs
      that can block on a single file descriptor (e.g., read(), recv(),
      connect()).

    * The behavior of paccept() when interrupted by a signal is IMO strange:
      the kernel restarts the system call if SA_RESTART was set for the
      handler.  I think that it should not do this -- that it should behave
      consistently with paccept()/ppoll()/epoll_pwait(), which never restart,
      regardless of SA_RESTART.  The reasoning here is that the very purpose
      of paccept() is to wait for a connection or a signal, and that
      restarting in the latter case is probably never useful.  (Note: Roland
      disagrees on this point, believing that rather paccept() should be
      consistent with accept() in its behavior wrt EINTR
      (http://thread.gmane.org/gmane.linux.kernel/723953/focus=732255).)

    I believe that instead, a simpler API, consistent with Ulrich's other
    recent additions, is preferable:

    accept4(int fd, struct sockaddr *sa, socklen_t *salen, ind flags);

    (This simpler API was originally proposed by Ulrich:
    http://thread.gmane.org/gmane.linux.network/92072)

    If this simpler API is added, then if we later decide that the sigset
    argument really is required, then a suitable bit in 'flags' could be added
    to indicate the presence of the sigset argument.

    At this point, I am hoping we either will get a counter-argument from
    Ulrich about why we really do need paccept()'s sigset argument, or that he
    will resubmit the original accept4() patch.

    Signed-off-by: Michael Kerrisk <mtk.manpages@gmail.com>
    Cc: David Miller <davem@davemloft.net>
    Cc: Davide Libenzi <davidel@xmailserver.org>
    Cc: Alan Cox <alan@redhat.com>
    Cc: Ulrich Drepper <drepper@redhat.com>
    Cc: Jakub Jelinek <jakub@redhat.com>
    Cc: Roland McGrath <roland@redhat.com>
    Cc: Oleg Nesterov <oleg@tv-sign.ru>
    Cc: Christoph Hellwig <hch@lst.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

:040000 040000 075d833177c2ee952fa0003bd490d50cb16926ec
d5a2bc1dbca03d3c21e3740cddb6164de6df9cda M	net


I think I was pretty straight forward with it. i.g. a good kernel
no sound bad kernel whining sound.

Now looking into sys_paccept seems it's been removed
in place for accept4.
I went to go revert that manually but there's too much
that has changed in net/socket.c

what/how is the best way to really find out if
accept4/sys_paccept is where this noise is coming
from on my machine(reverting is a mess)?


-- 
Justin P. Mattock
