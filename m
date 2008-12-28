Return-Path: <linux-kernel-owner+w=401wt.eu-S1755302AbYL1THs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302AbYL1THs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 14:07:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754482AbYL1THj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 14:07:39 -0500
Received: from mx2.redhat.com ([66.187.237.31]:56946 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733AbYL1THi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 14:07:38 -0500
Message-ID: <4957CE78.6030706@redhat.com>
Date: Sun, 28 Dec 2008 21:07:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081119)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>
CC: x86@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       KVM list <kvm@vger.kernel.org>
Subject: Re: [PATCH 0/3] Remove interrupt stack table usage from x86_64 kernel
References: <1230238726-17506-1-git-send-email-avi@redhat.com> <87vdt5vfxc.fsf@basil.nowhere.org> <4956A0B1.1060908@redhat.com> <20081227224029.GB496@one.firstfloor.org> <49573FE7.9090802@redhat.com> <20081228131605.GC496@one.firstfloor.org> <49578896.8030703@redhat.com> <20081228190840.GD496@one.firstfloor.org>
In-Reply-To: <20081228190840.GD496@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> On Sun, Dec 28, 2008 at 04:09:26PM +0200, Avi Kivity wrote:
>   
>> I don't see how syscall could work on i386, and indeed:
>>     
>
> i386 has task gates which support unconditional stack switching. But there 
> are no 64bit task gates, just ISTs.
>
>   

i386 is not that interesting to me (and probably task switching couldn't 
be made to work well with guest state in TR).

> BTW I think there are more similar problems in your patch too.
>   

One fatal problem is enough -- I don't thing that patch can be made to 
work.  Pity since it did clean up some stuff.

I would like however to speed up kvm.  Here's a plan:

1. Add per-cpu IDT
2. When switching to the guest TR (and other state), switch off IST use 
in the current IDT
3. When switching away from the kvm task, restore the IST entries

per-cpu IDT would cost around 4K per cpu.  I propose to make it 
kconfigurable, and have kvm select it.

Ingo, does this sound workable?  It increases complexity rather than 
decreasing it as the previous solution, but I don't see any way to drop 
the use of IST as SYSCALL cannot work without IST if NMIs are enabled.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

