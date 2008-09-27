Return-Path: <linux-kernel-owner+w=401wt.eu-S1754094AbYI0Us6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754094AbYI0Us6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2008 16:48:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbYI0Usu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Sep 2008 16:48:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36135 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbYI0Usu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2008 16:48:50 -0400
Date: Sat, 27 Sep 2008 22:48:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arjan van de Ven <arjan@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: How how latent should non-preemptive scheduling be?
Message-ID: <20080927204834.GA31650@elte.hu>
References: <fa.Jx/Ygtm46CVRawlA6OnfYNn6cN0@ifi.uio.no> <fa.iIHgL48F3T5VAqFw3mqaf9Pzrs4@ifi.uio.no> <fa.Td8xkKZKMSMghlJmEYefTRVF2kc@ifi.uio.no> <48D39312.9000400@yahoo.com> <20080922115749.GE14301@elte.hu> <48D88DB4.9020003@yahoo.com> <20080923115323.GA27240@elte.hu> <48D919A9.5000708@yahoo.com> <48D9460C.5040504@yahoo.com> <48D96725.1080909@yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D96725.1080909@yahoo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sitsofe Wheeler <sitsofe@yahoo.com> wrote:

> Logs with the filtering on can be seen here (15Mbytes decompressed each):
> http://sucs.org/~sits/test/eeepc-debug/20080923/latency_trace.gz
> http://sucs.org/~sits/test/eeepc-debug/20080923/trace.txt.gz
>
> It looks like lots of acpi state is created and deleted...

yeah. The latency starts here:

     cat-5901    0dNh.    1us : default_wake_function (__wake_up_common)
     cat-5901    0.Nh.    2us : kill_fasync (snd_pcm_period_elapsed)
     [...]

and ends here:

     [...]
     cat-5901    0.N.. 270501us+: mutex_lock (acpi_ec_transaction)
     cat-5901    0d... 270507us : __cond_resched (_cond_resched)

270 _milliseconds_ later. That's excessive.

The main overhead is starting here:

     cat-5901    0.N..  167us : acpi_ds_result_push (acpi_ds_exec_end_op)

lots of ACPI code executed ...

does it get better if you have CONFIG_PREEMPT_VOLUNTARY=y enabled? That 
_should_ break up this section neatly. If it doesnt then please add a 
might_sleep() check to kernel/kernel/semaphore.c's down_timeout() 
function - that is called a number of times in this trace.

	Ingo
