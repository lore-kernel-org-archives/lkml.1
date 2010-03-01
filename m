Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751282Ab0CAQOS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 11:14:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844Ab0CAQOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 11:14:17 -0500
Message-ID: <4B8BE7C1.40000@redhat.com>
Date: Mon, 01 Mar 2010 06:13:53 -1000
From: Zachary Amsden <zamsden@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, avi@redhat.com,
       mtosatti@redhat.com
Subject: Re: use of setjmp/longjmp in x86 emulator.
References: <20100301091819.GD16909@redhat.com>
In-Reply-To: <20100301091819.GD16909@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2010 11:18 PM, Gleb Natapov wrote:
> I am looking at improving KVM x86 emulator. Current code does not
> handle some special cases correctly (code execution from ROM, ins/outs
> to/from MMIO) and many exception conditions during instruction emulation
> are not handled correctly. There is a lot of code in emulator that is
> there only for exception propagation. Using setjmp/longjmp will be very
> beneficial here as exception condition during instruction execution
> maps very naturally to setjmp/longjmp, so my question is what about
> adding setjmp/longjmp implementation to the kernel, or alternatively,
> if there is a fear that it can be abused, add it locally to emulator.c?
> Note that instruction emulation is always done in process context.
>    

I'm all for radical ideas, but from a pragmatic point of view, you 
shouldn't use longjmp in the kernel.  Seriously bad things are happening 
with it; it leaves local variables undefined, doesn't undo global state 
changes.

So if you:

spin_lock(&s->lock);
if (!s->active)
     longjmp(buf, -1);

... you are broken.  This case can be made very much more complex and 
hard to reason about by using local variables which are reset by the 
longjmp.

Further, it requires use of the volatile keyword to interact properly 
with logic involving more than one variable, and thus, by definition is 
impossible to use in the kernel, which does not implement the volatile 
keyword.  :)


Instead, for this case, use the fact that there is an architecturally 
designed finite number of exceptions that can be processed 
simultaneously.  This means if you queue exceptions to a pending list of 
control-flow interrupting events to be processed, as long as the queue 
is appropriately sized, you will never overflow this queue and never 
require dynamic allocation.  Further, you can then naturally follow the 
exception priority rules at the top-level of the emulator and never need 
to pass back complex exception structures, merely a simple return value 
which indicates whether to return to top-level control logic or continue 
with instruction emulation.  I believe using this style of programming 
will make your need for setjmp/longjmp go away.

Zach
