Return-Path: <linux-kernel-owner+w=401wt.eu-S1754625AbYHSHxv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625AbYHSHxv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 03:53:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753189AbYHSHxm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 03:53:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37304 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800AbYHSHxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 03:53:41 -0400
Date: Tue, 19 Aug 2008 00:53:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: a.zummo@towertech.it, Linux Kernel List <linux-kernel@vger.kernel.org>,
       David Brownell <david-b@pacbell.net>
Subject: Re: [BUG] rtc uie emulation deadlocks
Message-Id: <20080819005320.00075dba.akpm@linux-foundation.org>
In-Reply-To: <20080811134339.GA21967@flint.arm.linux.org.uk>
References: <20080811134339.GA21967@flint.arm.linux.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Aug 2008 14:43:39 +0100 Russell King <rmk+lkml@arm.linux.org.uk> wrote:

> With CONFIG_RTC_INTF_DEV_UIE_EMUL=y, hwclock deadlocks in rtc_read_time
> due to:
> 
> static long rtc_dev_ioctl(struct file *file,
>                 unsigned int cmd, unsigned long arg)
> {
>         err = mutex_lock_interruptible(&rtc->ops_lock);
>         if (err)
>                 return err;
> ...
>         switch (cmd) {
> #ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
>         case RTC_UIE_OFF:
>                 clear_uie(rtc);
>                 break;
> 
>         case RTC_UIE_ON:
>                 err = set_uie(rtc);
> #endif
> }
> 
> static int set_uie(struct rtc_device *rtc)
> {
>         err = rtc_read_time(rtc, &tm);
> ...
> 
> int rtc_read_time(struct rtc_device *rtc, struct rtc_time *tm)
> {
>         err = mutex_lock_interruptible(&rtc->ops_lock);
> 
> So we try to take the same lock twice...  Not good.
> 
> The locking looks a rather random in there, so I'm not going to try to
> create a patch.
> 

Looks like this was caused by

commit 5ad31a575157147b43fa84ef1e21471661653878
Author: David Brownell <david-b@pacbell.net>
Date:   Wed Jul 23 21:30:33 2008 -0700

    rtc: remove BKL for ioctl()
    

