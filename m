Return-Path: <linux-kernel-owner+w=401wt.eu-S1757839AbXGZHfB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839AbXGZHfB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 03:35:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbXGZHex
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 03:34:53 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:39161 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbXGZHew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 03:34:52 -0400
Date: Thu, 26 Jul 2007 09:34:51 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Albert Cahalan <acahalan@gmail.com>, linux-kernel@vger.kernel.org,
       holt@sgi.com, oleg@tv-sign.ru, roland@redhat.com
Subject: Re: [RFC, PATCH 1/3] introduce SYS_CLONE_MASK
In-Reply-To: <m1646c8c33.fsf@ebiederm.dsl.xmission.com>
Message-ID: <Pine.LNX.4.64.0707260920151.3382@fbirervta.pbzchgretzou.qr>
References: <787b0d920705282023v22316e6bk709dc8d3aa3213d7@mail.gmail.com>
 <m1646c8c33.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


sorry for the really delayed mail..

On May 28 2007 22:53, Eric W. Biederman wrote:
>> Jan Engelhardt writes:
>>> On Apr 10 2007 17:47, Jan Engelhardt wrote:
>>>
>>> Done that and the result is that `ps afwx` now looks like:
>>>
>>>   PID TTY      STAT   TIME COMMAND
>>>  2722 ?        S      0:00 [lockd]
>> ...
>>>     3 ?        S<     0:00 [events/0]
>>>     2 ?        SN     0:00 [ksoftirqd/0]
>>>     1 ?        Ss     0:02 init [3]
>>>   537 ?        S<s    0:02  \_ /sbin/udevd --daemon
>>>  1600 ?        Ss     0:00  \_ /usr/bin/dbus-daemon --system
>>>  1692 ?        Ss     0:00  \_ /sbin/acpid
>>>  1923 ?        Ss     0:00  \_ /sbin/resmgrd
>> ...
>>> -    if(self_pid==1 && ADOPTED(processes[i]) && forest_type!='u')
>>> +    if(ADOPTED(processes[i]) && forest_type!='u')
>>
>> That's not compatible because init's children are now in the
>> logical place. Since the days of procps-1.x.x or earlier,
>> such processes have been listed at top level.
>>
>> BTW, what does "ps -ejH" do for you, with and without the patch?

2.6.22, without kernel patch, ps -ejH (shortened):

  PID  PGID   SID TTY          TIME CMD
    2     0     0 ?        00:00:00 kthreadd
    3     0     0 ?        00:00:00   migration/0
    1     1     1 ?        00:00:00 init
  821   821   821 ?        00:00:00   udevd
 2228  2228  2228 ?        00:00:00   klogd

and `ps afx`:

  PID TTY      STAT   TIME COMMAND
    2 ?        S<     0:00 [kthreadd]
    3 ?        S<     0:00  \_ [migration/0]
    1 ?        Ss     0:00 init [5]  
  821 ?        S<s    0:00 /sbin/udevd --daemon

With procps patch: it's all thrown up again, possibly due to some
kernel patch that made it into 2.6.22.

(ps -ejH)
  PID  PGID   SID TTY          TIME CMD
    2     0     0 ?        00:00:00 kthreadd
    3     0     0 ?        00:00:00   migration/0
    4     0     0 ?        00:00:00   ksoftirqd/0
    1     1     1 ?        00:00:00 init
  821   821   821 ?        00:00:00   udevd
 2228  2228  2228 ?        00:00:00   klogd


(ps afx)
  PID TTY      STAT   TIME COMMAND
    2 ?        S<     0:00 [kthreadd]
    3 ?        S<     0:00 [migration/0]
    4 ?        SN     0:00 [ksoftirqd/0]
    1 ?        Ss     0:00 init [5]  
  821 ?        S<s    0:00 /sbin/udevd --daemon
 2228 ?        Ss     0:00 /sbin/klogd -c 5 -2 -x


(procps 3.2.7, the one used back when this thread was alive :^))

>ps -ejH displays everything.

So does `ps afx` for me ;-)

>For 2.6.22 we will only have kthreadd
>as a sibling of init with ppid == 0.  Depending on what happens
>in the evolution of how we start kernel thread we may be able
>to remove kthreadd and have all kthreads with a ppid of 0, but only
>time will tell.
>

	Jan
-- 
