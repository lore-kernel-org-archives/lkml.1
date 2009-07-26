Return-Path: <linux-kernel-owner+w=401wt.eu-S1753092AbZGZGeY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092AbZGZGeY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 02:34:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753028AbZGZGeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 02:34:24 -0400
Received: from smtp.nokia.com ([192.100.105.134]:31577 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752614AbZGZGeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 02:34:23 -0400
Message-ID: <4A6BF8DB.2020100@nokia.com>
Date: Sun, 26 Jul 2009 09:34:03 +0300
From: Adrian Hunter <adrian.hunter@nokia.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "pierre@ossman.eu" <pierre@ossman.eu>,
       "Lavinen Jarkko (Nokia-D/Helsinki)" <jarkko.lavinen@nokia.com>,
       "Karpov Denis.2 (EXT-Teleca/Helsinki)" <ext-denis.2.karpov@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 20/32] omap_hsmmc: put MMC regulator to sleep
References: <20090710124004.1262.10422.sendpatchset@ahunter-tower>	<20090710124227.1262.7056.sendpatchset@ahunter-tower> <20090724155144.4c621e6d.akpm@linux-foundation.org>
In-Reply-To: <20090724155144.4c621e6d.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jul 2009 06:33:30.0001 (UTC) FILETIME=[FD680010:01CA0DBA]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Fri, 10 Jul 2009 15:42:27 +0300
> Adrian Hunter <adrian.hunter@nokia.com> wrote:
> 
>> +static int omap_mmc_regsleep_to_enabled(struct mmc_omap_host *host)
>> +{
>> +	unsigned long timeout;
>> +
>> +	dev_dbg(mmc_dev(host->mmc), "REGSLEEP -> ENABLED\n");
>> +
>> +	clk_enable(host->fclk);
>> +	clk_enable(host->iclk);
>> +
>> +	if (clk_enable(host->dbclk))
>> +		dev_dbg(mmc_dev(host->mmc),
>> +			"Enabling debounce clk failed\n");
>> +
>> +	omap_mmc_restore_ctx(host);
>> +
>> +	/*
>> +	 * We turned off interrupts and bus power.  Interrupts
>> +	 * are turned on by 'mmc_omap_start_command()' so we
>> +	 * just need to turn on the bus power here.
>> +	 */
>> +	OMAP_HSMMC_WRITE(host->base, HCTL,
>> +			 OMAP_HSMMC_READ(host->base, HCTL) | SDBP);
>> +
>> +	timeout = jiffies + msecs_to_jiffies(MMC_TIMEOUT_MS);
>> +	while ((OMAP_HSMMC_READ(host->base, HCTL) & SDBP) != SDBP &&
>> +	       time_before(jiffies, timeout))
>> +		;
>> +
>> +	if (mmc_slot(host).set_sleep)
>> +		mmc_slot(host).set_sleep(host->dev, host->slot_id,
>> +					 0, host->vdd, 0);
>> +
>> +	host->dpm_state = ENABLED;
>> +
>> +	return 0;
>> +}
> 
> We take no action if the wait for SDBP timed out?

Yeah that is on my TODO list, but SDBP (and other bits we wait for)
will not timeout unless the hardware is broken or there is a bug
in the driver.  In either of those cases we are ruined anyway.

