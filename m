Return-Path: <linux-kernel-owner+w=401wt.eu-S1756978AbZJLOj7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978AbZJLOj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 10:39:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756889AbZJLOj6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 10:39:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756892AbZJLOj5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 10:39:57 -0400
Message-ID: <4AD33FD9.5080207@redhat.com>
Date: Mon, 12 Oct 2009 10:40:25 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Christoph Hellwig <hch@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [PATCH tracing/kprobes v4] perf: Add perf probe subcommand for
 	kprobe-event setup helper
References: <4ACE56EE.8060000@redhat.com>	 <20091008211737.29299.14784.stgit@dhcp-100-2-132.bos.redhat.com> <c62985530910120331g42ff49a3pd043ef9c6923143e@mail.gmail.com>
In-Reply-To: <c62985530910120331g42ff49a3pd043ef9c6923143e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frédéric Weisbecker wrote:
> 2009/10/8 Masami Hiramatsu <mhiramat@redhat.com>:
>> Add perf probe subcommand for kprobe-event setup helper to perf command.
>> This allows user to define kprobe events by C expressions (C line numbers,
>> C function names, and C local variables).
>>
>> Usage
>> -----
>>  perf probe [<options>] -P 'PROBEDEF' [-P 'PROBEDEF' ...]
>>
>>    -k, --vmlinux <file>  vmlinux/module pathname
>>    -P, --probe <p|r:[GRP/]NAME FUNC[+OFFS][@SRC]|@SRC:LINE [ARG ...]>
>>                          probe point definition, where
>>                p:      kprobe probe
>>                r:      kretprobe probe
>>                GRP:    Group name (optional)
>>                NAME:   Event name
>>                FUNC:   Function name
>>                OFFS:   Offset from function entry (in byte)
>>                SRC:    Source code path
>>                LINE:   Line number
>>                ARG:    Probe argument (local variable name or
>>                        kprobe-tracer argument format is supported.)
>>
>> Changes in v4:
>>  - Add _GNU_SOURCE macro for strndup().
>>
>> Changes in v3:
>>  - Remove -r option because perf always be used for online kernel.
>>  - Check malloc/calloc results.
>>
>> Changes in v2:
>>  - Check synthesized string length.
>>  - Rename perf kprobe to perf probe.
>>  - Use spaces for separator and update usage comment.
>>  - Check error paths in parse_probepoint().
>>  - Check optimized-out variables.
>>
>> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Cc: Mike Galbraith <efault@gmx.de>
>> Cc: Paul Mackerras <paulus@samba.org>
>> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Cc: Christoph Hellwig <hch@infradead.org>
>> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> Cc: Jim Keniston <jkenisto@us.ibm.com>
>> Cc: Frank Ch. Eigler <fche@redhat.com>
>> ---
>>
> [...]
>> +/* Default vmlinux search paths */
>> +#define NR_SEARCH_PATH 3
>> +const char *default_search_path[NR_SEARCH_PATH] = {
>> +"/lib/modules/%s/build/vmlinux",               /* Custom build kernel */
>> +"/usr/lib/debug/lib/modules/%s/vmlinux",       /* Red Hat debuginfo */
>> +"/boot/vmlinux-debug-%s",                      /* Ubuntu */
>> +};
> [...]
>> +static int open_default_vmlinux(void)
>> +{
>> +       struct utsname uts;
>> +       char fname[MAX_PATH_LEN];
>> +       int fd, ret, i;
>> +
>> +       ret = uname(&uts);
>> +       if (ret) {
>> +               debug("uname() failed.\n");
>> +               return -errno;
>> +       }
>> +       session.release = uts.release;
>> +       for (i = 0; i < NR_SEARCH_PATH; i++) {
>> +               ret = snprintf(fname, MAX_PATH_LEN,
>> +                              default_search_path[i], session.release);
>> +               if (ret >= MAX_PATH_LEN || ret < 0) {
>> +                       debug("Filename(%d,%s) is too long.\n", i, uts.release);
>> +                       errno = E2BIG;
>> +                       return -E2BIG;
>> +               }
>> +               debug("try to open %s\n", fname);
>> +               fd = open(fname, O_RDONLY);
>> +               if (fd >= 0)
>> +                       break;
>> +       }
>> +       return fd;
>> +}
> 
> 
> We have a kind of kernel path finder already inside perf. It might be
> encapsulated
> inside the load_kernel() helper, I don't remember exactly.
> 
> It would be better to make use of such centralized and already
> existing facility.

Agreed. AFAICS, load_kernel() is currently only for symbol resolver,
and we can make it for dwarf analyzer too.

> 
> The patchset looks good. I'll apply and push it soon.

Thanks!

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

