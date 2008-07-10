Return-Path: <linux-kernel-owner+w=401wt.eu-S1760836AbYGJRd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760836AbYGJRd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:33:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756157AbYGJRdu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:33:50 -0400
Received: from gw.goop.org ([64.81.55.164]:38961 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804AbYGJRdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:33:49 -0400
Message-ID: <487647EF.5010609@goop.org>
Date: Thu, 10 Jul 2008 10:33:35 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christoph Lameter <cl@linux-foundation.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <48751CF9.4020901@linux-foundation.org>	<4875209D.8010603@goop.org> <48752CCD.30507@linux-foundation.org>	<m1wsjupuiz.fsf@frodo.ebiederm.org> <48753C99.5050408@goop.org> <m1ej62iq9z.fsf@frodo.ebiederm.org> <487555A8.2050007@zytor.com> <487556A5.5090907@goop.org> <4876194E.4080205@linux-foundation.org> <48761C06.3020003@zytor.com> <48762A3B.5050104@linux-foundation.org> <48762DD2.5090802@zytor.com> <487637A1.4080403@linux-foundation.org> <487639ED.7000502@zytor.com> <48763CA6.9030802@linux-foundation.org>
In-Reply-To: <48763CA6.9030802@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Lameter wrote:
> H. Peter Anvin wrote:
>
>   
>> It will, but it might still be a net loss due to higher load on the TLB
>> (you're effectively using the TLB to do the table lookup for you.)  On
>> the other hand, Mike points out that once we move away from fixed-sized
>> segments we pretty much have to use virtual addresses anyway(*).
>>     
>
> There will be no additional overhead since the memory already mapped 1-1 using 2MB TLBs and we want to use the same for the percpu areas. This is similar to the vmemmap solution.
>
>   
>>> The first percpu area would ideally be the per cpu segment generated
>>> by the linker.
>>>
>>> How would that fit into the address map? In particular the 2G distance
>>> between code and the first per cpu area must not be violated unless we
>>> go to a zero based approach.
>>>       
>> If with "zero-based" you mean "nonzero gs_base for the boot CPU" then
>> yes, you're right.
>>
>> Note again that that is completely orthogonal to RIP-based versus absolute.
>>     
>
> ?? The distance to the per cpu area for cpu 0 is larger than 2G. Kernel wont link with RIP based addresses. You would have to place the per cpu areas 1TB before the kernel text.

If %gs:0 points to start of your percpu area, then all the offsets off 
%gs are going to be no larger than the amount of percpu memory you 
have.  The gs base itself can be any 64-bit address, so it doesn't 
matter where it is within overall kernel memory.  Using zero-based 
percpu area means that you must set a non-zero %gs base before you can 
access the percpu area.

If the layout of the percpu area is done by the linker by packing all 
the percpu variables into one section, then any address computation 
using a percpu variable symbol will generate an offset which is 
appropriate to apply to a %gs: addressing mode.

The nice thing about the non-zero-based scheme i386 uses is that setting 
gs-base to zero means that percpu variables accesses get directly to the 
prototype percpu data area, which simplifies boot time setup (which is 
doubly awkward on 32-bit because you need to generate a GDT entry rather 
than just load an MSR as you do in 64-bit).

    J
