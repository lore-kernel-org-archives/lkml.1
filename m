Return-Path: <linux-kernel-owner+w=401wt.eu-S1759353AbZLOJww@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759353AbZLOJww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 04:52:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759558AbZLOJwr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 04:52:47 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:35409 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759553AbZLOJwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 04:52:45 -0500
Date: Tue, 15 Dec 2009 10:52:14 +0100
From: Ingo Molnar <mingo@elte.hu>
To: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
       paulus@samba.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, shemminger@vyatta.com,
       paulmck@linux.vnet.ibm.com, fweisbec@gmail.com, tglx@linutronix.de
Subject: Re: [tip:perf/diff] perf diff: Introduce tool to show performance
 difference
Message-ID: <20091215095214.GA749@elte.hu>
References: <1260828571-3613-3-git-send-email-acme@infradead.org>
 <tip-86a9eee047ba09a714c3b8e27c9df2bbf715393a@git.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tip-86a9eee047ba09a714c3b8e27c9df2bbf715393a@git.kernel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


'perf diff' looks to be very useful!

I think we want to improve the default output some more:

For example there should be column names like for perf report:

# Overhead    Command                 Shared Object  Symbol
# ........  .........  ............................  ......
#
    13.87%  hackbench  [kernel]                      [k] _raw_spin_lock
     5.60%  hackbench  [kernel]                      [k] copy_user_generic_string
     5.23%  hackbench  [kernel]                      [k] __cache_free

Secondly, here's the current output of two successive 'hackbench 10' run:

   1 +2381        +58         [kernel.kallsyms]   avc_has_perm_noaudit
   2              -26         [kernel.kallsyms]   clear_page_c
   3  +107        +29         [kernel.kallsyms]   _raw_spin_lock
   4  +106        +23         [kernel.kallsyms]   _raw_spin_lock
   5  +105        +22         [kernel.kallsyms]   _raw_spin_lock
   6  +104        +21         [kernel.kallsyms]   _raw_spin_lock
   7  +103        +20         [kernel.kallsyms]   _raw_spin_lock
   8  +102        +20         [kernel.kallsyms]   _raw_spin_lock
   9  +101        +19         [kernel.kallsyms]   _raw_spin_lock
  10    -6        -28         [kernel.kallsyms]   selinux_task_wait
  11   +99        +18         [kernel.kallsyms]   _raw_spin_lock
  12   +98        +18         [kernel.kallsyms]   _raw_spin_lock
  13   +97        +18         [kernel.kallsyms]   _raw_spin_lock
  14   +96        +18         [kernel.kallsyms]   _raw_spin_lock
  15  +220        +20         [kernel.kallsyms]   _raw_spin_lock_irqsave
  16   +94        +17         [kernel.kallsyms]   _raw_spin_lock
  17   +93        +17         [kernel.kallsyms]   _raw_spin_lock
  18   +92        +16         [kernel.kallsyms]   _raw_spin_lock
  19 +9648        +30         [kernel.kallsyms]   copy_page_c
  20   +90        +15         [kernel.kallsyms]   _raw_spin_lock
  21   +89        +15         [kernel.kallsyms]   _raw_spin_lock

beyond the missing column names, there's some other things visible too:

 - the symbol names are per pid, so they repeat all over again. I think we 
want the default output to be like perf report's, i.e. PIDs get summarized 
over commands.

Furthermore, i think -p should be enabled by default. Especially with a lot of 
functions the +/- notation isnt very obvious at first sight.

I.e. output like this would be more useful i think:

    baseline    delta   command        symbol
    -----------------------------------------------------------
      13.87%    +0.11%  hackbench  [k]  _raw_spin_lock
       5.60%    -2.53%  hackbench  [k]  copy_user_generic_string
       5.23%    -0.14%  hackbench  [k] __cache_free
       4.30%    -2.59%  hackbench  [k] unix_stream_recvmsg
       3.35%    -1.56%  hackbench  [k] avc_has_perm_noaudit
    -----------------------------------------------------------
    Sum:
       0.51% +- 0.05% less time elapsed

The relative position can be printed too but should not necessarily be the 
default. Printing the delta in elapsed time is also very important, because 
not only do we want to know the after/before profile delta, we also want to 
see the tangible result in elapsed time - via the same tool.

Btw., i think we also want a "--repeat N" feature for perf record, to allow 
the recording of the same command over and over again, so that a higher 
quality profile can be achieved.

"perf record -f --repeat 10 cmd" would be a convenience shortcut for:

  rm -f perf.data
  for ((i=0; i<10; i++)); do
    perf record -A cmd
  done

Thanks,

	Ingo
