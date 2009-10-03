Return-Path: <linux-kernel-owner+w=401wt.eu-S1754406AbZJCAhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406AbZJCAhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 20:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754249AbZJCAhp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 20:37:45 -0400
Received: from smtp.zeugmasystems.com ([70.79.96.174]:28847 "EHLO
	zeugmasystems.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752905AbZJCAhp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 20:37:45 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: futex question
Date: Fri, 2 Oct 2009 17:36:59 -0700
Message-ID: <DDFD17CC94A9BD49A82147DDF7D545C501FD860D@exchange.ZeugmaSystems.local>
In-Reply-To: <4AC68F13.8050601@us.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: futex question
Thread-Index: AcpDuaEJm9inU+QuSZSRrSkhr+R1qAAA6tcQ
References: <DDFD17CC94A9BD49A82147DDF7D545C501FD7F97@exchange.ZeugmaSystems.local> <20091001092218.GH15345@elte.hu> <DDFD17CC94A9BD49A82147DDF7D545C501FD8409@exchange.ZeugmaSystems.local> <4AC68F13.8050601@us.ibm.com>
From: "Anirban Sinha" <ASinha@zeugmasystems.com>
To: "Darren Hart" <dvhltc@us.ibm.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       <linux-kernel@vger.kernel.org>,
       "Kaz Kylheku" <KKylheku@zeugmasystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>
>Thanks for sending the patch.  I'm looking into it now.  Couple
questions:
>
>1) What caused you to instrument this path in the first place?  Were
you
>seeing some unexpected behavior?

Basically, all this started as a means to aid debug or at least isolate
cases of memory corruption. When a process holding a futex died, the
robust futex cleanup operation can be foiled if there are any memory
corruptions in the user land. The "carefully inspecting the user land
linked list" part would bail out silently. So no process would get
EOWNERDEAD and wake up. So we decided to add printks so that we can
track these silent return cases.

We thought that actual number of cases of silently bailing out would be
rare so we did not expect any of those logs in the kernel buffer under
regular circumstances. To our surprise, we found lots of those logs!
This puzzled us.  I looked at the code again and again but it deed some
seem to have any issues. Then it occurred to us (kaz) that an execve()
call can also cause invalid pointer values to remain in the task
structure. I did some testing and it seemed to indicate that this was
indeed the case.

There is a discussion on this by Kaz on the linux mips mailing list:

http://www.linux-mips.org/archives/linux-mips/2009-09/msg00130.html



>
>2) I wonder why we would need to clear the robust list, but I don't see
>other things like pi_blocked_on, etc. in execve being cleared. 

Yea, may be. We don't use pi-futexes, so not too much confident of the
pi futex codebase there. You can look into those too.


 I'm
>looking into this now (perhaps we don't do the same cleanup, need to
>check).... have to get on the plane...

Have a good trip and thanks for looking into it. :)

Ani

>>
>>
>> Signed-off-by: Anirban Sinha <asinha@zeugmasystems.com>
>> ---
>>  fs/compat.c |    3 +++
>>  fs/exec.c   |    3 +++
>>  2 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/fs/compat.c b/fs/compat.c
>> index 6d6f98f..c3d117c 100644
>> --- a/fs/compat.c
>> +++ b/fs/compat.c
>> @@ -1510,6 +1510,9 @@ int compat_do_execve(char * filename,
>>         if (retval)
>>                 goto out_file;
>>
>> +#ifdef CONFIG_FUTEX
>> +       current->compat_robust_list = NULL;
>> +#endif
>>         bprm->argc = compat_count(argv, MAX_ARG_STRINGS);
>>         if ((retval = bprm->argc) < 0)
>>                 goto out;
>> diff --git a/fs/exec.c b/fs/exec.c
>> index 172ceb6..e9334b8 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -1323,6 +1323,9 @@ int do_execve(char * filename,
>>         retval = bprm_mm_init(bprm);
>>         if (retval)
>>                 goto out_file;
>> +#ifdef CONFIG_FUTEX
>> +       current->robust_list = NULL;
>> +#endif
>>
>>         bprm->argc = count(argv, MAX_ARG_STRINGS);
>>         if ((retval = bprm->argc) < 0)
>>
>>
>
>
>--
>Darren Hart
>IBM Linux Technology Center
>Real-Time Linux Team
