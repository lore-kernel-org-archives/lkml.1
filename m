Return-Path: <linux-kernel-owner+w=401wt.eu-S1756365AbZEUWsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbZEUWsy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 18:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbZEUWsr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 18:48:47 -0400
Received: from claw.goop.org ([74.207.240.146]:45500 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986AbZEUWsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 18:48:47 -0400
Message-ID: <4A15DA4E.2090505@goop.org>
Date: Thu, 21 May 2009 15:48:46 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Chuck Ebbert <cebbert@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, "Xin, Xiaohui" <xiaohui.xin@intel.com>,
       "Li, Xin" <xin.li@intel.com>, "Nakajima, Jun" <jun.nakajima@intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: Performance overhead of paravirt_ops on native identified
References: <4A0B62F7.5030802@goop.org> <20090521184233.3c3e97ad@dhcp-100-2-144.bos.redhat.com>
In-Reply-To: <20090521184233.3c3e97ad@dhcp-100-2-144.bos.redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chuck Ebbert wrote:
> On Wed, 13 May 2009 17:16:55 -0700
> Jeremy Fitzhardinge <jeremy@goop.org> wrote:
>
>   
>> Paravirt patching turns all the pvops calls into direct calls, so
>> _spin_lock etc do end up having direct calls.  For example, the compiler
>> generated code for paravirtualized _spin_lock is:
>>
>> <_spin_lock+0>:		mov    %gs:0xb4c8,%rax
>> <_spin_lock+9>:		incl   0xffffffffffffe044(%rax)
>> <_spin_lock+15>:	callq  *0xffffffff805a5b30
>> <_spin_lock+22>:	retq
>>
>> The indirect call will get patched to:
>> <_spin_lock+0>:		mov    %gs:0xb4c8,%rax
>> <_spin_lock+9>:		incl   0xffffffffffffe044(%rax)
>> <_spin_lock+15>:	callq <__ticket_spin_lock>
>> <_spin_lock+20>:	nop; nop		/* or whatever 2-byte nop */
>> <_spin_lock+22>:	retq
>>
>>     
>
> Can't those calls be changed to jumps?
>   

In this specific instance of this example, yes.  But if you start 
enabling various spinlock debug options then there'll be code following 
the call.  It would be hard for the runtime patching machinery to know 
when it would be safe to do the substitution.

    J

