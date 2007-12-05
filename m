Return-Path: <linux-kernel-owner+w=401wt.eu-S1752625AbXLEBYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625AbXLEBYc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 20:24:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbXLEBYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 20:24:25 -0500
Received: from ms-smtp-01.nyroc.rr.com ([24.24.2.55]:58119 "EHLO
	ms-smtp-01.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbXLEBYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 20:24:24 -0500
Date: Tue, 4 Dec 2007 20:23:49 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       David Holmes - Sun Microsystems <David.Holmes@Sun.COM>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fix for futex_wait signal stack corruption
In-Reply-To: <alpine.LFD.0.9999.0712041436100.13796@woody.linux-foundation.org>
Message-ID: <Pine.LNX.4.58.0712042016540.18042@gandalf.stny.rr.com>
References: <1196801858.1645.37.camel@localhost.localdomain>
 <alpine.LFD.0.9999.0712041307270.32379@woody.linux-foundation.org>
 <20071204213924.GA14915@goodmis.org> <alpine.LFD.0.9999.0712041436100.13796@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 4 Dec 2007, Linus Torvalds wrote:

> On Tue, 4 Dec 2007, Steven Rostedt wrote:
> >
> > Seems that arg3 is not used here and since the timer is 64 bits, we can
> > store the bottom 32 bits in arg2 and the top in arg3 (this will work for
> > both 32 and 64 bit archs).
>
> Yes. That should work fine.

Unfortunately, looking closer at the code, arg3 _is_ used. arg3 is used to
set a flag whether or not the mmap_sem is shared.
(I blame lack of food for not noticing this in the first place).

[...]

> So far, using "unsigned long" has been good enough, in that it's big
> enough for a pointer and all normal arguments, but if something really
> deeply wants another format or a guaranteed 64-bit word regardless of
> architecture, we could make one or more of the arguments be "u64" instead.
>
> But in this case, since there is already unused argument space, I think
> that doing the "32 high bits + 32 low bits" is probably the best option.

Since arg3 is out, which do you prefer? Creating an arg4 (and perhaps
more) in the block or having a u64 arg?  Changing all the args to u64 may
be the best. This way we don't need to worry about passing 64bit
arguments, and we don't waste more space on 64 bit archs by adding more
args of unsigned long.

Thoughts?

-- Steve

