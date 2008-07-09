Return-Path: <linux-kernel-owner+w=401wt.eu-S1754841AbYGIVlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841AbYGIVlf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751086AbYGIVl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:41:27 -0400
Received: from gw.goop.org ([64.81.55.164]:40882 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750885AbYGIVl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:41:26 -0400
Message-ID: <4875307A.6050602@goop.org>
Date: Wed, 09 Jul 2008 14:41:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu> <48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org> <4875209D.8010603@goop.org> <48752CCD.30507@linux-foundation.org>
In-Reply-To: <48752CCD.30507@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Jeremy Fitzhardinge wrote:
>
>   
>> No, it makes no difference.  %gs:X always has a 32-bit offset in the
>> instruction, regardless of how big X is:
>>
>>     mov %eax, %gs:0
>>     mov %eax, %gs:0x1234567
>> ->
>>   0:    65 89 04 25 00 00 00 00    mov    %eax,%gs:0x0
>>   8:    65 89 04 25 67 45 23 01    mov    %eax,%gs:0x1234567
>>     
>
> The processor itself supports smaller offsets.
>   

Not in 64-bit mode.  In 32-bit mode you can use the addr16 prefix, but 
that would only save a byte per use (and I doubt it's a fast-path in the 
processor).

> Note also that the 32 bit offset size limits the offset that can be added to the segment register. You either need to place the per cpu area either in the last 2G of the address space or in the first 2G. The zero based approach removes that limitation.
>   

No.  The %gs base is a full 64-bit value you can put anywhere in the 
address space.  So long as your percpu data is within 2G of that point 
you can get to it directly.


>>   0:    65 89 05 00 00 00 00     mov    %eax,%gs:0(%rip)        # 0x7
>>     
>
> RIP relative also implies a 32 bit offset meaning that the code cannot be more than 2G away from the per cpu area.
>   

It means the percpu symbols must be within 2G of your code.  We can't 
compile the kernel any other way (there's no -mcmodel=large-kernel).

    J
