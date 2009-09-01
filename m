Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbZIAPNz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbZIAPNz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 11:13:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753007AbZIAPNy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 11:13:54 -0400
Received: from mail-px0-f204.google.com ([209.85.216.204]:36173 "EHLO
	mail-px0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246AbZIAPNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 11:13:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=beoiw2uNgRpJcMPUZ6dYauEyG9K7FromwJYqY9T+YDbBQH3motR4JFE8PqhOq3S5cN
         b9zxcU6jjuE0GeufJljGgipTUlb9f+PNvXoXfOhPLWMgngNraI7CJoiXHOERS/XtJ0/v
         AnAHQAxb5QuC3zwTdEGoLlU1PIjDNgPjqRrRE=
Date: Tue, 1 Sep 2009 23:17:20 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Yinghai Lu <yinghai@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zachary Amsden <zach@vmware.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] x86: introduce parse_early_param_alone() to parse
	param early (Was Re: linux-next: reservetop fix disables mem= )
Message-ID: <20090901151720.GC5394@hack>
References: <Pine.LNX.4.64.0908241736520.32764@sister.anvils> <4A92D029.8090807@kernel.org> <4A948C4A.8040004@cn.fujitsu.com> <4A9CD362.9010906@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A9CD362.9010906@cn.fujitsu.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 03:55:14PM +0800, Xiao Guangrong wrote:
>Hi Ingo,
>
>I find the broken patch is still in -tip tree:
>
>Commit-ID:  8126dec32738421afa362114337331337b4be17f
>Gitweb:     http://git.kernel.org/tip/8126dec32738421afa362114337331337b4be17f
>Author:     Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>AuthorDate: Thu, 20 Aug 2009 20:23:11 +0800
>Committer:  Ingo Molnar <mingo@elte.hu>
>CommitDate: Fri, 21 Aug 2009 16:40:30 +0200
>
>x86: Fix system crash when loading with "reservetop" parameter
>
>So, this patch is base on it.
>---------------------------------------------
>Subject: [RFC][PATCH] x86: introduce parse_early_param_alone() to parse param before parse_early_param()
>
>Sometimes, we should parse specific boot parameter alone before
>parse_early_param(), such as "reservetop" and "early_ioremap_debug",
>like below:
>
>> The main problem is that can't parse 'reservetop' and 'mem'/'memmap'
>> parameters at the same time, because we should parse 'mem'/'memmap'
>> after e820 map detected, and it might use early_memremap() during
>> e820 map detecting, so we should call early_ioremap_init() before it,
>> 'reservetop' parameter can change 'FIXADDR_TOP', so we parse
>> 'reservetop' first,
>> 
>> like below sequences:
>>   ......
>>   ___parse 'reservetop'___  ->
>>   early_ioremap_init()	  ->
>>   setup_memory_map(); /* might call early_memremap()*/  ->
>>   parse_setup_data(); /* might call early_memremap()*/  ->
>>   e820_reserve_setup_data();	->
>>   ___parse 'mem'/'memmap' and other parameters___
>>   ......
>> 
>> (the same as 'early_ioremap_debug' parameter)
>> 
>> So, I'm afraid that we need separate parse 'reservetop'/
>> 'early_ioremap_debug' parameters early
>> 
>
>This patch introduce a new api named parse_early_param_alone() to
>do this.
>
>Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
>---
> arch/x86/kernel/setup.c |   33 ++++++++++++++++++------------
> include/linux/init.h    |    1 +
> init/main.c             |   50 +++++++++++++++++++++++++++++++++++++++++++++++
> 3 files changed, 71 insertions(+), 13 deletions(-)
>
>diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
>index 83ea092..f241c12 100644
>--- a/arch/x86/kernel/setup.c
>+++ b/arch/x86/kernel/setup.c
>@@ -696,10 +696,28 @@ void __init setup_arch(char **cmdline_p)
> 	printk(KERN_INFO "Command line: %s\n", boot_command_line);
> #endif
> 
>+#ifdef CONFIG_CMDLINE_BOOL
>+#ifdef CONFIG_CMDLINE_OVERRIDE
>+	strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
>+#else
>+	if (builtin_cmdline[0]) {
>+		/* append boot loader cmdline to builtin */
>+		strlcat(builtin_cmdline, " ", COMMAND_LINE_SIZE);
>+		strlcat(builtin_cmdline, boot_command_line, COMMAND_LINE_SIZE);
>+		strlcpy(boot_command_line, builtin_cmdline, COMMAND_LINE_SIZE);
>+	}
>+#endif
>+#endif


This seems ugly.

CMDLINE_OVERRIDE depends on CMDLINE_BOOL, right? So the outer #ifdef
can be removed. :)


-- 
Live like a child, think like the god.
 
