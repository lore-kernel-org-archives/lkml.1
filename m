Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbZJTUNM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbZJTUNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 16:13:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbZJTUNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 16:13:11 -0400
Received: from smtp171.iad.emailsrvr.com ([207.97.245.171]:46820 "EHLO
	smtp171.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752012AbZJTUNB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 16:13:01 -0400
Message-ID: <4ADE19D0.4060900@librato.com>
Date: Tue, 20 Oct 2009 16:13:04 -0400
From: Oren Laadan <orenl@librato.com>
Organization: Librato
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Matt Helsley <matthltc@us.ibm.com>,
       Daniel Lezcano <daniel.lezcano@free.fr>, randy.dunlap@oracle.com,
       arnd@arndb.de, linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, kosaki.motohiro@jp.fujitsu.com,
       hpa@zytor.com, mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
References: <20091013044925.GA28181@us.ibm.com> <4AD8C7E4.9000903@free.fr>	<20091016194451.GA28706@us.ibm.com> <4ADCCD68.9030003@free.fr>	<4ADCDE7F.4090501@librato.com>	<20091020005125.GG27627@count0.beaverton.ibm.com>	<m1vdiad9jd.fsf@fess.ebiederm.org> <20091020040315.GA26632@us.ibm.com>	<m1iqeauyvl.fsf@fess.ebiederm.org> <20091020183329.GB22646@us.ibm.com> <m1r5sxsw7w.fsf@fess.ebiederm.org>
In-Reply-To: <m1r5sxsw7w.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Eric W. Biederman wrote:
> Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> writes:
> 
>> Eric W. Biederman [ebiederm@xmission.com] wrote:
>> | > Could you clarify ? How is the call to alloc_pidmap() from clone3() different
>> | > from the call from clone() itself ?
>> | 
>> | I think it is totally inappropriate to assign pids in a pid namespace
>> | where there are user space processes already running.
>>
>> Honestly, I don't understand why it is inappropriate or how this differs
>> from normal clone() - which also assigns pids in own and ancestor pid
>> namespaces.
> 
> The fact we can specify which pids we want.  I won't claim it is as
> exploitable as NULL pointer deferences have been but it has that kind
> of feel to it.

This security concern was first brought up by Linus, and to address it
we made clone3() require that the user be privileged to select pids.

But, honestly, a clone3() that allows the caller to request a specific
pid is like a restart() syscall that allows the caller to restore a
process with its original pid:  you would simply checkpoint, and then
alter the pid in the checkpoint image and restart, repeat ad infinitum.

>From your security prism, they are equivalent: they practically allow
a user to have an arbitrary process with a selected pid. So it doesn't
really matter - for this security concern - if you select the pid in
the kernel through restart() or from userspace through clone3().

Sure, you can also "choose" a pid today, by repeatedly forking until
you get what you want... but that is harder to exploit. In contrast,
both clone3() and restart() allow pid selection, instantaneously.
Which is why both require privileges if the caller wants to select/
restore pids.

Oren.

