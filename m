Return-Path: <linux-kernel-owner+w=401wt.eu-S1765108AbZEAXOK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765108AbZEAXOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 May 2009 19:14:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbZEAXNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 May 2009 19:13:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50670 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752498AbZEAXNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 May 2009 19:13:53 -0400
Date: Fri, 1 May 2009 16:09:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pavel@ucw.cz, torvalds@linux-foundation.org, jens.axboe@oracle.com,
       alan-jenkins@tuffmail.co.uk, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 1/3] PM: Disable OOM killer during system-wide power
 transitions
Message-Id: <20090501160931.1dbd2abc.akpm@linux-foundation.org>
In-Reply-To: <200905020027.31244.rjw@sisk.pl>
References: <nY3-4PrO6XH.A.xtB.yw85JB@chimera>
	<20090422131943.69288af3.akpm@linux-foundation.org>
	<200905020026.19027.rjw@sisk.pl>
	<200905020027.31244.rjw@sisk.pl>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 May 2009 00:27:30 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The OOM killer is not particularly useful during system-wide power
> transitions, so do not use it if such a transition is in progress.
> 

so...  I think what you've done here is to arrange for the page
allocator to return NULL if we're hibernating rather than oom-killing,
yes?

Does the same apply to suspending?  If so, why?

I think this is an OK change, as long as the only thing which is
allocating memory is hibernation itself.  If random processes are still
doing random memory allocations at this time then their failed memory
allocation could be just as fatal as an oom-killing.  Moreso if they're
s/bin/init or whatever.

So is it the case that pm_transition_in_progress() is only true during
the highly-constrained hibernation process?  After everything is frozen?

If so, there are alternatives - the calling process could set
PF_DONT_KILL_ANYONE_FOR_ME, or could pass __GFP_DONT_KILL_ANYONE_FOR_ME. 
Those might be worse alternatives, dunno - I'm just asking probing
questions ;)

