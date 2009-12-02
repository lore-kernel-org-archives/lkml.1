Return-Path: <linux-kernel-owner+w=401wt.eu-S1754590AbZLBPHu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590AbZLBPHu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 10:07:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753850AbZLBPHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 10:07:49 -0500
Received: from cantor.suse.de ([195.135.220.2]:36500 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbZLBPHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 10:07:49 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Christoph Hellwig <hch@lst.de>
Subject: Re: regression: 2.6.32-rc8 shuts down after reaching critical temperature
Date: Wed, 2 Dec 2009 16:07:52 +0100
User-Agent: KMail/1.10.3 (Linux/2.6.27.29-0.1-default; KDE/4.1.3; x86_64; ; )
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Zhang Rui <rui.zhang@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20091125102857.GA28310@lst.de> <200912021256.21683.trenn@suse.de> <20091202133032.GA9265@lst.de>
In-Reply-To: <20091202133032.GA9265@lst.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912021607.53237.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 December 2009 14:30:32 Christoph Hellwig wrote:
> On Wed, Dec 02, 2009 at 12:56:20PM +0100, Thomas Renninger wrote:
... 
> > 2.6.31 works?
> 
> Yes, perfectly.  Have been running it for a couple of days now again
> after I had all these reproducible .32-rc shutdowns when testiong it.
> 
> > Also the latest stable one?
> 
> Haven't tried that yet, will do if it helps you.
No need. Looks unrelated, the one system seem to overheat because of
no fan activity at all, yours seem to have a "passive cooling does not work
or kicks in too late" (and possibly also fan?) problem(s).

Best would be to open a bug on bugzilla.kernel.org and assign it to the
acpi component (and add Rui, Henrique and myself to CC. I won't be that
active, at least not the next days, just wanted to make sure whether
this isn't a duplicate).
dmesg, acpidump, grep . /proc/acpi/thermal_zone/*/*
and the shutdown messages should be most important info which
should show up there.

Some more hints you may want to try:

  - Does cpufreq work at all?
    Does this dir exist: /sys/devices/system/cpu/cpu*/cpufreq
    If temp of:
    watch -n1 cat /proc/acpi/thermal_zone/THM1/temperature
    goes beyond 96 C
    an ACPI processor event must get thrown and this:
    /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
    will get limited (lower than ../cpufreq/cpuinfo_max_freq).
    echo xy >/sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq
    may be bad workaround.
    These boot params: thermal.psv=90 thermal.tzp=10
    lowering all passive trip points to 90 and enabling polling
    might be a better one (with which you might be able to better
    test passive cooling). This really should be a runtime sysfs
    per thermal_zone parameter, but this is another story...
    
  - Is the ACPI event thrown at all?:
    SUSE has acpi_listen, not sure whether it's part of the acpid
    mainline project, I think it is. Do you see an ACPI event when
    96 C is past?
    If not this might workaround your issue:
    echo 10 >/proc/acpi/thermal_zone/THM1/polling_frequency (or similar)

  - T500 sounds pretty new. Still, make sure your fans are clean.
    E.g. the air must be really hot coming out at some point of time.

  - Also listen a bit to the fans. with thinkpad-acpi driver you might
    be able to monitor (T500 is rather new/untested) the fans:
    cat /proc/acpi/ibm/fan  # path out of my mind
    You might also be able to alter the fan behavior there.

Good luck,

    Thomas
