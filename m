Return-Path: <linux-kernel-owner+w=401wt.eu-S1752220AbYFVHkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbYFVHkg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 03:40:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751109AbYFVHk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 03:40:26 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:41015 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbYFVHkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 03:40:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent:from;
        b=sdehbOsTbABNpgFlRjm0ic8KgthEJcImt9nz6CA1Jq+FCTAdLE9RiRX0HLtCpEqrn5
         0nfojBiF6wWHLxsxSonkD2MqMrGLha5OTJwaEH/6G6t2qLbd6hrpYzILqFExcu3rCVY/
         iVFvG1CbuomciA/nQdrGn2gJUUjaAzTwz9d4k=
Date: Sun, 22 Jun 2008 09:40:18 +0200
To: Johannes Weiner <hannes@saeurebad.de>
Cc: Ingo Molnar <mingo@elte.hu>, Philippe Elie <phil.el@wanadoo.fr>,
       oprofile-list@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/oprofile: disable preemption in nmi_shutdown
Message-ID: <20080622074018.GA3163@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878wwylyej.fsf@skyscraper.fehenstaub.lan>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jun 22, 2008 at 9:30 AM, Johannes Weiner <hannes@saeurebad.de> wrote:
> Vegard Nossum <vegard.nossum@gmail.com> writes:
>>  static void nmi_shutdown(void)
>>  {
>> -     struct op_msrs *msrs = &__get_cpu_var(cpu_msrs);
>> +     struct op_msrs *msrs;
>> +
>> +     preempt_disable();
>> +     msrs = &__get_cpu_var(cpu_msrs);
>>       nmi_enabled = 0;
>>       on_each_cpu(nmi_cpu_shutdown, NULL, 0, 1);
>>       unregister_die_notifier(&profile_exceptions_nb);
>>       model->shutdown(msrs);
>>       free_msrs();
>> +     preempt_enable();
>
> Have a look at get_cpu_var() and put_cpu_var(), that is exactly the
> pattern.

Thanks! How about this instead?


Vegard


From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Sat, 21 Jun 2008 23:44:19 +0200
Subject: [PATCH] x86/oprofile: disable preemption in nmi_shutdown

    BUG: using smp_processor_id() in preemptible [00000000] code: oprofiled/27301
    caller is nmi_shutdown+0x11/0x60
    Pid: 27301, comm: oprofiled Not tainted 2.6.26-rc7 #25
     [<c028a90d>] debug_smp_processor_id+0xbd/0xc0
     [<c045fba1>] nmi_shutdown+0x11/0x60
     [<c045dd4a>] oprofile_shutdown+0x2a/0x60

Note that we don't need this for the other functions, since they are all
called with on_each_cpu() (which disables preemption for us anyway).

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/oprofile/nmi_int.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/oprofile/nmi_int.c b/arch/x86/oprofile/nmi_int.c
index cc48d3f..2b6ad5b 100644
--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -269,12 +269,13 @@ static void nmi_cpu_shutdown(void *dummy)
 
 static void nmi_shutdown(void)
 {
-	struct op_msrs *msrs = &__get_cpu_var(cpu_msrs);
+	struct op_msrs *msrs = &get_cpu_var(cpu_msrs);
 	nmi_enabled = 0;
 	on_each_cpu(nmi_cpu_shutdown, NULL, 0, 1);
 	unregister_die_notifier(&profile_exceptions_nb);
 	model->shutdown(msrs);
 	free_msrs();
+	put_cpu_var(cpu_msrs);
 }
 
 static void nmi_cpu_start(void *dummy)
-- 
1.5.4.1

