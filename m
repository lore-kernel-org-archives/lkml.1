Return-Path: <linux-kernel-owner+w=401wt.eu-S1763815AbYBMIIu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763815AbYBMIIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:08:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755002AbYBMIIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:08:41 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:37974 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbYBMIIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:08:40 -0500
Message-ID: <47B2A3F3.8060701@ak.jp.nec.com>
Date: Wed, 13 Feb 2008 17:01:55 +0900
From: Kohei KaiGai <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: "Andrew G. Morgan" <morgan@kernel.org>, akpm@osdl.org, jmorris@namei.org,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH] exporting capability code/name pairs (try #4)
References: <47997122.3070504@ak.jp.nec.com> <479990A1.3050103@kernel.org> <4799CAE0.7010400@ak.jp.nec.com> <47A2AB60.5000403@ak.jp.nec.com> <20080204162103.GA20130@sergelap.ibm.com> <47A91B00.9080301@ak.jp.nec.com> <20080206050805.GD3258@sergelap.austin.ibm.com> <47AC23F1.5030300@ak.jp.nec.com> <20080212180859.GA12876@sergelap.austin.ibm.com>
In-Reply-To: <20080212180859.GA12876@sergelap.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting Kohei KaiGai (kaigai@ak.jp.nec.com):
>> diff --git a/security/Kconfig b/security/Kconfig
>> index 25ffe1b..b79e830 100644
>> --- a/security/Kconfig
>> +++ b/security/Kconfig
>> @@ -91,6 +91,15 @@ config SECURITY_FILE_CAPABILITIES
>>
>>  	  If in doubt, answer N.
>>
>> +config SECURITY_CAPABILITIES_EXPORT
>> +	bool "Exporting capabilities kernel supported"
>> +	depends on SECURITY_CAPABILITIES && SYSFS
> 
> Oh no, we're being bit by this again...  When SECURITY=n, capabilities
> are compiled in but SECURITY_CAPABILITIES=n.
> 
> Months ago I floated the following patch so we'd have a CONFIG variable
> to let us know whether commoncap is compiled in.  You might want to use
> this and depend on CONFIG_COMMONCAP?  (Though really I personally don't
> think you need your own config variable for this)

I also think its own config variable is not necessary to turn on/off
exporting the list of capabilities in actually.
Do you want this feture to be moved into security/commoncap.c and
enabled unconditionally? I can agree this suggestion.

Is there any complaint for this idea?

Thanks,

> Other than that, this tested fine for me.
> 
> thanks,
> -serge
> 
>>From 54c70ca7671750fe8986451fae91d42107d0ca90 Mon Sep 17 00:00:00 2001
> From: Serge E. Hallyn <serue@us.ibm.com>
> Date: Fri, 28 Sep 2007 10:33:33 -0500
> Subject: [PATCH 1/2] capabilities: define CONFIG_COMMONCAP
> 
> currently the compilation of commoncap.c is determined
> through Makefile logic.  So there is no single CONFIG
> variable which can be relied upon to know whether it
> will be compiled.
> 
> Define CONFIG_COMMONCAP to be true when lsm is not
> compiled in, or when the capability or rootplug modules
> are compiled.  These are the cases when commoncap is
> currently compiled.  Use this variable in security/Makefile
> to determine commoncap.c's compilation.
> 
> Apart from being a logic cleanup, this is needed by the
> upcoming cap_bset patch so that prctl can know whether
> PR_SET_BSET should be allowed.
> 
> Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> ---
>  security/Kconfig  |    4 ++++
>  security/Makefile |    9 +++------
>  2 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/security/Kconfig b/security/Kconfig
> index 8086e61..02b33fa 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -103,6 +103,10 @@ config SECURITY_ROOTPLUG
>  	  
>  	  If you are unsure how to answer this question, answer N.
>  
> +config COMMONCAP
> +	bool
> +	default !SECURITY || SECURITY_CAPABILITIES || SECURITY_ROOTPLUG
> +
>  source security/selinux/Kconfig
>  
>  endmenu
> diff --git a/security/Makefile b/security/Makefile
> index ef87df2..7cccc81 100644
> --- a/security/Makefile
> +++ b/security/Makefile
> @@ -5,14 +5,11 @@
>  obj-$(CONFIG_KEYS)			+= keys/
>  subdir-$(CONFIG_SECURITY_SELINUX)	+= selinux
>  
> -# if we don't select a security model, use the default capabilities
> -ifneq ($(CONFIG_SECURITY),y)
> -obj-y		+= commoncap.o
> -endif
> +obj-$(CONFIG_COMMONCAP)			+= commoncap.o
>  
>  # Object file lists
>  obj-$(CONFIG_SECURITY)			+= security.o dummy.o inode.o
>  # Must precede capability.o in order to stack properly.
>  obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
> -obj-$(CONFIG_SECURITY_CAPABILITIES)	+= commoncap.o capability.o
> -obj-$(CONFIG_SECURITY_ROOTPLUG)		+= commoncap.o root_plug.o
> +obj-$(CONFIG_SECURITY_CAPABILITIES)	+= capability.o
> +obj-$(CONFIG_SECURITY_ROOTPLUG)		+= root_plug.o


-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>
