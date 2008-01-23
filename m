Return-Path: <linux-kernel-owner+w=401wt.eu-S1754245AbYAWRAB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbYAWRAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 12:00:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752599AbYAWQ7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 11:59:54 -0500
Received: from smtp-out.google.com ([216.239.45.13]:59640 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbYAWQ7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 11:59:53 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=D2g58fT0XiqdQ6ZG2zjMECcYeISwl8VzdAknG//kh10lLBE9OMxH3Um/f8bsDdtgP
	mRV8P3bwketumkAhfMSVA==
Message-ID: <6599ad830801230859l298da3a7r208502993276c86b@mail.gmail.com>
Date: Wed, 23 Jan 2008 08:59:49 -0800
From: "Paul Menage" <menage@google.com>
To: righiandr@users.sourceforge.net
Subject: Re: [RFC] [PATCH] cgroup: limit network bandwidth
Cc: "Naveen Gupta" <ngupta@google.com>, LKML <linux-kernel@vger.kernel.org>,
       "David Miller" <davem@davemloft.net>
In-Reply-To: <47976FE9.5030600@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47970448.7010609@users.sourceforge.net>
	 <20080123092417.GA4542@balbir.in.ibm.com>
	 <47976FE9.5030600@users.sourceforge.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 23, 2008 8:48 AM, Andrea Righi <righiandr@users.sourceforge.net> wrote:
> >
> > 1. Implementation of soft limits (limit on contention of resource)
> >    gets harder
>
> Why? do you mean implementing a grace time when the soft-limit is
> exceeded? this could be done in cgroup_nl_throttle() introducing 3
> additional attributes to struct netlimit (i.e. hard_limit,
> last_time_exceeded grace_time) and perform something like:
> ...
>         if ((current_rate > hard_limit) ||
>             time_after(jiffies, last_time_exceeded + grace_time))
>                         schedule_timeout(sleep);
> ...

He's talking about cases where we want the behaviour to be
work-conserving, whilst still offering guarantees in the event of
contention. e.g. cgroups A and B each get a 20% guarantee on the TX
path if they need it, but anyone can use any otherwise-idle bandwidth.
(This is relatively straightforward to set up from userspace with the
standard Linux traffic control tools).

>
> Yes, the integration with iptables (as Paul said), and traffic shaping
> rules would be absolutely the right way(tm) in perspective. I was just
> proposing a possible simple API to implement the limiting stuff.

But this issue (traffic control for cgroups) is too complex to be
described by a simple API. Any simple API you choose to try to
describe the limiting directly will be insufficient for a good number
of the potential users. Better to just provide a (very simple) API to
hook into the existing (complex) traffic control API and leave the
tricky stuff to userspace, where anyone can construct arbitrarily
complex queueing schemes with a shell script and a few calls to "tc".

Paul
