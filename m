Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756363Ab0BTEqv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 23:46:51 -0500
Received: from mail-qy0-f179.google.com ([209.85.221.179]:43750 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab0BTEqu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 23:46:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=U663dwe6YvsIoJEbLLcI7ZeEq8z58yHN/zXS3uE0PM/9q9sV1lRjfeBRY5JLaAWp3Q
         ekN0yqm2fLVIYmWn9DgS/LDfMZjDWMPCu7y61PW5Zszt+3/2FSeW5D2wm+aOmbHr0qQK
         /DxScuFPjzBAaBUBOykMkwEiDAe2bj4FTd9jM=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1002180825000.4141@localhost.localdomain>
References: <1264740107.20211.53.camel@pasglop>
	 <1266485775.6539.6.camel@jlt3.sipsolutions.net>
	 <alpine.LFD.2.00.1002180825000.4141@localhost.localdomain>
Date: Sat, 20 Feb 2010 12:46:48 +0800
Message-ID: <2375c9f91002192046u5105db8j4b8a63647d9220ce@mail.gmail.com>
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 12:31 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 18 Feb 2010, Johannes Berg wrote:
>> >
>> > Basically, the machine deadlocks right after printing the following
>> > when doing a shutdown:
>> >
>> > halt/4071 is trying to acquire lock:
>> >  (s_active){++++.+}, at: [<c0000000001ef868>]
>> > .sysfs_addrm_finish+0x58/0xc0
>> >
>> > but task is already holding lock:
>> >  (&per_cpu(cpu_policy_rwsem, cpu)){+.+.+.}, at: [<c0000000004cd6ac>]
>> > .lock_policy_rwsem_write+0x84/0xf4
>> >
>> > which lock already depends on the new lock.
>
> You don't have a full backtrace for these things?
>
> We've had lots of trouble with the cpu governors, and I suspect the
> problem isn't new, but the lockdep warning is likely new (see commit
> 846f99749ab68bbc7f75c74fec305de675b1a1bf: "sysfs: Add lockdep annotations
> for the sysfs active reference").
>
> So it is likely to be an old issue that (a) now gets warned about and (b)
> might have had timing changes enough to trigger it.
>

Right.

This is a real deadlock case found by lockdep added to s_active.

The problem is that we did kobject_put(&data->kobj) while holding policy_rwsem
which is used to protect 'data'. It is not so easy to fix this,
probably we need to
do more work on cpufreq code.

Thanks.
