Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYF2Ldt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYF2Ldt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 07:33:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754841AbYF2Ldl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 07:33:41 -0400
Received: from il.qumranet.com ([212.179.150.194]:57037 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754703AbYF2Ldk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 07:33:40 -0400
Message-ID: <48677313.8000804@qumranet.com>
Date: Sun, 29 Jun 2008 14:33:39 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Agner Fog <agner@agner.org>, Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: ABI change for device drivers using future AVX instruction set
References: <48626514.2040905@agner.org> <20080625092224.736c2541@infradead.org> <4862ECAB.1040402@zytor.com> <4864CFA5.9050901@agner.org> <20080627072231.7337ba18@infradead.org> <4865F0DA.2050906@agner.org> <87myl5pyqo.fsf@basil.nowhere.org> <4866541F.1060709@agner.org> <20080628200231.GA21259@one.firstfloor.org>
In-Reply-To: <20080628200231.GA21259@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>   
>> list. I had to actually look into the source code of kernel_fpu_begin to 
>> verify that it saves not only the FPU but also the XMM registers and 
>> that it disables pre-emption.
>>     
>
> The requirement to disable preemption is one reason why XMM in 
> a driver is not a good idea BTW.  XMM should be normally only
> used when you plan to spend a lot of CPU cycles (otherwise
> the cost of saving the state is not amortized by the improvements).
>
> But keeping preemption disabled for a long time is considered
> unfriendly because it increases kernel latencies and might 
> in the worst case cause visible scheduling problems like skipping audio
> etc. 
>   

This is fixable.  We could change kernel_fpu_begin() not to disable 
preemption, but instead set a task flag.  When we get the "no device" 
fault, if the flag is set, save the fpu state into the kernel fpu save 
area instead of the user fpu save area.  Similar logic for restoring the 
fpu state.

kvm runs with the guest fpu context while in the host kernel, using 
preempt notifiers to achieve the same thing.

-- 
error compiling committee.c: too many arguments to function

