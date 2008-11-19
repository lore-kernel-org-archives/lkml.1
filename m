Return-Path: <linux-kernel-owner+w=401wt.eu-S1753929AbYKSR4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929AbYKSR4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 12:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbYKSR4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 12:56:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51822 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752946AbYKSR4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 12:56:05 -0500
Message-ID: <492452CF.9080700@zytor.com>
Date: Wed, 19 Nov 2008 09:54:23 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Alexander van Heukelum <heukelum@mailshack.com>
CC: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Jan Beulich <jbeulich@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Glauber Costa <gcosta@redhat.com>, Matt Mackall <mpm@selenic.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH/RFC] Move entry_64.S register saving out of the macros
References: <1226845741-12470-2-git-send-email-heukelum@fastmail.fm> <20081117175232.GA13766@mailshack.com> <20081119001811.GA23237@mailshack.com>
In-Reply-To: <20081119001811.GA23237@mailshack.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander van Heukelum wrote:
> Hi all,
> 
> Here is a combined patch that moves "save_args" out-of-line for
> the interrupt macro and moves "error_entry" mostly out-of-line
> for the zeroentry and errorentry macros.
> 
> The save_args function becomes really straightforward and easy
> to understand, with the possible exception of the stack switch
> code, which now needs to copy the return address of to the
> calling function. Normal interrupts arrive with ((~vector)-0x80)
> on the stack, which gets adjusted in common_interrupt:
> 
> <common_interrupt>:
> (5)  addq   $0xffffffffffffff80,(%rsp)		/* -> ~(vector) */
> (4)  sub    $0x50,%rsp				/* space for registers */
> (5)  callq  ffffffff80211290 <save_args>
> (5)  callq  ffffffff80214290 <do_IRQ>
> <ret_from_intr>:
>      ...
> 
> An apic interrupt stub now look like this:
> 
> <thermal_interrupt>:
> (5)  pushq  $0xffffffffffffff05			/* ~(vector) */
> (4)  sub    $0x50,%rsp				/* space for registers */
> (5)  callq  ffffffff80211290 <save_args>
> (5)  callq  ffffffff80212b8f <smp_thermal_interrupt>
> (5)  jmpq   ffffffff80211f93 <ret_from_intr>
> 

Sorry, I'm away on a trip at the moment, so sorry for the delayed feedback.

First of all, if we're going to go through common code here, we should 
do the vector number adjustment in save_args and be able to use the 
short form of pushq in the common case.

What isn't clear to me is if we should just push a target field to the 
stack and then do an indirect call.  That way we can do save_args and 
ret_from_intr inline, but at the expense of an indirect call which will 
not necessarily speculate cleanly.

All of this qualify as "tweaking", which means we need to be very 
careful so we don't end up burning more performance than we gain, but 
all in all, I think this is a good idea.

	-hpa
