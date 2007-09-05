Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbXIEFRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbXIEFRW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 01:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbXIEFRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 01:17:14 -0400
Received: from sslsrv.de ([62.75.159.123]:59910 "EHLO sslsrv.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753453AbXIEFRN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 01:17:13 -0400
X-Greylist: delayed 881 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Sep 2007 01:17:13 EDT
Message-ID: <38292.193.171.152.61.1188968546.squirrel@webmail.marek.priv.at>
Date: Wed, 5 Sep 2007 07:02:26 +0200 (CEST)
Subject: 2.6.23.rc5: Problem with procfs -- schedstat
From: "Ph. Marek" <philipp@marek.priv.at>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.6-4.fc1.1.legacy
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everybody,

I found a problem in /proc/self/schedstat: a simple "cat" can give "wrong"
results.

        /proc# cat self/schedstat
        91117 26027 2
        /proc# cat self/schedstat
        90691 27872 2
        /proc# cat self/schedstat
        995483 15675 3

        /proc# cat self/schedstat
        478050 124422 3
        /proc# cat self/schedstat
        87912 21539 2
        /proc# cat self/schedstat
        81382 19722 2
        /proc# cat self/schedstat
        87999 119699 2
        /proc# cat self/schedstat
        87192 25990 2
        /proc# cat self/schedstat
        80114 15113 2
        3
        /proc# cat self/schedstat
        93064 28817 2
        /proc# cat self/schedstat
        90834 22816 2
        /proc# cat self/schedstat
        87806 37581 2
        /proc# cat self/schedstat
        80187 20283 2
        3
        /proc#

Please note the extra newline and possible other digits.

A strace reveals that cat does
        open("self/schedstat", O_RDONLY|O_LARGEFILE) = 3
        fstat64(3, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
        read(3, "946533 98256 64\n", 4096)      = 16
        write(1, "946533 98256 64\n", 16)       = 16
        read(3, "8\n", 4096)                    = 2
        write(1, "8\n", 2)                      = 2
        read(3, "", 4096)                       = 0
        close(3)                                = 0
        close(1)                                = 0
        exit_group(0)                           = ?

The simple fix would be to change the format in proc_pid_schedstat(), so
that it always returns the same number of bytes.

Or proc_info_read() gets changed - if less bytes than wanted (by userspace)
were returned, mark that file for returning EOF next time. But I fear that
that might break other entries that rely on getting repeatedly called.


Regards,

Phil


-- 
Versioning your /etc, /home or even your whole installation?
             Try fsvs (fsvs.tigris.org)!
