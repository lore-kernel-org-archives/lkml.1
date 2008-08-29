Return-Path: <linux-kernel-owner+w=401wt.eu-S1757558AbYH2QU6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757558AbYH2QU6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2008 12:20:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbYH2QUu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Aug 2008 12:20:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753520AbYH2QUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2008 12:20:50 -0400
Date: Fri, 29 Aug 2008 09:20:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH 4/5] select: make select() use schedule_hrtimeout()
In-Reply-To: <20080829080809.0e42a323@infradead.org>
Message-ID: <alpine.LFD.1.10.0808290915560.3300@nehalem.linux-foundation.org>
References: <20080829080549.6906b744@infradead.org> <20080829080809.0e42a323@infradead.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 29 Aug 2008, Arjan van de Ven wrote:
> 
> now that we have schedule_hrtimeout(), make select() use it.
> But only for short delays; really long delays are assumed to not
> need the highres level of accuracy but rather want the regular
> timer behavior for now.

This is _really_ ugly.

Can't you just do this relaxation in "schedule_hrtimeout()" instead, and 
just document the fact that the "high resolution" of hrtimeout is relative 
to the length of the timeout.

It's not that select() doesn't care, it's that *NOBODY* cares. If somebody 
asks for a timeout of one second and 2 microseconds, the two microseconds 
simply don't matter. Ever. But if somebody asks for a timeout of 12 
microseconds, individual microseconds probably _do_ matter.

So if you want high-resolution select/poll, then get rid of the "use_hr" 
logic entirely, and just do it unconditionally. Then, relax the scheduler 
timeouts in the scheduler.

(But, that's probably _generally_ true. Even now, when people do 
"schedule_timeout()", there's a big difference between asking for two 
ticks and asking for two seconds. The latter should probably try to round 
to a nice timer tick basis for power reasons).

		Linus
