Return-Path: <linux-kernel-owner+w=401wt.eu-S1762228AbZA1U55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762228AbZA1U55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 15:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755149AbZA1Ukv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 15:40:51 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49878 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758661AbZA1Uku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 15:40:50 -0500
Message-ID: <4980C278.8030204@redhat.com>
Date: Wed, 28 Jan 2009 15:39:20 -0500
From: Chris Snook <csnook@redhat.com>
Organization: Red Hat
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Davide Libenzi <davidel@xmailserver.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: if (unlikely(...)) == unnecessary?
References: <alpine.DEB.1.10.0901272346480.20262@alien.or.mcafeemobile.com> <49809C2E.3000005@redhat.com> <alpine.DEB.1.10.0901281130020.21401@alien.or.mcafeemobile.com>
In-Reply-To: <alpine.DEB.1.10.0901281130020.21401@alien.or.mcafeemobile.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Davide Libenzi wrote:
> On Wed, 28 Jan 2009, Chris Snook wrote:
> 
>> Davide Libenzi wrote:
>>> I noticed that GCC >= 3.3 (not tried the ones before) automatically branches
>>> out the "if" code (and follow-through the "else" code, if there). Is that a
>>> coincidence or a rule we can rely on going forward?
>> That's the default behavior, but there are lots of things that can cause it to
>> behave differently.
> 
> Please don't keep me hanging. What are they (just a few of the "lots" 
> that makes GCC follow-through "if" code)?
> 
> 
> - Davide
> 
> 

When you turn on optimizations, gcc will try to avoid branching just to execute 
a few instructions, since the cache miss and page fault penalties greatly exceed 
the cost of a branch mispredict.  The thresholds and heuristics vary, but in 
general, if you stick something like this:

if (condition) foo++;
else if (complex condition) {do lots of stuff}

In the middle of a long function body and compile with optimizations enabled, 
gcc will try to put the foo++ right after the evaluation.  Some ISAs support 
conditional instructions to let the compiler help fill pipeline bubbles, and 
some superscalar processors will speculatively execute it in parallel with their 
evaluation of the second condition, and proceed with whichever execution path is 
chosen when they retire the instruction evaluating the first conditional.

-- Chris
