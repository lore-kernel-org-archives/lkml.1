Return-Path: <linux-kernel-owner+w=401wt.eu-S1758798AbXKTGOi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798AbXKTGOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 01:14:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755073AbXKTGO3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 01:14:29 -0500
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:49733 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755005AbXKTGO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 01:14:28 -0500
Date: Tue, 20 Nov 2007 01:14:11 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Ingo Molnar <mingo@elte.hu>
cc: Bastian Blank <bastian@waldi.eu.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       glommer@gmail.com, tglx@linutronix.de, rusty@rustcorp.com.au,
       ak@suse.de, chrisw@sous-sol.org, avi@qumranet.com,
       anthony@codemonkey.ws, virtualization@lists.linux-foundation.org,
       lguest@ozlabs.org, kvm-devel@lists.sourceforge.net, zach@vmware.com,
       jun.nakajima@intel.com
Subject: Re: [PATCH 7/24] consolidate msr.h
In-Reply-To: <20071120055113.GC20436@elte.hu>
Message-ID: <Pine.LNX.4.58.0711200108510.4062@gandalf.stny.rr.com>
References: <11946337851964-git-send-email-gcosta@redhat.com>
 <11946337933104-git-send-email-gcosta@redhat.com>
 <11946337991750-git-send-email-gcosta@redhat.com>
 <11946338053158-git-send-email-gcosta@redhat.com>
 <11946338103068-git-send-email-gcosta@redhat.com> <1194633815833-git-send-email-gcosta@redhat.com>
 <11946338212915-git-send-email-gcosta@redhat.com>
 <11946338263902-git-send-email-gcosta@redhat.com> <20071119222151.GA11178@wavehammer.waldi.eu.org>
 <Pine.LNX.4.58.0711191734270.32296@gandalf.stny.rr.com> <20071120055113.GC20436@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 20 Nov 2007, Ingo Molnar wrote:

> * Steven Rostedt <rostedt@goodmis.org> wrote:
>
> > With PVOPS on it gives compiler warnings without that explict cast.
> > Without looking at the code, IIRC with non-PVOPS it is a macro
> > directly into asm, so it didn't matter what the cast was. But with
> > PVOPS as a function, it gave compiler warnings.
> >
> > Take it out and try compiling it for both i386 and x86_64. One of them
> > gave warnings. But maybe it's not a problem now.
>
> i dont think there's ever any true need (and good cause) to force
> integer type casts like that at the callee site.

I guess the problem is that we converted a macro to a function, where the
macro did no type checking. Now we need to pick between integers and
pointers. Some places uses intergers in wrmsrl and some use pointers. So
changing this to a typechecking protocol is not going to be nice.

Looking at the current code now, we have this:

====
	checking_wrmsrl(MSR_IA32_SYSENTER_CS, (u64)__KERNEL_CS);
	checking_wrmsrl(MSR_IA32_SYSENTER_ESP, 0ULL);
	checking_wrmsrl(MSR_IA32_SYSENTER_EIP, (u64)ia32_sysenter_target);

	wrmsrl(MSR_CSTAR, ia32_cstar_target);
====

A typecast is already used in that same area.

-- Steve


