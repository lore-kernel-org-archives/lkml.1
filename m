Return-Path: <linux-kernel-owner+w=401wt.eu-S1754297AbYGGClx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbYGGClx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 22:41:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752489AbYGGClp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 22:41:45 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:54565 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752383AbYGGCln (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 22:41:43 -0400
Date: Sun, 6 Jul 2008 20:41:26 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: linux-pci@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com, mingo@elte.hu,
       tglx@linutronix.de, davem@davemloft.net, dan.j.williams@intel.com,
       Martine.Silbermann@hp.com, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH 1/4] PCI MSI: Store the number of messages in the msi_desc
Message-ID: <20080707024125.GU14894@parisc-linux.org>
References: <20080705132728.GO14894@parisc-linux.org> <1215264855-4372-1-git-send-email-matthew@wil.cx> <1215396324.19157.14.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215396324.19157.14.camel@localhost>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2008 at 12:05:24PM +1000, Michael Ellerman wrote:
> On Sat, 2008-07-05 at 09:34 -0400, Matthew Wilcox wrote:
> > This first part simply changes the msi_attrib data structure to store
> > how many vectors have been allocated.  In order to do this, I shrink the
> > 'type' from 5 bits to 2 and rename it to _type to catch any unsuspecting
> > users.
> 
> Please don't, it significantly uglifies the code IMHO. Just add a new
> field for the size, I'd rather call it qsize to match the register.

Uglifies the code?  Seriously?  Other than the _ addition (which really
I just did to be sure I didn't miss a case), how is MSI_ATTRIB uglier
than PCI_CAP_ID_MSI?

I'd like to rename the register definition from QSIZE.  It's _not_ a
queue.  I don't know where this misunderstanding came from, but I
certainly don't want to spread it any further.

> If you're worried about bloating msi_desc, there's several fields in
> there that are per-device not per-desc, so we could do another patch to
> move them into pci_dev or something hanging off it, eg.
> pci_dev->msi_info rather than storing them in every desc.

Might be worth it anyway for devices with lots of MSI-X interrupts.
I think the MSI-X implementation is a bit poorly written anyway.  If we
had an array of msi_desc for each device, we could avoid the list_head
in the msi_desc, for example.  That'd save two pointers (8 or 16 bytes),
plus the overhead of allocating each one individually.

I also think that MSI-X could be improved by changing the interface to
do away with this msix_entry list passed in -- just allocate the irqs
consecutively.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
