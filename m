Return-Path: <linux-kernel-owner+w=401wt.eu-S1760941AbZLJPpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760941AbZLJPpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 10:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752125AbZLJPpu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 10:45:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56392 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751250AbZLJPpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 10:45:49 -0500
Date: Thu, 10 Dec 2009 07:45:14 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Alan Stern <stern@rowland.harvard.edu>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Zhang Rui <rui.zhang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: Async suspend-resume patch w/ completions (was: Re: Async
 suspend-resume patch w/ rwsems)
In-Reply-To: <Pine.LNX.4.44L0.0912101010090.2825-100000@iolanthe.rowland.org>
Message-ID: <alpine.LFD.2.00.0912100739260.3560@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912101010090.2825-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 10 Dec 2009, Alan Stern wrote:
> 
> In device_pm_remove():
> 
> 	mutex_lock(&dpm_list_mtx);
> 	if (dev == dpm_next)
> 		dpm_next = to_device(dpm_iterate_forward ?
> 			dev->power.entry.next : dev->power.entry.prev);
> 	list_del_init(&dev->power.entry);
> 	mutex_unlock(&dpm_list_mtx);

I'm really not seeing the point - it's much better to hardcode the 
ordering in the place you use it (where it is static and the compiler can 
generate bette code) than to do some dynamic choice that depends on some 
fake flag - especially a global one.

Also, quite frankly, error handling needs to be separated out of the whole 
async patch, and needs to be thought about a lot more. And I would 
seriously argue that if you have any async suspends, then those async 
suspends are _not_ allowed to fail. At least not initially 

Having async failures and trying to fix them up is just a disaster. Which 
ones actually failed, and which ones were aborted before they even really 
got to their suspend routines? Which ones do you try to resume?

IOW, it needs way more thought than what has clearly happened so far. And 
once more, I will refuse to merge anything that is complicated for no 
actual reason (where reason is "real life, and tested to make a big 
difference", not some hand-waving)

		Linus
