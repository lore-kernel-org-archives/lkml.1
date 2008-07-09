Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbYGIVnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbYGIVnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYGIVnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:43:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56252 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbYGIVnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:43:15 -0400
Message-ID: <48752F5D.9090807@zytor.com>
Date: Wed, 09 Jul 2008 17:36:29 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu> <48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org> <4875209D.8010603@goop.org> <48752CCD.30507@linux-foundation.org>
In-Reply-To: <48752CCD.30507@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> Jeremy Fitzhardinge wrote:
> 
>> No, it makes no difference.  %gs:X always has a 32-bit offset in the
>> instruction, regardless of how big X is:
>>
>>     mov %eax, %gs:0
>>     mov %eax, %gs:0x1234567
>> ->
>>   0:    65 89 04 25 00 00 00 00    mov    %eax,%gs:0x0
>>   8:    65 89 04 25 67 45 23 01    mov    %eax,%gs:0x1234567
> 
> The processor itself supports smaller offsets.

No, it doesn't, unless you have a base register.  There is no naked 
disp8 form, and disp16 is only available in 16- or 32-bit mode (and in 
32-bit form it requires a 67h prefix.)

> Note also that the 32 bit offset size limits the offset that can be added to the segment register. You either need to place the per cpu area either in the last 2G of the address space or in the first 2G. The zero based approach removes that limitation.

The offset is either ±2 GB from the segment register, or ±2 GB from the 
segment register plus %rip.  The latter is more efficient.

The processor *does* permit a 64-bit absolute form, which can be used 
with a segment register, but that one is hideously restricted (only move 
to/from %rax) and bloated (10 bytes!)

>>   0:    65 89 05 00 00 00 00     mov    %eax,%gs:0(%rip)        # 0x7
> 
> RIP relative also implies a 32 bit offset meaning that the code cannot be more than 2G away from the per cpu area.

Not from the per cpu area, but from the linked address of the per cpu 
area (the segment register base can point anywhere.)

In our case means between -2 GB and a smallish positive value (I believe 
it is guaranteed to be 2 MB or more.)

Being able to use %rip-relative forms would save a byte per reference, 
which is valuable.

	-hpa
