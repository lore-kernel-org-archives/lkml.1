Return-Path: <linux-kernel-owner+w=401wt.eu-S1752148AbZLaH7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbZLaH7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 02:59:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751995AbZLaH7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 02:59:41 -0500
Received: from 30.mail-out.ovh.net ([213.186.62.213]:33432 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751938AbZLaH7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 02:59:41 -0500
Message-ID: <4B3C59E9.6010308@free.fr>
Date: Thu, 31 Dec 2009 08:59:37 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Issue connecting to an HT40 AP that sends a Country IE
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 6478991014855069464
X-Ovh-Remote: 88.163.232.53 (ns.popipo.fr)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'd like to report an issue I have when trying to connect a laptop 
running ath9k to a 802.11n AP in HT40 mode. What happens is that the 
laptop cannot associate if the AP is running in HT40 mode. Association 
is OK if the AP is running in HT20 mode. Here is an excerpt from syslog :

[  577.166241] wlan0: associate with AP 00:15:6d:e8:88:84 (try 1)
[  577.167448] wlan0: RX AssocResp from 00:15:6d:e8:88:84 (capab=0x411 
status=10 aid=257)
[  577.167451] wlan0: AP denied association (code=10)
[  577.167460] wlan0: deauthenticating from 00:15:6d:e8:88:84 by local 
choice (reason=3)

What's wrong is that the Associate Request (built by 
ieee80211_send_assoc) does not set the bit in HT Capabilities IE saying 
: "The station supports both HT20 & HT40".

Looking into the code, it appears that both (flags & 
IEEE80211_CHAN_NO_HT40PLUS) and (flags & IEEE80211_CHAN_NO_HT40MINUS) 
are true, thus disabling the IEEE80211_HT_CAP_SUP_WIDTH_20_40 which is 
the culprit mentioned above.

Digging further down, both flags are set in reg.c by :
    if (freq_range->max_bandwidth_khz < MHZ_TO_KHZ(40))
        bw_flags = IEEE80211_CHAN_NO_HT40;

Indeed, at this stage, max_bandwidth_khz is 20 MHz only... Looking up in 
my syslog, I found this :

