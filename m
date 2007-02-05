Return-Path: <linux-kernel-owner+w=401wt.eu-S933436AbXBEVbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933436AbXBEVbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 16:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933461AbXBEVbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 16:31:39 -0500
Received: from nf-out-0910.google.com ([64.233.182.184]:10179 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933436AbXBEVbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 16:31:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=bQpi+ssfz3yUyS0jcS8Ft9uUjp86a0/DCdRK4fFVdVuNpVp2w206DVp5frOv+Mt/WVZ3zVKpzwX8fxNyEsxrKj3EiADmgaeevtD8dllAEIXWcQqkRewBpTi5B5YxHgWIXemN/rjKSvHxa6UM8p2IrPtGuV6j4o0panI1+PeCExo=
Message-ID: <6f703f960702051331v3ceab725h68aea4cd77617f84@mail.gmail.com>
Date: Mon, 5 Feb 2007 12:31:35 -0900
From: "Kent Overstreet" <kent.overstreet@gmail.com>
To: "Davide Libenzi" <davidel@xmailserver.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Zach Brown" <zach.brown@oracle.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Benjamin LaHaise" <bcrl@kvack.org>
In-Reply-To: <Pine.LNX.4.64.0702051259030.14453@alien.or.mcafeemobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <patchbomb.1170193181@tetsuo.zabbo.net>
	 <20070202235531.GA18904@elte.hu>
	 <Pine.LNX.4.64.0702021636410.15057@woody.linux-foundation.org>
	 <20070203082308.GA6748@elte.hu>
	 <B27B1E97-10E3-4A60-A476-4ED4173481A5@oracle.com>
	 <Pine.LNX.4.64.0702051121420.14453@alien.or.mcafeemobile.com>
	 <8CF4BE18-8EEF-4ACA-A4B4-B627ED3B4831@oracle.com>
	 <Pine.LNX.4.64.0702051147100.14453@alien.or.mcafeemobile.com>
	 <Pine.LNX.4.64.0702051223390.8424@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0702051259030.14453@alien.or.mcafeemobile.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > HOWEVER, they get returned differently. The cookie gets returned
> > immediately, the system call result gets returned in-memory only after the
> > async thing has actually completed.
> >
> > I would actually argue that it's not the kernel that should generate any
> > cookie, but that user-space should *pass*in* the cookie it wants to, and
> > the kernel should consider it a pointer to a 64-bit entity which is the
> > return code.
>
> Yes. Let's have the userspace to "mark" the async operation. IMO the
> cookie should be something transparent to the kernel.
> Like you said though, that'd require compat-code (unless we fix the size).

You don't need an explicit cookie if you're passing in a pointer to
the return code, it doesn't really save you anything to do so. Say
you've got a bunch of user threads (with or without stacks, it doesn't
matter).

struct asys_ret {
     int ret;
     struct thread *p;
};

struct asys_ret r;
r.p = me;

async_read(fd, buf, nbytes, &r);

Then you just have your async_getevents return the same pointers you
passed in, and your main event loop gets pointers to its threads for
free.

It seems cleaner to do it this way vs. returning structs with the
actual return code and a cookie, as threads get the return code
exactly where they want it.

Keep in mind that the epoll way (while great for epoll, I do love it)
makes sense because it doesn't have to deal with any sort of return
codes.

My only other point is that you really do want a bulk asys_submit
instead of doing a syscall per async syscall; one of the great wins of
this approach is heavily IO driven apps can batch up syscalls.
