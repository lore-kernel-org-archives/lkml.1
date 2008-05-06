Return-Path: <linux-kernel-owner+w=401wt.eu-S1761405AbYEFAzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761405AbYEFAzb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 20:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755542AbYEFAzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 20:55:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44018 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755475AbYEFAzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 20:55:21 -0400
Date: Mon, 5 May 2008 17:54:49 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] do_wait reorganization
In-Reply-To: <20080506003239.43FF026FA20@magilla.localdomain>
Message-ID: <alpine.LFD.1.10.0805051742370.32269@woody.linux-foundation.org>
References: <20080506003239.43FF026FA20@magilla.localdomain>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 5 May 2008, Roland McGrath wrote:
>
> This breaks out the guts of do_wait into three subfunctions.
> The control flow is less nonobvious without so much goto.

I dunno.

I absolutely detest your propensity for multiple return values. You have 
"int ret" for the return value, and then you *also* have a "int *retval" 
for the return value.

Which is what, and why?

I really don't think this helps in the "nonobvious" department. 

Yes, I can see the comments, so I know what it's supposed to be about, but 
it still disturbs me.

I'm pretty sure it should be possible to return a positive value for 
"eligible but not available" and make do with just one return value, but 
if that is just not possible or too complicated, at least don't call it 
"retval" and have totally different semantics from the return value we 
return?

So for example, maybe it could just be count of eligible children, and we 
call could it "int *eligible", and then rather than initialize to -ECHILD, 
initialize to zero, and make the logic be

	if (!eligible)
		return -ECHILD;
	.. otherwise see if we can wait, return -EINTR or whatever it we 
	can't ..

which then looks like a fairly sane thing to do in all contexts (both the 
caller and the callee).

			Linus
