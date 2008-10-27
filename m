Return-Path: <linux-kernel-owner+w=401wt.eu-S1753038AbYJ0HWF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753038AbYJ0HWF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 03:22:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751838AbYJ0HVz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 03:21:55 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:47794 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbYJ0HVy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 03:21:54 -0400
Date: Mon, 27 Oct 2008 01:21:38 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "Zhao, Yu" <yu.zhao@intel.com>
Cc: Yu Zhao <yu.zhao@uniscape.net>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       Rakib Mullick <rakib.mullick@gmail.com>
Subject: Re: [PATCH] pci: Fixing drivers/pci/search.c compilation warning.
Message-ID: <20081027072137.GZ26094@parisc-linux.org>
References: <b9df5fa10809280816u23ef3021k7eee287a237b72ae@mail.gmail.com> <20080928163211.GR27204@parisc-linux.org> <20081021011308.GA3889@parisc-linux.org> <490467CD.3000402@uniscape.net> <20081026183412.GX26094@parisc-linux.org> <49053313.9080706@intel.com> <20081027070745.GY26094@parisc-linux.org> <49056A2F.6030206@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49056A2F.6030206@intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2008 at 03:13:51PM +0800, Zhao, Yu wrote:
> Matthew Wilcox wrote:
> >On Mon, Oct 27, 2008 at 11:18:43AM +0800, Zhao, Yu wrote:
> >>Matthew Wilcox wrote:
> >>>Yes, that's why pci_find_device() is deprecated.  But it doesn't also
> >>>need to be buggy ;-)
> >>How about pci_get_bus_and_slot()? People would meet the problem with it 
> >>anyway.
> >
> >What problem with it?  It's documented to return the device with an
> >increased refcount, and the implementation appears to do exactly that:
> >
> 
> The 'dev' returned by pci_get_device() may be destroyed by PCI hotplug. 
> I suppose that passing this 'dev' to pci_get_device() in the next loop 
> would crash the system, right?

Erm, no, the 'dev' cannot be destroyed because the caller has a refcount
on it.  The physical device backing it might have gone away.  The dev
won't be destroyed until its reference count reaches zero, which could
be any time someone calls pci_dev_put() on it.  In the scenario you're
postulating, it would happen in pci_get_dev_by_id():

        if (from)
                pci_dev_put(from);

which is the last time that 'from' is referred to in that callchain.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
