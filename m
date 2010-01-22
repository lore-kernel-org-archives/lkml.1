Return-Path: <linux-kernel-owner+w=401wt.eu-S1752640Ab0AVKnZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752640Ab0AVKnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 05:43:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654Ab0AVKnY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 05:43:24 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56008 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab0AVKnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 05:43:24 -0500
To: Don Mullis <don.mullis@gmail.com>
Cc: linux-kernel@vger.kernel.org, airlied@redhat.com, david@fromorbit.com,
       dedekind@infradead.org
Subject: Re: [PATCH 1/2] lib: more scalable list_sort()
From: Andi Kleen <andi@firstfloor.org>
References: <87fx609i29.fsf@gmail.com> <20100121175914.GA8910@basil.fritz.box>
	<87vdeu96bo.fsf@gmail.com>
Date: Fri, 22 Jan 2010 11:43:21 +0100
In-Reply-To: <87vdeu96bo.fsf@gmail.com> (Don Mullis's message of "Thu, 21 Jan 2010 19:17:15 -0800")
Message-ID: <87k4vah12u.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don Mullis <don.mullis@gmail.com> writes:
>
> Being just a dumb library routine, list_sort() has no idea what context
> it's been called in, how long a list a particular client could pass in,
> nor how expensive the client's cmp() callback might be.
>
> The cmp() callback already passes back a client-private pointer.
> Hanging off of this could be a count of calls, or timing information,
> maintained by the client.  Whenever some threshold is reached, the
> client's cmp() could do whatever good CPU-sharing citizenship required.

need_resched() does all the timing/thresholding (it checks the 
reschedule flag set by the timer interrupt). You just have to call it.
But preferable not in the inner loop, but in a outer one. It's
not hyper-expensive, but it's not free either.

The drawback is that if it's called the context always has to
allow sleeping, so it might need to be optional.

Anyways a better fix might be simply to ensure in the caller
that lists never get as long that they become a scheduling
hazard. But you indicated that ubifs would pass very long lists?
Perhaps ubifs (and other calls who might have that problem) simply
needs to be fixed.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
