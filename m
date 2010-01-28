Return-Path: <linux-kernel-owner+w=401wt.eu-S1754415Ab0A1VBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab0A1VBm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 16:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062Ab0A1VBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 16:01:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754017Ab0A1VBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 16:01:41 -0500
Message-ID: <4B61FABA.6000600@redhat.com>
Date: Thu, 28 Jan 2010 15:59:38 -0500
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 4/9] perf session: Create kernel maps in the constructor
References: <1264633557-17597-1-git-send-email-acme@infradead.org> <1264633557-17597-4-git-send-email-acme@infradead.org> <4B60C9A6.10704@redhat.com> <20100127232936.GI12567@ghostprotocols.net> <4B61BB2D.70802@redhat.com> <20100128182951.GB2499@ghostprotocols.net>
In-Reply-To: <20100128182951.GB2499@ghostprotocols.net>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> Em Thu, Jan 28, 2010 at 11:28:29AM -0500, Masami Hiramatsu escreveu:
> 
>> Yeah, and if you can separate an interface only for handling symbols
>> from debug/elf binaries, it will be helpful for me too.
> 
> It was done on this same series, now you can do as the patch at the end
> of this message, that will be on my next series, does.

Great! thank you!

> 
> Testing with this patch:
> 
> [root@doppio ~]# perf probe --list
> [root@doppio ~]# perf probe schedule
> Added new event:
>   probe:schedule                           (on schedule+0)
> 
> You can now use it on all perf tools, such as:
> 
> 	perf record -e probe:schedule -a sleep 1
> 
> [root@doppio ~]# perf record -e probe:schedule -a sleep 1
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.158 MB perf.data (~6923 samples) ]
> [root@doppio ~]# perf report | head -9
> # Samples: 4
> #
> # Overhead          Command          Shared Object  Symbol
> # ........  ...............  .....................  ......
> #
>     25.00%             perf  libc-2.10.2.so         [.] __GI___libc_read
>     25.00%      kondemand/1  [kernel.kallsyms]      [k] kernel_thread_helper
>     25.00%      kondemand/0  [kernel.kallsyms]      [k] kernel_thread_helper
> [root@doppio ~]#
> 
> And what about support for modules? You have everything you need there
> as well :-)
> 
> If you do:
> 
> 	struct map *mod;
> 	struct symbol *sym;
> 
> 	mod = map_groups__find_by_name(&session.kmap_groups,
> 				       MAP__FUNCTION, "[ipv6]");
> 
> 	sym = map__find_symbol_by_name(module, "ip6_xmit");
> 
> you'll get ipv6.ko located and loaded, mod->dso->long_name thus will
> have the file to use with libdwarf and sym->start will have the
> unrelocated address, and mod->start will have where ipv6 is loaded in
> kernel space

Oh, nice :-) Is that available for the modules which aren't loaded?
And yeah, I'd like to support modules and it will requires some
enhancement in kprobe-tracer too.

.
> Also you should be able to find variables by name or address too, just
> use MAP__VARIABLE where above you see MAP__FUNCTION.
> 
> - Arnaldo
> 
> From 387ab05301cce32c8b091ba9feb94c906124e8a8 Mon Sep 17 00:00:00 2001
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> Date: Thu, 28 Jan 2010 16:12:31 -0200
> Subject: [PATCH 1/1] perf probe: Don't use a perf_session instance just to resolve symbols
> MIME-Version: 1.0
> Content-Type: text/plain; charset=utf-8
> Content-Transfer-Encoding: 8bit
> 
> With the recent modifications done to untie the session and symbol
> layers, 'perf probe' now can use just the symbols layer.

Could you remove session.kmap too?
other parts look good to me.

Thank you,

> 
> Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Paul Mackerras <paulus@samba.org>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/builtin-probe.c |   15 +++++++++------
>  1 files changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
> index 4fa73ec..cd45e02 100644
> --- a/tools/perf/builtin-probe.c
> +++ b/tools/perf/builtin-probe.c
> @@ -41,7 +41,6 @@
>  #include "util/debugfs.h"
>  #include "util/symbol.h"
>  #include "util/thread.h"
> -#include "util/session.h"
>  #include "util/parse-options.h"
>  #include "util/parse-events.h"	/* For debugfs_path */
>  #include "util/probe-finder.h"
> @@ -59,7 +58,8 @@ static struct {
>  	int nr_probe;
>  	struct probe_point probes[MAX_PROBES];
>  	struct strlist *dellist;
> -	struct perf_session *psession;
> +	struct map_groups kmap_groups;
> +	struct map *kmaps[MAP__NR_TYPES];
>  	struct map *kmap;


>  	struct line_range line_range;
>  } session;
> @@ -212,10 +212,13 @@ static void init_vmlinux(void)
>  		pr_debug("Use vmlinux: %s\n", symbol_conf.vmlinux_name);
>  	if (symbol__init() < 0)
>  		die("Failed to init symbol map.");
> -	session.psession = perf_session__new(NULL, O_WRONLY, false);
> -	if (session.psession == NULL)
> -		die("Failed to init perf_session.");
> -	session.kmap = session.psession->vmlinux_maps[MAP__FUNCTION];
> +
> +	map_groups__init(&session.kmap_groups);
> +	if (map_groups__create_kernel_maps(&session.kmap_groups,
> +					   session.kmaps) < 0)
> +		die("Failed to create kernel maps.");
> +
> +	session.kmap = session.kmaps[MAP__FUNCTION];
>  	if (!session.kmap)
>  		die("Could not find kernel map.\n");
>  }

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America), Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

