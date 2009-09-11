Return-Path: <linux-kernel-owner+w=401wt.eu-S1756845AbZIKVYM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756845AbZIKVYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 17:24:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753157AbZIKVYL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 17:24:11 -0400
Received: from mail-qy0-f172.google.com ([209.85.221.172]:65015 "EHLO
	mail-qy0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbZIKVYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 17:24:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=adzCixNujoIMiBRdBgW/LVX23L9K7fody9vY9k120H4cYYDYjjapG4nSPr0PkTdHu1
         Va/8kur+PxB4etUfZ6rnlkCpT1+lbhxeI2BdiByKCdKbitn+CjvrYjC6dM9P+KuCeWXa
         mTFCY436VvYApHTk9+bcRKL3Ntc0++ZI8fCE8=
Subject: Re: [PATCH 1/8] networking/fanotify: declare fanotify socket
	numbers
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Eric Paris <eparis@redhat.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, netdev@vger.kernel.org,
       viro@zeniv.linux.org.uk, alan@linux.intel.com, hch@infradead.org,
       balbir@in.ibm.com
In-Reply-To: <1252697613.2305.38.camel@dhcp231-106.rdu.redhat.com>
References: <20090911052558.32359.18075.stgit@paris.rdu.redhat.com>
	 <20090911.114620.260824240.davem@davemloft.net>
	 <1252697613.2305.38.camel@dhcp231-106.rdu.redhat.com>
Content-Type: text/plain
Date: Fri, 11 Sep 2009 17:21:42 -0400
Message-Id: <1252704102.25158.36.camel@dogo.mojatatu.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2009-09-11 at 15:33 -0400, Eric Paris wrote:


> 
> I'm willing to try to make this happen, I'm just sure I see the benefit
> and I don't know anyone who knows the net/netlink code well enough who
> owuld be interested to help.....
> 

I can help you on the netlink side but maybe we need to define the
problem scope properly first. I dont know anything about fanotify, but
i then dont need to. Can I re-phrase your problem as follows:

You have kernel code which wishes to communicate information to multiple
listeners in user space. The listeners register some form of filter
(that you term as a monitor) for an object of interest.  For a specific
filter you wish to send them events when something happens to
the object they registered for.
Would the above be accurate?

One good place to start is the taskstats code in linux. Look at
Documentation/accounting in the kernel code. Ive also CCed Balbir who
was involved in that work since i think it bears similarity to what you
are trying to achieve conceptually.

To your other statements:
0) A single skb can be used to send to all the listners..
1) Netlink messages wont get lost unless the listener is not keeping up
and the kernel sending it messages ends up filling its queues. In such a
case your event message will be delivered to the 49 other users but
not the overloaded one. You can add sequence numbers to the event
messages you send to the listeners and any gaps in sequences on received
events imply lost events. You can add a mechanism to query your user
space kernel when something like that gets lost.
2) Your architecture has to take care of maintaining the state of what
you want to deliver. So your editing has nothing to do with skbs.
i.e an event happens, you update your state. If you need to send the
event to the listeners, you alloc an skb - populate it with the info;
multicast it to all the listeners. If something else happens, i would
suggest for sake of simplicity you rinse and repeat. Sure, the listener
may get contradicting events - but they should be able to handle it.

I hope this helps...

cheers,
jamal



