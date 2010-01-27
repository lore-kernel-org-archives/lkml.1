Return-Path: <linux-kernel-owner+w=401wt.eu-S1755299Ab0A0Qg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab0A0Qg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 11:36:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755113Ab0A0Qg6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 11:36:58 -0500
Received: from one.firstfloor.org ([213.235.205.2]:53811 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753995Ab0A0Qg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 11:36:57 -0500
Date: Wed, 27 Jan 2010 17:36:52 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
       Borislav Petkov <petkovbb@googlemail.com>, mingo@redhat.com,
       hpa@zytor.com, linux-kernel@vger.kernel.org, tglx@linutronix.de,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       linux-tip-commits@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Aristeu Rozanski <aris@redhat.com>, Doug Thompson <norsk5@yahoo.com>,
       Huang Ying <ying.huang@intel.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [tip:x86/mce] x86, mce: Rename cpu_specific_poll to
	mce_cpu_specific_poll
Message-ID: <20100127163651.GF12522@basil.fritz.box>
References: <20100121221711.GA8242@basil.fritz.box> <tip-f91c4d2649531cc36e10c6bc0f92d0f99116b209@git.kernel.org> <20100123051717.GA26471@elte.hu> <20100123075851.GA7098@liondog.tnic> <20100123090003.GA20056@elte.hu> <4B6032E7.1090900@redhat.com> <20100127143957.GE12522@basil.fritz.box> <4B605617.6050006@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B605617.6050006@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 27, 2010 at 01:04:55PM -0200, Mauro Carvalho Chehab wrote:
> I haven't the datasheets for 75xx, so I can't say for sure if it would be better to
> use the same driver or to fork it.

You can't use the same driver.

> Well, the error parsing can be done in kernel space in a standard way provided
> by the edac interface.
> 
> I don't see why not the mcelog userspace shouldn't use the EDAC interface as one
> of its source, getting memory errors from it, avoiding the need of re-parsing
> the errors.

The errors are just numbers which are printed. If you mean with "parsing" 
splitting up the bitfields that's not really an too interesting case.

Essentially to get terminology clear, for corrected errors there are multiple
steps: (uncorrected errors are quite different)

1) Getting the error from hardware registers
2) Accounting them
3) Presenting them to users
4) Reacting to events
   which can be separated in 
   4a) protocol to communicate with event handler
       4a1) interface to wake up event handler
       4a2) communication 
   4b) event handler itself

Some parts of these need to be in kernel space: but that's
pretty much only (1)

Some parts of these need to be in user space: in particular
4b) and (3) for any non trivial presentation (the kernel can 
do some very limited one, but it's not good at anything non trivial
here)

4b needs to be in user space, it's deep policies and most interesting 
advanced reactions to errors cannot be done in kernel space alone.

i7core does (1), some of (2) but not complete and 4a)
I don't really count EDAC as (3) because fishing the numbers out of
sysfs by hand is not user friendly. In EDAC that's typically done
with the EDAC utils, which are user space.

EDAC doesn't really solve 4a1) unless you could "written a syslog scanner"
in it.

The xeon75xx mce driver only does (1) and uses the standard
MCE event passing mechanism (4a) to pass it to mcelog.

mcelog just does the other parts, most of which have to be in user space
anyways.

The only thing you could probably argue is if it should do accounting
or not. Right now it does it and EDAC does it too. At least
for advanced accounting (per page) where you can have a lot of 
data (can be larger than a struct page per 4K page) 
I personally prefer that to be swappable.

Hope this helps,

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
