Return-Path: <linux-kernel-owner+w=401wt.eu-S1761314AbYFDMMV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314AbYFDMMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:12:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760632AbYFDMKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:10:03 -0400
Received: from gw.goop.org ([64.81.55.164]:49971 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760487AbYFDMJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:09:58 -0400
Message-ID: <484685EE.40303@goop.org>
Date: Wed, 04 Jun 2008 13:09:18 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: collapse the various size-dependent percpu	accessors
 together
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <48466BFB.40004@goop.org> <4846725D.4090607@goop.org> <20080604112939.GA27845@elte.hu>
In-Reply-To: <20080604112939.GA27845@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Jeremy Fitzhardinge wrote:
>>     
>>> We can use gcc's %z modifier to emit the appropriate size suffix for
>>> an instruction, so we don't need to duplicate the asm statement for
>>> each size.
>>>       
>> Nah, it's a disaster.  Drop this one.
>>     
>
> hm, what's the problem with it? What you are trying to do here looks 
> like a nice cleanup - assuming it results in the same instructions 
> emitted ;-)

Yes, would have been lovely.  But gcc emits junk:

  CC      arch/x86/xen/enlighten.o
{standard input}: Assembler messages:
{standard input}:637: Error: no such instruction: `movll %gs:per_cpu__xen_vcpu(%rip),%rax'
{standard input}:655: Error: no such instruction: `movll %gs:per_cpu__xen_vcpu(%rip),%rax'
{standard input}:671: Error: no such instruction: `movll %gs:per_cpu__xen_vcpu(%rip),%rax'
{standard input}:682: Error: no such instruction: `movll %gs:per_cpu__xen_vcpu(%rip),%rax'
{standard input}:783: Error: no such instruction: `movll %gs:per_cpu__pda+8(%rip),%rbx'
{standard input}:834: Error: no such instruction: `movll %gs:per_cpu__xen_mc_irq_flags(%rip),%rdi'
{standard input}:901: Error: no such instruction: `movll %gs:per_cpu__pda+8(%rip),%rbx'
{standard input}:978: Error: no such instruction: `movll %gs:per_cpu__xen_mc_irq_flags(%rip),%rdi'
{standard input}:1064: Error: no such instruction: `movll %gs:per_cpu__pda+8(%rip),%rbx'
{standard input}:1110: Error: no such instruction: `movll %gs:per_cpu__xen_mc_irq_flags(%rip),%rdi'
...
  CC      arch/x86/vdso/vclock_gettime.o
{standard input}: Assembler messages:
{standard input}:75: Error: suffix or operands invalid for `movs'
(all over the place)


I tried a version to do 64-bit accesses with an explicit "movq" to solve 
the "movll" problem, but it generates "movs" on occasion and that was 
the point I gave up.

    J