[  506.036923] cfg80211: Received country IE:
[  506.036927] cfg80211: Regulatory domain: FR
[  506.036928]     (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[  506.036931]     (5170000 KHz - 5190000 KHz @ 40000 KHz), (10000 mBi, 
10000 mBm)
[  506.036933]     (5190000 KHz - 5210000 KHz @ 40000 KHz), (10000 mBi, 
10000 mBm)
[  506.036936]     (5210000 KHz - 5230000 KHz @ 40000 KHz), (10000 mBi, 
10000 mBm)
[  506.036938]     (5230000 KHz - 5250000 KHz @ 40000 KHz), (10000 mBi, 
10000 mBm)
[  506.036940]     (5250000 KHz - 5270000 KHz @ 40000 KHz), (10000 mBi, 
10000 mBm)
[  506.036943]     (5270000 KHz - 5290000 KHz @ 40000 KHz), (10000 mBi, 
10000 mBm)
[  506.036945]     (5290000 KHz - 5310000 KHz @ 40000 KHz), (10000 mBi, 
10000 mBm)
[  506.036948]     (5310000 KHz - 5330000 KHz @ 40000 KHz), (10000 mBi, 
10000 mBm)
[  506.036950]     (5490000 KHz - 5510000 KHz @ 40000 KHz), (10000 mBi, 
10000 mBm)
[  506.036952]     (5510000 KHz - 5530000 KHz @ 40000 KHz), (10000 mBi, 
10000 mBm)
[  506.036955]     (5530000 KHz - 5550000 KHz @ 40000 KHz), (10000 mBi, 
10000 mBm)
[  506.036957]     (5550000 KHz - 5570000 KHz @ 40000 KHz), (10000 mBi, 
10000 mBm)
[  506.036959]     (5570000 KHz - 5590000 KHz @ 40000 KHz), (10000 mBi, 
10000 mBm)
[  506.036962]     (5590000 KHz - 5610000 KHz @ 40000 KHz), (10000 mBi, 
10000 mBm)
[  506.036964]     (5610000 KHz - 5630000 KHz @ 40000 KHz), (10000 mBi, 
10000 mBm)
[  506.036966]     (5630000 KHz - 5650000 KHz @ 40000 KHz), (10000 mBi, 
10000 mBm)
[  506.036969]     (5650000 KHz - 5670000 KHz @ 40000 KHz), (10000 mBi, 
10000 mBm)
[  506.036971]     (5670000 KHz - 5690000 KHz @ 40000 KHz), (10000 mBi, 
10000 mBm)
[  506.036974]     (5690000 KHz - 5710000 KHz @ 40000 KHz), (10000 mBi, 
10000 mBm)

[  506.036975] cfg80211: CRDA thinks this should applied:
[  506.036976] cfg80211: Regulatory domain: FR
[  506.036978]     (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[  506.036980]     (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  506.036982]     (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  506.036984]     (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[  506.036987]     (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)

[  506.036988] cfg80211: We intersect both of these and get:
[  506.037005] cfg80211: Regulatory domain: 98
[  506.037006]     (start_freq - end_freq @ bandwidth), 
(max_antenna_gain, max_eirp)
[  506.037008]     (5170000 KHz - 5190000 KHz @ 20000 KHz), (N/A, 2000 mBm)
[  506.037011]     (5190000 KHz - 5210000 KHz @ 20000 KHz), (N/A, 2000 mBm)
[  506.037013]     (5210000 KHz - 5230000 KHz @ 20000 KHz), (N/A, 2000 mBm)
[  506.037015]     (5230000 KHz - 5250000 KHz @ 20000 KHz), (N/A, 2000 mBm)
[  506.037017]     (5250000 KHz - 5270000 KHz @ 20000 KHz), (N/A, 2000 mBm)
[  506.037019]     (5270000 KHz - 5290000 KHz @ 20000 KHz), (N/A, 2000 mBm)
[  506.037021]     (5290000 KHz - 5310000 KHz @ 20000 KHz), (N/A, 2000 mBm)
[  506.037024]     (5310000 KHz - 5330000 KHz @ 20000 KHz), (N/A, 2000 mBm)
[  506.037026]     (5490000 KHz - 5510000 KHz @ 20000 KHz), (N/A, 2700 mBm)
[  506.037028]     (5510000 KHz - 5530000 KHz @ 20000 KHz), (N/A, 2700 mBm)
[  506.037030]     (5530000 KHz - 5550000 KHz @ 20000 KHz), (N/A, 2700 mBm)
[  506.037032]     (5550000 KHz - 5570000 KHz @ 20000 KHz), (N/A, 2700 mBm)
[  506.037035]     (5570000 KHz - 5590000 KHz @ 20000 KHz), (N/A, 2700 mBm)
[  506.037037]     (5590000 KHz - 5610000 KHz @ 20000 KHz), (N/A, 2700 mBm)
[  506.037039]     (5610000 KHz - 5630000 KHz @ 20000 KHz), (N/A, 2700 mBm)
[  506.037041]     (5630000 KHz - 5650000 KHz @ 20000 KHz), (N/A, 2700 mBm)
[  506.037043]     (5650000 KHz - 5670000 KHz @ 20000 KHz), (N/A, 2700 mBm)
[  506.037045]     (5670000 KHz - 5690000 KHz @ 20000 KHz), (N/A, 2700 mBm)
[  506.037047]     (5690000 KHz - 5710000 KHz @ 20000 KHz), (N/A, 2700 mBm)

So, at this stage, max_bandwidth_khz is indeed 20 MHz!

What's the real meaning of max_bandwidth_khz? If this is just the 
difference between the upper/lower frequency of each channels, then it's 
useless. If it is a capability features saying 40 MHz channel wide are 
allowed, then it should be left to 40 MHz even if upper/lower 
frequencies are only 20 MHz wide (since the ability to use 40 MHz 
depends on the list of all frequencies, not a single frequency).

I did a quick patch commenting the lines setting IEEE80211_CHAN_NO_HT40 
and it works. But it'd like to know how it is expected to work in this case.

Regards,
Benoit
PS: in Country IE, TxPower field is not parsed as well ...
