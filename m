Return-Path: <linux-kernel-owner+w=401wt.eu-S965381AbXBFUqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965381AbXBFUqh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 15:46:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965435AbXBFUqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 15:46:37 -0500
Received: from smtp.osdl.org ([65.172.181.24]:49952 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965381AbXBFUqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 15:46:36 -0500
Date: Tue, 6 Feb 2007 12:46:11 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kent Overstreet <kent.overstreet@gmail.com>
cc: Davide Libenzi <davidel@xmailserver.org>,
       Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <6f703f960702051331v3ceab725h68aea4cd77617f84@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0702061238300.8424@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>  <20070202235531.GA18904@elte.hu>
  <Pine.LNX.4.64.0702021636410.15057@woody.linux-foundation.org> 
 <20070203082308.GA6748@elte.hu>  <B27B1E97-10E3-4A60-A476-4ED4173481A5@oracle.com>
  <Pine.LNX.4.64.0702051121420.14453@alien.or.mcafeemobile.com> 
 <8CF4BE18-8EEF-4ACA-A4B4-B627ED3B4831@oracle.com> 
 <Pine.LNX.4.64.0702051147100.14453@alien.or.mcafeemobile.com> 
 <Pine.LNX.4.64.0702051223390.8424@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0702051259030.14453@alien.or.mcafeemobile.com>
 <6f703f960702051331v3ceab725h68aea4cd77617f84@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 Feb 2007, Kent Overstreet wrote:
> 
> You don't need an explicit cookie if you're passing in a pointer to
> the return code, it doesn't really save you anything to do so. Say
> you've got a bunch of user threads (with or without stacks, it doesn't
> matter).
> 
> struct asys_ret {
>     int ret;
>     struct thread *p;
> };
> 
> struct asys_ret r;
> r.p = me;
> 
> async_read(fd, buf, nbytes, &r);

That's horrible. It means that "r" cannot have automatic linkage (since 
the stack will be *gone* by the time we need to fill in "ret"), so now you 
need to track *two* pointers: "me" and "&r".

Wouldn't it be much better to just track one (both in user space and in 
kernel space).

In kernel space, the "one pointer" would be the fibril pointer (which 
needs to have all the information necessary for completing the operation 
anyway), and in user space, it would be better to have just the cookie be 
a pointer to the place where you expect the return value (since you need 
both anyway).

I think the point here (for *both* the kernel and user space) would be to 
try to keep the interfaces really easy to use. For the kernel, it means 
that we don't ever pass anything new around: the "fibril" pointer is 
basically defined by the current execution thread.

And for user space, it means that we pass the _one_ thing around that we 
need for both identifying the async operation to the kernel (the "cookie") 
for wait or cancel, and the place where we expect the return value to be 
found (which in turn can _easily_ represent a whole "struct aiocb *", 
since the return value obviously has to be embedded in there anyway).

		Linus
