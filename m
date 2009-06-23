Return-Path: <linux-kernel-owner+w=401wt.eu-S1761307AbZFWPdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761307AbZFWPdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:33:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760881AbZFWPcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:32:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48117 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760888AbZFWPcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:32:13 -0400
Date: Tue, 23 Jun 2009 18:31:44 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: avi@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       mtosatti@redhat.com, paulmck@linux.vnet.ibm.com, markmc@redhat.com
Subject: Re: [PATCH] kvm: remove in_range from kvm_io_device
Message-ID: <20090623153144.GA21423@redhat.com>
References: <20090623150008.GA21059@redhat.com> <4A40F311.80105@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A40F311.80105@novell.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 11:21:53AM -0400, Gregory Haskins wrote:
> Michael S. Tsirkin wrote:
> > Remove in_range from kvm_io_device and ask read/write callbacks, if
> > supplied, to perform range checks internally. This allows aliasing
> > (mostly for in-kernel virtio), as well as better error handling by
> > making it possible to pass errors up to userspace. And it's enough to
> > look at the diffstat to see that it's a better API anyway.
> >
> > While we are at it, document locking rules for kvm_io_device.
> >   
> 
> Sorry, not trying to be a PITA, but I liked your last suggestion better.  :(
> 
> I am thinking forward to when we want to use something smarter than a
> linear search (like rbtree/radix) for scaling the number of "devices"
> (really, virtio-rings) that we support.

in_range is broken for this anyway: you need more than a boolean
predicate to implement rbtree/radix

> The current device-count
> target is 512, which we will begin to rapidly consume as the in-kernel
> virtio work progresses.

That's a large number. I had in mind more like 4 virtio devices, for
starters: 1 for each virtqueue in net and block.

>  This proposed approach forces us into a
> potential O(256) algorithm in the hotpath (all MMIO/PIO exits will hit
> this, not just in-kernel users).  How would you address this?

Two ideas that come to mind:
- add addr/len fields to devices, use these to speed up lookup
- add a small cache that can be scanned first

In both cases, you first do a fast lookup, ask the device whether
it wants the transaction, then resort to linear scan if not

-- 
MST
