Return-Path: <linux-kernel-owner+w=401wt.eu-S1757161AbXIETEf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161AbXIETEf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 15:04:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755044AbXIETE3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 15:04:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:45412 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755010AbXIETE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 15:04:28 -0400
X-Authenticated: #24879014
X-Provags-ID: V01U2FsdGVkX1/UoMZhYSTUaLyevjeIg87PZzjaXb6F6z00MT21oM
	a8lIfsnS4TaZAK
Message-ID: <46DEFD3F.8020502@gmx.net>
Date: Wed, 05 Sep 2007 21:02:23 +0200
From: Michael Kerrisk <mtk-manpages@gmx.net>
User-Agent: Thunderbird 1.5.0.8 (X11/20060911)
MIME-Version: 1.0
To: drepper@redhat.com
CC: lkml <linux-kernel@vger.kernel.org>
Subject: O_CLOEXEC / MSG_CMSG_CLOEXEC documentation
References: <200705312320.l4VNKS44030545@shell0.pdx.osdl.net>
In-Reply-To: <200705312320.l4VNKS44030545@shell0.pdx.osdl.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ulrich,

For man-pages-2.66, I have added the following documentation in
the open.2 man page for the new-in-2.6.23 O_CLOEXEC.

    O_CLOEXEC (Since Linux 2.6.23)
          Enable   the  close-on-exec  flag  for  the  new  file
          descriptor.  This is useful in multithreaded  programs
          since  using  a separate fcntl(2) F_SETFD operation to
          set the FD_CLOEXEC flag does not suffice to avoid race
          conditions  in multithreaded programs where one thread
          opens a file descriptor at the same  time  as  another
          thread does a fork(2) plus execve(2).

For the recv.2 I added the analogous:

    MSG_CMSG_CLOEXEC (recvmsg() only; since Linux 2.6.23)
         Set  the  close-on-exec  flag  for the file descriptor
         received via a Unix domain file descriptor  using  the
         SCM_RIGHTS  operation  (described  in  unix(7)).  This
         flag is useful for the same reasons as  the  O_CLOEXEC
         flag of open(2).

Please let me know if these changes are correct and complete.

Cheers,

Michael

akpm@linux-foundation.org wrote:
> The patch titled
>      Introduce O_CLOEXEC
> has been added to the -mm tree.  Its filename is
>      introduce-o_cloexec-take-2.patch
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this
> 
> ------------------------------------------------------
> Subject: Introduce O_CLOEXEC
> From: Ulrich Drepper <drepper@redhat.com>
> 
> The problem is as follows: in multi-threaded code (or more correctly: all
> code using clone() with CLONE_FILES) we have a race when exec'ing.
> 
>    thread #1                       thread #2
> 
>    fd=open()
> 
>                                    fork + exec
> 
>   fcntl(fd,F_SETFD,FD_CLOEXEC)
> 
> In some applications this can happen frequently.  Take a web browser.  One
> thread opens a file and another thread starts, say, an external PDF viewer.
>  The result can even be a security issue if that open file descriptor
> refers to a sensitive file and the external program can somehow be tricked
> into using that descriptor.
> 
> Just adding O_CLOEXEC support to open() doesn't solve the whole set of
> problems.  There are other ways to create file descriptors (socket,
> epoll_create, Unix domain socket transfer, etc).  These can and should be
> addressed separately though.  open() is such an easy case that it makes not
> much sense putting the fix off.
> 
> The test program:
> 
> #include <errno.h>
> #include <fcntl.h>
> #include <stdio.h>
> #include <unistd.h>
> 
> #ifndef O_CLOEXEC
> # define O_CLOEXEC 02000000
> #endif
> 
> int
> main (int argc, char *argv[])
> {
>   int fd;
>   if (argc > 1)
>     {
>       fd = atol (argv[1]);
>       printf ("child: fd = %d\n", fd);
>       if (fcntl (fd, F_GETFD) == 0 || errno != EBADF)
>         {
>           puts ("file descriptor valid in child");
>           return 1;
>         }
>       return 0;
>     }
> 
>   fd = open ("/proc/self/exe", O_RDONLY | O_CLOEXEC);
>   printf ("in parent: new fd = %d\n", fd);
>   char buf[20];
>   snprintf (buf, sizeof (buf), "%d", fd);
>   execl ("/proc/self/exe", argv[0], buf, NULL);
>   puts ("execl failed");
>   return 1;
> }
[...]

-- 
Michael Kerrisk
maintainer of Linux man pages Sections 2, 3, 4, 5, and 7

Want to help with man page maintenance?  Grab the latest tarball at
http://www.kernel.org/pub/linux/docs/manpages/
read the HOWTOHELP file and grep the source files for 'FIXME'.


