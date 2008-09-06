Return-Path: <linux-kernel-owner+w=401wt.eu-S1755238AbYIFU4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238AbYIFU4P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 16:56:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbYIFUz7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 16:55:59 -0400
Received: from jade.aracnet.com ([216.99.193.136]:59526 "EHLO jade.aracnet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753090AbYIFUz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 16:55:58 -0400
Message-ID: <48C2EE46.2060509@BitWagon.com>
Date: Sat, 06 Sep 2008 13:55:34 -0700
From: John Reiser <jreiser@BitWagon.com>
Organization: -
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Jeff Dike <jdike@addtoit.com>
CC: Steve VanDeBogart <vandebo-lkml@NerdBox.Net>, jiayingz@google.com,
       linux-kernel@vger.kernel.org,
       user-mode-linux-devel@lists.sourceforge.net, dkegel@google.com
Subject: Re: [uml-devel] [PATCH 2/6] UML: Don't valgrind userspace
References: <alpine.DEB.1.00.0808281139420.15543@abydos.NerdBox.Net>	<alpine.DEB.1.00.0808291614430.15543@abydos.NerdBox.Net> <20080905163718.GA11455@c2.user-mode-linux.org>
In-Reply-To: <20080905163718.GA11455@c2.user-mode-linux.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Dike wrote:
> On Fri, Aug 29, 2008 at 04:15:24PM -0700, Steve VanDeBogart wrote:
>> Add a flag to tell Valgrind to run the forked child natively.  Necessary
>> because Valgrind makes additional system calls to instrumented processes,
>> which confuse UML.
> 
>> +#ifdef UML_CONFIG_VALGRIND_SUPPORT
>> +		flags |= VALGRIND_CLONE_LETGO;
>> +#endif
>> +	}
> 
> I keep forgetting that I have a really bad feeling about this:
> 
> +#define VALGRIND_CLONE_LETGO   0x80000000      /* do not track fork like childr
> en*/
> 
> This is effectively appropriating part of the kernel's ABI for
> valgrind's use.  

UML is part of the kernel, so getting a memory reference checker (valgrind)
running in UML is part of the kernel, too.  The concept of "escape from the
virtualizer" eventually occurs to more than just memory reference checkers.

> Not to mention that that bit is already taken:
> 
> #define CLONE_IO		0x80000000	/* Clone io context */

It wasn't taken a few months ago when the valgrind patches for UML were
first proposed.  The list of free bits in that flag word is now empty.
There may be some overlap of concept with CLONE_UNTRACED, which might
be used temporarily while figuring out an alternative.

> 
> Could you do this with an annotation that says "let the next clone run
> untraced"?

Why wouldn't that be a race between the next _NR_clone from this thread
and the next _NR_clone from any other existing thread [in the same process]?

Valgrind can pre-pend a block of code at the start of the new thread,
but almost immediately that code will want to "unvirtualize."
Doing so at _NR_clone itself is convenient all around.

-- 
John Reiser, jreiser@BitWagon.com
