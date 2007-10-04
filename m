Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbXJDM5W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbXJDM5W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 08:57:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbXJDM5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 08:57:13 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:60440 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753075AbXJDM5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 08:57:11 -0400
To: yoshfuji@linux-ipv6.org, a.p.zijlstra@chello.nl
Cc: kaigai@kaigai.gr.jp, jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, chrisw@sous-sol.org
Subject: Re: [TOMOYO 05/15](repost) Domain transition handler functions.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200710032259.HJF90663.OFMLOJtQHOFVSF@I-love.SAKURA.ne.jp>
	<1191420442.5599.12.camel@lappy>
	<200710032326.FJF32915.OQOOHLMtFSFJFV@I-love.SAKURA.ne.jp>
	<20071003.233249.126777093.yoshfuji@linux-ipv6.org>
	<200710032356.JIH05236.JQSMOOHFLVFFOt@I-love.SAKURA.ne.jp>
In-Reply-To: <200710032356.JIH05236.JQSMOOHFLVFFOt@I-love.SAKURA.ne.jp>
Message-Id: <200710042157.JJD13084.FJHtFQFOOOMSLV@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Thu, 4 Oct 2007 21:57:06 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


About use of singly-linked list:

What my SLL (singly-linked list) holds is bit different from other lists.

Almost all lists hold list of elements (e.g. buffer) that are used *temporarily*.
Thus, adding to the list and removing from the list are essential.

My SLL holds ACL (access control list) entries that are used *permanently*
(i.e. throughout the kernel's lifetime).
These ACL entries are policy used for MAC (mandatory access control).
You don't change MAC's policy without clear reason, do you?
Therefore, ACL entries of MAC's policy seldom need to be removed.

So I wonder
"Remodeling the mechanism of holding ACL entries to support removal of individual entry
 worth the cost of reference-counter manipulation and the risk of dead-pointers?"

Your next question would be
"Why are you using SLL for holding elements that are used *permanently*?"
"Why not allocate a large memory block and hold all elements in that block?"
Yes, you are right. But I can't do so.
The reason is explained in "policy file handling" at http://lkml.org/lkml/2007/10/2/56 .



About use of list that can't remove elements:

I think that many of you are misunderstanding about
"When entries are automatically appended to a list".

If you run the system in "learning mode" *forever*,
it will consume all memory; so DoS attacks are possible.

But please be aware that entries are automatically appended
only while you are running the system in "learning mode".
Also, there is a safeguard mechanism that controls upper limit.
These lists consume less than some hundreds KB
for embedded systems and/or targeted protection of PC systems,
less than 1 MB for complete protection of PC systems.
You can see how much memory is used for holding ACL entries
via /sys/kernel/security/tomoyo/meminfo interface
and you will find that these lists won't consume all memory in your system.

When you are running the system in "enforcing mode",
no entries are appended automatically; so DoS attacks are impossible.

