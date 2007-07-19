Return-Path: <linux-kernel-owner+w=401wt.eu-S1762996AbXGSUrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762996AbXGSUrV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 16:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756867AbXGSUrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 16:47:07 -0400
Received: from mx1.suse.de ([195.135.220.2]:59518 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756919AbXGSUrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 16:47:05 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: patches@x86-64.org
Subject: Re: [patches] new text patching for review
Date: Thu, 19 Jul 2007 22:46:57 +0200
User-Agent: KMail/1.9.6
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Zachary Amsden <zach@vmware.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       "S. P. Prasanna" <prasanna@in.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>
References: <200707191105.44056.ak@suse.de> <p73d4yow0ys.fsf@bingen.suse.de> <469FC9D4.5070604@goop.org>
In-Reply-To: <469FC9D4.5070604@goop.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707192246.58047.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 19 July 2007 22:30:12 Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
> > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> >   
> >> I see that IRQs are disabled in alternative_instructions(), but it does
> >> not protect against NMIs, which could come at a very inappropriate
> >> moment. MCE and SMIs would potentially cause the same kind of trouble.
> >>
> >> So unless you can guarantee that any code from NMI handler won't call
> >> basic things such as get_cycles() (nor MCE, nor SMIs), you can't insure
> >> it won't execute an illegal instruction. Also, the option of temporarily
> >> disabling the NMI for the duration of the update simply adds unwanted
> >> latency to the NMI handler which could be unacceptable in some setups.
> >>     
> >
> > Ok it's a fair point.  But how would you address it ?
> >
> > Even if we IPIed the other CPUs NMIs or MCEs could still happen.
> >
> > BTW Jeremy, have you ever considered that problem with paravirt ops
> > patching? 
> >   
> 
> I remember Zach was thinking about it when he was thinking of making vmi
> a kernel module, but I don't think we discussed it with respect to the
> current patching mechanism.  Though he did discover that at one point
> alternative_instructions() was being run with interrupts enabled, which
> caused surprisingly few problems...
> 
> But, yeah, it seems like it could be a problem.

Normally there are not that many NMIs or MCEs at boot, but it would
be still good to avoid the very rare crash by auditing the code first
[better than try to debug it on some production system later]

> > - smp lock patching only ever changes a single byte (lock prefix) of
> > a single instruction
> > - kprobes only ever change a single byte
> >
> > For the immediate value patching it also cannot happen because
> > you'll never modify multiple instructions and all immediate values
> > can be changed atomically. 
> >   
> 
> Are misaligned/cross-cache-line updates atomic?

In theory yes, in practice there can be errata of course. There tend 
to be a couple with self modifying code, especially cross modifying
(from another CPU) -- but you don't do that.

-Andi
