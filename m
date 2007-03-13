Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575AbXCMRxV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbXCMRxV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 13:53:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbXCMRxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 13:53:20 -0400
Received: from smtp.osdl.org ([65.172.181.24]:55817 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752575AbXCMRxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 13:53:20 -0400
Date: Tue, 13 Mar 2007 10:53:13 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Andi Kleen <ak@suse.de>, zach@vmware.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix vmi time header bug
In-Reply-To: <20070313055944.bf89eb9b.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0703131043380.9690@woody.linux-foundation.org>
References: <45F5DB00.1070506@vmware.com> <20070312223136.dc6969f3.akpm@linux-foundation.org>
 <45F648B1.5000408@vmware.com> <200703131345.06514.ak@suse.de>
 <20070313055944.bf89eb9b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Mar 2007, Andrew Morton wrote:
> 
> (The ARM thing is a pain, because the compiler cannot check that the
> definition and declaration match.  However something like sparse could do
> so).

Well, I guess sparse could do it, but the fact is, this is just a gcc bug. 
It would be much better if *gcc* just checked the function attributes it 
cared about. Anybody want to send a bug-report to the gcc lists?

Here's a trivial test-case.

	#define section(x) __attribute__((__section__(x)))

	extern int section(".text.one") test_function(int);

	int section(".text.two") test_function(int arg)
	{
		return arg+1;
	}

and the bug is that gcc doesn't warn about the section mismatch, and still 
seems to care.

(Now, if gcc doesn't care, missing the section from the declaration could 
be considered ok. But having explicit but *different* section declarations 
can clearly not be ok, and it seems that gcc sometimes *does* require 
sections to match, so it probably should always require them to match 
exactly).

We could make sparse care, but right now sparse ignores the section 
attribute *entirely*.

		Linus
