Return-Path: <linux-kernel-owner+w=401wt.eu-S1755000AbZGULP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000AbZGULP0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 07:15:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752374AbZGULPZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 07:15:25 -0400
Received: from e28smtp02.in.ibm.com ([59.145.155.2]:43488 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797AbZGULPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 07:15:24 -0400
Date: Tue, 21 Jul 2009 16:45:17 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linuxtronix.de>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Anton Blanchard <anton@samba.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH 1/5] hw-breakpoints: Make kernel breakpoints API
	truly generic
Message-ID: <20090721111517.GC5804@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <1248109687-7808-1-git-send-email-fweisbec@gmail.com> <1248109687-7808-2-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248109687-7808-2-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 01:08:03PM -0400, Frederic Weisbecker wrote:
> To define a kernel hardware breakpoint, one need to define the
> address, type and length of the breakpoint using arch specific
> operations and then register it using a core helper.
> 
> The first stage is truly not scalable with respect to the number of
> archictures, because for each of them that support hardware
> breakpoints, we would need a seperate specific field definition for
> the breakpoint.
> 
> However, the supported breakpoint functionalities may be very different
> between architectures.
> Then this new API tries to compose with the following constraints:
> 
> - a given architecture may perhaps not support the triggering on one
>   of the usual memory access (read-write/read/write/execute)
> 
> - a given architecture may perhaps not support the ability to trigger
>   a breakpoint only on specific memory access size lower than the word
>   size for this arch.
> 
> - a given architecture may perhaps not support breakpoints on addresses
>   range.
> 
> The new API changes the following prototype for a kernel breakpoint
> registration:
> 
>  int register_kernel_hw_breakpoint(struct hw_breakpoint *bp)
> 
> into:
> 
>  int register_kernel_hw_breakpoint(struct hw_breakpoint *bp,
>                                    unsigned long addr,
> 				   int len, enum breakpoint_type type)

It is not clear how adding these new parameters to the interface would
help it become generic, as opposed to moving them to 'struct
hw_breakpoint'.

It would make the usage cumbersome of some architectures - say for
instance the PPC64 which always has a breakpoint length of 8 bytes. So
the user needs to specify either '8' always or '0' to indicate variable
length not supported (but it is counter-intuitive..may be interpreted as
zero-length).

> 
> The choice of passing the breakpoint settings as parameters of the
> registration helper and not by adding generic fields into the breakpoint
> structure is motivated by the need of a very specific per arch
> representation of the breakpoint:
> 
> - the arch may only need an address, but could also need a couple for
>   breakpoints in ranges.
> - the type is subject to arch interpretation (values of debug registers)
> - the length too.
> 
> Then, to get back these values from a generic breakpoint structure that have
> specific encodings into the arch fields, this API comes along with abstract
> accessors which implementation is arch specific:
> 
> - type hw_breakpoint_type(bp)
> - addr hw_breakpoint_addr(bp)
> 
> However, open debates come along this RFC patch:
> 
> - the address could be a generic field in struct hw_breakpoint. If we
>   are dealing with a range breakpoint, then we would just need to
>   compute addr + length to get the end of the range.
> 
> - the length and type could also be generic fields of
>   struct hw_breakpoint. It would then be up to the arch to get a
>   translation between such generic values and per arch needs.
>

While the issues have been enumerated above, the patchset only pushes
the issue into a different domain i.e. make the user determine if a
breakpoint type or len is supported in a given architecture vs the existing
implementation in which the user determines if a constant pertaining to
a given len/type is defined. But the accessor-routines
hw_breakpoint_type() and hw_breakpoint_addr() make it much easier to use
and is a good addition.

To make the usage much easier, I would see a combination of the
following:

- Define constants/enums for length and type that are common to all
  architectures.
- Define accessor routines that help determine if a given type/len is
  supported on the host processor.
- Move fields such as address, len and type to generic breakpoint
  structure (if it still matters despite the two changes above).

Let me know what you think.

Thanks,
K.Prasad

