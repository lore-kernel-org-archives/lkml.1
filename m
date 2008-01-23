Return-Path: <linux-kernel-owner+w=401wt.eu-S1756009AbYAWSii@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009AbYAWSii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 13:38:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751021AbYAWSia
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 13:38:30 -0500
Received: from mail.mev.co.uk ([62.49.15.74]:44162 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750919AbYAWSi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 13:38:29 -0500
Message-ID: <4797899E.6020207@mev.co.uk>
Date: Wed, 23 Jan 2008 18:38:22 +0000
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Thunderbird 2.0.0.9 (X11/20071116)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, gregkh@suse.de,
       kristen.c.accardi@intel.com
Subject: Re: [RESEND][PATCH-2.6.24-rc8] Fix fakephp deadlock
References: <4795FD78.6020208@mev.co.uk> <20080123174639.GB10387@kroah.com>
In-Reply-To: <20080123174639.GB10387@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jan 2008 18:38:22.0310 (UTC) FILETIME=[21A53060:01C85DEF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/08 17:46, Greg KH wrote:
> On Tue, Jan 22, 2008 at 02:28:08PM +0000, Ian Abbott wrote:
>> #include <linux/init.h>
>> #include <linux/string.h>
>> #include <linux/slab.h>
>> +#include <linux/workqueue.h>
>> #include "../pci.h"
>> #if !defined(MODULE)
>> @@ -63,10 +64,13 @@ struct dummy_slot {
>> 	struct list_head node;
>> 	struct hotplug_slot *slot;
>> 	struct pci_dev *dev;
>> +	struct work_struct remove_work;
>> +	unsigned long removed;
> 
> You are treating "removed" as an atomic value, so why not just make it
> an atomic_t?

Because I'm using it as a boolean?

> And what is protecting the fact that the flag could be set right after
> it gets checked?  I don't see a lock here :)

Okay, it looks like there might be a race condition between 
enable_slot() and disable_slot() if some other task calls disable_slot() 
while enable_slot() is between the test_bit() and flush_workqueue() 
calls.  I can fix that by avoiding the call to flush_workqueue() in 
enable_slot() and allocating and queueing a work queue item to defer the 
call to pci_rescan().  And enable_slot() won't then need to check if the 
slot was marked as removed - it can just go ahead and allocate and queue 
a work item.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
