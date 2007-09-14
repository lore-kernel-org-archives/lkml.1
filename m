Return-Path: <linux-kernel-owner+w=401wt.eu-S932305AbXINVUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932305AbXINVUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 17:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756850AbXINVUr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 17:20:47 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:46599 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756231AbXINVUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 17:20:46 -0400
Subject: Re: [kvm-devel] [PATCH] Refactor hypercall infrastructure
From: Zachary Amsden <zach@vmware.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Anthony Liguori <aliguori@us.ibm.com>, kvm-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Avi Kivity <avi@qumranet.com>
In-Reply-To: <46EAF6FC.80207@codemonkey.ws>
References: <11897991353793-git-send-email-aliguori@us.ibm.com>
	 <46EAF4C6.8090903@goop.org>  <46EAF6FC.80207@codemonkey.ws>
Content-Type: text/plain
Date: Fri, 14 Sep 2007 14:20:47 -0700
Message-Id: <1189804847.5982.137.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-09-14 at 16:02 -0500, Anthony Liguori wrote:
> Jeremy Fitzhardinge wrote:
> > Anthony Liguori wrote:
> >   
> >> This patch refactors the current hypercall infrastructure to better support live
> >> migration and SMP.  It eliminates the hypercall page by trapping the UD
> >> exception that would occur if you used the wrong hypercall instruction for the
> >> underlying architecture and replacing it with the right one lazily.
> >>   
> >>     
> >
> > I guess it would be pretty rude/unlikely for these opcodes to get reused
> > in other implementations...  But couldn't you make the page trap
> > instead, rather than relying on an instruction fault?
> >   
> 
> The whole point of using the instruction is to allow hypercalls to be 
> used in many locations.  This has the nice side effect of not requiring 
> a central hypercall initialization routine in the guest to fetch the 
> hypercall page.  A PV driver can be completely independent of any other 
> code provided that it restricts itself to it's hypercall namespace.

But if the instruction is architecture dependent, and you run on the
wrong architecture, now you have to patch many locations at fault time,
introducing some nasty runtime code / data cache overlap performance
problems.  Granted, they go away eventually.

I prefer the idea of a hypercall page, but not a central initialization.
Rather, a decentralized approach where PV drivers can detect using CPUID
which hypervisor is present, and a common MSR shared by all hypervisors
that provides the location of the hypercall page.

Zach

