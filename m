Return-Path: <linux-kernel-owner+w=401wt.eu-S1754195AbXJBG3r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195AbXJBG3r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 02:29:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751588AbXJBG3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 02:29:40 -0400
Received: from gw.goop.org ([64.81.55.164]:48310 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbXJBG3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 02:29:39 -0400
Message-ID: <4701E552.3070501@goop.org>
Date: Mon, 01 Oct 2007 23:29:38 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Zachary Amsden <zach@vmware.com>,
       Avi Kivity <avi@qumranet.com>, Anthony Liguori <anthony@codemonkey.ws>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>
Subject: Re: [PATCH RFC] paravirt: cleanup lazy mode handling
References: <470186C4.5080208@goop.org> <1191288858.6979.20.camel@localhost.localdomain>
In-Reply-To: <1191288858.6979.20.camel@localhost.localdomain>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rusty Russell wrote:
> That's good, but this code does lose on native because we no longer
> simply replace the entire thing with noops.
>
> Perhaps inverting this and having (inline) helpers is the way to go?
>   

I'm thinking that the overhead will be unmeasurably small, and its not
really worth any more complexity.  That's almost certainly true for lazy
mmu mode, but lazy cpu is used in the middle of a context switch, so
it's probably worth a bit more attention.

> I'm thinking something like:
>
> static inline void paravirt_enter_lazy(enum paravirt_lazy_mode mode)
> {
> 	BUG_ON(x86_read_percpu(paravirt_lazy_mode) != PARAVIRT_LAZY_NONE);
> 	BUG_ON(preemptible());
>
> 	x86_write_percpu(paravirt_lazy_mode, mode);
> }
>
> static inline void paravirt_exit_lazy(enum paravirt_lazy_mode mode)
> {
> 	BUG_ON(x86_read_percpu(paravirt_lazy_mode) != mode);
> 	BUG_ON(preemptible());
>
> 	x86_write_percpu(paravirt_lazy_mode, PARAVIRT_LAZY_NONE);
> }
>   

Er, they should probably call something to make the switch actually
happen, no?

> The only trick would be that the flushes are so rarely required it's
> probably worth putting the unlikely() in the top level:
>   

Sure, I guess.  Would it make any difference?  (I've never personally
noticed likely/unlikely change the generated code in any seriously
positive way.)

    J
