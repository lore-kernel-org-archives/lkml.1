Return-Path: <linux-kernel-owner+w=401wt.eu-S1760231AbYHTQzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760231AbYHTQzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 12:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYHTQzI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 12:55:08 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:38067 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbYHTQzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 12:55:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type
         :content-transfer-encoding:from;
        b=ipWCzue77teCywToTQEx8SHoTiOyMh4z1eE2Qu1kZ/EXGxTHzjisVTe72GconBG2Zp
         iMtkApgqu7oq+O8ZHZ9g2rsEVX2SE7+0CATfWDcat4pbHIebR4jCi7tb7Gz7icbU0AKQ
         Ebiu5+iW8TVA94uS/6e2H682zZvm/teZtnPfo=
Message-ID: <48AC4B6E.4040409@gmail.com>
Date: Wed, 20 Aug 2008 18:50:54 +0200
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Ulrich Drepper <drepper@redhat.com>
CC: Davide Libenzi <davidel@xmailserver.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: paccept() oddity
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Michael Kerrisk <mtk.manpages@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich,

[
2.6.27-rc has paccept():

int paccept(int fd, struct sockaddr *sockaddr, socklen_t *addrlen,
         const sigset_t *sigmask, int setsize, int flags)
]

While considering the sigset argument for paccept() (see my previous
message), and testing that system call, I realized that there is a certain
oddness in the implementation of paccept().

Like accept(), paccept() automatically restarts if interrupted by a signal
handler that was established with the SA_RESTART flag.

On the other hand, pselect(), ppoll(), and epoll_pwait() are never restarted
if interrupted by a handler, even if the handler was established with
SA_RESTART.  (This is the same as with select(), poll(), and epoll_wait().)

It seems to me that it makes little sense to restart paccept(), especially in
the case where it is interrupted by a handler for one of the signals that is
in sigmask, since the whole point of calling paccept() is to block until a
connection is received, or until one of the signals in sigmask is caught().

How about changing paccept() so that it is never automatically restarted if
interrupted by a signal handler, regardless of the SA_RESTART flag.  (In
other words, paccept() should be consistent with pselect(), ppoll(), and
epoll_pwait(), rather than being consistent with accept().)  What are your
thoughts?

Cheers,

Michael

