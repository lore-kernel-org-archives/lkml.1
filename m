Return-Path: <linux-kernel-owner+w=401wt.eu-S1758887AbZHRMuJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758887AbZHRMuJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 08:50:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758878AbZHRMuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 08:50:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:27060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758877AbZHRMuG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 08:50:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,402,1246863600"; 
   d="scan'208";a="542341710"
From: "Metzger, Markus T" <markus.t.metzger@intel.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: "tglx@linutronix.de" <tglx@linutronix.de>, "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
Date: Tue, 18 Aug 2009 13:49:57 +0100
Subject: RE: [PATCH] perf_counter: Fix a race on perf_counter_ctx
Thread-Topic: [PATCH] perf_counter: Fix a race on perf_counter_ctx
Thread-Index: AcoZwPH32O+eE+8/TDeninUWmRiuXwAjFfggAARFOmABZBQJ8A==
Message-ID: <928CFBE8E7CB0040959E56B4EA41A77EC1CB7725@irsmsx504.ger.corp.intel.com>
References: <928CFBE8E7CB0040959E56B4EA41A77EC1BFEFEB@irsmsx504.ger.corp.intel.com>
 <20090807103127.GA23139@elte.hu> <20090807103610.GA23728@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF02D@irsmsx504.ger.corp.intel.com>
 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF048@irsmsx504.ger.corp.intel.com>
 <20090807112421.GB30014@elte.hu> <20090807113349.GA31673@elte.hu>
 <1249667341.17467.5.camel@twins> <20090808120315.GA14086@elte.hu>
 <928CFBE8E7CB0040959E56B4EA41A77EC1BFF464@irsmsx504.ger.corp.intel.com>
 <20090810134608.GA8295@elte.hu>
  <928CFBE8E7CB0040959E56B4EA41A77EC1BFF78D@irsmsx504.ger.corp.intel.com>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77EC1BFF78D@irsmsx504.ger.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo, Peter,

Did you say that branch tracing is working for you?

On my system, the kernel hangs.

Could it be that it simply takes too long to copy the trace? When I set the number
of samples to 10, everything seems to work OK. When I increase that number to 1000,
the kernel is getting very slow and eventually hangs.

I get a message "hrtimer: interrupt too slow", and I get a soft lockup bug. The rest
of the message log seems pretty garbled.

In that case, I should probably defer the perf_counter_output() and simply switch
buffers in the interrupt handler. This would use twice as much locked memory, though, and
it will likely lose trace when tracing kernel branches. I would further need to make
sure that the counter does not go away when I do the perf_counter_output(). If possible,
I should also stall the task until its trace has been processed.

All in all, it adds complexity and makes the feature more expensive. If you think that
this could cause the problem of the hanging kernel, I would give it a try.


One more thing, Peter's patch seems to make the problem appear much more reliably
than before. Without the patch, I only got the kernel hang when I ran perf top
in the background. Now, the kernel hangs for every perf record that uses branch
tracing. This could give another hint to the problem, but I did not find anything
when I looked at the patch. Do you have any idea, Peter?


thanks,
markus.


>>>* Metzger, Markus T <markus.t.metzger@intel.com> wrote:
>>>
>>>> I've been using some old version of perf. When I try to build the
>>>> version for the latest -tip, I get the following build error:
>>>>
>>>> builtin-annotate.o: In function `print_summary':
>>>> /home/markus/linux/git-tip/tools/perf/builtin-annotate.c:1211: undefined reference to `rb_first'
>>>> /home/markus/linux/git-tip/tools/perf/builtin-annotate.c:1223: undefined reference to `rb_next'
>>>> builtin-annotate.o: In function `insert_source_line':
>>>
>>>Weird. How do you build perf? Do you do:
>>>
>>>  cd tools/perf/
>>>  make
>>>
>>>? does your build directory have the ../../lib/rbtree.c file?
>>
>>Yes and yes.
>
>
>The rbtree object file does not seem to be an ELF file (see below).
>
>When I have gcc generate an assembly file and generate the object with a
>separate call to gcc, I can build perf.
>
>When I say "perf record -f -e branches -c 1", the kernel hangs.
>
>You said that this is working for you?
>
>regards,
>markus.
>
>----
>
>[markus@labpc212 perf]$ gcc --version
>gcc (GCC) 4.3.2 20081105 (Red Hat 4.3.2-7)
>Copyright (C) 2008 Free Software Foundation, Inc.
>This is free software; see the source for copying conditions.  There is NO
>warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
>
>[markus@labpc212 perf]$ file *.o util/*.o
>builtin-annotate.o:   ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>builtin-help.o:       ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>builtin-list.o:       ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>builtin-record.o:     ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>builtin-report.o:     ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>builtin-stat.o:       ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>builtin-top.o:        ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>perf.o:               ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/abspath.o:       ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/alias.o:         ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/callchain.o:     ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/color.o:         ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/config.o:        ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/ctype.o:         ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/environment.o:   ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/exec_cmd.o:      ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/header.o:        ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/help.o:          ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/levenshtein.o:   ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/module.o:        ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/pager.o:         ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/parse-events.o:  ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/parse-options.o: ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/path.o:          ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/quote.o:         ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/rbtree.o:        data
>util/run-command.o:   ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/sigchain.o:      ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/strbuf.o:        ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/string.o:        ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/strlist.o:       data
>util/symbol.o:        ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/usage.o:         ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/values.o:        ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>util/wrapper.o:       ELF 64-bit LSB relocatable, x86-64, version 1 (SYSV), not stripped
>[markus@labpc212 perf]$
---------------------------------------------------------------------
Intel GmbH
Dornacher Strasse 1
85622 Feldkirchen/Muenchen Germany
Sitz der Gesellschaft: Feldkirchen bei Muenchen
Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
Registergericht: Muenchen HRB 47456 Ust.-IdNr.
VAT Registration No.: DE129385895
Citibank Frankfurt (BLZ 502 109 00) 600119052

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

