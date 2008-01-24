Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbYAXHW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbYAXHW3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 02:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYAXHWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 02:22:19 -0500
Received: from one.firstfloor.org ([213.235.205.2]:59825 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbYAXHWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 02:22:19 -0500
Date: Thu, 24 Jan 2008 08:56:05 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>, Alexey Dobriyan <adobriyan@gmail.com>,
       akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove BKL from sysctl(2)
Message-ID: <20080124075605.GB6814@one.firstfloor.org>
References: <20080122202727.GB1975@martell.zuzino.mipt.ru> <20080123105140.3406e25b@lxorguk.ukuu.org.uk> <p73k5m0lrxq.fsf@crumb.suse.de> <20080123113800.1cecbc59@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080123113800.1cecbc59@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yes - that's why I am wondering if we want a general 'sysctl' mutex or
> just to fix the specific case. The corename case is nasty as it is timing
> dependant against user activity rather than the less interesting "root
> can be silly" type of problem.

I think for the strings it would be better to just do a kind of copy-on-write.
As in don't use the array directly, but a pointer instead and then sysctl 
allocates a new string, switches the pointer around
and then does a RCU delayed free on the old string if it wasn't in .data.

This would also have the advantage that the small upper limits these 
strings currently have are gone and actually save a little memory in 
the common case of them not being changed.

Only case that wouldn't fix would be someone keeping the string accessed
over a sleep point. And for preemptible kernels it would need rcu_read_lock().
So no free lunch without code auditing. But it would be probably the best
way to go forward longer term.

For multi number arrays the code ideally needs to be robust against temporary
inconsistencies.

BTW while interesting in theory in practice i suspect the actual likelyhood
of a user actually hitting such a race is pretty small because sysctls tend
to be set up a boot only where not much is going on.

-Andi

