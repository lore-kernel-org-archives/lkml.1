Return-Path: <linux-kernel-owner+w=401wt.eu-S1754201AbXLGQZh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbXLGQZh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 11:25:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752882AbXLGQZ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 11:25:29 -0500
Received: from mtagate7.de.ibm.com ([195.212.29.156]:1602 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbXLGQZ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 11:25:28 -0500
In-Reply-To: <ada7ijrd6gy.fsf@cisco.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Christoph Raisch <raisch@de.ibm.com>,
       "OF-EWG" <ewg@lists.openfabrics.org>,
       "OF-General" <general@lists.openfabrics.org>,
       LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org,
       Marcus Eder <meder@de.ibm.com>, Roland Dreier <rolandd@cisco.com>,
       Stefan Roscher <stefan.roscher@de.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH] IB/ehca: Serialize HCA-related hCalls on POWER5
X-Mailer: Lotus Notes Release 7.0 HF277 June 21, 2006
From: Joachim Fenkes <FENKES@de.ibm.com>
Message-ID: <OF85E31FAA.DADA6039-ONC12573AA.005439C8-C12573AA.005A137A@de.ibm.com>
Date: Fri, 7 Dec 2007 17:25:23 +0100
X-MIMETrack: Serialize by Router on D12ML064/12/M/IBM(Release 7.0.2HF71 | November 3, 2006) at
 07/12/2007 17:25:26,
	Serialize complete at 07/12/2007 17:25:26
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <rdreier@cisco.com> wrote on 06.12.2007 19:27:09:

>  > > +               ehca_lock_hcalls = 
!(cur_cpu_spec->cpu_user_features
>  > > +                                    & PPC_FEATURE_ARCH_2_05);
> 
>  > We already talked about this yesterday, but I still feel that 
checking the
>  > instruction set of the CPU should not be used to determine whether a
>  > specific device driver implementation is used int hypervisor.
> 
> I had the same reaction... is testing cpu_user_features really the
> best way to detect this issue?

I concur it's not nice, but it was the only feasible method we could find 
without adding a "bug fixed" feature flag to the partition<->firmware 
interface. The firmware version reported in the OFDT is not a reliable 
enough source, and even if it were, it would require a lot of string 
parsing and matching against tables.

We're taking this to the firmware architects at the moment, but they're 
not very fond of the idea of reporting the absence of bugs through 
capability flags, as this could quickly lead to the exhaustion of flag 
bits. We'll let the discussion stew for a bit, but if we don't get this 
flag, we'll have to resort to the CPU features.
 
> I'll hold off applying this for a few days so you guys can decide the
> best thing to do.  We'll definitely get some fix into 2.6.24 but we
> have time to make a good decision.

Right.
 
>  > Regarding the performance problem, have you checked whether 
converting all
>  > your spin_lock_irqsave to spin_lock/spin_lock_irq improves your 
performance
>  > on the older machines? Maybe it's already fast enough that way.
> 
> It does seem that the only places that the hcall_lock is taken also
> use msleep, so they must always be in process context.  So you can
> safely just use spin_lock(), right?

As Arnd said, there are hCalls that will never return H_LONG_BUSY_*, such 
as H_QUERY_PORT and chums, so they will never sleep. The surrounding 
functions, though, are not prepared to be called from interrupt context 
(GFP_KERNEL comes to mind), so I agree that a simple spin_lock() will 
suffice. Thanks, Arnd, for pointing this out.

We'll keep you guys posted on the feature flag discussion. Until then, 
have a nice weekend!

Joachim
