Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbZESKWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbZESKWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 06:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbZESKWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 06:22:06 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:24608 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbZESKWF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 06:22:05 -0400
Message-Id: <4A12A46A02000078000017E1@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 19 May 2009 11:22:02 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: "the arch/x86 maintainers" <x86@kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jesse Barnes" <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [Xen-devel] Re: [GIT PULL] xen /proc/mtrr implementation
References: <4A0ADBA2.2020300@goop.org> <20090515182757.GA19256@elte.hu>
 <4A0DCC11.10307@goop.org> <m1my9ex818.fsf@fess.ebiederm.org>
 <4A0DFF78.6000501@goop.org> <20090515202250.0f1218ef@jbarnes-g45>
 <m1iqk1k708.fsf@fess.ebiederm.org> <4A10EAC4.9070701@goop.org>
 <20090518085902.GE10687@elte.hu> <4A11A3F8.1010202@goop.org>
 <20090519095918.GA11790@elte.hu>
In-Reply-To: <20090519095918.GA11790@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 19.05.09 11:59 >>>
>Exactly what is 'bizarre' about using the API defined by the _CPU_ 
>already, without adding any ad-hoc hypecall? Catch the dom0 WRMSRs, 
>filter out the MTRR indices - that's it.

But that is *not* the same as using the hypercalls: The hypercall tells Xen
"Change all CPUs' MTRRs with the indicated index to the indicated value",
while the MSR write says "Change the MTRR with the given index on the
physical CPU the current virtual CPU happens to run on to the given value".
A write-base/write-mask pair may happen to get interrupted (preempted)
by the hypervisor, and hence the two writes may happen on different
pCPU-s. Teaching the hypervisor to (correctly!) guess what the guest
meant in that situation isn't trivial, as then it needs to handle all possible
situations (and it can never know whether Dom0 really intended to do
something that may look bogus/inconsistent at the first glance). This is
even more so considering that Linux is not the only OS capable of
running as Dom0.

An apparently relatively simple solution - latch the writes and commit them
only when the global view became consistent again - isn't possible,
since Dom0 may not have a vCPU running on each individual pCPU.

Jan

