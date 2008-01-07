Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbYAGG6x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbYAGG6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 01:58:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752940AbYAGG6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 01:58:46 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:49719 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042AbYAGG6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 01:58:45 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: regression: sysctl_check changes in 2.6.24 are O(n) resulting in slow creation of 10000 network interfaces
References: <20080106220307.GU28570@kvack.org>
Date: Sun, 06 Jan 2008 23:57:57 -0700
In-Reply-To: <20080106220307.GU28570@kvack.org> (Benjamin LaHaise's message of
	"Sun, 6 Jan 2008 17:03:07 -0500")
Message-ID: <m1ir26ktqi.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Benjamin LaHaise <bcrl@kvack.org> writes:

> Hello folks,
>
> 2.6.24-rc6 regresses on the 10000 network interface creation test relative to 
> 2.6.23.  The cause appears to be the new code in sysctl_check_lookup(), which 
> shows up as the #1 item while profiling.  Is a revert of this new code 
> possible until its scaling issues are fixed?  2.6.23 can do more than 100 new 
> network interfaces per second for the first few thousand devices, but with 
> 2.6.24-rc6 the results drop off rather dramatically to less than 10 interfaces
> per second.  The 10000 interface test is unbearable with the new sysctl_check 
> code.

Why do we need 10000 interfaces?  Why isn't network device creation a
slow path?

The problem seems to be in the data structures used by sysctl.
You are increasing the length of the linked list each time you
add a network interface.  So sysctl lookups slow down.
At 10000 entries that is a long linked list walk.

At 100000 things get even longer.  Now the numbers you report still
seem like a lot of time to me.  My guess would be that we are getting
badly into cache miss territory.

If what you describe is a real scenario where users care we need
to fix the sysctl data structures so that they scale.

Because of this bug report and another one I got earlier today
about a real bug in the parallel port code detected by the very
lookup that is slowing you down.  I am quite reluctant to contemplate
pulling this code.  It seems to be doing it's job, if in some cases
uncomfortably so.

So is this a bug report telling me that there are users with
10k or 100k interfaces that care.  So we need to fix sysctl.

Is there a specific kernel test case that is run often that having
slow sysctl performance matters for?  CONFIG_SYSCTL=n should solve
that if it is specialized.

Eric
