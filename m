Return-Path: <linux-kernel-owner+w=401wt.eu-S932843AbZE0Ryh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843AbZE0Ryh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 13:54:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932374AbZE0RsL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 13:48:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:42292 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932309AbZE0RsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 13:48:09 -0400
Subject: Re: [KVM PATCH v4 3/3] kvm: add iosignalfd support
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Gregory Haskins <ghaskins@novell.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Davide Libenzi <davidel@xmailserver.org>,
       mtosatti@redhat.com
In-Reply-To: <4A1D7AFD.40004@novell.com>
References: <20090526191010.20860.75372.stgit@dev.haskins.net>
	 <20090526191539.20860.1385.stgit@dev.haskins.net>
	 <4A1D01F8.8080508@redhat.com> <4A1D285C.9050008@novell.com>
	 <4A1D2DD8.2050709@redhat.com> <1243445144.16318.15.camel@blaa>
	 <4A1D7AFD.40004@novell.com>
Content-Type: text/plain
Date: Wed, 27 May 2009 18:48:04 +0100
Message-Id: <1243446484.4852.13.camel@blaa>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-05-27 at 13:40 -0400, Gregory Haskins wrote:
> Mark McLoughlin wrote:
> > On Wed, 2009-05-27 at 15:11 +0300, Avi Kivity wrote:
> >
> >   
> >> Multiple cookies on the same address are required by virtio.  You can't 
> >> mux since the data doesn't go anywhere.
> >>
> >> Virtio can survive by checking all rings on a notify, and we can later 
> >> add a mechanism that has a distinct address for each ring, but let's see 
> >> if we can cope with multiple cookies.  Mark?
> >>     
> >
> > Trying to catch up, but you're talking about replacing virtio-pci
> > QUEUE_NOTIFY handling with iosignalfd ?
> >
> > For a perfect replacement, what you really need is to be able to
> > register multiple cookies per address range, but only have them trigger
> > if the written data matches a provided value.
> >   
> 
> Hmm..thats an interesting idea.  To date, the "cookie" has really been
> for identifying the proper range selected for deassignment.  I never
> thought of using it as an actual trigger value at run-time.
> 
> > If the data is lost, virtio has no way of knowing which queue is being
> > notified, so we either end up with per-device, rather than per-queue,
> > notifications (probably not too bad for net, at least) or a different
> > notify address per queue (limiting the number of queues per device).
> >   
> 
> The addr-per-queue is how I was envisioning it, but the trigger value
> concept hadn't occurred to me.  I could make this an option during
> assignment (e.g. "COOKIE" flag means only trigger on writes of the
> provided cookie, otherwise trigger on any write).  Sound good?

Ah, I'd been thinking of the trigger data being provided separately to
the cookie.

The virtio ABI is fixed, so we couldn't e.g. have the guest use a cookie
to identify a queue - it's just going to continue using a per-device
queue number. So, if the cookie was also the trigger, we'd need an
eventfd per device.

And if this was a device where the guest writes similar values to
multiple addresses, you'd need an eventfd per address.

Cheers,
Mark.

