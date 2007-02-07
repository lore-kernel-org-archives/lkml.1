Return-Path: <linux-kernel-owner+w=401wt.eu-S1030245AbXBGBWI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030245AbXBGBWI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 20:22:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030510AbXBGBWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 20:22:08 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:46578 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030245AbXBGBWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 20:22:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=og0r2Qf5SEz0jSA/mEY9QivDCGl/0nwRMtc5k/FdwZk5vfkEfD2Kgyj+QsctzOqOxR/435wKfbA5edIp2OGt7C13OK5oVL6MFR6ozFyb0o+YtYS6uvRnFMyPlAwu9nw1R1Lt9NrU6g9LeiwzB2xYvVLrXrUH/mY3em8QDQa0W2s=
Message-ID: <6f703f960702061722h3987c6fev1a330c3d954bccc8@mail.gmail.com>
Date: Tue, 6 Feb 2007 16:22:04 -0900
From: "Kent Overstreet" <kent.overstreet@gmail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Cc: "Davide Libenzi" <davidel@xmailserver.org>,
       "Zach Brown" <zach.brown@oracle.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, "Suparna Bhattacharya" <suparna@in.ibm.com>,
       "Benjamin LaHaise" <bcrl@kvack.org>
In-Reply-To: <Pine.LNX.4.64.0702061500270.8424@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <patchbomb.1170193181@tetsuo.zabbo.net>
	 <Pine.LNX.4.64.0702051121420.14453@alien.or.mcafeemobile.com>
	 <8CF4BE18-8EEF-4ACA-A4B4-B627ED3B4831@oracle.com>
	 <Pine.LNX.4.64.0702051147100.14453@alien.or.mcafeemobile.com>
	 <Pine.LNX.4.64.0702051223390.8424@woody.linux-foundation.org>
	 <Pine.LNX.4.64.0702051259030.14453@alien.or.mcafeemobile.com>
	 <6f703f960702051331v3ceab725h68aea4cd77617f84@mail.gmail.com>
	 <Pine.LNX.4.64.0702061238300.8424@woody.linux-foundation.org>
	 <6f703f960702061445q23dd9d48q7afec75d2400ef62@mail.gmail.com>
	 <Pine.LNX.4.64.0702061500270.8424@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/6/07, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Tue, 6 Feb 2007, Kent Overstreet wrote:
> >
> > The "struct aiocb" isn't something you have to or necessarily want to
> > keep around.
>
> Oh, don't get me wrong - the _only_ reason for "struct aiocb" would be
> backwards compatibility. The point is, we'd need to keep that
> compatibility to be useful - otherwise we just end up having to duplicate
> the work (do _both_ fibrils _and_ the in-kernel AIO).

Bah, I was unclear here, sorry. I was talking about the userspace interface.

Right now, with the aio interface, io_submit passes in an array of
pointers to struct iocb; there's nothing that says the kernel will be
done with the structs when io_submit returns, so while userspace is
free to reuse the array of pointers, it can't free the actual iocbs
until they complete.

This is slightly stupid, for a couple reasons, and if we're making a
new pair of sycalls it'd be better to do it slightly differently.

What you want is for the async_submit syscall (or whatever it's
called) to pass in an array of structs, and for the kernel to not
reference them after async_submit returns. This is easy; after
async_submit returns, each syscall in the array is either completed
(if it could be without blocking), or in progress, and there's no
reason to need the arguments again.

It also means that the kernel has to copy in only a single userspace
buffer, instead of one buffer per syscall; as Joel mentions, there are
plenty of apps that will be doing 1000s of syscalls at once. From a
userspace perspective it's awesome, it simplifies coding for it and
means you have to hit the heap that much less.
