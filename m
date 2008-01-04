Return-Path: <linux-kernel-owner+w=401wt.eu-S1754869AbYADXwd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754869AbYADXwd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 18:52:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbYADXwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 18:52:23 -0500
Received: from japan.chezphil.org ([77.240.5.4]:3821 "EHLO japan.chezphil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332AbYADXwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 18:52:22 -0500
To: "Jiri Slaby" <jirislaby@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Date: Fri, 04 Jan 2008 23:52:17 +0000
Subject: Re: strace, accept(), ERESTARTSYS and EINTR
Message-ID: <1199490737714@dmwebmail.japan.chezphil.org>
In-Reply-To: <477EB949.5040409@gmail.com>
References: <477EB949.5040409@gmail.com>
X-Mailer: Decimail Webmail 3alpha16
MIME-Version: 1.0
Content-Type: text/plain; format="flowed"
From: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
X-SPF-Guess: pass
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Jiri Slaby wrote:
> On 01/04/2008 10:01 PM, Phil Endecott wrote:
>> Dear Experts,
>> 
>> I have some code like this:
>> 
>> struct sockaddr_in client_addr;
>> socklen_t client_size=sizeof(client_addr);
>> int connfd = accept(fd,(struct sockaddr*)(&client_addr),&client_size);
>> if (connfd==-1) {
>>   // [1]
>>   .....report error and terminate......
>> }
>> int rc = fcntl(connfd,F_SETFD,FD_CLOEXEC);
>
> show socket() call please to see what proto and type you have there.

It's a ipv4 tcp socket:

// error handling & other noise removed:
int fd = socket(PF_INET,SOCK_STREAM,0);
struct sockaddr_in server_addr;
memset(&server_addr,0,sizeof(server_addr));
server_addr.sin_family=AF_INET;
server_addr.sin_addr.s_addr=htonl(INADDR_ANY);
server_addr.sin_port=htons(port);
bind(fd,(struct sockaddr*)&server_addr,sizeof(server_addr));
listen(listenfd,128);


>> I believe that I should be checking for errno==EINTR at [1] and retrying
>> the accept(); currently I'm not doing so.
>> 
>> When I strace -f this application - which is multi-threaded - I see this:
>> 
>> [pid 11079] accept(3,  <unfinished ...>
>> [pid 11093] restart_syscall(<... resuming interrupted call ...>
>> <unfinished ...>
>> [pid  8799] --- SIGSTOP (Stopped (signal)) @ 0 (0) ---
>> [pid 11079] <... accept resumed> 0xbfdaa73c, [16]) = ? ERESTARTSYS (To
>> be restarted)
>> [pid  8799] read(6,  <unfinished ...>
>> [pid 11079] fcntl64(-512, F_SETFD, FD_CLOEXEC) = -1 EBADF (Bad file
>> descriptor)
>> 
>> This shows accept() "returning" ERESTARTSYS; as I understand it this is
>> an artefact of how strace works, and my code will not have seen accept
>> return at all at that point.  However, the strace output does not show
>> any other return from the call to accept() before reporting that
>> thread's call to fcntl().  And the first parameter to fcntl, -512, is
>> the return value from accept() which should be -1 or >0.  What is going
>> on here???
>> 
>> Google found a couple of related reports:
>> 
>> http://lkml.org/lkml/2001/11/22/65 - Phil Howard reports getting
>> ERESTARTSYS returned from accept(), not only in the strace output, and
>> fixed his problem by treating it like EINTR.  He looked at errno if
>> accept() returned <0, not ==-1.
>> 
>> http://lkml.org/lkml/2005/9/20/135 - Peter Duellings reports seeing
>> accept() return -512 with errno==0.
>
> ERESTARTSYS might be returned from system calls only when signal is pending.
> Signal handler will change ERESTARTSYS to proper userspace error, i.e.
> ERESTARTSYS (512) must not leak to userspace.
>
> Some fail paths returns ERESTARTSYS even if no signal is pending and that used
> to be the point.

There are two odd things happening:

1. ERESTARTSYS is escaping to user-space, rather than EINTR or 
restarting the accept.
2. It gets out of libc into my code in the form ret=-512, not (ret=-1, errno=512).

Very odd; a user-space mess (e.g. stack corruption) shouldn't be able 
to change the kernel behaviour, and a kernel problem shouldn't cause 
the odd libc behaviour.  There must be another explanation....


Phil.




