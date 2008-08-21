Return-Path: <linux-kernel-owner+w=401wt.eu-S1757712AbYHUUZ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712AbYHUUZ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 16:25:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753573AbYHUUZV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 16:25:21 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:41431 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbYHUUZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 16:25:20 -0400
Date: Thu, 21 Aug 2008 14:25:04 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alex Chiang <achiang@hp.com>, gregkh@suse.de, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: refcount leak in pci_get_device()?
Message-ID: <20080821202504.GU8318@parisc-linux.org>
References: <20080821201918.GA24411@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080821201918.GA24411@ldl.fc.hp.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2008 at 02:19:18PM -0600, Alex Chiang wrote:
> #define for_each_pci_dev(d) while ((d = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, d)) != NULL)
> 
> That eventually calls pci_get_dev_by_id(), which increases the
> refcount on the device, but never decrements it.
> 
> Looks like that change in behavior happened here:
> 
> 	PCI: clean up search.c a lot
> 	95247b57ed844511a212265b45cf9a919753aea1
> 
> pci_get_device() used to decrement the refcount, but no longer
> does.
> 
> Thanks to Matthew Wilcox for helping me get this far...
> 
> Like I said, I'm still trying to track down my particular issue,
> but I'd like to get your opinion on this.

In particular, I'd like to know whether this should be fixed by
pci_get_dev_by_id() decrementing the refcount of from/dev_start,
pci_get_subsys() decrementing 'from', or by bus_find_device()
decrementing 'start'.  It looks like bus_find_device() is the place
where this should logically happen, but the kerneldoc doesn't document
the intended behaviour.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
