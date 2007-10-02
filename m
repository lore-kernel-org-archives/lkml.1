Return-Path: <linux-kernel-owner+w=401wt.eu-S1754678AbXJBRLx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbXJBRLx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 13:11:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752950AbXJBRLq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 13:11:46 -0400
Received: from mx1.redhat.com ([66.187.233.31]:60654 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbXJBRLp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 13:11:45 -0400
Message-ID: <47027BCD.9080709@redhat.com>
Date: Tue, 02 Oct 2007 13:11:41 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: gogi-k@gogi.tv
CC: linux-kernel@vger.kernel.org
Subject: Re: One process with multiple user ids.
References: <200710021256.08469.gogi-k@gogi.tv>
In-Reply-To: <200710021256.08469.gogi-k@gogi.tv>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Giuliano Gagliardi wrote:
> Hello,
> 
> I have a server that has to switch to different user ids, but because it does 
> other complex things, I would rather not have it run as root.

Well, it's probably going to have to *start* as root, or use something like 
sudo.  It's probably easiest to have it start as root and drop privileges as 
soon as possible, certainly before handling any untrusted data.

 > I only need the
> server to be able to switch to certain pre-defined user ids.

This is a very easy special case.  Just start a process for each user ID and 
drop root privileges.  They can communicate via sockets or even shared memory. 
If you wanted to switch between arbitrary UIDs at runtime, it might be worth 
doing something exotic, but it's really not in this case.  Also, if you do it 
this way, it's rather easy to verify the correctness of your design, and you 
never have to touch kernel code.

> I have seen that two possible solutions have already been suggested here on 
> the LKML, but it was some years ago, and nothing like it has been 
> implemented.
> 
> (1) Having supplementary user ids like there are supplementary group ids and 
> system calls getuids() and setuids() that work like getgroups() and 
> setgroups()

But you can already accomplish this with ACLs and SELinux.  You're trying to 
make this problem harder than it really is.

> (2) Allowing processes to pass user and group ids via sockets.

And do what with them?  You can already pass arbitrary data via sockets.  It 
sounds like you need (1) to use (2).

> Both (1) and (2) would solve my problem. Now my question is whether there are 
> any fundamental flaws with (1) or (2), or whether the right way to solve my 
> problem is another one.

(1) doesn't accomplish anything you can't already do, but it would make a huge 
mess of a lot of code.

(2) is silly.  Sockets are for communicating between userspace processes.  If 
you want to be granting/revoking credentials, you should be using system calls, 
and even then only if you absolutely must.  Having the kernel snoop traffic on 
sockets between processes would be disastrous for performance, and without that, 
any process could claim that it had been granted privileges over a socket and 
the kernel would just have to trust it.

Don't overthink this.  You don't need to touch the kernel at all to do this. 
Just use a multi-process model, like qmail does, for example.  You can start 
with root privileges and drop them, or use sudo to help you out.  It's fast, 
secure, takes advantage of modern multi-core CPUs, and is much simpler.

	-- Chris
