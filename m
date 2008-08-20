Return-Path: <linux-kernel-owner+w=401wt.eu-S1759991AbYHTQye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759991AbYHTQye (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYHTQyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:54:25 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:34181 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752019AbYHTQyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:54:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type
         :content-transfer-encoding:from;
        b=Qv883ggQNFLsxV2MM6RoZUfXDRkZN1keEYhp7x2X5Gn83GPDIuxtmRjEFe+sC+KHHD
         omlkyKy7kkrd+g8Kt8s3jbE7Ytd9iv1KQJ5HgiB8OBhhtBf1j7H5bQeaMUd/IKOaDWFT
         MXo/WjpliS7h4MY6XlHdU1DUyhQW1lh5SzD+o=
Message-ID: <48AC4B44.2010606@gmail.com>
Date: Wed, 20 Aug 2008 18:50:12 +0200
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Davide Libenzi <davidel@xmailserver.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Rationale for paccept() sigset argument?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich,

I'll need to cover this point in the man pages, and the rationale still isn't
clear to me, so I'll check it with you...

2.6.27-rc has paccept():

int paccept(int fd, struct sockaddr *sockaddr, socklen_t *addrlen,
         const sigset_t *sigmask, int setsize, int flags)

paccept() blocks until either a connection is received on fd, or a signal is
sigmask() is caught.

What is the rationale for the sigset argument of paccept()?

For pselect()/ppoll()/epoll_pwait(), the sigset argument allows us to deal
with a not uncommon situation: waiting for both signals and (multiple) file
descriptors.  (The alternative is the self-pipe trick, which requires more
programming effort.)

However, do we really need this argument for paccept()?  I ask this for the
following reasons:

* This seems to be special casing for accept().  But there are other system
calls (e.g., open(), connect(), recvfrom()) that are similar, in the sense
that they may wait on a file descriptor, for which there is no [perceived
need for a] sigset argument.

* It seems to me that any case where we might want to use paccept() could be
equivalently dealt with using the existing pselect()/ppoll()/epoll_pwait()
followed by a conventional accept() if the listening file descriptor
indicates as ready.  (But perhaps I missed something?)

Can you please explain why we need this special case for [p]accept()?

Cheers,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html

