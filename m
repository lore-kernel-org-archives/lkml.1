Return-Path: <linux-kernel-owner+w=401wt.eu-S1753433AbXDBI5M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753433AbXDBI5M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 04:57:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753436AbXDBI5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 04:57:12 -0400
Received: from mu-out-0910.google.com ([209.85.134.188]:35765 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753433AbXDBI5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 04:57:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-disposition:content-type:content-transfer-encoding:message-id;
        b=AldWl51m+cjpEqUPokf0YNx8SAju4SPW4I8MWEN+wufcfL6W7jLM14TtP5o0lLi9GABeDHuIY4d9Pu0G7feO421NNCW/TUca02ExC2HDHlR1uo03pcK3uqJX+XjUvnAewxe/oUDCYhTO8aysQXq0wY3oynsMRepSeF0ZTZpPgSg=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Clockevents: one-shoot mode is never enabled if local apic timer is disabled
Date: Mon, 2 Apr 2007 11:57:03 +0300
User-Agent: KMail/1.9.6
Cc: Thomas Gleixner <tglx@linutronix.de>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200704021157.03368.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I finally figured out why one-shoot mode is enabled on my system only and only if local apic is enabled.

While reading through dynatic code it looks that all clockevent devices are put in periodic mode.
Then hrtimer_run_queues (which runs nevertheless CONFIG_HIGH_RES_TIMERS enabled or not) calls
indirectly (through tick_check_oneshot_change or hrtimer_switch_to_hres) to tick_switch_to_oneshot

tick_switch_to_oneshot checks that current cpu's clockevents device (and it is lapic even if not used) is not a dummy device
and it is , so it never calls tick_broadcast_switch_to_oneshot

To put it simply if broadcast is used, it works in periodic mode only. tick_broadcast_switch_to_oneshot is never called
(well it is called when broadcast is not used, but it is unnecessary, on my system for example it brings HPET on one-shoot mode,
and HPET is not used at all)

I tried to remove this check and this resulted in hard lock-up during boot with nolapic_timer
Maybe this was connected to the fact that this function is called on both cpus, and if one set a 
broadcasting device(HPET) to one shoot mode, second is still not aware of this.

Is it a bug or feature ?

	Best regards,
		Maxim Levitsky
