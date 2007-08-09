Return-Path: <linux-kernel-owner+w=401wt.eu-S935611AbXHIMSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935611AbXHIMSk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2007 08:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762911AbXHIMS3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Aug 2007 08:18:29 -0400
Received: from ms-smtp-03.nyroc.rr.com ([24.24.2.57]:47088 "EHLO
	ms-smtp-03.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763610AbXHIMSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2007 08:18:17 -0400
Date: Thu, 9 Aug 2007 08:17:26 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Andi Kleen <andi@firstfloor.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       rusty@rustcorp.com.au, Ingo Molnar <mingo@elte.hu>, chrisw@sous-sol.org,
       avi@qumranet.com, anthony@codemonkey.ws,
       virtualization@lists.linux-foundation.org, lguest@ozlabs.org
Subject: Re: [PATCH 18/25] [PATCH] turn priviled operations into macros in
 entry.S
In-Reply-To: <46BAA447.9010504@goop.org>
Message-ID: <Pine.LNX.4.58.0708090813450.29847@gandalf.stny.rr.com>
References: <11865467522495-git-send-email-gcosta@redhat.com>
 <200708081138.23018.ak@suse.de> <Pine.LNX.4.58.0708080740490.5921@gandalf.stny.rr.com>
 <200708081424.49896.ak@suse.de> <Pine.LNX.4.58.0708080835350.6751@gandalf.stny.rr.com>
 <p738x8mrv4m.fsf@bingen.suse.de> <Pine.LNX.4.58.0708080919330.7236@gandalf.stny.rr.com>
 <Pine.LNX.4.58.0708080924590.7236@gandalf.stny.rr.com>
 <20070808133001.GD14419@one.firstfloor.org> <Pine.LNX.4.58.0708080936070.7516@gandalf.stny.rr.com>
 <46BAA447.9010504@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--
On Wed, 8 Aug 2007, Jeremy Fitzhardinge wrote:

> Steven Rostedt wrote:
> > 	/*
> > 	 * x86 arch doesn't have an easy way to find out where
> > 	 * gs is located. So we need to read the MSR. But first
> > 	 * we need to save off the rcx, rax and rdx.
> >
> Why don't you store it in gs?  movq %gs:my_gs_base, %rax?

Because it can't be trusted.  After the swapgs, we are pointing to the RW
section of the HV. But by running the guest kernel in ring 1, we have no
protection from the guest writing into that area too. So we can't put
anything in that section and expect it to be safe after jumping to guest
code.  The only trusted values, is jumping in after getting there by an
interrupt, where the hardware places the values onto the stack.

But with Andi's comments, I realized I can point the gs pointer to the
RO area. And make a constant offset that will point up into the RW area,
so we could save the stack and replace it.

-- Steve

