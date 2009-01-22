Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbZAVLa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbZAVLa5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 06:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754154AbZAVLar
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 06:30:47 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:33731 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725AbZAVLaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 06:30:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Wa/xu9PLISVhVxq7OooAmONRRFo9hVGWl0hv9gu80rWuVL0e4nuNJWIoIWqn+WMM3j
         VFDUS5u1eO2V0jSwNstpP/Q9b+pPP7qktcmvWDucuf69udGJTbIrkoRX3YHIQePyBSxj
         agHk8iPJzfzd6IWTzjILZ10j2WzCrIK/Ig/Z8=
Message-ID: <497858E1.5070303@tuffmail.co.uk>
Date: Thu, 22 Jan 2009 11:30:41 +0000
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: kernel-testers@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@suse.cz>, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: BISECTED: 2.6.29-rc2 regression: hibernation hang on eeepc-701
References: <9b2b86520901180345j434eacbdn7386958991ee50b@mail.gmail.com>
In-Reply-To: <9b2b86520901180345j434eacbdn7386958991ee50b@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Hibernation hangs just after writing the image.  With s2disk I can see
> this from the console messages.  The same hang happens with kernel
> swsusp ('echo disk | sudo tee /sys/power/state'), and I can see that
> the image has been written from the HDD led.
>
> In either case, I can still hard-power-off and resume from hibernation.
>
> It doesn't hang if I use the shutdown method (either 'echo shutdown |
> sudo tee /sys/power/disk' or  's2disk -P "shutdown method=shutdown"').
>   

I've bisected this to commit 571ff7584bb9e05fca0eb79752ae55a46faf3a98. 
It doesn't revert cleanly from RC2.

I think it's distinct from the other two reported suspend regressions. 
I'm not using acpi-cpufreq, and the issue doesn't affect resume.

Alan


commit 571ff7584bb9e05fca0eb79752ae55a46faf3a98
Author: Rafael J. Wysocki <rjw@sisk.pl>
Date:   Wed Jan 7 13:05:05 2009 +0100

    PCI PM: Power-manage devices without drivers during suspend-resume

    PCI devices without drivers can be put into low power states during
    suspend with the help of pci_prepare_to_sleep() and prevented from
    generating wake-up events during resume with the help of
    pci_enable_wake().  However, it's better not to put bridges into
    low power states during suspend, because that might result in entire
    bus segments being powered off.

    Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
    Acked-by: Pavel Machek <pavel@suse.cz>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>

:040000 040000 6b6fb7bfa561583f14bdf55b084473dcf9cd1765
d72fbda87eff26db8f2574e868a793b79deb9f92 M      drivers
