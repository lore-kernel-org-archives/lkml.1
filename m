Return-Path: <linux-kernel-owner+w=401wt.eu-S1757151AbZBTQ6z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151AbZBTQ6z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 11:58:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753771AbZBTQ6p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 11:58:45 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:51451 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054AbZBTQ6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 11:58:44 -0500
Message-ID: <499EE162.4050008@oracle.com>
Date: Fri, 20 Feb 2009 08:59:14 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, zippel@linux-m68k.org,
       linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] tracing/markers: make markers select tracepoints
References: <499edf47.1818d00a.060b.2b8d@mx.google.com>
In-Reply-To: <499edf47.1818d00a.060b.2b8d@mx.google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.499EE12B.0184:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frederic Weisbecker wrote:
> Sometimes it happens that KConfig dependencies are not handled
> like in the following scenario:
> 
> - config A
>    bool
> 
> - config B
>    bool
>    depends on A
> 
> -config C
>    bool
>    select B
> 
> If one selects C, then it will select B without checking its dependency to A, if A
> hasn't been selected elsewhere, it will result in a build crash.

as documented in Documentation/kbuild/kconfig-language.txt (and yes, it is
considered to be a shortcoming/problem by most people AFAIK):

  Note:
	select should be used with care. select will force
	a symbol to a value without visiting the dependencies.
	By abusing select you are able to select a symbol FOO even
	if FOO depends on BAR that is not set.
	In general use select only for non-visible symbols
	(no prompts anywhere) and for symbols with no dependencies.
	That will limit the usefulness but on the other hand avoid
	the illegal configurations all over.
	kconfig should one day warn about such things.

> This is what happens on the following build error:
> 
> kernel/built-in.o: In function `marker_update_probe_range':
> (.text+0x52f64): undefined reference to `tracepoint_probe_register_noupdate'
> kernel/built-in.o: In function `marker_update_probe_range':
> (.text+0x52f74): undefined reference to `tracepoint_probe_unregister_noupdate'
> kernel/built-in.o: In function `marker_update_probe_range':
> (.text+0x52fb9): undefined reference to `tracepoint_probe_unregister_noupdate'
> kernel/built-in.o: In function `marker_update_probes':
> marker.c:(.text+0x530ba): undefined reference to `tracepoint_probe_update_all'
> 
> CONFIG_KVM_TRACE will select CONFIG_MARKER, but the latter depends on CONFIG_TRACEPOINTS
> which will not be selected.
> 
> A temporary fix is to make CONFIG_MARKER select CONFIG_TRACEPOINTS, though it doesn't
> fix the source KConfig dependency handling problem.
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Cc: Roman Zippel <zippel@linux-m68k.org>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  init/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index b6400a5..a93f957 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -975,7 +975,7 @@ config TRACEPOINTS
>  
>  config MARKERS
>  	bool "Activate markers"
> -	depends on TRACEPOINTS
> +	select TRACEPOINTS
>  	help
>  	  Place an empty function call at each marker site. Can be
>  	  dynamically changed for a probe function.

but using "select" instead of "depends on" just causes the kind of problem
that you described, whereas using "depends on" does follow dependency
chains.

-- 
~Randy
