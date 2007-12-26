Return-Path: <linux-kernel-owner+w=401wt.eu-S1751994AbXLZP60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbXLZP60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 10:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751151AbXLZP6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 10:58:17 -0500
Received: from mailhub.hp.com ([192.151.27.10]:41333 "EHLO mailhub.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751133AbXLZP6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 10:58:16 -0500
From: "Paul Moore" <paul.moore@hp.com>
Subject: Re: 2.6.24-rc6-mm1 - git-lblnet.patch and networking horkage
Date: 26 Dec 2007 08:57:00 -0700
To: <jmorris@namei.org>
X-Mailer: ChatterEmail+ for Treo 6xx/700p (3.0.8)
Message-ID: <3281504256.5618888@mail.hp.com>
Cc: <Valdis.Kletnieks@vt.edu>, <akpm@linux-foundation.org>,
       <linux-kernel@vger.kernel.org>, <sds@tycho.nsa.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As James said I'm away right now and computer access is limited.  However, I'm stuck in the airport right now and spent some time looking at the code ... Based on what has been found so far I wonder if the problem isn't a race but a problem of skb->iif never being initialized correctly?  To my untrained eye it looks like __netdev_alloc_skb() should be setting skb->iif (like it does for skb->dev) but it currently doesn't.

Am I barking up the wrong tree here?

. paul moore
. linux security @ hp
-----Original Message-----
From: James Morris <jmorris@namei.org>
Date: Wednesday, Dec 26, 2007 7:16 am
Subject: Re: 2.6.24-rc6-mm1 - git-lblnet.patch and networking horkage
To: Valdis.Kletnieks@vt.edu
CC: Andrew Morton <akpm@linux-foundation.org>,	Paul Moore <paul.moore@hp.com>, linux-kernel@vger.kernel.org,	Stephen Smalley <sds@tycho.nsa.gov>

On Wed, 26 Dec 2007, James Morris wrote:
>
>> What does the following say ?
> 
> # sestatus  && rpm -q selinux-policy
>
>Don't worry about that -- I reproduced it with Paul Moore's git tree: git://git.infradead.org/users/pcmoore/lblnet-2.6_testing
>
>(under current -mm, the e1000 driver doesn't find my ethernet card & the 
>tcl tests won't run without an external interface).
>
>The offending commit is when SELinux is converted to the new ifindex 
>interface:
>
>  9c6ad8f6895db7a517c04c2147cb5e7ffb83a315 is first bad commit
>  commit 9c6ad8f6895db7a517c04c2147cb5e7ffb83a315
>  Author: Paul Moore <paul.moore@hp.com>
>  Date:   Fri Dec 21 11:44:26 2007 -0500
>
>      SELinux: Convert the netif code to use ifindex values
>
>      [...]
>
>In some case (not yet fully identified -- also happens when avahi starts 
>up, although seemingly silently & without obvious issues), SELinux is 
>passed an ifindex of 1515870810, which corresponds to 0x5a5a5a5a, the slab 
>poison value, suggesting a race in the calling code where we're being 
>asked to check an skb which has been freed.
>
>The SELinux code is erroring out before performing an access check 
>(perhaps there should be WARN_ON, at least), so this will affect both 
>permissive and enforcing mode without generating any log messages.
>
>Andrew: I suggest dropping the patchset from -mm until Paul gets back from 
>vacation.
>
>
>- James
>-- 
>James Morris
><jmorris@namei.org>
>

