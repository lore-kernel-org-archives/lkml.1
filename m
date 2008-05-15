Return-Path: <linux-kernel-owner+w=401wt.eu-S932572AbYEOPoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572AbYEOPoV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2008 11:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYEOPoJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 May 2008 11:44:09 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755310AbYEOPoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2008 11:44:07 -0400
Subject: Re: [PATCH] virtio_net: free transmit skbs in a timer
From: Mark McLoughlin <markmc@redhat.com>
Reply-To: Mark McLoughlin <markmc@redhat.com>
To: Avi Kivity <avi@qumranet.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org
In-Reply-To: <482AAA0F.2020607@qumranet.com>
References: <1209565906-9019-1-git-send-email-markmc@redhat.com>
	 <1210624663.14409.20.camel@muff> <48294776.3010504@qumranet.com>
	 <200805141607.26306.rusty@rustcorp.com.au>  <482AAA0F.2020607@qumranet.com>
Content-Type: text/plain
Date: Thu, 15 May 2008 16:29:40 +0100
Message-Id: <1210865380.16012.15.camel@muff>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-4.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-05-14 at 11:59 +0300, Avi Kivity wrote:
> Rusty Russell wrote:
> >> Sorry to barge in late, but IMO the timer should be on the host, which
> >> is cheaper than on the guest (well, a 100ms timer is likely zero cost,
> >> but  I still don't like it).
> >>
> >> the host should fire a tx completion interrupt whenever the completion
> >> queue has "enough" entries, where we can define "enough" now as the
> >> halfway mark or a timer expiry, whichever comes earlier.
> >>
> >> We can later improve "enough" to be "just enough so the timer never
> >> triggers" and adjust it dynamically.  It probably doesn't matter for
> >> Linux, but I don't want to punish guests that can do true async
> >> networking and depend on timely completion notification.
> >>     
> >
> > This implies that we should not be supressing notifications in the guest at 
> > all (unless we're sure there are more packets to come, which currently we 
> > never are: that needs new net infrastructure).
> >   
> 
> We don't have to be sure, just reasonably confident.  If we see a stream 
> of packets, we open the window, but set a timer in case we're wrong.  
> The expectation is that the timer will only fire when tx rate drops (or 
> tx stops completely).
> 
> > But that means we'd get a notification on every xmit at the moment.  
> > Benchmarks anyone?
> >   
> 
> Notification on every xmit will surely kill performance.  I'm trying to 
> get batching to work but also good latency when the link is not saturated.

I think Rusty is speaking from the POV of the guest driver - i.e. that
virtio_net should never disable notifications on the xmit queue using
disable_cb()?

Sounds like you think agree, but that the host side should throttle the
rate of xmit notifications?

Cheers,
Mark.

