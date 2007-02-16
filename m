Return-Path: <linux-kernel-owner+w=401wt.eu-S1751899AbXBPK1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751899AbXBPK1d (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 05:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751901AbXBPK1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 05:27:33 -0500
Received: from 207.47.60.150.static.nextweb.net ([207.47.60.150]:17935 "EHLO
	webmail.xensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbXBPK1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 05:27:33 -0500
X-Greylist: delayed 642 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Feb 2007 05:27:32 EST
User-Agent: Microsoft-Entourage/11.2.5.060620
Date: Fri, 16 Feb 2007 10:09:47 +0000
Subject: Re: [patch 14/21] Xen-paravirt: Add XEN config options and
 disable unsupported config options.
From: Keir Fraser <keir@xensource.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>
CC: Dan Hecht <dhecht@vmware.com>, Andi Kleen <ak@muc.de>,
       Chris Wright <chrisw@sous-sol.org>, <virtualization@lists.osdl.org>,
       <xen-devel@lists.xensource.com>, Ian Pratt <ian.pratt@xensource.com>,
       <linux-kernel@vger.kernel.org>, Steven Hand <steven.hand@cl.cam.ac.uk>
Message-ID: <C1FB336B.98D6%keir@xensource.com>
Thread-Topic: [patch 14/21] Xen-paravirt: Add XEN config options and
 disable unsupported config options.
Thread-Index: AcdRspY91NOrjr2lEduvqQAX8io7RQ==
In-Reply-To: <45D55C4D.1060807@goop.org>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/2/07 07:25, "Jeremy Fitzhardinge" <jeremy@goop.org> wrote:

>> Oh, so that's why it doesn't break when CONFIG_PREEMPT=y.  In which case
>> that preempt_disable() I spotted is wrong-and-unneeded.
>> 
>> Why doesn't Xen work with preemption??
> 
> I've forgotten the details.  Ian?  Keir?  Steven?  Maybe it can be done.

It breaks guest save/restore for us currently because threads can be
sleeping with machine addresses in local storage (registers, stack). There
are a few ways to achieve an acceptable solution:

 1. Put processes in the freezer when we suspend. This should avoid any
thread being in a critical section with machine addresses in its hand. We
haven't yet investigated the performance impact of freezing processes,
particularly on the downtime of live relocation.

 2. Allow CONFIG_PREEMPT to be compiled in, but disable it at runtime. We
could do this by, for example, reserving a bit in preempt_count() so that
most preemption checks do not touch any more cache lines. I guess it would
need a bit of fixing up (e.g., so that in_atomic() would not be always
asserted). Even better for us would be to allow switching between
involuntary and voluntary preemption at runtime. It looks as though the hook
points for these two techniques are not usually compiled in at the same
time, however.

 -- Keir

