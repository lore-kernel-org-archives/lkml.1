Return-Path: <linux-kernel-owner+w=401wt.eu-S1761653AbZDCLBl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761653AbZDCLBl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Apr 2009 07:01:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761882AbZDCLBT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Apr 2009 07:01:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33126 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762828AbZDCLBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Apr 2009 07:01:17 -0400
Message-ID: <49D5EBE1.8030200@redhat.com>
Date: Fri, 03 Apr 2009 12:58:41 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Herbert Xu <herbert@gondor.apana.org.au>, ghaskins@novell.com,
       anthony@codemonkey.ws, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, agraf@suse.de, pmullaney@novell.com,
       pmorreale@novell.com, rusty@rustcorp.com.au, netdev@vger.kernel.org,
       kvm@vger.kernel.org
Subject: Re: [RFC PATCH 00/17] virtual-bus
References: <20090402085253.GA29932@gondor.apana.org.au> <49D47F11.6070400@redhat.com>
In-Reply-To: <49D47F11.6070400@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> There is no choice.  Exiting from the guest to the kernel to userspace
> is prohibitively expensive, you can't do that on every packet.

I didn't look at virtio-net very closely yet.  I wonder why the
notification is that a big issue though.  It is easy to keep the number
of notifications low without increasing latency:

Check shared ring status when stuffing a request.  If there are requests
not (yet) consumed by the other end there is no need to send a
notification.  That scheme can even span multiple rings (nics with rx
and tx for example).

Host backend can put a limit on the number of requests it takes out of
the queue at once.  i.e. block backend can take out some requests, throw
them at the block layer, check whenever any request in flight is done,
if so send back replies, start over again.  guest can put more requests
into the queue meanwhile without having to notify the host.  I've seen
the number of notifications going down to zero when running disk
benchmarks in the guest ;)

Of course that works best with one or more I/O threads, so the vcpu
doesn't has to stop running anyway to get the I/O work done ...

cheers,
  Gerd
