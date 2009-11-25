Return-Path: <linux-kernel-owner+w=401wt.eu-S934593AbZKYJDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934593AbZKYJDe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 04:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934493AbZKYJDd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 04:03:33 -0500
Received: from lo.gmane.org ([80.91.229.12]:36106 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934489AbZKYJDb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 04:03:31 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tim Blechmann <tim@klingt.org>
Subject: Re: [tip:sched/core] sched, x86: Optimize branch hint in    __switch_to()
Date: Wed, 25 Nov 2009 10:03:12 +0100
Message-ID: <4B0CF2D0.90600@klingt.org>
References: <4B0BBB93.3080307@klingt.org>	 <tip-a3a1de0c34de6f5f8332cd6151c46af7813c0fcb@git.kernel.org> <73c1f2160911240928j69cbf65dx4a2747a06c7ca43d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
Cc: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de, tim@kl
X-Gmane-NNTP-Posting-Host: 85-127-156-204.dynamic.xdsl-line.inode.at
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.6pre) Gecko/20091121 Shredder/3.0.1pre
In-Reply-To: <73c1f2160911240928j69cbf65dx4a2747a06c7ca43d@mail.gmail.com>
X-Enigmail-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/24/2009 06:28 PM, Brian Gerst wrote:
> On Tue, Nov 24, 2009 at 11:57 AM, tip-bot for Tim Blechmann
> <tim@klingt.org> wrote:
>> Commit-ID:  a3a1de0c34de6f5f8332cd6151c46af7813c0fcb
>> Gitweb:     http://git.kernel.org/tip/a3a1de0c34de6f5f8332cd6151c46af7813c0fcb
>> Author:     Tim Blechmann <tim@klingt.org>
>> AuthorDate: Tue, 24 Nov 2009 11:55:15 +0100
>> Committer:  Ingo Molnar <mingo@elte.hu>
>> CommitDate: Tue, 24 Nov 2009 12:20:04 +0100
>>
>> sched, x86: Optimize branch hint in __switch_to()
>>
>> Branch hint profiling on my nehalem machine showed 96%
>> incorrect branch hints:
>>
>>  6548732 174664120  96 __switch_to                    process_64.c
>>    406
>>  6548745 174565593  96 __switch_to                    process_64.c
>>    410
>>
>> Signed-off-by: Tim Blechmann <tim@klingt.org>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Cc: Mike Galbraith <efault@gmx.de>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> LKML-Reference: <4B0BBB93.3080307@klingt.org>
>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>> ---
>>  arch/x86/kernel/process_64.c |    5 ++---
>>  1 files changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
>> index ad535b6..d9db104 100644
>> --- a/arch/x86/kernel/process_64.c
>> +++ b/arch/x86/kernel/process_64.c
>> @@ -406,11 +406,10 @@ __switch_to(struct task_struct *prev_p, struct task_struct *next_p)
>>         * This won't pick up thread selector changes, but I guess that is ok.
>>         */
>>        savesegment(es, prev->es);
>> -       if (unlikely(next->es | prev->es))
>> +       if (next->es | prev->es)
>>                loadsegment(es, next->es);
>> -
>>        savesegment(ds, prev->ds);
>> -       if (unlikely(next->ds | prev->ds))
>> +       if (next->ds | prev->ds)
>>                loadsegment(ds, next->ds);
>>
>>
> 
> 64-bit tasks should have %ds and %es set to null selectors.  The only
> time they should be different is for 32-bit tasks.
	
this doesn't seem to be the case on my machine for 96% of the calls ...
i am just running 64bit binaries on this machine, no 32bit programs
(that i know of (ubuntu karmic amd64))

tim

- -- 
tim@klingt.org
http://tim.klingt.org

Relying on the government to protect your privacy is like asking a
peeping tom to install your window blinds.
  John Perry Barlow
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksM8s0ACgkQdL+4qsZfVsscjwCffcvQz7/VTtIfH1XXgJ2SxJxT
xWYAnjZ9aBD/OWmroVn68oEKqJZ7Pm3U
=C7kB
-----END PGP SIGNATURE-----

