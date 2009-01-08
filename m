Return-Path: <linux-kernel-owner+w=401wt.eu-S1761383AbZAHRF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761383AbZAHRF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 12:05:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752739AbZAHRFp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 12:05:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39156 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752003AbZAHRFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 12:05:44 -0500
Date: Thu, 8 Jan 2009 09:05:01 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Chris Mason <chris.mason@oracle.com>
cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       peterz@infradead.org, jack@suse.cz, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, npiggin@suse.de
Subject: Re: Increase dirty_ratio and dirty_background_ratio?
In-Reply-To: <1231433701.14304.24.camel@think.oraclecorp.com>
Message-ID: <alpine.LFD.2.00.0901080858500.3283@localhost.localdomain>
References: <alpine.LFD.2.00.0901070833430.3057@localhost.localdomain>  <20090107.125133.214628094.davem@davemloft.net>  <20090108030245.e7c8ceaf.akpm@linux-foundation.org>  <20090108.082413.156881254.davem@davemloft.net>  <alpine.LFD.2.00.0901080842180.3283@localhost.localdomain>
 <1231433701.14304.24.camel@think.oraclecorp.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 8 Jan 2009, Chris Mason wrote:
> 
> Does it make sense to hook into kupdate?  If kupdate finds it can't meet
> the no-data-older-than 30 seconds target, it lowers the sync/async combo
> down to some reasonable bottom.  
> 
> If it finds it is going to sleep without missing the target, raise the
> combo up to some reasonable top.

I like autotuning, so that sounds like an intriguing approach. It's worked 
for us before (ie VM).

That said, 30 seconds sounds like a _loong_ time for something like this. 
I'd use the normal 5-second dirty_writeback_interval for this: if we can't 
clean the whole queue in that normal background writeback interval, then 
we try to lower the tagets. We already have that "congestion_wait()" thing 
there, that would be a logical place, methinks.

I'm not sure how to raise them, though. We don't want to raise any limits 
just because the user suddenly went idle. I think the raising should 
happen if we hit the sync/async ratio, and we haven't lowered in the last 
30 seconds or something like that.

		Linus
