Return-Path: <linux-kernel-owner+w=401wt.eu-S1946790AbXBJAPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946790AbXBJAPF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 19:15:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946791AbXBJAPF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 19:15:05 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56754 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946790AbXBJAPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 19:15:03 -0500
Date: Fri, 9 Feb 2007 16:12:45 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Eric Dumazet <dada1@cosmosbay.com>
cc: Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
In-Reply-To: <45CD0C07.5060601@cosmosbay.com>
Message-ID: <Pine.LNX.4.64.0702091608120.8424@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <Pine.LNX.4.64.0702091419470.8424@woody.linux-foundation.org>
 <45CD0C07.5060601@cosmosbay.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 10 Feb 2007, Eric Dumazet wrote:
> 
> Well, I guess if the original program was mono-threaded, and syscall used
> fget_light(), we might have a problem here if the child try a close(). So you
> may have to disable fget_light() magic if async call is the originator of the
> syscall.

Yes. All the issues that I already brought up with Zach's patches are 
still there. This doesn't really change any of them. Any optimization that 
checks for "am I single-threaded" will need to be aware of pending and 
running async things.

With my patch, any _running_ async things will always be seen as normal 
clones, but the pending ones won't. So you'd need to effectively change 
anything that looks like

	if (atomic_read(&current->mm->count) == 1)
		.. do some simplified version ..

into

	if (!current->async_cookie && atomic_read(..) == 1)
		.. do the simplified thing ..

to make it safe.

I think we only do it for fget_light and some VM TLB simplification, so it 
shouldn't be a big burden to check.

Side note: the real issues still remain. The interfaces, and the 
performance testing.

		Linus
