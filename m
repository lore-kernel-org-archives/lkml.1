Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbXFTRTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbXFTRTT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 13:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755058AbXFTRTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 13:19:10 -0400
Received: from homer.mvista.com ([63.81.120.155]:53723 "EHLO
	imap.sh.mvista.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754562AbXFTRTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 13:19:08 -0400
Message-ID: <467961F1.1060909@ru.mvista.com>
Date: Wed, 20 Jun 2007 21:20:49 +0400
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Organization: MontaVista Software Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.7.2) Gecko/20040803
X-Accept-Language: ru, en-us, en-gb
MIME-Version: 1.0
To: Tony Breeds <tony@bakeyournoodle.com>
Cc: Daniel Walker <dwalker@mvista.com>, Andrew Morton <akpm@osdl.org>,
       john stultz <johnstul@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       LinuxPPC-dev <linuxppc-dev@ozlabs.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC] clocksouce implementation for powerpc
References: <20070616101126.296384219@inhelltoy.tec.linutronix.de>	<20070616101637.107940593@inhelltoy.tec.linutronix.de>	<1182009083.11539.369.camel@imap.mvista.com>	<20070620065710.GR9768@bakeyournoodle.com> <1182351439.18168.79.camel@imap.mvista.com>
In-Reply-To: <1182351439.18168.79.camel@imap.mvista.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Walker wrote:
>>+static void clocksource_settimeofday(struct clocksource *cs,
>>+                                     struct timespec *ts)
>>+{
>>+	u64 new_xsec;
>>+
>>+#ifdef CONFIG_PPC_ISERIES
>>+	if (firmware_has_feature(FW_FEATURE_ISERIES) && first_settimeofday) {
>>+		iSeries_tb_recal();
>>+		first_settimeofday = 0;
>>+	}
>>+#endif
>>+
>>+	/* Make userspace gettimeofday spin until we're done. */
>>+	++vdso_data->tb_update_count;
>>+	smp_mb();
>>+
>>+	/* In case of a large backwards jump in time with NTP, we want the
>>+	 * clock to be updated as soon as the PLL is again in lock.
>>+	 */
>>+	last_rtc_update = xtime.tv_sec - 658;
>>+
>>+	new_xsec = xtime.tv_nsec;
>>+	if (new_xsec != 0) {
>>+		new_xsec *= XSEC_PER_SEC;
>>+		do_div(new_xsec, NSEC_PER_SEC);
>>+	}
>>+
>>+	new_xsec += (u64)xtime.tv_sec * XSEC_PER_SEC;
>>+
>>+	vdso_data->tz_minuteswest = sys_tz.tz_minuteswest;
>>+	vdso_data->tz_dsttime = sys_tz.tz_dsttime;

    I'm not sure why these are copied *only* here. Shouldn't they be copied 
only once, at init. time?

>>+
>>+	update_gtod(tb_last_jiffy, new_xsec, do_gtod.varp->tb_to_xs);
>>+}

> It does look too large to run from interrupt context,

    You mean if this would have been "included" into update_vsyscall()?

> but it also looks
> like it could get cleaned out more ..

    Yeah, at least new_xsec calculation is duplicated in timer_recalc_offset()..

>>+void update_vsyscall(struct timespec *wall_time, struct clocksource *clock)
>>+{
>>+	timer_recalc_offset(tb_last_jiffy);
>>+	timer_check_rtc();
>>+}

> Hmm .. This doesn't look like it's taking into account that the time has
> changed ..

    Why? By the time it gets called (form the timer softirq context) 
tb_last_jiffy should've been incremented. Well, this won't happen wither in or 
right after the timer interrupt... since timer has no IRQ on PowerPC -- it 
signals "exception". Well, HRT works somehow anyway. :-)

> Your time has effectively incremented by one jiffie .. The
> vdso_data doesn't appear to be updated ..

    Moreover, it will get called for settimeofday() as well which would seem 
to double the overhead since your clocksource hook will get called beforehand.

WBR, Sergei
