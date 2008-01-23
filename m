Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbYAWSto@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbYAWSto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 13:49:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbYAWSth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 13:49:37 -0500
Received: from mail.suse.de ([195.135.220.2]:36838 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbYAWStg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 13:49:36 -0500
Date: Wed, 23 Jan 2008 10:42:39 -0800
From: Greg KH <gregkh@suse.de>
To: Ian Abbott <abbotti@mev.co.uk>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz,
       pcihpd-discuss@lists.sourceforge.net, kristen.c.accardi@intel.com
Subject: Re: [RESEND][PATCH-2.6.24-rc8] Fix fakephp deadlock
Message-ID: <20080123184239.GA22852@suse.de>
References: <4795FD78.6020208@mev.co.uk> <20080123174639.GB10387@kroah.com> <4797899E.6020207@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4797899E.6020207@mev.co.uk>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2008 at 06:38:22PM +0000, Ian Abbott wrote:
> On 23/01/08 17:46, Greg KH wrote:
>> On Tue, Jan 22, 2008 at 02:28:08PM +0000, Ian Abbott wrote:
>>> #include <linux/init.h>
>>> #include <linux/string.h>
>>> #include <linux/slab.h>
>>> +#include <linux/workqueue.h>
>>> #include "../pci.h"
>>> #if !defined(MODULE)
>>> @@ -63,10 +64,13 @@ struct dummy_slot {
>>> 	struct list_head node;
>>> 	struct hotplug_slot *slot;
>>> 	struct pci_dev *dev;
>>> +	struct work_struct remove_work;
>>> +	unsigned long removed;
>> You are treating "removed" as an atomic value, so why not just make it
>> an atomic_t?
>
> Because I'm using it as a boolean?

Heh, an unsigned long as a boolean?  Come on... :)

>> And what is protecting the fact that the flag could be set right after
>> it gets checked?  I don't see a lock here :)
>
> Okay, it looks like there might be a race condition between enable_slot() 
> and disable_slot() if some other task calls disable_slot() while 
> enable_slot() is between the test_bit() and flush_workqueue() calls.  I can 
> fix that by avoiding the call to flush_workqueue() in enable_slot() and 
> allocating and queueing a work queue item to defer the call to 
> pci_rescan().  And enable_slot() won't then need to check if the slot was 
> marked as removed - it can just go ahead and allocate and queue a work 
> item.

That sounds reasonable.

thanks,

greg k-h
