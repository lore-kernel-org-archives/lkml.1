Return-Path: <linux-kernel-owner+w=401wt.eu-S934315AbXHNSuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934315AbXHNSuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 14:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932894AbXHNSuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 14:50:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42592 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765483AbXHNSuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 14:50:18 -0400
Message-ID: <46C1F917.1070008@redhat.com>
Date: Tue, 14 Aug 2007 14:48:55 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org, paulmck@linux.vnet.ibm.com,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Chris Friesen <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH 10/23] make atomic_read() and atomic_set() behavior consistent
 on ia64
References: <46C03885.7000109@redhat.com> <20070813112334.GJ24018@shell.boston.redhat.com> <617E1C2C70743745A92448908E030B2A0229FD89@scsmsx411.amr.corp.intel.com>
In-Reply-To: <617E1C2C70743745A92448908E030B2A0229FD89@scsmsx411.amr.corp.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Luck, Tony wrote:
>> Use volatile consistently in atomic.h on ia64.
>> This will do weird things without Andreas Schwab's fix:
>> http://lkml.org/lkml/2007/8/10/410
> 
> The build is very noisy with the inline versions of atomic_{read,set}
> and their 64-bit siblings.  Here are the prime culprits (some of them
> repeat >100 times).

Part of the motivation for using inline functions was to expose places where 
we've been lazy, so this isn't unexpected.  We need to work on clearing up those 
callers.

> include/linux/skbuff.h:521: warning: passing arg 1 of `atomic_read' discards qualifiers from pointer target type
> include/net/sock.h:1244: warning: passing arg 1 of `atomic_read' discards qualifiers from pointer target type
> include/net/tcp.h:958: warning: passing arg 1 of `atomic_read' discards qualifiers from pointer target type
> mm/slub.c:3115: warning: passing arg 1 of `atomic_read' from incompatible pointer type
> mm/slub.c:3250: warning: passing arg 1 of `atomic_read' from incompatible pointer type
> mm/slub.c:3286: warning: passing arg 1 of `atomic_read' from incompatible pointer type

Do you get any warnings other than those two?

> The inline versions also result in some structural changes in
> the object file that make it difficult to compare with the
> original.  Text size is 96 bytes smaller ... but even after
> I use sed(1) to exclude the most obvious instructions that
> differ, I still find big blocks of code with changes.  Perhaps
> even more surprising there are entire functions that are
> optimized out in either the 'before' or 'after' binary.
> E.g. lookup_pi_state() was optimized away (or completely
> inlined?) before this patch, but the function appears as
> standalone in the 'after' version.  The reverse is true for
> fixup_pi_state_owner().

IIRC, when you applied a version which used macros instead, there was no change. 
  It would seem that inlining changed the optimization behavior of the compiler. 
  If you turn down the optimization level, do the macro and inline versions look 
the same, or at least more similar?

> The binary does boot ... but I haven't run any tests to see whether
> there are any problems.

The only part of the patch that I was really worried about breaking anything was 
the removal of the volatile declaration, in case there was some other access 
that needed a cast.  Since the macro version didn't change anything, that's 
covered.  Converting from a macro to an inline shouldn't really change anything 
in this case, except perhaps for how the compiler optimizes it.  If something 
*does* break, I'd suspect compiler bugs.

	-- Chris
