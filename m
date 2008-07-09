Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbYGIUd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbYGIUd7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752295AbYGIUdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:33:50 -0400
Received: from gw.goop.org ([64.81.55.164]:41230 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752217AbYGIUdu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:33:50 -0400
Message-ID: <4875209D.8010603@goop.org>
Date: Wed, 09 Jul 2008 13:33:33 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu> <48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>
In-Reply-To: <48751CF9.4020901@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Jeremy Fitzhardinge wrote:
>   
>> Ingo Molnar wrote:
>>     
>>> Note that the zero-based percpu problems are completely unrelated to
>>> stackprotector. I was able to hit them with a stackprotector-disabled
>>> gcc-4.2.3 environment.
>>>       
>> The only reason we need to keep a zero-based pda is to support
>> stack-protector.  If we drop drop it, we can drop the pda - and its
>> special zero-based properties - entirely.
>>     
>
>
> Another reason to use a zero based per cpu area is to limit the offset range. Limiting the offset range allows in turn to limit the size of the generated instructions because it is part of the instruction.

No, it makes no difference.  %gs:X always has a 32-bit offset in the 
instruction, regardless of how big X is:

	mov %eax, %gs:0
	mov %eax, %gs:0x1234567
->
   0:	65 89 04 25 00 00 00 00	mov    %eax,%gs:0x0
   8:	65 89 04 25 67 45 23 01	mov    %eax,%gs:0x1234567


>  It also is easier to handle since __per_cpu_start does not figure
> in the calculation of the offsets.
>   

No, you do it the same as i386.  You set the segment base to be 
percpu_area-__per_cpu_start, and then just refer to %gs:per_cpu__foo 
directly.  You can use rip-relative addressing to make it a smaller 
addressing mode too:

   0:	65 89 05 00 00 00 00 	mov    %eax,%gs:0(%rip)        # 0x7


    J
