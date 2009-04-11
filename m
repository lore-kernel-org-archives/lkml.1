Return-Path: <linux-kernel-owner+w=401wt.eu-S1752517AbZDMPOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517AbZDMPOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 11:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbZDMPOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 11:14:45 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:42566 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751653AbZDMPOp (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 11:14:45 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
Subject: Re: mmotm 2009-04-10-02-21 uploaded - forkbombed by work_for_cpu
In-Reply-To: Your message of "Fri, 10 Apr 2009 02:22:23 PDT."
             <200904100922.n3A9MOIV013828@imap1.linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <200904100922.n3A9MOIV013828@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1239456126_4005P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 11 Apr 2009 09:22:06 -0400
Message-ID: <4609.1239456126@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1239456126_4005P
Content-Type: text/plain; charset=us-ascii

On Fri, 10 Apr 2009 02:22:23 PDT, akpm@linux-foundation.org said:
> The mm-of-the-moment snapshot 2009-04-10-02-21 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/

My system is reporting 70-90 forks per second, 'lastcomm' is reporting:

work_for_cpu      F    root     ??         0.00 secs Sat Apr 11 08:37
work_for_cpu      F    root     ??         0.00 secs Sat Apr 11 08:37
work_for_cpu      F    root     ??         0.00 secs Sat Apr 11 08:37
work_for_cpu      F    root     ??         0.00 secs Sat Apr 11 08:37
work_for_cpu      F    root     ??         0.00 secs Sat Apr 11 08:37
work_for_cpu      F    root     ??         0.00 secs Sat Apr 11 08:37
work_for_cpu      F    root     ??         0.00 secs Sat Apr 11 08:37
work_for_cpu      F    root     ??         0.00 secs Sat Apr 11 08:37
work_for_cpu      F    root     ??         0.00 secs Sat Apr 11 08:37

(and about 100K more of same).

Reverting this commit made the forks go away:

commit 6b44003e5ca66a3fffeb5bc90f40ada2c4340896
Author: Andrew Morton <akpm@linux-foundation.org>
Date:   Thu Apr 9 09:50:37 2009 -0600

    work_on_cpu(): rewrite it to create a kernel thread on demand

No, I don't see why this generated a user-visible fork and accounting
record to be cut.  Maybe that's a normal side effect of kthread_create()
that I've never noticed because kthreads rarely exit, especially not at
90/sec.  I also don't know who's *calling* work_on_cpu() 90 times a
second, but I suspect it's this:

    This is not terribly fast, but the only current caller of work_on_cpu() is
    pci_call_probe().

Umm. No.

% find . -name '*.c' | xargs grep -l work_on_cpu 2> /dev/null 
./arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c
./arch/x86/kernel/microcode_core.c
./arch/x86/kernel/acpi/cstate.c
./arch/x86/kernel/apm_32.c
./kernel/workqueue.c
./drivers/acpi/processor_throttling.c
./drivers/pci/pci-driver.c

Probable cause for my problem:

arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c calls work_on_cpu(). We get into a
state where we have enough activity to kick us to a high CPU speed, and then
the activity of writing 90 acct records per sec keeps us there - with continual
callbacks to see if we can drop the CPU speed.


--==_Exmh_1239456126_4005P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJ4Jl+cC3lWbTT17ARAlWkAJ0cE21Ct8xo1I03rFGxO+8hq6KnXgCgyMiX
rbUSSCmVWq3AIsMP0i6s+wE=
=lcWo
-----END PGP SIGNATURE-----

--==_Exmh_1239456126_4005P--
