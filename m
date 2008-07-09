Return-Path: <linux-kernel-owner+w=401wt.eu-S1755335AbYGISrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755335AbYGISrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 14:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753411AbYGISrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 14:47:15 -0400
Received: from gw.goop.org ([64.81.55.164]:33732 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296AbYGISrO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 14:47:14 -0400
Message-ID: <487507A1.2020100@goop.org>
Date: Wed, 09 Jul 2008 11:46:57 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Christoph Lameter <cl@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F4F2.9010603@goop.org> <4874F7D9.5060607@linux-foundation.org> <4874FD52.8070000@sgi.com> <4874FFC4.7050505@linux-foundation.org> <487502FB.3090106@sgi.com>
In-Reply-To: <487502FB.3090106@sgi.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> Christoph Lameter wrote:
>   
>> Mike Travis wrote:
>>
>>     
>>> I think Jeremy's point is that by removing the pda struct entirely, the
>>> references to the fields can be the same for both x86_32 and x86_64.
>>>       
>> That is going to be difficult. The GS register is tied up for the pda area
>> as long as you have it. And you cannot get rid of the pda because of the library
>> compatibility issues. We would break binary compatibility if we would get rid of the pda.
>>
>> If one attempts to remove one field after another then the converted accesses will not be able to use GS relative accesses anymore. This can lead to all sorts of complications.
>>
>> It will be possible to shrink the pda (as long as we maintain the fields that glibc needs) after this patchset because the pda and the per cpu area can both be reached with the GS register. So (apart from undiscovered surprises) the generated code is the same.
>>     
>
> Is there a comprehensive list of these library accesses to variables
> offset from %gs, or is it only the "stack_canary"?

It's just the stack canary.  It isn't library accesses; it's the code 
gcc generates:

foo:	subq	$152, %rsp
        movq    %gs:40, %rax
        movq    %rax, 136(%rsp)
...
        movq    136(%rsp), %rdx
        xorq    %gs:40, %rdx
        je      .L3
        call    __stack_chk_fail
.L3:
        addq    $152, %rsp
        .p2align 4,,4
        ret


There are two irritating things here:

One is that the kernel supports -fstack-protector for x86-64, which 
forces us into all these contortions in the first place.  We don't 
support stack-protector for 32-bit (gcc does), and things are much easier.

The other somewhat orthogonal irritation is the fixed "40".  If they'd 
generated %gs:__gcc_stack_canary, then we could alias that to a per-cpu 
variable like anything else and the whole problem would go away - and we 
could support stack-protector on 32-bit with no problems (and normal 
usermode could define __gcc_stack_canary to be a weak symbol with value 
"40" (20 on 32-bit) for backwards compatibility).

I'm close to proposing that we run a post-processor over the generated 
assembly to perform the %gs:40 -> %gs:__gcc_stack_canary transformation 
and deal with it that way.

    J
