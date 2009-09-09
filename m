Return-Path: <linux-kernel-owner+w=401wt.eu-S1752536AbZIIIAv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbZIIIAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 04:00:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752431AbZIIIAu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 04:00:50 -0400
Received: from mail-yw0-f173.google.com ([209.85.211.173]:57266 "EHLO
	mail-yw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752107AbZIIIAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 04:00:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=nHYKyJNkxhB/d0VIkxnPiG7ypmp1jQTTiGDyD0iP8prlr2+GFhfEcCCku3bOvl6XCc
         Ry7UKz4+fbq71piULc4uJfFfg5TDOkdwIEqOk7vxOGEoJ2H4S0wHC2yO7mdnvEAsMeBs
         /lEuLyYYsBQHk//IMYEbtUZmcq8590EquTvdE=
Message-ID: <4AA760B6.6070601@gmail.com>
Date: Wed, 09 Sep 2009 10:00:54 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.1) Gecko/20090715 SUSE/3.0b3-8.5 Thunderbird/3.0b3
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: clocksource: !keventd_up() && schedule_work() == oops
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I started to see oopses on boot in qemu machine because keventd is
created in kernel_init/do_basic_setup, but schedule_work is done earlier
in kernel_init/smp_init[1] when the tsc is unstable during this early phase.

It looks like "clocksource: Resolve cpu hotplug dead lock with TSC
unstable" is the culprit.

Creating its own either singlethread or "multithread" workqueue won't
work either (we do not have singlethread_cpu and cpu_populated_map).
Checking !keventd_up() in the clocksource code looks to me like a hack.
Any ideas, please?

[1]
kernel_init/smp_init/cpu_up/native_cpu_up/check_tsc_sync_source/mark_tsc_unstable/clocksource_mark_unstable/__clocksource_unstable
