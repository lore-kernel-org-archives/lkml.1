Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbYKMQXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbYKMQXT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 11:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751358AbYKMQXH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 11:23:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751351AbYKMQXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 11:23:04 -0500
Date: Thu, 13 Nov 2008 08:22:47 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Helge Deller <deller@gmx.de>
cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, vda.linux@googlemail.com,
       hugh@veritas.com, jer@gentoo.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Who broke cb8f488c33 patch? (was Re: [PATCH 1/1] USBHID: correct
 start/stop cycle)
In-Reply-To: <491C488E.8030609@gmx.de>
Message-ID: <alpine.LFD.2.00.0811130809570.3468@nehalem.linux-foundation.org>
References: <1225579306-28524-1-git-send-email-jirislaby@gmail.com> <200811022024.31528.vda.linux@googlemail.com> <alpine.LNX.1.10.0811120021500.24889@jikos.suse.cz> <200811120124.41222.vda.linux@googlemail.com> <alpine.LNX.1.10.0811120126320.24889@jikos.suse.cz>
 <20081111165038.fb1f2f45.akpm@linux-foundation.org> <491AA08D.9080401@gmail.com> <491C488E.8030609@gmx.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 Nov 2008, Helge Deller wrote:
> 
> I bisected twice. Both times I found this one to be the culprit.
> Nevertheless, just reverting this (Thanks Denys!) didn't fixed the USB
> problem.

The trivial bisecting approach doesn't work if there are two independent 
bugs that have overlapping lifetimes. In fact, bisection doesn't 
necessarily work even if the lifetimes of the bugs are clearly disjoint, 
because then if you look for bug A, but mark something "bad" because of 
bug B, it can easily end up zeroing in on the wrong cause.

So "git bisect" is an absolutely wonderful tool, but it does require you 
to be able to be sure about _which_ exact bug you chase down to give 
reliable answers.

In the presense of multiple bugs, you have two choices:

 (a) either you have to know how to distinguish them reliably in order to 
     give a clean good/bad for the particular bug you are chasing.

     This can be impossible: one bug may make it impossible to even _test_ 
     for the other bug, eg a bug that prevents bootup will obviously make 
     it impossible to see whether an independent run-time bug exists or 
     not. In this case, you have to do (b)

 (b) Find _one_ bug first (doesn't matter which), and fix it. And then, do 
     a second bisection run, but before each test, you may need to apply 
     the fix for the first bug, so that you know that's not the an issue.

     This can be automated (check if the broken commit is in the current 
     tree to be tested, apply a patch to fix it if it is), but it's not as 
     simple as just saying "let's bisect".

So bisection with multiple bugs is certainly possible, but it's also 
unquestionably a lot more work, and more complicated.

			Linus
