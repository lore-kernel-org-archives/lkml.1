Return-Path: <linux-kernel-owner+w=401wt.eu-S1759205AbZCMVBo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759205AbZCMVBo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 17:01:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbZCMVBc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 17:01:32 -0400
Received: from smtp-out.google.com ([216.239.33.17]:51955 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbZCMVBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 17:01:31 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=cfo+DlOQ+U66CqFSkocv7fclZfrlFyljNt/X3vlTuAeEx+F8bbQG4D8xl7Lzvk60m
	rKvy9d0JlwIq13m6kbNow==
MIME-Version: 1.0
In-Reply-To: <20090313.115137.254924980.davem@davemloft.net>
References: <1236866906.3221.11.camel@achroite>
	 <1236926602.2567.528.camel@ymzhang>
	 <65634d660903131006n44f068dw18b2fe9dce25399e@mail.gmail.com>
	 <20090313.115137.254924980.davem@davemloft.net>
Date: Fri, 13 Mar 2009 14:01:07 -0700
Message-ID: <65634d660903131401v24d0b5aarec36ad95220ba201@mail.gmail.com>
Subject: Re: [RFC v2: Patch 1/3] net: hand off skb list to other cpu to submit 
	to upper layer
From: Tom Herbert <therbert@google.com>
To: David Miller <davem@davemloft.net>
Cc: yanmin_zhang@linux.intel.com, bhutchings@solarflare.com,
       andi@firstfloor.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
       jesse.brandeburg@intel.com, shemminger@vyatta.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 13, 2009 at 11:51 AM, David Miller <davem@davemloft.net> wrote:
>
> From: Tom Herbert <therbert@google.com>
> Date: Fri, 13 Mar 2009 10:06:56 -0700
>
> > You'll definitely want to look at the hardware provided hash.  We've
> > been using a 10G NIC which provides a Toeplitz hash (the one defined
> > by Microsoft) and a software RSS-like capability to move packets from
> > an interrupting CPU to another for processing.  The hash could be used
> > to index to a set of CPUs, but we also use the hash as a connection
> > identifier to key into a lookup table to steer packets to the CPU
> > where the application is running based on the running CPU of the last
> > recvmsg.  Using the device provided hash in this manner is a HUGE win,
> > as opposed to taking cache misses to get 4-tuple from packet itself to
> > compute a hash.  I posted some patches a while back on our work if
> > you're interested.
>
> I never understood this.
>
> If you don't let the APIC move the interrupt around, the individual
> MSI-X interrupts will steer packets to individual specific CPUS and as
> a result the scheduler will migrate tasks over to those cpus since the
> wakeup events keep occuring there.

We are trying to follow the decisions scheduler as opposed to leading
it.  This works on very loaded systems, with applications binding to
cpusets, with threads that are receiving on multiple sockets.  I
suppose it might be compelling if a NIC could steer packets per flow,
instead of by a hash...
