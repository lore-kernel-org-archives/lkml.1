Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbXI3XLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbXI3XLn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 19:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbXI3XLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 19:11:35 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:50677 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbXI3XLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 19:11:34 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sun, 30 Sep 2007 16:11:32 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Denys Vlasenko <vda.linux@googlemail.com>
cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: F_DUPFD_CLOEXEC implementation
In-Reply-To: <200709300131.49320.vda.linux@googlemail.com>
Message-ID: <Pine.LNX.4.64.0709301605340.19355@alien.or.mcafeemobile.com>
References: <200709281734.l8SHYTmd027235@devserv.devel.redhat.com>
 <200709300131.49320.vda.linux@googlemail.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 30 Sep 2007, Denys Vlasenko wrote:

> Hi Ulrich,
> 
> On Friday 28 September 2007 18:34, Ulrich Drepper wrote:
> > One more small change to extend the availability of creation of
> > file descriptors with FD_CLOEXEC set.  Adding a new command to
> > fcntl() requires no new system call and the overall impact on
> > code size if minimal.
> 
> Tangential question: do you have any idea how userspace can
> safely do nonblocking read or write on a potentially-shared fd?
> 
> IIUC, currently it cannot be done without races:
> 
> old_flags = fcntl(fd, F_GETFL);
> ...other process may change flags!...
> fcntl(fd, F_SETFL, old_flags | O_NONBLOCK);
> read(fd, ...)
> ...other process may see flags changed under its feet!...
> fcntl(fd, F_SETFL, old_flags);
> 
> Can this be fixed?

I'm not sure I understood correctly your use case. But, if you have two 
processes/threads randomly switching O_NONBLOCK on/off, your problems 
arise not only the F_SETFL time.
If one of the tasks is not expecting an fd to be O_NONBLOCK, that will 
likely end up not handling correctly read/write-miss situations.
In that case it'd be better to keep the fd as O_NONBLOCK, and manually 
create blocking behaviour (when needed) with poll+read/write.



- Davide


