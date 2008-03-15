Return-Path: <linux-kernel-owner+w=401wt.eu-S1756726AbYCOAmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbYCOAmb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 20:42:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYCOAmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 20:42:23 -0400
Received: from gateway.drzeus.cx ([85.8.24.16]:53621 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546AbYCOAmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 20:42:22 -0400
Date: Sat, 15 Mar 2008 01:41:43 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: "Len Brown" <lenb@kernel.org>, linux-pm@lists.linux-foundation.org,
       "Pavel Machek" <pavel@ucw.cz>, "LKML" <linux-kernel@vger.kernel.org>,
       "Adam Belay" <abelay@novell.com>, "Andi Kleen" <andi@firstfloor.org>,
       "Lee Revell" <rlrevell@joe-job.com>
Subject: Re: [linux-pm] [PATCH] cpuidle: avoid singing capacitors
Message-ID: <20080315014143.32d0d5e9@mjolnir.drzeus.cx>
In-Reply-To: <924EFEDD5F540B4284297C4DC59F3DEEB34783@orsmsx423.amr.corp.intel.com>
References: <Pine.LNX.4.44L0.0803031804330.8280-100000@iolanthe.rowland.org>
	<20080310100008.GA9520@elf.ucw.cz>
	<20080310134915.45ae7446@mjolnir.drzeus.cx>
	<200803121511.17389.lenb@kernel.org>
	<20080313173437.5f00f70e@mjolnir.drzeus.cx>
	<20080314204041.6e376568@mjolnir.drzeus.cx>
	<924EFEDD5F540B4284297C4DC59F3DEEB34783@orsmsx423.amr.corp.intel.com>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008 14:15:46 -0700
"Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com> wrote:

> 
> Why go only one C-state down. Why not directly drop to max_hwcstate? We
> don't need to loop through that way.
> 

Good point. But we can't just jump there and be done with it. That state might not be available (then again, we could require the user to put in a valid max_hwcstate, but that isn't as user friendly).

> There are few other concerns which make me feel that the patch will be
> not as simple as this.
> 1) BIOS may already be exporting the lower C-states as separate states.
> In which case we just have to ignore this deep C-state and return. I
> mean, on your system if BIOS exports C1, C3 and C6 hardware C-states and
> you give max_hwcstate as C3, then we don't want to have C1, C3 and C3 in
> our list.
> 

Indeed. But the current system doesn't easily allows us to handle that. Any ideas?

> 2) On same lines the other information in ACPI like (low power of 100
> and higher latency for C6 on your system) corresponds to hardware C6
> state. If we change the hardware C-state here to C3, then continue to
> use latency info from ACPI for hw C6, that may lead to inefficient state
> selection in the governor. Also, ther are assumptions related DMA,
> lapic, TSC etc in upper level ACPI based on "ACPI C-state" and changing
> underlying hardware C-state to C1 for example will change some of those
> behavior.
> 

It is still way better going to C3 less than possible than not at all (i.e. the previous workaround of processor.max_cstate). As far as I can tell from the documentation, every C-state includes all of the negative side effects of the ones preceding it. So it should just be a matter of sub-optimal selection by the governor. And I don't see how we can fix that without a big table for each processor and possibly chipset.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
