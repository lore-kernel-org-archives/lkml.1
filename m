Return-Path: <linux-kernel-owner+w=401wt.eu-S1755083AbYKGSri@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083AbYKGSri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2008 13:47:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbYKGSr2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Nov 2008 13:47:28 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46757 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751758AbYKGSr1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2008 13:47:27 -0500
Date: Fri, 7 Nov 2008 10:45:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mathieu.desnoyers@polymtl.ca, dhowells@redhat.com, nico@cam.org,
       mingo@elte.hu, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       ralf@linux-mips.org, benh@kernel.crashing.org, paulus@samba.org,
       davem@davemloft.net, mingo@redhat.com, tglx@linutronix.de,
       rostedt@goodmis.org, linux-arch@vger.kernel.org,
       Dave Young <hidave.darkstar@gmail.com>
Subject: Re: [RFC patch 08/18] cnt32_to_63 should use smp_rmb()
Message-Id: <20081107104519.2caa959f.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.0811071034520.3468@nehalem.linux-foundation.org>
References: <20081107003816.9b0f947a.akpm@linux-foundation.org>
	<20081107052336.652868737@polymtl.ca>
	<20081107053349.861709786@polymtl.ca>
	<20081106220530.5b0e3a96.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0811070256450.13034@xanadu.home>
	<25363.1226056819@redhat.com>
	<alpine.LFD.2.00.0811070952150.13034@xanadu.home>
	<8189.1226074915@redhat.com>
	<8509.1226077800@redhat.com>
	<20081107092643.0bd9bb4e.akpm@linux-foundation.org>
	<20081107180041.GG22134@Krystal>
	<20081107102148.6eb53dea.akpm@linux-foundation.org>
	<alpine.LFD.2.00.0811071034520.3468@nehalem.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 Nov 2008 10:36:27 -0800 (PST)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Fri, 7 Nov 2008, Andrew Morton wrote:
> > 
> > Referring to include/linux/tracepoint.h:DEFINE_TRACE()?
> > 
> > It does look a bit fragile.  Does every .c file which included
> > include/trace/block.h get a copy of __tracepoint_block_rq_issue,
> > whether or not it used that tracepoint? Hopefully not.
> 
> Look at "ratelimit()" too. Broken, broken.

Yup.  Easy enough to fix, but...

>  Of course, I don't think it's 
> actually _used_ anywhere, so..
> 

removing it altogether would be best, I think.  It's a bit of an odd
thing.

I'll see what this

--- a/include/linux/ratelimit.h~a
+++ a/include/linux/ratelimit.h
@@ -17,11 +17,4 @@ struct ratelimit_state {
 		struct ratelimit_state name = {interval, burst,}
 
 extern int __ratelimit(struct ratelimit_state *rs);
-
-static inline int ratelimit(void)
-{
-	static DEFINE_RATELIMIT_STATE(rs, DEFAULT_RATELIMIT_INTERVAL,
-					DEFAULT_RATELIMIT_BURST);
-	return __ratelimit(&rs);
-}
 #endif

breaks.
