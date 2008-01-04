Return-Path: <linux-kernel-owner+w=401wt.eu-S1755258AbYADWzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258AbYADWzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 17:55:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753533AbYADWzL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 17:55:11 -0500
Received: from fk-out-0910.google.com ([209.85.128.189]:17254 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753709AbYADWzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 17:55:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=cCBHqzlUZBVrmyzDhbDsFsiy3qQBJN40Smwbc+VmBcetMkYbVt5rYIo0+/SMEJit4tm9NT3KbRcbNA/MGyMhGvhJcNq7LzzpQpPFSiU+FAbqF1Rwk86pWQt9vKhmrgIJHwIOd7Ul/e3C0tGIP970y+eEZztLfjVg5z+CFpqnP5g=
Message-ID: <477EB949.5040409@gmail.com>
Date: Fri, 04 Jan 2008 23:55:05 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Phil Endecott <phil_wueww_endecott@chezphil.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: strace, accept(), ERESTARTSYS and EINTR
References: <1199480498017@dmwebmail.japan.chezphil.org>
In-Reply-To: <1199480498017@dmwebmail.japan.chezphil.org>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2008 10:01 PM, Phil Endecott wrote:
> Dear Experts,
> 
> I have some code like this:
> 
> struct sockaddr_in client_addr;
> socklen_t client_size=sizeof(client_addr);
> int connfd = accept(fd,(struct sockaddr*)(&client_addr),&client_size);
> if (connfd==-1) {
>   // [1]
>   .....report error and terminate......
> }
> int rc = fcntl(connfd,F_SETFD,FD_CLOEXEC);

show socket() call please to see what proto and type you have there.

> I believe that I should be checking for errno==EINTR at [1] and retrying
> the accept(); currently I'm not doing so.
> 
> When I strace -f this application - which is multi-threaded - I see this:
> 
> [pid 11079] accept(3,  <unfinished ...>
> [pid 11093] restart_syscall(<... resuming interrupted call ...>
> <unfinished ...>
> [pid  8799] --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
> [pid 11079] <... accept resumed> 0xbfdaa73c, [16]) = ? ERESTARTSYS (To
> be restarted)
> [pid  8799] read(6,  <unfinished ...>
> [pid 11079] fcntl64(-512, F_SETFD, FD_CLOEXEC) = -1 EBADF (Bad file
> descriptor)
> 
> This shows accept() "returning" ERESTARTSYS; as I understand it this is
> an artefact of how strace works, and my code will not have seen accept
> return at all at that point.  However, the strace output does not show
> any other return from the call to accept() before reporting that
> thread's call to fcntl().  And the first parameter to fcntl, -512, is
> the return value from accept() which should be -1 or >0.  What is going
> on here???
> 
> Google found a couple of related reports:
> 
> http://lkml.org/lkml/2001/11/22/65 - Phil Howard reports getting
> ERESTARTSYS returned from accept(), not only in the strace output, and
> fixed his problem by treating it like EINTR.  He looked at errno if
> accept() returned <0, not ==-1.
> 
> http://lkml.org/lkml/2005/9/20/135 - Peter Duellings reports seeing
> accept() return -512 with errno==0.

ERESTARTSYS might be returned from system calls only when signal is pending.
Signal handler will change ERESTARTSYS to proper userspace error, i.e.
ERESTARTSYS (512) must not leak to userspace.

Some fail paths returns ERESTARTSYS even if no signal is pending and that used
to be the point.
