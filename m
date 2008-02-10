Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbYBJTN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbYBJTN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 14:13:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbYBJTNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 14:13:20 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41003 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752575AbYBJTNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 14:13:19 -0500
Date: Sun, 10 Feb 2008 11:12:19 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Kiszka <jan.kiszka@web.de>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@zip.com.au>, Thomas Gleixner <tglx@linutronix.de>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [2/6] uaccess: add probe_kernel_write()
In-Reply-To: <47AF483E.2060202@web.de>
Message-ID: <alpine.LFD.1.00.0802101102300.2896@woody.linux-foundation.org>
References: <20080210071326.GB3851@elte.hu> <47AF483E.2060202@web.de>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 10 Feb 2008, Jan Kiszka wrote:
> 
> Along Linus' suggestion to work on larger chunks in kgdb, here are
> improved probe_kernel_read/write helpers that take a size argument.

I don't think this is good.

Make it
 - a function, not a #define
 - preferably uninlined (this does *not* look performance-critical)
 - get rid of the get_fs/set_fs/set_fs dance

The last point is somewhat debatable, but the fact is, those functions are 
not defined to be safe to be called from interrupt context. And since we 
use the "__copy_xxxx()" functions with two underscores, those really are 
supposed to mean that we've checked the address earlier.

So it's possible that some architecture does need the explicit segment 
munging (S390 comes to mind), but in that case, we really should add 
special support for that, or we should really validate that get_fs/set_fs 
are safe in all contexts.

And regardless, if we *do* end up needing to munge some segment register 
(which on other architectures tends to be an address space identifier, not 
a segment, but whatever), that just makes it even more clear that this 
isn't some macro or inline function, because those things tend to explode 
the code-space.

			Linus
