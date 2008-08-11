Return-Path: <linux-kernel-owner+w=401wt.eu-S1752714AbYHKNoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752714AbYHKNoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 09:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbYHKNn6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 09:43:58 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48275 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221AbYHKNn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 09:43:57 -0400
Date: Mon, 11 Aug 2008 14:43:39 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: a.zummo@towertech.it, Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [BUG] rtc uie emulation deadlocks
Message-ID: <20080811134339.GA21967@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With CONFIG_RTC_INTF_DEV_UIE_EMUL=y, hwclock deadlocks in rtc_read_time
due to:

static long rtc_dev_ioctl(struct file *file,
                unsigned int cmd, unsigned long arg)
{
        err = mutex_lock_interruptible(&rtc->ops_lock);
        if (err)
                return err;
...
        switch (cmd) {
#ifdef CONFIG_RTC_INTF_DEV_UIE_EMUL
        case RTC_UIE_OFF:
                clear_uie(rtc);
                break;

        case RTC_UIE_ON:
                err = set_uie(rtc);
#endif
}

static int set_uie(struct rtc_device *rtc)
{
        err = rtc_read_time(rtc, &tm);
...

int rtc_read_time(struct rtc_device *rtc, struct rtc_time *tm)
{
        err = mutex_lock_interruptible(&rtc->ops_lock);

So we try to take the same lock twice...  Not good.

The locking looks a rather random in there, so I'm not going to try to
create a patch.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
