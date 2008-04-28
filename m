Return-Path: <linux-kernel-owner+w=401wt.eu-S965998AbYD1W0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965998AbYD1W0z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 18:26:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933799AbYD1W0l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 18:26:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47915 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933495AbYD1W0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 18:26:40 -0400
Message-ID: <48164EE6.8010506@zytor.com>
Date: Mon, 28 Apr 2008 15:25:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/2] Immediate Values - jump patching update
References: <20080428033415.303000651@polymtl.ca> <481607AF.80803@zytor.com> <20080428202552.GG15840@elte.hu> <48163B84.90605@zytor.com> <20080428221122.GC16153@elte.hu>
In-Reply-To: <20080428221122.GC16153@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
>   [ .... fastpath head ....       ]
>   [ immediate value instruction   ]  --->
>   [ branch instruction            ]  ---> these two get NOP-ed out
>   [ .... fastpath tail ....       ]
>   [ ............................. ]
>   [ ... offline area ............ ]
>   [ ... parameter preparation ... ]
>   [ ... marker call ............. ]
> 
> your proposed 5-byte call NOP approach (which btw. was what i proposed 
> multiple times in the past 2 years) would do this:
> 
>   [ .... fastpath head ......     ]
>   [ ... parameter preparation ... ]
>   [ ....   5-byte CALL .......... ]  ---> NOP-ed out
>   [ .... fastpath tail .......... ]
>   [ ............................. ]
> 
> in the first case we have little "marker parameter/value preparation" 
> cost: it all happens in the 'offline area' _by GCC_. I.e. the fastpath 
> is relatively undisturbed.

No, that's not what I'm proposing at all (and would indeed be bogus.)

What I'm proposing is:

 >   [ .... fastpath head ......     ]
 >   [ ....   5-byte CALL .......... ]  ---> NOP-ed out
 >   [ .... fastpath tail .......... ]
 >   [ ............................. ]

The call site is created with an asm() statement as opposed to a gcc 
function call; it is up to the logging function to take the state and 
mangle it into whatever format it wants to; the debugging information 
(e.g. DWARF) should tell it all it needs to know about how the 
register/memory state maps onto the C state.  This mapping can either be 
done online, with a small piece of dynamic code, or offline (although 
offline makes it tricky to know what memory tems to gather.)

For pieces of data which would be dead at the call site, one can add "g" 
annotations to the asm() statement to force it to be live without 
forcing it to be present in any particular location.

	-hpa
