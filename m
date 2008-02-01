Return-Path: <linux-kernel-owner+w=401wt.eu-S934993AbYBAHid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934993AbYBAHid (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2008 02:38:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933845AbYBAHgR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Feb 2008 02:36:17 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50584 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763979AbYBAHgO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2008 02:36:14 -0500
Date: Thu, 31 Jan 2008 23:36:26 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: yi.y.yang@intel.com
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.24] Add new string functions strict_strto* and
 convert kernel params to use them, take 2
Message-Id: <20080131233626.2a91d534.akpm@linux-foundation.org>
In-Reply-To: <1201817503.3925.5.camel@yangyi-dev.bj.intel.com>
References: <1199441414.19185.9.camel@yangyi-dev.bj.intel.com>
	<1201043126.3861.5.camel@yangyi-dev.bj.intel.com>
	<1201562058.12722.9.camel@yangyi-dev.bj.intel.com>
	<1201650080.3875.1.camel@yangyi-dev.bj.intel.com>
	<1201742302.6500.7.camel@yangyi-dev.bj.intel.com>
	<1201817503.3925.5.camel@yangyi-dev.bj.intel.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Feb 2008 06:11:43 +0800 Yi Yang <yi.y.yang@intel.com> wrote:

> This patch is a resend, it changes previous name "real_" to "strict_" 
> according to Randy Dunlap's feedback. Please consider to apply. thanks.
> 
> Currently, for every sysfs node, the callers will be responsible for
> implementing store operation, so many many callers are doing duplicate
> things to validate input, they have the same mistakes because they are
> calling simple_strtol/ul/ll/uul, especially for module params, they are
> just numeric, but you can echo such values as 0x1234xxx, 07777888 and
> 1234aaa, for these cases, module params store operation just ignores
> succesive invalid char and converts prefix part to a numeric although
> input is acctually invalid.
> 
> This patch tries to fix the aforementioned issues and implements strict_strtox
> serial functions, kernel/params.c uses them to strictly validate input,
> so module params will reject such values as 0x1234xxxx and returns an error:
> 
> write error: Invalid argument
> 
> Any modules which export numeric sysfs node can use strict_strtox instead of
> simple_strtox to reject any invalid input.
> 
> Here are some test results:
> 
> Before applying this patch:
> 
> [root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
> 4096
> [root@yangyi-dev /]# echo 0x1000 > /sys/module/e1000/parameters/copybreak
> [root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
> 4096
> [root@yangyi-dev /]# echo 0x1000g > /sys/module/e1000/parameters/copybreak
> [root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
> 4096
> [root@yangyi-dev /]# echo 0x1000gggggggg > /sys/module/e1000/parameters/copybreak
> [root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
> 4096
> [root@yangyi-dev /]# echo 010000 > /sys/module/e1000/parameters/copybreak
> [root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
> 4096
> [root@yangyi-dev /]# echo 0100008 > /sys/module/e1000/parameters/copybreak
> [root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
> 4096
> [root@yangyi-dev /]# echo 010000aaaaa > /sys/module/e1000/parameters/copybreak
> [root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
> 4096
> [root@yangyi-dev /]#
> 
> 
> After applying this patch:
> 
> [root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
> 4096
> [root@yangyi-dev /]# echo 0x1000 > /sys/module/e1000/parameters/copybreak
> [root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
> 4096
> [root@yangyi-dev /]# echo 0x1000g > /sys/module/e1000/parameters/copybreak
> -bash: echo: write error: Invalid argument
> [root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
> 4096
> [root@yangyi-dev /]# echo 0x1000gggggggg > /sys/module/e1000/parameters/copybreak
> -bash: echo: write error: Invalid argument
> [root@yangyi-dev /]# echo 010000 > /sys/module/e1000/parameters/copybreak
> [root@yangyi-dev /]# echo 0100008 > /sys/module/e1000/parameters/copybreak
> -bash: echo: write error: Invalid argument
> [root@yangyi-dev /]# echo 010000aaaaa > /sys/module/e1000/parameters/copybreak
> -bash: echo: write error: Invalid argument
> [root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
> 4096
> [root@yangyi-dev /]# echo -n 4096 > /sys/module/e1000/parameters/copybreak
> [root@yangyi-dev /]# cat /sys/module/e1000/parameters/copybreak
> 4096
> [root@yangyi-dev /]#
> 

Oh dear.  So if someone has an existing script which does

	echo 0x1000g > /sys/module/e1000/parameters/copybreak

we just broke their setup.

This is what happens when we screw up kernel interfaces: we should remain
bug-for-bug compatible with earlier releases.  argh, we suck :(

I'm inclined to merge it anyway - everyone already knows we suck, and
not many people will be affected and they suck too.

