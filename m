Return-Path: <linux-kernel-owner+w=401wt.eu-S1759300AbYA3Tdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbYA3Tdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 14:33:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755552AbYA3Tdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 14:33:44 -0500
Received: from mga03.intel.com ([143.182.124.21]:7664 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751026AbYA3Tdl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:33:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,279,1199692800"; 
   d="scan'208";a="373161365"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Subject: RE: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Date: Wed, 30 Jan 2008 11:33:29 -0800
Message-ID: <1FE6DD409037234FAB833C420AA843EC757F12@orsmsx424.amr.corp.intel.com>
In-Reply-To: <47A0CD4B.5040706@sgi.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: x86/non-x86: percpu, node ids, apic ids x86.git fixup
Thread-Index: AchjdOgXp8RJIaOrTS6pkB01Yo4gUQAALOjw
References: <200801301414.m0UEEgCC006371@hera.kernel.org> <Pine.LNX.4.64.0801301622460.11859@vixen.sonytel.be> <47A09F8A.3000309@sgi.com> <20080130161036.GA12293@elte.hu> <1FE6DD409037234FAB833C420AA843EC757C72@orsmsx424.amr.corp.intel.com> <20080130180623.GA24881@elte.hu> <1FE6DD409037234FAB833C420AA843EC757DEA@orsmsx424.amr.corp.intel.com> <47A0CD4B.5040706@sgi.com>
From: "Luck, Tony" <tony.luck@intel.com>
To: "Mike Travis" <travis@sgi.com>
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Geert Uytterhoeven" <Geert.Uytterhoeven@sonycom.com>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux Kernel Development" <linux-kernel@vger.kernel.org>,
       "Linux/PPC Development" <linuxppc-dev@ozlabs.org>,
       <linux-ia64@vger.kernel.org>, <sparclinux@vger.kernel.org>
X-OriginalArrivalTime: 30 Jan 2008 19:33:30.0892 (UTC) FILETIME=[FE9AFCC0:01C86376]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'm having trouble replicating this error.  With the latest linux-2.6.git
> plus the patch I just sent, I get the following errors:
>
> drivers/input/mouse/psmouse-base.c:45: error: __param_proto causes a section type conflict
> drivers/md/md.c:5881: error: __param_start_ro causes a section type conflict

Weird.  psmouse-base.c builds ok for me.  Perhaps there is a compiler
version difference?  I'm running a rather old 3.4.6 that came with
my RHEL 4.5 release.

> (plenty of warnings too, but no vmlinux)
New section mismatch checks are complaining about lots of stuff in this
post 2.6.24 world.  There are a couple of dozen other warnings in a
"normal" build.

> I copied arch/ia64/configs/tiger_defconfig to .config, ran menuconfig to
> turn off SMP and built with this line

Yup ... my script is a little different.  It uses
	$ sed -e '/CONFIG_SMP/d' arch/ia64/configs/tiger_defconfig > .config
	$ make oldconfig

But the net effect should be equivalent.

> #ifdef HAVE_MODEL_SMALL_ATTRIBUTE
> # define PER_CPU_ATTRIBUTES     __attribute__((__model__ (__small__)))
> #endif
> 
> This is only defined for !__ASSEMBLY__

Some place in there.  The CONFIG_SMP=n path in ia64 makes quite radical
changes ... rather than putting all the per-cpu stuff into the top 64K
of address space and providing a per-cpu TLB mapping for that range to a
different physical address ... it just makes all the per-cpu stuff link
as ordinary variables in .data.  The error messages indicate that some of
the new code is unaware of this.

-Tony
