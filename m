Return-Path: <linux-kernel-owner+w=401wt.eu-S1754502AbZBJDxX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbZBJDxX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 22:53:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752799AbZBJDxP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 22:53:15 -0500
Received: from yx-out-2324.google.com ([74.125.44.28]:37784 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752709AbZBJDxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 22:53:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=w6nHUFzY5bijyNIAxsUBBVyisEPBYXS6QyVLbcp8RiZRWM1a9iCv+NYEyxTqRy0OG0
         vsrrKf9MewsimhIBWjH54DhADBEbr2/Eq1lEzinlgyEOFYxTxOtyttjlPjzVjgE6K21Z
         7dwmZ4lZCZjtLJwPR1ECpumpEviCl7W+lTerk=
MIME-Version: 1.0
Date: Tue, 10 Feb 2009 01:53:13 -0200
Message-ID: <cc0fa41f0902091953y2ab718fcmdbd1c42acf270e08@mail.gmail.com>
Subject: ACPI regression in 2.6.29 - cpufreq_performance doesn't work
From: Guilherme Malschitzky Schroeder <guilherme.m.schroeder@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

If i set performance for scaling_governor using 2.6.29-rc4-git2,
ondemand stills control my CPU.
I get just 800MHz instead of 2268MHz.

dub:/sys/devices/system/cpu/cpu0/cpufreq# cat cpuinfo_cur_freq
800000
dub:/sys/devices/system/cpu/cpu0/cpufreq# echo performance > scaling_governor
dub:/sys/devices/system/cpu/cpu0/cpufreq# cat scaling_governor
performance
dub:/sys/devices/system/cpu/cpu0/cpufreq# cat cpuinfo_cur_freq
2267000

But, /proc/cpuinfo still shows 800MHz:

model name      : Intel(R) Core(TM)2 Duo CPU     P8400  @ 2.26GHz
stepping        : 6
cpu MHz         : 800.000

And i cannot remove the ondemand module, that is not used anymore:

dub:/sys/devices/system/cpu/cpu0/cpufreq# rmmod cpufreq_ondemand
ERROR: Module cpufreq_ondemand is in use

I can confirm that it's not at 2268MHz because glxgears differs:
alemao@dub:~/linux-2.6$ glxgears
4268 frames in 5.0 seconds = 853.428 FPS
^C
alemao@dub:~/linux-2.6$ sudo cpufreq-set -g ondemand
alemao@dub:~/linux-2.6$ glxgears
3283 frames in 5.0 seconds = 656.429 FPS

With 2.6.29-rc4-git2 and scaling_governor as "performance" i got about ~660FPS.

I've git bisect from 2.6.28.4 (which was working) to 2.6.29-rc4-git2
and i get into this:

alemao@dub:~/linux-2.6$ git bisect good
d96f94c604453f87fe24154b87e1e9a3a72511f8 is first bad commit
commit d96f94c604453f87fe24154b87e1e9a3a72511f8
Author: Pallipadi, Venkatesh <venkatesh.pallipadi@intel.com>
Date:   Mon Feb 2 11:57:18 2009 -0800

    ACPI: Enable bit 11 in _PDC to advertise hw coord

    Bit 11 in intel PDC definitions is meant for OS capability to handle
    hardware coordination of P-states. In Linux we have always supported
    hwardware coordination of P-states. Just let the BIOSes know that we
    support it, by setting this bit.

    Some BIOSes use this bit to choose between hardware or software coordination
    and without this change below, BIOSes switch to software coordination, which
    is not very optimal in terms of power consumption and extra
wakeups from idle.

    Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

:040000 040000 bc006c98ae03b69ad27b2e80227abba178326d8d
e97c37098193793e3e2e719ecdac2fe5eab94104 M      include

Now, without this patch, cpufreq_performance behaves correctly:

alemao@dub:~/linux-2.6$ uname -a
Linux dub 2.6.29-rc2 #27 SMP Tue Feb 10 01:36:46 BRST 2009 x86_64 GNU/Linux
alemao@dub:~/linux-2.6$ cat /proc/cpuinfo | grep MH
cpu MHz         : 2268.000
cpu MHz         : 2268.000
alemao@dub:~/linux-2.6$ cat
/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
performance

Thanks,
