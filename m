Return-Path: <linux-kernel-owner+w=401wt.eu-S1754082AbYJEIwc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082AbYJEIwc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 04:52:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752748AbYJEIwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 04:52:24 -0400
Received: from www.tglx.de ([62.245.132.106]:39933 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731AbYJEIwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 04:52:22 -0400
Date: Sun, 5 Oct 2008 10:51:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
cc: Jiri Kosina <jkosina@suse.cz>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Miller <davem@davemloft.net>, jesse.brandeburg@intel.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org, kkeil@suse.de,
       agospoda@redhat.com, arjan@linux.intel.com, david.graham@intel.com,
       bruce.w.allan@intel.com, john.ronciak@intel.com,
       chris.jones@canonical.com, tim.gardner@canonical.com, airlied@gmail.com,
       Olaf Kirch <okir@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 02/12] On Tue, 23 Sep 2008, David Miller wrote:
In-Reply-To: <4807377b0810041824u5ea472d1q4cf5ff606bd23a11@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.0810050959420.3398@apollo>
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com>  <200810021523.45884.jbarnes@virtuousgeek.org>  <20081003.134634.240211201.davem@davemloft.net>  <200810031429.22598.jbarnes@virtuousgeek.org>  <alpine.LNX.1.10.0810032338140.26779@jikos.suse.cz>
  <4807377b0810031628x43f79eferdbb9c9c264a5816e@mail.gmail.com>  <alpine.LNX.1.10.0810041219130.26779@jikos.suse.cz>  <alpine.LFD.2.00.0810041236250.4404@apollo> <4807377b0810041824u5ea472d1q4cf5ff606bd23a11@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 4 Oct 2008, Jesse Brandeburg wrote:
> > Exactly. The access to a ro region results in a fault. I have nowhere
> > seen that trigger, but I can reproduce the trylock() WARN_ON, which
> > confirms that there is concurrent access to the NVRAM registers. The
> > backtrace pattern is similar to the one you have seen.
> 
> are you still getting WARN_ON *with* all the mutex based fixes already applied?

The WARN_ON triggers with current mainline. Is there any fixlet in
Linus tree missing ?

> with the mutex patches in place (without protection patch) we are
> still reproducing the issue, until we apply the set_memory_ro patch.

That does not make sense to me. If the memory_ro patch is providing
_real_ protection then you _must_ run into an access violation. If not,
then the patch just papers over the real problem in some mysterious
way.

The patch does:

+	set_memory_rw((unsigned long)hw->flash_address,
+	              hw->flash_len >> PAGE_SHIFT);
 	writew(val, hw->flash_address + reg);
+	set_memory_ro((unsigned long)hw->flash_address,
+	              hw->flash_len >> PAGE_SHIFT);

This changes massively the timing of the flash access. Could this be
the problem on the machine which needs the set_memory_ro patch to
survive ?

> I had no luck on friday setting a hardware breakpoint on memory access
> with kgdb to catch the writer with a breakpoint.

Well, why should you get a hardware breakpoint when the _ro protection
does not trigger in the first place ?

Granted there could be a _rw alias mapping, but then the problem must
be still visible with the _ro patch applied.

Thanks,

	tglx

