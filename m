Return-Path: <linux-kernel-owner+w=401wt.eu-S1757360AbZCCS2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757360AbZCCS2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 13:28:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbZCCS2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 13:28:34 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:46690 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549AbZCCS2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 13:28:33 -0500
Date: Tue, 3 Mar 2009 12:28:21 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Cedric Le Goater <legoater@free.fr>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-api@vger.kernel.org,
       containers@lists.linux-foundation.org, mpm@selenic.com,
       linux-kernel@vger.kernel.org, Dave Hansen <dave@linux.vnet.ibm.com>,
       linux-mm@kvack.org, tglx@linutronix.de, viro@zeniv.linux.org.uk,
       hpa@zytor.com, Ingo Molnar <mingo@elte.hu>,
       torvalds@linux-foundation.org,
       Andrew Morton <akpm@linux-foundation.org>, xemul@openvz.org
Subject: Re: How much of a mess does OpenVZ make? ;) Was: What can OpenVZ
	do?
Message-ID: <20090303182821.GA4088@us.ibm.com>
References: <1234475483.30155.194.camel@nimitz> <20090212141014.2cd3d54d.akpm@linux-foundation.org> <1234479845.30155.220.camel@nimitz> <20090226162755.GB1456@x200.localdomain> <20090226173302.GB29439@elte.hu> <20090226223112.GA2939@x200.localdomain> <20090301013304.GA2428@x200.localdomain> <20090301200231.GA25276@us.ibm.com> <20090301205659.GA7276@x200.localdomain> <49AD581F.2090903@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AD581F.2090903@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Cedric Le Goater (legoater@free.fr):
> 
> >> 1. cap_sys_admin check is unfortunate.  In discussions about Oren's
> >> patchset we've agreed that not having that check from the outset forces
> >> us to consider security with each new patch and feature, which is a good
> >> thing.
> > 
> > Removing CAP_SYS_ADMIN on restore?
> 
> we've kept the capabilities in our patchset but the user tools doing checkpoint
> and restart are setcap'ed appropriately to be able to do different things like : 
> 	
> 	clone() the namespaces
> 	mount /dev/mqueue
> 	interact with net_ns
> 	etc.

Right, that stuff done in userspace requires capabilities.

> at restart, the task are restarted through execve() so they loose their 
> capabilities automatically.
> 
> but I think we could drop the CAP_SYS_ADMIN tests for some namespaces,
> uts and ipc are good candidates. I guess network should require some 
> privilege.  

Eric and i have talked about that a lot, and so far are continuing
to punt on it.  There are too many possibilities for subtle exploits
so I'm not suggesting changing those now.

But checkpoint and restart are entirely new.  If at each small step
we accept that an unprivileged user should be able to use it safely,
that will lead to a better design, i.e. doing may_ptrace before
checkpoint, and always doing access checks before re-creating a
resource.

If we *don't* do that, we'll have a big-stick setuid root checkpoint
and restart program which isn't at all trustworthy (bc it hasn't
received due scrutiny at each commit point), but must be trusted by
anyone wanting to use it.

And if we're too afraid to remove CAP_SYS_ADMIN checks from unsharing
one innocuous namespace, will we ever convince ourselves to remove it
from an established feature that can recreate every type of resource on
the system?

-serge
