Return-Path: <linux-kernel-owner+w=401wt.eu-S1752297AbYJaNwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbYJaNwQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 09:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbYJaNv7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 09:51:59 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:27913 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750868AbYJaNv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 09:51:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=eked7w1vuSQpIJGoJsycRTRvqAs0rh5G19TNMlDDPGW490nf1qv9Rtoz4yVZA8A7wD
         kUmO5lkRigfg89/niRi5Ob2GSyq87pmaXZNJA3zAYGDaX5A4DIyxfQOSTyvXdYH129aj
         QRSCFLLNtwhddBf7TYK+TvGvmrQps0b/N96yE=
Message-ID: <490B0D75.8020601@tuffmail.co.uk>
Date: Fri, 31 Oct 2008 13:51:49 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
CC: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
       willy@linux.intel.com, lrodriguez@atheros.com,
       Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: ath5k gets lost with eeepc-laptop removal
References: <20081031110502.18e33eba@doriath.conectiva>
In-Reply-To: <20081031110502.18e33eba@doriath.conectiva>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luiz Fernando N. Capitulino wrote:
>  Hi guys,
> 
>  If I do a 'rmmod eeepc-laptop', while connected to my AP, I get the
> following error messages from ath5k:
> 
> """
> ath5k phy0: noise floor calibration timeout (2417MHz)
> ath5k phy0: failed to wakeup the MAC Chip
> ath5k phy0: can't reset hardware (-5)
> ath5k phy0: failed to wakeup the MAC Chip
> ath5k phy0: can't reset hardware (-5)
> wlan0: No ProbeResp from current AP 00:1d:0f:e9:c7:c0 - assume out of range
> ath5k phy0: failed to wakeup the MAC Chip
> ath5k phy0: ath5k_chan_set: unable to reset channel (2412 Mhz)
> wlan0: failed to set freq to 2412 MHz for scan
> ath5k phy0: failed to wakeup the MAC Chip
> ath5k phy0: ath5k_chan_set: unable to reset channel (2417 Mhz)
> wlan0: failed to set freq to 2417 MHz for scan
> ath5k phy0: failed to wakeup the MAC Chip
> ath5k phy0: ath5k_chan_set: unable to reset channel (2422 Mhz)
> wlan0: failed to set freq to 2422 MHz for scan
> ath5k phy0: failed to wakeup the MAC Chip
> ath5k phy0: ath5k_chan_set: unable to reset channel (2427 Mhz)
> wlan0: failed to set freq to 2427 MHz for scan
> ath5k phy0: failed to wakeup the MAC Chip
> ath5k phy0: ath5k_chan_set: unable to reset channel (2432 Mhz)
> wlan0: failed to set freq to 2432 MHz for scan
> wlan0: failed to set freq to 2437 MHz for scan
> wlan0: failed to set freq to 2442 MHz for scan
> wlan0: failed to set freq to 2447 MHz for scan
> wlan0: failed to set freq to 2452 MHz for scan
> wlan0: failed to set freq to 2457 MHz for scan
> wlan0: failed to set freq to 2462 MHz for scan
> wlan0: failed to set freq to 2467 MHz for scan
> wlan0: failed to set freq to 2472 MHz for scan
> wlan0: failed to set freq to 2484 MHz for scan
> wlan0: failed to restore operational channel after scan
> wlan0: authenticate with AP 00:1d:0f:e9:c7:c0
> wlan0: authenticate with AP 00:1d:0f:e9:c7:c0
> wlan0: authenticate with AP 00:1d:0f:e9:c7:c0
> wlan0: authentication with AP 00:1d:0f:e9:c7:c0 timed out
> """
> 
>  Then I lost my wireless connection.
> 
>  I'm running latest Linus git tree (2.6.28-rc2) on a Eeepc 701.
> 
>  The problem doesn't happen on 2.6.27.4, but as 2.6.28-rc1 doesn't
> boot on this machine, it would be a bit difficult to bisect it.
> 
>  Thanks.
> 

The trick with bisection is to identify the fix, use "git cherry-pick" to apply it before testing, and then "git reset --hard HEAD^" to unapply the fix before "git bisect {good|bad}".

But you shouldn't need to bisect.  It'll be the addition of rfkill support (see below).

Matthew: I nagged you twice about different consequences of this commit, so here's a third :).  You said rfkill no longer automatically frobs on suspend/resume, which was what I was worried about last time.  Should the core code also  be modified so it doesn't do anything when the rfkill device is unregistered?

Thanks
Alan

---

commit a195dcdcff33b8ef01a23cbc489fdfcdfa28c88e
Author: Matthew Garrett <mjg59@srcf.ucam.org>
Date:   Tue Aug 19 12:13:20 2008 +0100

    eeepc-laptop: Use standard interfaces

    eeepc-laptop currently only sends key events via ACPI and has
    non-standard rfkill control. Add an input device and use the rfkill
    infrastructure.

    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Len Brown <len.brown@intel.com>
