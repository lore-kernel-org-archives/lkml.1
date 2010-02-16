Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299Ab0BPUrs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 15:47:48 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59230 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932757Ab0BPUrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 15:47:47 -0500
Date: Tue, 16 Feb 2010 21:47:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org, ak@linux.intel.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Doug Thompson <dougthompson@xmission.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Borislav Petkov <borislav.petkov@amd.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [tip:x86/mce] x86, mce: Make xeon75xx memory driver dependent on
 PCI
Message-ID: <20100216204732.GA2301@elte.hu>
References: <20100123113359.GA29555@one.firstfloor.org>
 <tip-757fd770c649b0dfa6eeefc2d5e2ea3119b6be9c@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-757fd770c649b0dfa6eeefc2d5e2ea3119b6be9c@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* tip-bot for Andi Kleen <andi@firstfloor.org> wrote:

> Commit-ID:  757fd770c649b0dfa6eeefc2d5e2ea3119b6be9c
> Gitweb:     http://git.kernel.org/tip/757fd770c649b0dfa6eeefc2d5e2ea3119b6be9c
> Author:     Andi Kleen <andi@firstfloor.org>
> AuthorDate: Sat, 23 Jan 2010 12:33:59 +0100
> Committer:  H. Peter Anvin <hpa@zytor.com>
> CommitDate: Fri, 5 Feb 2010 14:51:53 -0800
> 
> x86, mce: Make xeon75xx memory driver dependent on PCI
> 
> Found by Ingo Molnar's automated tester.
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> LKML-Reference: <20100123113359.GA29555@one.firstfloor.org>
> Signed-off-by: H. Peter Anvin <hpa@zytor.com>

As an x86 maintainer i'm NAK-ing your Nehalem MCE patches. I really dont want 
to see this code in v2.6.34, please work on it some more - this should be 
implemented _properly_ and _cleanly_.

Andi, you've ignored my repeated complaints about the cleanliness of the MCE 
code:

  http://linux.derkeiler.com/Mailing-Lists/Kernel/2010-01/msg08454.html

  ( There's been earlier remarks from me on this topic, months ago, the first 
    one more than a year ago, so it's not like you didnt have any advance 
    warning. I suspect i should have NAK-ed earlier. )

and you've ignored what the EDAC developers such as Mauro tried to explain to 
you in that same thread. Your design to expose Intel hardware features sucks 
(because it's essentially non-existent, and because it exposes so little and 
gives users so little benefits) and you should know it.

Please work with Mauro on the Nehalem EDAC bits, they seem rather advanced to 
me for v2.6.34, and _far_ cleaner and more capable as well. See those Intel 
support bits at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/i7core.git master

  Documentation/edac.txt              |  151 +++
  arch/x86/include/asm/pci_x86.h      |    2 +
  arch/x86/kernel/cpu/mcheck/mce_64.c | 1200 +++++++++++++++++++++
  arch/x86/pci/legacy.c               |   43 +-
  drivers/edac/Kconfig                |   19 +
  drivers/edac/Makefile               |    7 +
  drivers/edac/edac_core.h            |    5 +
  drivers/edac/edac_mc_sysfs.c        |    4 +
  drivers/edac/edac_mce.c             |   61 ++
  drivers/edac/i7core_edac.c          | 1966 +++++++++++++++++++++++++++++++++++
  include/linux/edac_mce.h            |   31 +
  include/linux/pci.h                 |    1 +
  include/linux/pci_ids.h             |   19 +
  13 files changed, 3492 insertions(+), 17 deletions(-)

It's a big step forward for Intel CPU features in my opinion, as it is a 
proper, clean driver interface, and i find it highly curious why you are not 
coding for that feature instead.

Once that is done the EDAC code can be pushed by all distros as a common 
interface, as recent Intel CPUs would be supported by it.

I really do not understand why you are trying to keep Intel CPUs in the dark 
ages while most other CPUs are properly supported by the EDAC code ... It 
seems hugely counter-intuitive to me.

Note, any missing functionality on the EDAC side needs a proper driver 
interface to arch/x86 - not this kind of ugly butchered-in 700 lines piece of 
ugly crap that you are trying to push here ... I'd welcome patches for such 
interfaces as they'd further simplify (and also enhance) arch/x86.

( And as i suggested you might also want to work on representing machine
  events as part of the perf events framework. )

	Ingo
