Return-Path: <linux-kernel-owner+w=401wt.eu-S1751281AbZDNFtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281AbZDNFtK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 01:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750767AbZDNFsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 01:48:53 -0400
Received: from jalapeno.cc.columbia.edu ([128.59.29.5]:55029 "EHLO
	jalapeno.cc.columbia.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725AbZDNFsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 01:48:52 -0400
Message-ID: <49E4233C.3000108@cs.columbia.edu>
Date: Tue, 14 Apr 2009 01:46:36 -0400
From: Oren Laadan <orenl@cs.columbia.edu>
Organization: Columbia University
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Alexey Dobriyan <adobriyan@gmail.com>
CC: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, hch@infradead.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/30] C/R OpenVZ/Virtuozzo style
References: <20090410023207.GA27788@x200.localdomain>
In-Reply-To: <20090410023207.GA27788@x200.localdomain>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-No-Spam-Score: Local
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Some meta comments about this patch set:

* Patches 1-9 are cleanups, unrelated to checkpoint/restart. They
deserve a separate thread.

* You barely take locks or reference counts to objects that you
later refer to. What if something really bad happens ?

* (contd) If you don't take locks, then you at the very least need
to rely on the container remaining frozen for the duration of the
operation (during checkpoint).

* (contd) Still with locks and references, during restart you can't
even freeze the container, so need extra logic to prevent bad things
(e.g. OOM killer, signal or ptrace from parent container etc).

* What is the rationale behind doing the freeze/unfreeze from within
sys_checkpoint/sys_restart ?   Instead of you let userspace do it
(and only verify in kernel) you gain, again, flexibility. For example,
you want to also snapshot the filesystem, then userspace will do
something like:  freeze container -> snapshot filesystem -> checkpoint
-> thaw container.

* A plethora of "FIXME" comments ...

Alexey Dobriyan wrote:
> This is to show how we see C/R and to provoke discussion on number of
> important issues (mounts, ...).

Quoting your patch:
---
This is one big FIXME:
	What to do with overmounted files?
	What to do with mounts at all, who should restore them?

just restore something to not oops on task exit
---

> 
> This is small part of long-awaited to be cleanuped code.
> 
> It's able to restore busyloop on i386 and x86_64 and restore i386
> busyloop on x86_64. It wasn't tested much more than that.

Oh .. I really wish you'd sent a x86_64 patch our way, too ;)

> 
> I'm currently starting formal testsuite, otherwise it's whack-a-mole
> game and formal TODO list (a huge one).
> 

So I'm still struggling to see the major different in the approaches
that would justify throwing away our hard worked, reviewed, tested
and functional code, and take this - similar in design, largely
incomplete and unreviewed code.

Best,

Oren.
