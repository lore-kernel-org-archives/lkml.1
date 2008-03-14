Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbYCNApR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbYCNApR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 20:45:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbYCNApD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 20:45:03 -0400
Received: from testure.choralone.org ([194.9.77.134]:60484 "EHLO
	testure.choralone.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbYCNApA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 20:45:00 -0400
Date: Thu, 13 Mar 2008 20:44:48 -0400
From: Dave Jones <davej@codemonkey.org.uk>
To: Tilman Schmidt <tilman@imap.cc>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-acpi@vger.kernel.org
Subject: Re: [2.6.25-rc5-mm1] WARNING: at drivers/base/sys.c:173
Message-ID: <20080314004448.GF32463@codemonkey.org.uk>
Mail-Followup-To: Dave Jones <davej@codemonkey.org.uk>,
	Tilman Schmidt <tilman@imap.cc>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
	linux-acpi@vger.kernel.org
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <47D87238.8080305@imap.cc> <20080313195656.GA32463@codemonkey.org.uk> <47D9C04E.3060208@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D9C04E.3060208@imap.cc>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 01:01:18AM +0100, Tilman Schmidt wrote:

 > > Full dmesg please, with CPU_FREQ_DEBUG=y, and boot with cpufreq.debug=7
 > 
 > You can find it at
 > http://gollum.phnxsoft.com/~ts/linux/dmesg.out
 > and the corresponding .config right beside it at
 > http://gollum.phnxsoft.com/~ts/linux/config-2.6.25-rc5-mm1
 > 
 > CCing linux-acpi as you did in your other mail.

The interesting bits..

[   46.075145] cpufreq-core: trying to register driver centrino

here we've done sysdev_driver_register(&cpu_sysdev_class,&cpufreq_sysdev_driver);
(see cpufreq_register_driver in drivers/cpufreq/cpufreq.c)
This is the only place we register sysdev entries.

[   46.075155] cpufreq-core: adding CPU 0
[   46.075163] speedstep-centrino: found unsupported CPU with Enhanced SpeedStep: send /proc/cpuinfo to cpufreq@lists.linux.org.uk
[   46.075167] cpufreq-core: initialization failed

this ENODEVs

[   46.075173] cpufreq-core: adding CPU 1
[   46.075176] cpufreq-core: initialization failed

Same for the 2nd CPU.

[   46.075180] cpufreq-core: no CPU initialized for driver centrino

here we hit this part of cpufreq_register_driver

                /* if all ->init() calls failed, unregister */
                if (ret) {
                        dprintk("no CPU initialized for driver %s\n",
                                                        driver_data->name);
                        sysdev_driver_unregister(&cpu_sysdev_class,
                                                &cpufreq_sysdev_driver);


So we release all the refs.


[   46.075185] cpufreq-core: unregistering CPU 0
[   46.075190] cpufreq-core: unregistering CPU 1

These are the sysdev callbacks.

[   46.429147] powernow: This module only works with AMD K7 CPUs
[   47.081642] speedstep-lib: x86: f, model: 6
[   47.081649] speedstep-ich: Intel(R) SpeedStep(TM) capable processor not found

These drivers don't even get as far as calling cpufreq_register_driver,
they ENODEV way before things get that far along.

[   47.262236] acpi-cpufreq: acpi_cpufreq_init
[   47.262242] acpi-cpufreq: acpi_cpufreq_early_init
[   47.262262] cpufreq-core: trying to register driver acpi-cpufreq
[   47.262272] ------------[ cut here ]------------
[   47.267635] WARNING: at drivers/base/sys.c:173 sysdev_driver_register+0x34/0xce()

Boom.  I'm really puzzled. At this point, we shouldn't have any leaked refs
on the objects.  Needs more thinking.

	Dave

-- 
http://www.codemonkey.org.uk
