Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbYIWFnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbYIWFnl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 01:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751859AbYIWFnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 01:43:33 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:46826 "EHLO
	WA4EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbYIWFnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 01:43:32 -0400
X-BigFish: VPS-34(zz1432R98dR1805M936fO3117Kzzzzz32i6bh61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0K7MVWB-02-V9V-01
Date: Tue, 23 Sep 2008 07:42:48 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: Valdis.Kletnieks@vt.edu, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: c1e_idle: don't mark TSC unstable if CPU has
	invariant TSC
Message-ID: <20080923054248.GB16896@alberich.amd.com>
References: <20080918191210.GD23287@alberich.amd.com> <27087.1221766532@turing-police.cc.vt.edu> <20080919172019.GA16896@alberich.amd.com> <20080920061457.GE25713@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080920061457.GE25713@elte.hu>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 23 Sep 2008 05:43:21.0582 (UTC) FILETIME=[49D830E0:01C91D3F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2008 at 08:14:57AM +0200, Ingo Molnar wrote:
> 
> * Andreas Herrmann <andreas.herrmann3@amd.com> wrote:
> 
> > Currently the kernel assumes TSC is stable and there are various 
> > places where Linux might spot when TSC is unstable. c1e_idle is one 
> > such place. But it's wrong to mark TSC unstable for all AMD CPUs in 
> > this function as newer CPU families have TSC's that are P- and C-state 
> > invariant.
> 
> i agree with the purpose of the patch (as it flags the first really sane 
> TSC implementation on x86!!!) - but it would be nice to indicate this in 
> a different CPU feature bit other than X86_FEATURE_CONSTANT_TSC, to 
> reduce confusion. Perhaps introduce a virtual CPU feature bit for that?

Yes, I thought about it as well, but at the moment I don't see a big
benefit. I guess you mean that with a new feature bit we could skip
all those additional checks for good TSCs if the bit is set or exit
mark_tsc_unstable() early?

But I've observed on one test machine with a dual-core CPU that TSC's
were P- and C-state invariant but they also had a constant difference
which was large enough to cause a
  "Measured ... cycles TSC warp between CPUs, turning off TSC clock"
message. It was a family 0x11 CPU which has invariant TSCs and
for it the X86_FEATURE_CONSTANT_TSC bit is set. But obviously both
cores' TSCs were not correctly synced among themselves at start time.

Thus I think the current behaviour of the kernel to check for good TSC
in different places is the right thing to do because it is robust enough
to detect such unexpected behaviour.


Regards,

Andreas


