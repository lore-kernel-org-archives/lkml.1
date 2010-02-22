Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab0BVRCJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 12:02:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34694 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752297Ab0BVRCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 12:02:07 -0500
Date: Mon, 22 Feb 2010 09:01:39 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Thomas Gleixner <tglx@linutronix.de>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [GIT PULL] perf fixes
In-Reply-To: <20100222165052.GA14352@elte.hu>
Message-ID: <alpine.LFD.2.00.1002220856280.4141@localhost.localdomain>
References: <20100222165052.GA14352@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 22 Feb 2010, Ingo Molnar wrote:
> 
> The reason i'm sending them post -rc8 is the fix for the Wine breakage from 
> Frederic, which would be nice to see resolved in -final.

Umm. That commit seems to be crap.

Yes, it was wrong to not allow a NULL address breakpoint. But if you call 
kallsyms_lookup_name(), you should check the "I couldn't find it" end 
result for _that_ case, and 0 is the correct check there.

So the code _should_ do something like

	if (info->name) {
		info->address = kallsyms_lookup_name(info->name);
		if (!info->address)
			return -EINVAL;
	}

and that would correctly handle both the NULL original address _and_ the 
name lookup failure.

Also, note how I removed the totally bogus cast.

Anyway, I pulled, but I really wish somebody had thought through those 
cases. Somebody who knows the code better than I do (maybe there is an 
error check later for "if (info->name && !info->address)", but I didn't 
see one in a quick grep).

		Linus
