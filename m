Return-Path: <linux-kernel-owner+w=401wt.eu-S1756914AbZEVLga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914AbZEVLga (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 07:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752222AbZEVLgW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 07:36:22 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47192 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbZEVLgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 07:36:21 -0400
Date: Fri, 22 May 2009 05:36:22 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Alex Chiang <achiang@hp.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, bjorn.helgaas@hp.com,
       kaneshige.kenji@jp.fujitsu.com, linux-pci <linux-pci@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI Hotplug: acpiphp: don't store a pci_dev in
	acpiphp_func
Message-ID: <20090522113622.GA14692@parisc-linux.org>
References: <20090521222115.GC8792@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090521222115.GC8792@ldl.fc.hp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 21, 2009 at 04:21:15PM -0600, Alex Chiang wrote:
> In other words, if acpiphp has claimed a PCI device, and that
> device is logically removed, then acpiphp may oops when it
> attempts to access it again.
> 
> 	# echo 1 > /sys/bus/pci/devices/$device/remove
> 	# echo 0 > /sys/bus/pci/slots/$slot/power
> 
> The root cause of this oops is that the logical remove ("echo 1 >
> /sys/bus/pci/devices/$device/remove") destroyed the pci_dev. The
> pci_dev struct itself wasn't deallocated because acpiphp kept a
> reference, but some of its fields became invalid.
> 
> acpiphp doesn't have any real reason to keep a pointer to a
> pci_dev around. It can always derive it using pci_get_slot().
> 
> If a logical remove destroys the pci_dev, acpiphp won't find it
> and is thus prevented from causing mischief.
> 
> Reported-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
> Acked-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
> Signed-off-by: Alex Chiang <achiang@hp.com>

I think this is the right approach.  The more minimal way to fix this
would be to check that the pdev was valid before destroying it ... but
I approve of deleting more code from acpiphp ;-)  You do end up doing
slightly more work in the remove case, but this is such an infrequent
operation that it really doesn't matter.

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
