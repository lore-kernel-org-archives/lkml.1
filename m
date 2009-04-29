Return-Path: <linux-kernel-owner+w=401wt.eu-S1753429AbZD2KMU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753429AbZD2KMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 06:12:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbZD2KMG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 06:12:06 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:49693 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbZD2KMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 06:12:05 -0400
Message-ID: <49F827F1.8010308@monstr.eu>
Date: Wed, 29 Apr 2009 12:12:01 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, john.williams@petalogix.com
Subject: Re: [PATCH 20/30] microblaze_mmu_v1: uaccess MMU update
References: <1240821139-7247-1-git-send-email-monstr@monstr.eu>	<1240821139-7247-6-git-send-email-monstr@monstr.eu>	<1240821139-7247-7-git-send-email-monstr@monstr.eu>	<1240821139-7247-8-git-send-email-monstr@monstr.eu>	<1240821139-7247-9-git-send-email-monstr@monstr.eu>	<1240821139-7247-10-git-send-email-monstr@monstr.eu>	<1240821139-7247-11-git-send-email-monstr@monstr.eu>	<1240821139-7247-12-git-send-email-monstr@monstr.eu>	<1240821139-7247-13-git-send-email-monstr@monstr.eu>	<1240821139-7247-14-git-send-email-monstr@monstr.eu>	<1240821139-7247-15-git-send-email-monstr@monstr.eu>	<1240821139-7247-16-git-send-email-monstr@monstr.eu>	<1240821139-7247-17-git-send-email-monstr@monstr.eu>	<1240821139-7247-18-git-send-email-monstr@monstr.eu>	<1240821139-7247-19-git-send-email-monstr@monstr.eu>	<1240821139-7247-20-git-send-email-monstr@monstr.eu>	<1240821139-7247-21-git-send-email-monstr@monstr.eu> <20090428225352.4a54f277.akpm@linux-foundation.org>
In-Reply-To: <20090428225352.4a54f277.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Mon, 27 Apr 2009 10:32:09 +0200 monstr@monstr.eu wrote:
> 
>> +#define __clear_user(addr, n)	(memset((void *)(addr), 0, (n)), 0)
> 
> __clear_user() already takes a void* argument, so the cast is hopefully
> unneeded and undesirable.  The same applies to many other
> architectures.  If someone is passing a non-pointer type to
> __clear_user() then that's potentially a bad thing which we want to
> know about.
> 

Please look at fs/signalfd.c:72. that's the reason why I need __clear_user macro
first parameter is pointer to struct signalfd_siginfo __user.

memset function has the following parameters.
void *memset(void *v_src, int c, __kernel_size_t n)

That's why is cast there. I think that I have to add __force parameter
because without it is there address space mishmash.

Without cast
CHECK   fs/signalfd.c
fs/signalfd.c:72:8: warning: incorrect type in argument 1 (different address spaces)
fs/signalfd.c:72:8:    expected void *<noident>
fs/signalfd.c:72:8:    got struct signalfd_siginfo [noderef] <asn:1>*uinfo

With current cast (void *)
CHECK   fs/signalfd.c
fs/signalfd.c:72:8: warning: cast removes address space of expression

Here is that change which remove address space problem.

#define __clear_user(addr, n)	(memset((__force void *)(addr), 0, (n)), 0)

Am I right?

The same mishmash is for memset_fromio/memset_toio and maybe some others which I want to fix too.

Thanks,
Michal


> IOW, someone screwed up and everyone copied it :(
> 






-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
