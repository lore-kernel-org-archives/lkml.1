Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab0CCVjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 16:39:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39481 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753284Ab0CCVjk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 16:39:40 -0500
Message-ID: <4B8ED702.8070403@redhat.com>
Date: Wed, 03 Mar 2010 16:39:14 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc11 Thunderbird/3.0.3
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jason Baron <jbaron@redhat.com>
Subject: Re: [PATCH -tip 2/2] x86: Issue at least one memory barrier in	stop_machine_text_poke().
References: <20100303212656.25645.48466.stgit@localhost6.localdomain6> <20100303212703.25645.50986.stgit@localhost6.localdomain6> <20100303213614.GA29880@Krystal>
In-Reply-To: <20100303213614.GA29880@Krystal>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
>> Fix stop_machine_text_poke() to issue smp_mb() before exiting waiting
>> loop. Also, use ACCESS_ONCE() to check a flag according to Mathieu's
>> comment.
>>
>> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Jason Baron <jbaron@redhat.com>
>> ---
>>
>>  arch/x86/kernel/alternative.c |    6 +++---
>>  1 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
>> index 635e4f4..3236a11 100644
>> --- a/arch/x86/kernel/alternative.c
>> +++ b/arch/x86/kernel/alternative.c
>> @@ -596,9 +596,9 @@ static int __kprobes stop_machine_text_poke(void *data)
>>  		smp_wmb();	/* Make sure other cpus see that this has run */
>>  		wrote_text = 1;
>>  	} else {
>> -		while (!wrote_text)
>> -			smp_rmb();
>> -		sync_core();
>> +		while (!ACCESS_ONCE(wrote_text))
> 
> Well, cpu_relax() has a "memory" clobber, so the access once is not required to
> ensure the variable is re-read. And, sorry to contradict my previous statement
> somewhat, but given that we don't care if the compiler fetches wrote_text in
> chunks or not, ACCESS_ONCE() is not required here. So rather than leaving people
> wondering why we put an ACCESS_ONCE() here, it's probably better to leave it
> out.

Ah, OK. Indeed, volatile is for compiler...

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
