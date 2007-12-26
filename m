Return-Path: <linux-kernel-owner+w=401wt.eu-S1751776AbXLZOQ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbXLZOQ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 09:16:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751055AbXLZOQt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 09:16:49 -0500
Received: from namei.org ([69.55.235.186]:52895 "EHLO us.intercode.com.au"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750990AbXLZOQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 09:16:48 -0500
Date: Thu, 27 Dec 2007 01:16:25 +1100 (EST)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@us.intercode.com.au
To: Valdis.Kletnieks@vt.edu
cc: Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul.moore@hp.com>,
       linux-kernel@vger.kernel.org, Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: 2.6.24-rc6-mm1 - git-lblnet.patch and networking horkage
In-Reply-To: <Xine.LNX.4.64.0712261949060.10612@us.intercode.com.au>
Message-ID: <Xine.LNX.4.64.0712270059270.5765@us.intercode.com.au>
References: <20071222233056.d652743e.akpm@linux-foundation.org>
 <30638.1198647786@turing-police.cc.vt.edu>           
 <Xine.LNX.4.64.0712261833110.7815@us.intercode.com.au>
 <10809.1198657525@turing-police.cc.vt.edu> <Xine.LNX.4.64.0712261949060.10612@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Dec 2007, James Morris wrote:

> What does the following say ?
> 
> # sestatus  && rpm -q selinux-policy

Don't worry about that -- I reproduced it with Paul Moore's git tree:
git://git.infradead.org/users/pcmoore/lblnet-2.6_testing

(under current -mm, the e1000 driver doesn't find my ethernet card & the 
tcl tests won't run without an external interface).

The offending commit is when SELinux is converted to the new ifindex 
interface:

  9c6ad8f6895db7a517c04c2147cb5e7ffb83a315 is first bad commit
  commit 9c6ad8f6895db7a517c04c2147cb5e7ffb83a315
  Author: Paul Moore <paul.moore@hp.com>
  Date:   Fri Dec 21 11:44:26 2007 -0500

      SELinux: Convert the netif code to use ifindex values

      [...]

In some case (not yet fully identified -- also happens when avahi starts 
up, although seemingly silently & without obvious issues), SELinux is 
passed an ifindex of 1515870810, which corresponds to 0x5a5a5a5a, the slab 
poison value, suggesting a race in the calling code where we're being 
asked to check an skb which has been freed.

The SELinux code is erroring out before performing an access check 
(perhaps there should be WARN_ON, at least), so this will affect both 
permissive and enforcing mode without generating any log messages.

Andrew: I suggest dropping the patchset from -mm until Paul gets back from 
vacation.


- James
-- 
James Morris
<jmorris@namei.org>
