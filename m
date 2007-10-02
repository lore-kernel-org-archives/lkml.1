Return-Path: <linux-kernel-owner+w=401wt.eu-S1755762AbXJBJ2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762AbXJBJ2b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 05:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751906AbXJBJ2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 05:28:23 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:12689 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbXJBJ2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 05:28:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=EbKkTqs7CCDC/locx/OHJN/r1QJUZGLpy1gMrEBGkBWd2QaEewvl0zvoiSUvD9PuX7321sIodpGJ2XxQMGJiRbG4OxPOapMrbAFhXuXPqxs1X5aWfjQvz/WTrDppCVsrM6kCQslAeI320kr6CFe1voSK4Ueg44AnDpzPhO4BvSk=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Subject: Re: F_DUPFD_CLOEXEC implementation
Date: Tue, 2 Oct 2007 10:28:13 +0100
User-Agent: KMail/1.9.1
Cc: Al Viro <viro@ftp.linux.org.uk>, Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200709281734.l8SHYTmd027235@devserv.devel.redhat.com> <200710011949.03482.vda.linux@googlemail.com> <Pine.LNX.4.64.0710011158390.25942@alien.or.mcafeemobile.com>
In-Reply-To: <Pine.LNX.4.64.0710011158390.25942@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710021028.13536.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 October 2007 20:04, Davide Libenzi wrote:
> > They don't even need to read in parallel, just having shared fd is enough.
> > Think about pipes, sockets and terminals. A real-world scenario:
> > 
> > * a process started from shell (interactive or shell script)
> > * it sets O_NONBLOCK and does a read from fd 0...
> > * it gets killed (kill -9, whatever)
> > * shell suddenly has it's fd 0 in O_NONBLOCK mode
> > * shell and all subsequent commands started from it unexpectedly have
> >   O_NONBLOCKed stdin.
> 
> I told you how in the previous email. You cannot use the:
> 
> 1) set O_NONBLOCK
> 2) read/write
> 3) unset O_NONBLOCK
> 
> in a racy-free fashion, w/out wrapping it with a lock (thing that we 
> don't want to do).

I'm confused. I am saying exactly this same thing: that I cannot
do it atomically using standard unix operations, but I still need
to do a nonblocking read. Why are you explaining to me that it
cannot be done? I *know*. I'm asking what API should be
added/extended to make it possible.

I have following proposals:

* make recv(..., MSG_DONTWAIT) work on any fd

Sounds neat, but not trivial to implement in current kernel.

* new fcntl command F_DUPFL: fcntl(fd, F_DUPFL, n):
  Analogous to F_DUPFD, but gives you *unshared* copy of the fd.
  Further seeks, fcntl(fd, F_SETFL, O_NONBLOCK), etc won't affect
  any other process.

How hard would it be implement F_DUPFL in current kernel?
--
vda
