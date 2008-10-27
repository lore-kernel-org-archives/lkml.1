Return-Path: <linux-kernel-owner+w=401wt.eu-S1753333AbYJ0Qi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753333AbYJ0Qi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 12:38:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751883AbYJ0QiP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 12:38:15 -0400
Received: from mail.atheros.com ([12.36.123.2]:42447 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751771AbYJ0QiO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 12:38:14 -0400
Date: Mon, 27 Oct 2008 09:38:12 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: Arjan van de Ven <arjan@infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       Luis Rodriguez <Luis.Rodriguez@atheros.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: bisected: 2.6.28-rc broke my iwl4965 wireless
Message-ID: <20081027163812.GB6377@tesla>
References: <20081025222208.1d2a2c8b@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20081025222208.1d2a2c8b@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2008 at 10:22:08PM -0700, Arjan van de Ven wrote:
> [resend, first version got corrupted]
> 
> 2.6.28-rc1 broke my (intel 4965) wireless, and I've bisected it down to
> the commit below..... something's fishy with this...
> 
> 
> b2e1b30290539b344cbaff0d9da38012e03aa347 is first bad commit
> commit b2e1b30290539b344cbaff0d9da38012e03aa347
> Author: Luis R. Rodriguez <lrodriguez@atheros.com>
> Date:   Tue Sep 9 23:19:48 2008 -0700
> 
>     cfg80211: Add new wireless regulatory infrastructure
> 
>     This adds the new wireless regulatory infrastructure. The
>     main motiviation behind this was to centralize regulatory
>     code as each driver was implementing their own regulatory solution,
>     and to replace the initial centralized code we have where:
> 
>     * only 3 regulatory domains are supported: US, JP and EU
>     * regulatory domains can only be changed through module parameter
>     * all rules were built statically in the kernel
> 
>     We now have support for regulatory domains for many countries
>     and regulatory domains are now queried through a userspace agent
>     through udev allowing distributions to update regulatory rules
>     without updating the kernel.
> 
>     Each driver can regulatory_hint() a regulatory domain
>     based on either their EEPROM mapped regulatory domain value to a
>     respective ISO/IEC 3166-1 country code or pass an internally built
>     regulatory domain. We also add support to let the user set the
>     regulatory domain through userspace in case of faulty EEPROMs to
>     further help compliance.
> 
>     Support for world roaming will be added soon for cards capable of
>     this.
> 
>     For more information see:
> 
>     http://wireless.kernel.org/en/developers/Regulatory/CRDA
> 
>     For now we leave an option to enable the old module parameter,
>     ieee80211_regdom, and to build the 3 old regdomains statically
>     (US, JP and EU). This option is CONFIG_WIRELESS_OLD_REGULATORY.
>     These old static definitions and the module parameter is being
>     scheduled for removal for 2.6.29. Note that if you use this
>     you won't make use of a world regulatory domain as its pointless.
>     If you leave this option enabled and if CRDA is present and you
>     use US or JP we will try to ask CRDA to update us a regulatory
>     domain for us.
> 
>     Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>

Arjan,

so newer kernels require CRDA and iw to set regulatory domain,
otherwise only the world regulatory domain is set so if your AP
is not in the world regulatory domain it won't connect. To enable
the other channels you need CRDA and iw installed.

http://wireless.kernel.org/en/developers/Regulatory/CRDA
http://wireless.kernel.org/en/users/Documentation/iw

Drivers can also hint to CRDA as per the API a country and in those cases
only CRDA is required, however right now only zd1211rw is using this
hint, work on the other drivers is in progress so for now calling iw
for your country is required. What is expected is in the future
wpa_supplicant will carry a country config element and it hints it.

Additionally if the old behaviour is desired for now (until distributions
catch up and add CRDA) CONFIG_WIRELESS_OLD_REGULATORY can be enabled
and you'll get the old behaviour of defaulting to country "US".

Please let me know if there are any issues.

  Luis
