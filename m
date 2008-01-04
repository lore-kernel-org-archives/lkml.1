Return-Path: <linux-kernel-owner+w=401wt.eu-S1754834AbYADVlb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbYADVlb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 16:41:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753925AbYADVlY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 16:41:24 -0500
Received: from japan.chezphil.org ([77.240.5.4]:3544 "EHLO japan.chezphil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896AbYADVlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 16:41:23 -0500
X-Greylist: delayed 2380 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 Jan 2008 16:41:23 EST
To: <linux-kernel@vger.kernel.org>
Date: Fri, 04 Jan 2008 21:01:38 +0000
Subject: strace, accept(), ERESTARTSYS and EINTR
Message-ID: <1199480498017@dmwebmail.japan.chezphil.org>
X-Mailer: Decimail Webmail 3alpha16
MIME-Version: 1.0
Content-Type: text/plain; format="flowed"
From: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
X-SPF-Guess: pass
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Experts,

I have some code like this:

struct sockaddr_in client_addr;
socklen_t client_size=sizeof(client_addr);
int connfd = accept(fd,(struct sockaddr*)(&client_addr),&client_size);
if (connfd==-1) {
   // [1]
   .....report error and terminate......
}
int rc = fcntl(connfd,F_SETFD,FD_CLOEXEC);


I believe that I should be checking for errno==EINTR at [1] and 
retrying the accept(); currently I'm not doing so.

When I strace -f this application - which is multi-threaded - I see this:

[pid 11079] accept(3,  <unfinished ...>
[pid 11093] restart_syscall(<... resuming interrupted call ...> 
<unfinished ...>
[pid  8799] --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
[pid 11079] <... accept resumed> 0xbfdaa73c, [16]) = ? ERESTARTSYS (To 
be restarted)
[pid  8799] read(6,  <unfinished ...>
[pid 11079] fcntl64(-512, F_SETFD, FD_CLOEXEC) = -1 EBADF (Bad file descriptor)

This shows accept() "returning" ERESTARTSYS; as I understand it this is 
an artefact of how strace works, and my code will not have seen accept 
return at all at that point.  However, the strace output does not show 
any other return from the call to accept() before reporting that 
thread's call to fcntl().  And the first parameter to fcntl, -512, is 
the return value from accept() which should be -1 or >0.  What is going 
on here???

Google found a couple of related reports:

http://lkml.org/lkml/2001/11/22/65 - Phil Howard reports getting 
ERESTARTSYS returned from accept(), not only in the strace output, and 
fixed his problem by treating it like EINTR.  He looked at errno if 
accept() returned <0, not ==-1.

http://lkml.org/lkml/2005/9/20/135 - Peter Duellings reports seeing 
accept() return -512 with errno==0.


Some more background: I started stracing the program because it was 
already misbehaving.  It had created a larger than usual number of 
threads (30?).  It's quite possible that some process resource limit 
had been reached; could this have confused the glibc syscall wrapper, 
causing it to return the mysterious -512?  Could it have confused the 
kernel into returng ERESTARTSYS instead of e.g. E-too-many-sockets-open?

It's also possible that some random memory corruption had occurred.  
valgrind is on my to-do list.  But even if this had occurred, I would 
expect to see strace reporting a legitimate return from accept() before 
the call to fcntl(); there was no sign of any global resource limit 
that might affect strace occurring.

This is a Debian system running kernel 2.6.21-1 i686, glibc 2.7, and 
strace 4.5.14.


Many thanks for any suggestions.

Phil.

(You're welcome to Cc: me in any replies.)



