Return-Path: <linux-kernel-owner+w=401wt.eu-S967258AbXFHC0Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967258AbXFHC0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 22:26:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965718AbXFHC0C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 22:26:02 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:38304 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964987AbXFHC0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 22:26:00 -0400
Date: Thu, 7 Jun 2007 19:25:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matt Mackall <mpm@selenic.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Davide Libenzi <davidel@xmailserver.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <dada1@cosmosbay.com>
Subject: Re: [patch 7/8] fdmap v2 - implement sys_socket2
In-Reply-To: <20070608005931.GZ11166@waste.org>
Message-ID: <alpine.LFD.0.98.0706071920340.4205@woody.linux-foundation.org>
References: <send-serie.davidel@xmailserver.org.4625.1181169040.7>
 <20070606235906.72439d16@the-village.bc.nu>
 <alpine.LFD.0.98.0706071240150.4205@woody.linux-foundation.org>
 <20070608005931.GZ11166@waste.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 7 Jun 2007, Matt Mackall wrote:
> 
> First, how does this work in-kernel? Does it set a flag in the thread
> struct that magically gets used in the actual syscall? Or do we pass
> flags down to the sys_foo() function in some manner?

Set a flag in the thread-struct.

In fact, that's how "access()" already works.

And yes, syslets would need to have their own thread-structs and/or 
save/restore the thing.

> Second, I think we're likely to run out of flag bits really quickly as
> this is a good dumping spot for patching up our many slightly
> brain-damaged APIs (be they POSIX or Linux-specific).

Well, I do suspect that we'd need to basically make the flags be 
per-system call. With "common features" (ie a system call that doesn't 
return a file descriptor would re-use the bit for "nonlinear-fd" for 
something else, while a system call that doesn't do path lookup would use 
all the LOOKUP_xyzzy bits for something else).

I agree that if we kept flags _totally_ separate, we'd run out of them 
really quickly. But I don't think we want to ever be in the situation 
where _one_ set of system calls would need that many flags. If we get 
there, we'd really be much better off with a new system call!

> Third, can I do sys_indirect(sys_indirect(foo, args), flags1), flags2)?

I'd say no.

> Fourth, can we do sys_indirect(foo, args, flags | ASYNC) and get most
> of the way to merging this with the syslet proposal?

I think that may well be a really good idea.

		Linus
