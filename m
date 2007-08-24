Return-Path: <linux-kernel-owner+w=401wt.eu-S1760596AbXHXHFM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760596AbXHXHFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 03:05:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751331AbXHXHE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 03:04:59 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:56383 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751217AbXHXHE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 03:04:58 -0400
Message-ID: <46CE81DC.90103@vmware.com>
Date: Thu, 23 Aug 2007 23:59:40 -0700
From: Zachary Amsden <zach@vmware.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Linus Torvalds <torvalds@osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Chris Wright <chrisw@sous-sol.org>,
       stable@kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] Fix preemptible lazy mode bug
References: <46CE70C8.2030005@vmware.com> <46CE8069.9070404@goop.org>
In-Reply-To: <46CE8069.9070404@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Hm.  Doing any kind of lazy-state operation with preemption enabled is
> fundamentally meaningless.  How does it get into a preemptable state
>   

Agree 100%.  It is the lazy mode flush that might happen when preempt is 
enabled, but lazy mode is disabled.  In that case, the code relies on 
per-cpu variables, which is a bad thing to do in preemtible code.  This 
can happen in the current code path.

Thinking slightly deeper about it, it might be the case that there is no 
bug, because the local lazy mode variables are only _modified_ in the 
preemptible state, and guaranteed to be zero in the non-preemtible 
state; but it was not clear to me that this is always the case, and I 
got very nervous about reading per-cpu variables with preempt enabled.  
It would, in any case, fire a BUG_ON in the Xen code, which I did fix.

Do you agree it is better to be safe than sorry in this case?  The kind 
of bugs introduced by getting this wrong are really hard to find, and I 
would rather err on the side of an extra increment and decrement of 
preempt_count that causing a regression.

Zach
