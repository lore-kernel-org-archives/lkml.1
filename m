Return-Path: <linux-kernel-owner+w=401wt.eu-S1759962AbXKHMNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759962AbXKHMNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 07:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758461AbXKHMNH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 07:13:07 -0500
Received: from ro-out-1112.google.com ([72.14.202.181]:14527 "EHLO
	ro-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758458AbXKHMNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 07:13:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:reply-to:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=buqFVoNqiKqn+kgTOqYRh6NPa0CApGXlheKHwgprz7Cz9Ln826dO14yFWarYVKvItmopZkw7B2ffhK6Lxs82r5730bJM/G2/x1l3XL0dHCOy4GqWt9Uhq4kxAUWJOhE95xPOyLfOE/XsgmppkTpvCUkQF7MjwcJdz4jv9rRXS2M=
Date: Thu, 8 Nov 2007 20:11:17 +0800
From: WANG Cong <xiyou.wangcong@gmail.com>
To: Miao Xie <miaox@cn.fujitsu.com>
Cc: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] time: fix
	sysfs_show_{available,current}_clocksources() buffer overflow
	problem
Message-ID: <20071108121117.GG2479@hacking>
Reply-To: WANG Cong <xiyou.wangcong@gmail.com>
References: <4732EAB4.5070605@cn.fujitsu.com> <20071108114741.GF2479@hacking>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071108114741.GF2479@hacking>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 08, 2007 at 07:47:41PM +0800, WANG Cong wrote:
>On Thu, Nov 08, 2007 at 06:53:40PM +0800, Miao Xie wrote:
>>Hi,every one.
>>  I found that there is a buffer overflow problem in the following code.
>>
>>Version:	2.6.24-rc2,
>>File:		kernel/time/clocksource.c:417-432
>>--------------------------------------------------------------------
>>static ssize_t
>>sysfs_show_available_clocksources(struct sys_device *dev, char *buf)
>>{
>>	struct clocksource *src;
>>	char *curr = buf;
>>
>>	spin_lock_irq(&clocksource_lock);
>>	list_for_each_entry(src, &clocksource_list, list) {
>>		curr += sprintf(curr, "%s ", src->name);
>>	}
>>	spin_unlock_irq(&clocksource_lock);
>>
>>	curr += sprintf(curr, "\n");
>>
>>	return curr - buf;
>>}
>>-----------------------------------------------------------------------
>>
>>sysfs_show_current_clocksources() also has the same problem though in 
>>practice
>>the size of current clocksource's name won't exceed PAGE_SIZE.
>>
>>I fix the bug by using snprintf according to the specification of the kernel
>>(Version:2.6.24-rc2,File:Documentation/filesystems/sysfs.txt)
>>
>>Fix sysfs_show_available_clocksources() and 
>>sysfs_show_current_clocksources()
>>buffer overflow problem with snprintf().
>>
>>Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
>>
>>---
>> kernel/time/clocksource.c |   19 ++++++++++---------
>> 1 files changed, 10 insertions(+), 9 deletions(-)
>>
>>diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
>>index c8a9d13..5d5926f 100644
>>--- a/kernel/time/clocksource.c
>>+++ b/kernel/time/clocksource.c
>>@@ -342,15 +342,13 @@ void clocksource_change_rating(struct clocksource 
>>*cs, int rating)
>> static ssize_t
>> sysfs_show_current_clocksources(struct sys_device *dev, char *buf)
>> {
>>-	char *curr = buf;
>>+	ssize_t count = 0;
>>
>> 	spin_lock_irq(&clocksource_lock);
>>-	curr += sprintf(curr, "%s ", curr_clocksource->name);
>>+	count = snprintf(buf, PAGE_SIZE, "%s\n", curr_clocksource->name);
>
>Yes, snprintf is safer than sprintf. But here, the 'count' will be
>mis-pointed when snprintf returns no less than PAGE_SIZE (what you called
>overflow). So you may also need:
>
>	if (unlikely(count >= PAGE_SIZE))
>		count = PAGE_SIZE - 1;
>
>Just a simple guess. ;)

Or try scnprintf. ;)


