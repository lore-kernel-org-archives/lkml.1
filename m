Return-Path: <linux-kernel-owner+w=401wt.eu-S1755213AbYIPRWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213AbYIPRWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 13:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752610AbYIPRWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 13:22:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:20650 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187AbYIPRWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 13:22:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.32,409,1217833200"; 
   d="scan'208";a="617004494"
Message-ID: <48CFEB64.5030808@intel.com>
Date: Tue, 16 Sep 2008 10:22:44 -0700
From: "Kok, Auke" <auke-jan.h.kok@intel.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080626)
MIME-Version: 1.0
To: Michal Hocko <mstsxfx@gmail.com>
CC: power@bughost.org, Alexey Starikovskiy <astarikovskiy@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: Why is /sys/class/power_supply/CMB1/energy_now not exported?
References: <20080721041213.GA3491@dhcp35.suse.cz> <48841AE3.3000004@suse.de>	<20080721165921.GB3491@dhcp35.suse.cz> <4884F98F.4060903@suse.de>	<20080722030412.GA5969@dhcp35.suse.cz> <20080904194058.GA24955@dhcp35.suse.cz>
In-Reply-To: <20080904194058.GA24955@dhcp35.suse.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Sep 2008 17:22:44.0977 (UTC) FILETIME=[D515DE10:01C91820]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Hocko wrote:
> On Mon, Jul 21, 2008 at 09:04:13PM -0600, Michal Hocko wrote:
>> [fixing bad linux kernel mailing list email address - sorry, but gmail's
>> thrown mailing delivery error to the spam]
>>
>> On Tue, Jul 22, 2008 at 01:03:11AM +0400, Alexey Starikovskiy wrote:
>>> Hi Michal,
>> Hi Alexey,
>>
>>> the charge_now part of your patch seems to be correct, but the
>>> calculation is somehow broken --
>> I have made some experiments and the result is quite surprising to me.
>> It seems that this problem is somehow related to Debian distribution
>> kernel, because I wasn't able to reproduce it with the Vanilla kernel (I
>> had to screw something up last time when I have checked that and
>> reported in the original message).
>>
>> I have tried 3 configurations:
>> * 2.6.25 - Vanilla kernel with config-2.6.25 config and result output in
>>   powertop-2.6.25-good
>> * 2.6.25-2 - Debian distribution kernel with config-2.6.25-2 config and
>>   powertop-2.6.25-2-bad output
>> * 2.6.26 - Vanilla kernel with config-2.6.26 config and result output in
>>   powertop-2.6.26-good
> [...]
> 
> I had some time to get back to this issue and the problem why I have
> seen different behavior on distribution and vanilla kernel was in
> configuration. 
> While distribution kernel doesn't use CONFIG_ACPI_PROCFS_POWER=y while
> my vanilla kernel configuration does! This means that the patched code
> wasn't triggered in my vanilla kernel testing.
> 
> So that I have checked the print_batter_sysfs again and it seems that
> the problem is on another place:
> powertop.c:648
> 	sprintf(filename, "/sys/class/power_supply/%s/current_now", dirent->d_name);
> 	file = fopen(filename, "r");
> 	if (!file)
> 		continue;
> 	memset(line, 0, 1024);
> 	if (fgets(line, 1024, file) != NULL) {
> 		watts_drawn = strtoull(line, NULL, 10) / 1000000.0;
> 	}
> 	fclose(file);
> 
> 	if (!dontcount) {
> 		rate += watts_drawn + voltage * amperes_drawn;
> 	}
> 
> current rate (later used for the remaining time calculation:
> display.c:201
> 	sprintf(buffer, _("Power usage (ACPI estimate): %3.1fW (%3.1f hours)"), rate, cap/rate);
> )
> 
> is calculated as watts_drawn + voltage which is not correct, because
> current_* values are in A and not in W (according to
> linux-src/Documentation/power/power_supply_class.txt).
> 
> Updated patch is attached. This one is already working for me.

Merged in powertop-svn, thanks!

Auke
