Return-Path: <linux-kernel-owner+w=401wt.eu-S1753126AbYLFQgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126AbYLFQgP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 11:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbYLFQf7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 11:35:59 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:40942 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487AbYLFQf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 11:35:58 -0500
Date: Sat, 6 Dec 2008 16:35:39 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Tom Hughes <tom@compton.nu>
Cc: Thomas Renninger <trenn@suse.de>,
       Cristiano Prisciandaro <cristiano.p@solnet.ch>,
       Dave Jones <davej@redhat.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] cpufreq: eeepc 900 frequency scaling driver
Message-ID: <20081206163539.GB7623@srcf.ucam.org>
References: <1227454026.7262.59.camel@localhost> <492A7632.4040106@compton.nu> <4936DD78.4090501@compton.nu> <200812040257.09099.trenn@suse.de> <4939B3C3.8060205@compton.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4939B3C3.8060205@compton.nu>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 11:05:39PM +0000, Tom Hughes wrote:
> Thomas Renninger wrote:
> 
> >The biggest problem I see with these "special" ACPI cpufreq interface is:
> >Can there be Asus/eeepcs which provide these ACPI functions (maybe dummies 
> >on
> >future machines?), but can still be switched via the spec conform and more 
> >efficient acpi-cpufreq driver via PSS tables?
> 
> So should we tie this driver to particular DMI signature(s) then? As far 
> as I know it is only useful for the Eee 900 and possibly the 701 when 
> running later BIOSes.

It appears to be implemented in the 900 and 901 BIOSes as well, so some 
kind of limitation is probably needed. The best approach would probably 
to check whether the CPU has the EST flag. Just do something like:

struct cpuinfo_x86 *cpu = &cpu_data(policy->cpu);

if (cpu->x86_vendor != X86_VENDOR_INTEL || cpu_has(cpu, X86_FEATURE_EST))
	return -ENODEV

at the top of the cpufreq init code. That way you'll refuse to bind on 
anything that implements speedstep and acpi-cpufreq can be used instead.

> Running with wifi and the screen off, and the CPU busy (doing m5sum of 
> /dev/zero) I get 2:37 run time at 900MHz and 3:09 at 630MHz so the 
> increase in run time is about 20% on that test.

My only concern about this is that implementing it via cpufreq means 
that on most distributions you'll end up with ondamend running the CPU. 
This makes sense on systems where the cpu scaling drops the voltage, but 
that isn't the case here as far as I can tell. This may result in some 
workloads now having lower battery lives than they did previously. I'll 
try to do some experimentation next week.

Other than that, this patch looks good. I think it makes sense to 
integrate it into eeepc-laptop.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
