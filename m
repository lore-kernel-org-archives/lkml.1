Return-Path: <linux-kernel-owner+w=401wt.eu-S1762824AbZE1JJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762824AbZE1JJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 05:09:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759468AbZE1JJj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 05:09:39 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46976 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759079AbZE1JJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 05:09:37 -0400
Subject: Re: [KVM PATCH v4 3/3] kvm: add iosignalfd support
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: Gregory Haskins <ghaskins@novell.com>, Avi Kivity <avi@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>, mtosatti@redhat.com
In-Reply-To: <4A1DA653.4050109@gmail.com>
References: <20090526191010.20860.75372.stgit@dev.haskins.net>
	 <20090526191539.20860.1385.stgit@dev.haskins.net>
	 <4A1D01F8.8080508@redhat.com> <4A1D285C.9050008@novell.com>
	 <4A1D2DD8.2050709@redhat.com> <1243445144.16318.15.camel@blaa>
	 <4A1D7AFD.40004@novell.com> <1243446484.4852.13.camel@blaa>
	 <4A1DA653.4050109@gmail.com>
Content-Type: text/plain
Date: Thu, 28 May 2009 10:09:30 +0100
Message-Id: <1243501772.4046.36.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 16:45 -0400, Gregory Haskins wrote:
> Mark McLoughlin wrote:
> > The virtio ABI is fixed, so we couldn't e.g. have the guest use a cookie
> > to identify a queue - it's just going to continue using a per-device
> > queue number. 
> 
> Actually, I was originally thinking this would be exposed as a virtio
> FEATURE bit anyway, so there were no backwards-compat constraints.  That
> said, we can possibly make it work in a backwards compat way, too. 
> IIRC, today virtio does a PIO cycle to a specific register with the
> queue-id when it wants to signal guest->host, right?  What is the width
> of the write?

It's a 16-bit write.

/* A 16-bit r/w queue notifier */
#define VIRTIO_PCI_QUEUE_NOTIFY         16

> > So, if the cookie was also the trigger, we'd need an
> > eventfd per device.
> >   
> 
> I'm having trouble parsing this one.  The cookie namespace is controlled
> by the userspace component that owns the corresponding IO address, so
> there's no reason you can't make "queue-id = 0" use cookie = 0, or
> whatever.  That said, I still think a separation of the cookie and
> trigger as suggested above is a good idea, so its probably moot to
> discuss this point further.

Ah, my mistake - I thought the cookie was returned to userspace when the
eventfd was signalled, but no ... userspace only gets an event counter
value and the cookie is used during de-assignment to distinguish between
iosignalfds.

Okay, so suppose you do assign multiple times at a given address -
you're presumably going to use a different eventfd for each assignment?
If so, can't we match using both the address and eventfd at
de-assignment and drop the cookie from the interface altogether?

i.e. to replace the virtio queue notify with this, we'd:

  1) create an eventfd per queue

  2) assign each of those eventfds to the QUEUE_NOTIFY address

  3) have only one of the eventfds be triggered, depending on what 
     value is written by the guest

  4) de-assign using the address/eventfd pair to distinguish between 
     assignments

Cheers,
Mark.

