Return-Path: <linux-kernel-owner+w=401wt.eu-S1753240AbXKIKqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753240AbXKIKqc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2007 05:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbXKIKqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Nov 2007 05:46:24 -0500
Received: from madara.hpl.hp.com ([192.6.19.124]:64152 "EHLO madara.hpl.hp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751651AbXKIKqW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2007 05:46:22 -0500
Date: Fri, 9 Nov 2007 02:44:38 -0800
From: Stephane Eranian <eranian@hpl.hp.com>
To: perfmon2-devel@lists.sourceforge.net
Cc: perfmon@napali.hpl.hp.com, linux-kernel@vger.kernel.org,
       linux-ia64@vger.kernel.org, Stephane Eranian <eranian@hpl.hp.com>
Subject: conflict between tickless and perfmon2
Message-ID: <20071109104438.GB18909@frankl.hpl.hp.com>
Reply-To: eranian@hpl.hp.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: eranian@hpl.hp.com
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: eranian@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

We have identified a conflict between TICKLESS (CONFIG_NO_HZ) and
the current perfmon2 implementation. The problem impacts system-wide
sessions using timeout-based event set multiplexing.

Event set multiplexing allows monitoring tools to measure more events
than there are actual performance counters on the processor. Events
are grouped in sets which are then multiplexed onto the actual counters.
Switching can be triggered either by a timeout or by a counter overflow.
This is supported for per-thread and system-wide sessions.

For timeout-based switching, the duration expressed in nanoseconds is
meant to represent wall-clock time in system-wide mode, and execution
time in per-thread mode. Granularity is limited by HZ.

The current implementation for timeout is a simple hook on the timer
interrupt path in apic_*.c:smp_local_timer_interrupt(). Unfortunately,
this does not work when tickless is enabled: we get much less set
switches than expected on an idle system.

It looks like a solution would be to change the implementation of
timeout-based switching to use HR timers instead. Similar to what is
done for ITIMER_REAL and ITIMER_VIRTUAL.

Unless someone has a better proposal, I will experiment with this on
2.6.24-rc2.

Thanks.

-- 
-Stephane
