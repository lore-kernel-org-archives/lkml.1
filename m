Return-Path: <linux-kernel-owner+w=401wt.eu-S1755469AbYGIV0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469AbYGIV0e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751562AbYGIV0Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:26:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39607 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750955AbYGIV0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:26:25 -0400
Message-ID: <48752CCD.30507@linux-foundation.org>
Date: Wed, 09 Jul 2008 16:25:33 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Ingo Molnar <mingo@elte.hu>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu> <48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org> <4875209D.8010603@goop.org>
In-Reply-To: <4875209D.8010603@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:

> No, it makes no difference.  %gs:X always has a 32-bit offset in the
> instruction, regardless of how big X is:
> 
>     mov %eax, %gs:0
>     mov %eax, %gs:0x1234567
> ->
>   0:    65 89 04 25 00 00 00 00    mov    %eax,%gs:0x0
>   8:    65 89 04 25 67 45 23 01    mov    %eax,%gs:0x1234567

The processor itself supports smaller offsets.

Note also that the 32 bit offset size limits the offset that can be added to the segment register. You either need to place the per cpu area either in the last 2G of the address space or in the first 2G. The zero based approach removes that limitation.


>>  It also is easier to handle since __per_cpu_start does not figure
>> in the calculation of the offsets.
>>   
> 
> No, you do it the same as i386.  You set the segment base to be
> percpu_area-__per_cpu_start, and then just refer to %gs:per_cpu__foo
> directly.  You can use rip-relative addressing to make it a smaller
> addressing mode too:
> 
>   0:    65 89 05 00 00 00 00     mov    %eax,%gs:0(%rip)        # 0x7

RIP relative also implies a 32 bit offset meaning that the code cannot be more than 2G away from the per cpu area.
