Return-Path: <linux-kernel-owner+w=401wt.eu-S1755186AbXLDWom@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755186AbXLDWom (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 17:44:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751829AbXLDWoe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 17:44:34 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57612 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750969AbXLDWod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 17:44:33 -0500
Date: Tue, 4 Dec 2007 14:43:29 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       David Holmes - Sun Microsystems <David.Holmes@Sun.COM>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix for futex_wait signal stack corruption
In-Reply-To: <20071204213924.GA14915@goodmis.org>
Message-ID: <alpine.LFD.0.9999.0712041436100.13796@woody.linux-foundation.org>
References: <1196801858.1645.37.camel@localhost.localdomain> <alpine.LFD.0.9999.0712041307270.32379@woody.linux-foundation.org> <20071204213924.GA14915@goodmis.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 4 Dec 2007, Steven Rostedt wrote:
> 
> Seems that arg3 is not used here and since the timer is 64 bits, we can
> store the bottom 32 bits in arg2 and the top in arg3 (this will work for
> both 32 and 64 bit archs).

Yes. That should work fine.

The restart logic sometimes results in odd calling conventions, and quite 
frankly, we could just change how "restart_block" looks too. There is 
nothing that says that it has to be

	unsigned long arg0, arg1, arg2, arg3

and that particular layout was just picked on a whim. The only issue is:

 - we don't want the restart block to be *too* large, since it's part of 
   the thread info.
 - but we need to have enough room for all the system calls that want to 
   use the restart block, and preferably in a reasonable format.

So far, using "unsigned long" has been good enough, in that it's big 
enough for a pointer and all normal arguments, but if something really 
deeply wants another format or a guaranteed 64-bit word regardless of 
architecture, we could make one or more of the arguments be "u64" instead.

But in this case, since there is already unused argument space, I think 
that doing the "32 high bits + 32 low bits" is probably the best option.

			Linus
