Return-Path: <linux-kernel-owner+w=401wt.eu-S1757368AbXJCPL4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbXJCPL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 11:11:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbXJCPLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 11:11:48 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39966 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753784AbXJCPLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 11:11:47 -0400
Date: Wed, 3 Oct 2007 08:11:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Alexander Viro <viro@ftp.linux.org.uk>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [bug] crash when reading /proc/mounts (was: Re: Linux 2.6.23-rc9
 and a heads-up for the 2.6.24 series..)
In-Reply-To: <20071003084607.GC32218@elte.hu>
Message-ID: <alpine.LFD.0.999.0710030804310.3579@woody.linux-foundation.org>
References: <alpine.LFD.0.999.0710012029400.3579@woody.linux-foundation.org>
 <20071003084607.GC32218@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Oct 2007, Ingo Molnar wrote:
> 
> hm, i just triggered the procfs crash below with -rc9 on a testbox. 

You have a terminally buggy piece of shit compiler.

Lookie here:

 - the bug happens on this:

	char c = *p++;

 - which has been compiled into

	8b 3a		mov    (%edx),%edi

   which is a *word* access.

 - the pointer is at the end of a page (very much on purpose):

	edx: f2a3fffe	

 - and as a result you get an exception on the *next* page:

	BUG: unable to handle kernel paging request at virtual address f2a40000

and btw, there is no question what-so-ever about whether your compiler 
might be doing a legal optimization - the compiler really is wrong, and is 
total shit. You need to make a gcc bug-report. Because this is not a 
question of "the standard is ambiguous", this is a question of "the 
compiler turned good code into code that could SIGSEGV in user space too, 
if 'malloc()' happened to return a pointer at the end of an allocation".

			Linus
