Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbZLBNZV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbZLBNZV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 08:25:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754158AbZLBNZU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 08:25:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753975AbZLBNZS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 08:25:18 -0500
Message-ID: <4B166ABC.9040004@redhat.com>
Date: Wed, 02 Dec 2009 15:25:16 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Nix <nix@esperi.org.uk>
CC: kvm@vger.kernel.org,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>,
       Marcelo Tosatti <mtosatti@redhat.com>
Subject: Re: 2.6.31.5 x86-64 KVM: 'emulation failed (pagetable) rip 7fb49335da7b
 66 0f 7f 07'
References: <87skbzvdgd.fsf@spindle.srvr.nix> <4B125051.6010506@redhat.com> <87k4x9saqn.fsf@spindle.srvr.nix> <4B1283F5.5060204@redhat.com>
In-Reply-To: <4B1283F5.5060204@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2009 04:23 PM, Avi Kivity wrote:
> On 11/29/2009 03:48 PM, Nix wrote:
>> On 29 Nov 2009, Avi Kivity uttered the following:
>>> 66 0f 7f 07              movdqa %xmm0,(%rdi)
>>>
>>> which we don't emulate.
>> x86-64 glibc 2.10 memset(), perhaps? On SSE-capable platforms that does
>> a whole bunch of
>>
>> L(SSE0QB):  movdqa %xmm0,-0xb0(%rdi)
>> L(SSE0QA):  movdqa %xmm0,-0xa0(%rdi)
>> L(SSE0Q9):  movdqa %xmm0,-0x90(%rdi)
>> L(SSE0Q8):  movdqa %xmm0,-0x80(%rdi)
>> L(SSE0Q7):  movdqa %xmm0,-0x70(%rdi)
>> L(SSE0Q6):  movdqa %xmm0,-0x60(%rdi)
>> L(SSE0Q5):  movdqa %xmm0,-0x50(%rdi)
>> L(SSE0Q4):  movdqa %xmm0,-0x40(%rdi)
>> L(SSE0Q3):  movdqa %xmm0,-0x30(%rdi)
>> L(SSE0Q2):  movdqa %xmm0,-0x20(%rdi)
>> L(SSE0Q1):  movdqa %xmm0,-0x10(%rdi)
>> L(SSE0Q0):  retq
>>
>> (multiple blocks of this, catering for alignment, I guess)
>>
>> and x86-64 is always SSE-capable.
>
> Most likely, either this or something similar is called on a userspace 
> device driver.  Can you check if this is triggered by starting X?
>
> If so, we'll have to emulate this instruction, which will be a bitch.
>

Not just in the emulator, also in the userspace interface.  We only 
support up to 8 bytes mmio.

Our options in fixing this are:

- extend mmio support to 16 (32? more?) bytes, require new kernel and 
new userspace
- use coalesced_mmio for this
    - if the mmio happens for a non coalesced mmio region, we flush 
immediately
    - what if userspace doesn't support coalesced mmio? (unlikely these 
days)
    - doesn't work for reads (unlikely for 16 byte accesses?)

-- 
error compiling committee.c: too many arguments to function

