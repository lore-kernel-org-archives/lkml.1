Return-Path: <linux-kernel-owner+w=401wt.eu-S1754171AbZG1Rff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754171AbZG1Rff (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 13:35:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbZG1Rfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 13:35:34 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:39819 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbZG1Rfd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 13:35:33 -0400
Date: Tue, 28 Jul 2009 19:35:33 +0200
From: Andreas Mohr <andi@lisas.de>
To: Andreas Mohr <andi@lisas.de>
Cc: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Corrado Zoccolo <czoccolo@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: ok, now would this be useful? (Re: Dynamic configure max_cstate)
Message-ID: <20090728173533.GA27055@rhlx01.hs-esslingen.de>
References: <20090727073338.GA12669@rhlx01.hs-esslingen.de> <1248748935.2560.669.camel@ymzhang> <4e5e476b0907280020x242d9ef7gfa05c3d7b66f941f@mail.gmail.com> <1248771635.2560.682.camel@ymzhang> <20090728101135.GA22358@rhlx01.hs-esslingen.de> <20090728140308.GA17543@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090728140308.GA17543@rhlx01.hs-esslingen.de>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 04:03:08PM +0200, Andreas Mohr wrote:
> Still, an average of +8.16% during 5 test runs each should be quite some incentive,
> and once there's a proper "idle latency skipping during expected I/O replies"
> even with idle/wakeup code path reinstated we should hopefully be able to keep
> some 5% improvement in disk access.

I went ahead and created a small and VERY dirty test for this.

In kernel/pm_qos_params.c I added

static bool io_reply_is_expected;

bool io_reply_expected(void)
{
  return io_reply_is_expected;
}
EXPORT_SYMBOL_GPL(io_reply_expected);

void set_io_reply_expected(bool expected)
{
  io_reply_is_expected = expected;
}
EXPORT_SYMBOL_GPL(set_io_reply_expected);



Then in drivers/ata/libata-core.c I added

extern bool set_io_reply_expected();

and updated it to

	set_io_reply_expected(1);
	rc = wait_for_completion_timeout(&wait, msecs_to_jiffies(timeout));
	set_io_reply_expected(0);

	ata_port_flush_task(ap);


Then I changed ./drivers/cpuidle/governors/menu.c
(make sure you're using the menu governor!) to use

extern bool io_reply_expected(void);

and updated

	if (io_reply_expected())
		data->expected_us = 10;
	else {
	/* determine the expected residency time */
	data->expected_us =
		(u32) ktime_to_ns(tick_nohz_get_sleep_length()) / 1000;
	}

Rebuilt, rebootloadered ;), rebooted, and then booting and disk operation
_seemed_ to be snappier (I'm damn sure the hdd seek noise
is a bit higher-pitched ;).
And it's exactly seeks which should be shorter-intervalled now,
since the system triggers a hdd operation and then is forced to wait (idle)
until the seeking is done.

bonnie test results (of patched kernel vs. kernel with set_io_reply_expected() muted)
seem to support this, but then a "time make bzImage" (of newly rebooted box each)
showed inconsistent results again and a much higher sample rate (with reboots each)
would be needed to really confirm this.

I'd expect improvements to be in the 3% to 4% range, at most, but still,
compared to the yield of other kernel patches this ain't nothing.

Now the question becomes whether one should implement such an improvement and especially, how.
Perhaps the io reply decision making should be folded into the tick_nohz_get_sleep_length()
function (or rather create a higher-level "expected sleep length" function which consults both
tick_nohz_get_sleep_length() and io reply mechanism).
And another important detail is that my current hack completely ignores per-cpu operation
and thus causes suboptimal power savings of _all_ cpus,
not just the one waiting for the I/O reply (i.e., we should properly take into account
cpu affinity settings of the reply interrupt).
And of course it would probably be best to create a mechanism which stores a record of average
responsiveness delays of various block devices and then derive a maximum
idle wakeup latency value from this to request.

Does anyone else have thoughts on this or benchmark numbers which would support this?

Andreas Mohr
