Return-Path: <linux-kernel-owner+w=401wt.eu-S1759026AbYE2TB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026AbYE2TB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2008 15:01:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755215AbYE2TBs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 May 2008 15:01:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53411 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbYE2TBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2008 15:01:47 -0400
Message-ID: <483EFCBC.2030704@zytor.com>
Date: Thu, 29 May 2008 11:58:04 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>, x86@kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: extend e820 ealy_res support 32bit - fix #2
References: <200805110030.15510.yhlu.kernel@gmail.com>	 <483C70F9.2030901@goop.org>	 <86802c440805271406l4348db33r5622c440b494baa2@mail.gmail.com>	 <483C7BB0.6080901@goop.org>	 <86802c440805271435l744eab84xe55ac9ce6196c03b@mail.gmail.com>	 <483C8157.7080702@goop.org>	 <86802c440805271552k724415a6i66686b9abb8c083f@mail.gmail.com>	 <483D2D8A.5040800@goop.org>	 <86802c440805281348u2fdd6ce2t71231f0fc94d8b5b@mail.gmail.com>	 <483EB18F.4070105@goop.org> <86802c440805291141i7fdc73e8p56e4728996337abc@mail.gmail.com>
In-Reply-To: <86802c440805291141i7fdc73e8p56e4728996337abc@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Thu, May 29, 2008 at 6:37 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>> Yinghai Lu wrote:
>>> can we use e820 entries for that? So the domain builder could have
>>> several entries for E820_RAM and E820_RESERVED...
>>>
>> I tried this, but it doesn't work; the kernel crashes during boot,
>> presumably because it's trying to use the reserved memory as heap.  I
>> suspect the e820 maps are not registered early enough or something...
>>
>> (One thought: if reserving in the E820 map were enough, then couldn't we use
>> it for all the early reservations?)
> 
> "e820 reserved entries" means kernel will only read it.
> 
> reserve_early will be converted to bootmem via reserve_bootmem[_generic]
> and later it could be freed and be reused.
> 

Hang on...

E820_RESERVED is supposed to mean "nothing touches this address space; 
the kernel cannot use it either as RAM nor for I/O allocations."

The kernel *cannot* assume it is safe to read.  There might be an I/O 
device there.

Now, to support using the E820 map for early reservations, we can simply 
define new "fake" E820 types.  The easiest way to do that, is to 
pre-sanitize the map so that all unknown-type entries are collapsed into 
a "fake" type E820_UNKNOWN:

/* Real E820 types */
#define E820_NONE	0
#define E820_RAM        1
#define E820_RESERVED   2
#define E820_ACPI       3
#define E820_NVS        4

/* Fake E820 types */
#define E820_UNKNOWN	5
#define E820_BOOTMEM	6	/* Pre-bootmem allocation in kernel */

/* .... */

/* Look for unknown types */
if (e820->type >= E820_UNKNOWN)
	e820->type = E820_UNKNOWN;

/* Now all numbers above E820_UNKNOWN are available for the kernel */

We can either do this sanitization in the kernel proper, in which case 
the values we pick have no real importance, as they can change from one 
version to the next, or in the boot code (Xen domain builder, ELILO, 
etc.)  The latter case would allow us to pass in new types, but in that 
case, we want to pick a Linux-specific range much higher up the 
numberspace, for obvious reasons.

	-hpa
