Return-Path: <linux-kernel-owner+w=401wt.eu-S1760890AbZLOS6X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760890AbZLOS6X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 13:58:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753542AbZLOS6V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 13:58:21 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33971 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752189AbZLOS6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 13:58:20 -0500
Date: Tue, 15 Dec 2009 10:57:25 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <alpine.LFD.2.00.0912150803250.14385@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0912151051580.14385@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912151047410.3566-100000@iolanthe.rowland.org> <alpine.LFD.2.00.0912150803250.14385@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 15 Dec 2009, Linus Torvalds wrote:
> 
> And even when you know it's PCI, our rules are actually not simple at all. 
> Our rules for PCI devices (and this strictly speaking is true for bridges 
> too) are rather complex:
> 
>  - do we have _any_ legacy PM support (ie the "direct" driver 
>    suspend/resume functions in the driver ops, rather than having a 
>    "struct dev_pm_ops" pointer)? If so, call "->suspend()"
> 
>  - If not - do we have that "dev_pm_ops" thing? If so, call it.
> 
>  - If not - just disable the device entirely _UNLESS_ you're a PCI bridge.
> 
> Notice? The way things are set up, if you have no suspend routine, you'll 
> not get suspended, but you will get disabled. 

Side note - what I think might be a clean solution for PCI at least is to 
do something like the following:

 - move that "disable the device entirely" thing to suspend_late, rather 
   than the earlier suspend phase. Now PCI devices without drivers or PM 
   will not be touched at all in the first suspend phase.

 - initialize all PCI devices to have 'async_suspend = 1' on discovery

 - whenever we bind a driver to the PCI device, we'd then look at whether 
   that driver implements suspend/resume callbacks (legacy or new), and 
   clear the async_suspend bit if so.

That way we'd have the same old synchronous behavior for all PCI suspend 
and resume events (unless the driver itself then sets the async_suspend 
bit at device init time, which it could do, of course), while still always 
doing async "no-op" events.

That would avoid the ugly one-liner that just "knows" that PCI bridges are 
special and don't do anything at suspend time (even though they aren't 
really - a PCI bridge _could_ have a driver associated with it that does 
something that might not be happy being asynchronous).

			Linus
