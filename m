Return-Path: <linux-kernel-owner+w=401wt.eu-S1030513AbXBFXFV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030513AbXBFXFV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 18:05:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030519AbXBFXFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 18:05:20 -0500
Received: from smtp.osdl.org ([65.172.181.24]:54639 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030513AbXBFXFS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 18:05:18 -0500
Date: Tue, 6 Feb 2007 15:04:51 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Kent Overstreet <kent.overstreet@gmail.com>
cc: Davide Libenzi <davidel@xmailserver.org>,
       Zach Brown <zach.brown@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <6f703f960702061445q23dd9d48q7afec75d2400ef62@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0702061500270.8424@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>  <20070203082308.GA6748@elte.hu>
  <B27B1E97-10E3-4A60-A476-4ED4173481A5@oracle.com> 
 <Pine.LNX.4.64.0702051121420.14453@alien.or.mcafeemobile.com> 
 <8CF4BE18-8EEF-4ACA-A4B4-B627ED3B4831@oracle.com> 
 <Pine.LNX.4.64.0702051147100.14453@alien.or.mcafeemobile.com> 
 <Pine.LNX.4.64.0702051223390.8424@woody.linux-foundation.org> 
 <Pine.LNX.4.64.0702051259030.14453@alien.or.mcafeemobile.com> 
 <6f703f960702051331v3ceab725h68aea4cd77617f84@mail.gmail.com> 
 <Pine.LNX.4.64.0702061238300.8424@woody.linux-foundation.org>
 <6f703f960702061445q23dd9d48q7afec75d2400ef62@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 6 Feb 2007, Kent Overstreet wrote:
> 
> The "struct aiocb" isn't something you have to or necessarily want to
> keep around.

Oh, don't get me wrong - the _only_ reason for "struct aiocb" would be 
backwards compatibility. The point is, we'd need to keep that 
compatibility to be useful - otherwise we just end up having to duplicate 
the work (do _both_ fibrils _and_ the in-kernel AIO). 

> I don't see the point in having a ring for completed events, since
> it's at most two pointers per completion; quite a bit less data being
> sent back than for submissions.

I'm certainly personally perfectly happy with the kernel not remembering 
any completed events at all - once it's done, it's done and forgotten. So 
doing

	async(mycookie)
	wait_for_async(mycookie)

could actually return with -ECHILD (or similar error). 

In other words, if you see it as a "process interface" (instead of as a 
"filedescriptor interface"), I'd suggest automatic reaping of the fibril 
children. I do *not* think we want the equivalent of zombies - if only 
because they are just a lot of work to reap, and potentially a lot of 
memory to keep around.

		Linus
