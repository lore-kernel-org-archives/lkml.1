Return-Path: <linux-kernel-owner+w=401wt.eu-S935932AbXGSXxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935932AbXGSXxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 19:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756913AbXGSXx1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 19:53:27 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:41485 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755289AbXGSXx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 19:53:26 -0400
Date: Thu, 19 Jul 2007 19:53:24 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, Jeremy Fitzhardinge <jeremy@goop.org>,
       Zachary Amsden <zach@vmware.com>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org, "S. P. Prasanna" <prasanna@in.ibm.com>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [patches] new text patching for review
Message-ID: <20070719235324.GD30383@Krystal>
References: <200707191105.44056.ak@suse.de> <p73d4yow0ys.fsf@bingen.suse.de> <469FC9D4.5070604@goop.org> <200707192246.58047.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <200707192246.58047.ak@suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:52:42 up 2 days, 18:26,  2 users,  load average: 1.79, 0.58, 0.36
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (ak@suse.de) wrote:
> On Thursday 19 July 2007 22:30:12 Jeremy Fitzhardinge wrote:
> > Andi Kleen wrote:
> > > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> writes:
> > >   
> > >> I see that IRQs are disabled in alternative_instructions(), but it does
> > >> not protect against NMIs, which could come at a very inappropriate
> > >> moment. MCE and SMIs would potentially cause the same kind of trouble.
> > >>
> > >> So unless you can guarantee that any code from NMI handler won't call
> > >> basic things such as get_cycles() (nor MCE, nor SMIs), you can't insure
> > >> it won't execute an illegal instruction. Also, the option of temporarily
> > >> disabling the NMI for the duration of the update simply adds unwanted
> > >> latency to the NMI handler which could be unacceptable in some setups.
> > >>     
> > >
> > > Ok it's a fair point.  But how would you address it ?
> > >
> > > Even if we IPIed the other CPUs NMIs or MCEs could still happen.
> > >
> > > BTW Jeremy, have you ever considered that problem with paravirt ops
> > > patching? 
> > >   
> > 
> > I remember Zach was thinking about it when he was thinking of making vmi
> > a kernel module, but I don't think we discussed it with respect to the
> > current patching mechanism.  Though he did discover that at one point
> > alternative_instructions() was being run with interrupts enabled, which
> > caused surprisingly few problems...
> > 
> > But, yeah, it seems like it could be a problem.
> 
> Normally there are not that many NMIs or MCEs at boot, but it would
> be still good to avoid the very rare crash by auditing the code first
> [better than try to debug it on some production system later]
> 
> > > - smp lock patching only ever changes a single byte (lock prefix) of
> > > a single instruction
> > > - kprobes only ever change a single byte
> > >
> > > For the immediate value patching it also cannot happen because
> > > you'll never modify multiple instructions and all immediate values
> > > can be changed atomically. 
> > >   
> > 
> > Are misaligned/cross-cache-line updates atomic?
> 
> In theory yes, in practice there can be errata of course. There tend 
> to be a couple with self modifying code, especially cross modifying
> (from another CPU) -- but you don't do that.
> 

Hrm, changing instructions in multiple memory accesses does not seem to
be atomic to me (unaligned case).

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
