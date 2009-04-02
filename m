Return-Path: <linux-kernel-owner+w=401wt.eu-S933527AbZDBJ1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933527AbZDBJ1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 05:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757293AbZDBJ1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 05:27:34 -0400
Received: from mx2.redhat.com ([66.187.237.31]:44349 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756109AbZDBJ1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 05:27:33 -0400
Message-ID: <49D484F5.2000400@redhat.com>
Date: Thu, 02 Apr 2009 12:27:17 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Herbert Xu <herbert@gondor.apana.org.au>
CC: ghaskins@novell.com, anthony@codemonkey.ws, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <20090402085253.GA29932@gondor.apana.org.au> <49D47F11.6070400@redhat.com> <20090402091639.GA30126@gondor.apana.org.au>
In-Reply-To: <20090402091639.GA30126@gondor.apana.org.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Herbert Xu wrote:
> On Thu, Apr 02, 2009 at 12:02:09PM +0300, Avi Kivity wrote:
>   
>> There is no choice.  Exiting from the guest to the kernel to userspace  
>> is prohibitively expensive, you can't do that on every packet.
>>     
>
> I was referring to the bit between the kernel and userspace.
>
> In any case, I just looked at the virtio mitigation code again
> and I am completely baffled at why we need it.  Look at Greg's
> code or the netback/netfront notification, why do we need this
> completely artificial mitigation when the ring itself provides
> a natural way of stemming the flow?
>   

If the vcpu thread does the transmit, then it will always complete 
sending immediately:

  guest: push packet, notify qemu
  qemu: disable notification
  qemu: pop packet
  qemu: copy to tap
  qemu: ??

At this point, qemu must enable notification again, since we have no 
notification from tap that the transmit completed.  The only alternative 
is the timer.

If we do the transmit through an extra thread, then scheduling latency 
buys us some time:

  guest: push packet, notify qemu
  qemu: disable notification
  qemu: schedule iothread
  iothread: pop packet
  iothread: copy to tap
  iothread: check for more packets
  iothread: enable notification

If tap told us when the packets were actually transmitted, life would be 
wonderful:

  guest: push packet, notify qemu
  qemu: disable notification
  qemu: pop packet
  qemu: queue on tap
  qemu: return to guest
  hardware: churn churn churn
  tap: packet is out
  iothread: check for more packets
  iothread: enable notification

-- 
error compiling committee.c: too many arguments to function

