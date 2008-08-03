Return-Path: <linux-kernel-owner+w=401wt.eu-S1758346AbYHCPmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758346AbYHCPmc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2008 11:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756128AbYHCPmY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Aug 2008 11:42:24 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:47068 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbYHCPmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2008 11:42:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=j6aP5euwuR1dqlx/w/C3bO06uf1xopTffiHlSGdQWzsAnYz2aLPEF01rVSopyWlp02
         5MWx49bWArZ9TYon2tXQh4pxzMenkgQR6Di9w+McwL4ccLG8pjYogbCRC+UdvkxySkuc
         2sgiptQdDzbLVQPjSPYfO9D1lDNE6X3tZV3Sk=
Subject: [rfc-patch, bugfix] x86-microcode
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Oruba <peter.oruba@amd.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Max Krasnyansky <maxk@qualcomm.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 03 Aug 2008 17:42:15 +0200
Message-Id: <1217778135.4912.40.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,


[ consider it a pre-release and RFC... I'm a bit in hurry now and just send what I have got by this moment.
Although, I expect it to be workable ]


this change is supposed to fix bug#11197 (note, its name "Oops in microcode sysfs registration" is misleading)

The problem description can be found here:
http://www.ussg.iu.edu/hypermail/linux/kernel/0807.3/3791.html
or
http://lkml.org/lkml/2008/7/24/260

perhaps it does look quite bulky for -rc, although it's mainly move-redesign-some-bits of the code and
I tried to preserve the original logic (even if it looked like a possible optimizations might had been applied)
as much as possible.

The basic idea is that we introduce another mechanism to run ucode-updates on a target cpu
and replace set_cpus_allowed_ptr() in (1) cpu-hotplug events and (2) module load.


[1/2] x86-microcode: generic updates

Basically, it introduces microcode_update_cpu() which can be run either from start_secondary()
(perhaps via a function pointer) or scheduled via keventd ([2/2]) and reworks the logic of cpu-hotplug events.

[2/2] x86-microcode: do updates via workqueue


More testing is necessary. I tested without ucode-package (so only generic machinery) and for
- load/unload module;
- cpu-hotplug (so it doesn't give an oops anymore)

hm, suspend/resume seems to be broken even without the 'microcode' module (will check the date of my previous kernel).


--Dmitry



