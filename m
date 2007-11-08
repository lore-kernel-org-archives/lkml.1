Return-Path: <linux-kernel-owner+w=401wt.eu-S1761585AbXKHRUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761585AbXKHRUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2007 12:20:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759962AbXKHRTw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Nov 2007 12:19:52 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:40640 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760662AbXKHRTv (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2007 12:19:51 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Mark Gross <mgross@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.23-mm1 breaks C-state support on Intel T7200 x86_64
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1194542384_3143P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 08 Nov 2007 12:19:44 -0500
Message-ID: <3624.1194542384@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1194542384_3143P
Content-Type: text/plain; charset=us-ascii

(Sorry for not reporting this sooner - I haven't been running off battery
much in the last 3 weeks, so I didn't notice it till now...)

Dell Latitude D820 laptop, T7200 Core2 Duo CPU, x86_64 kernel.

As reported by 'powertop' on a basically idle machine:

2.6.23-mm1:

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        (100.0%)        2.00 Ghz     0.8%
C1                0.0ms ( 0.0%)         1.67 Ghz     0.0%
C2                0.0ms ( 0.0%)         1333 Mhz     0.0%
C3                0.0ms ( 0.0%)         1000 Mhz    99.2%

2.6.23-rc8-mm2:

Cn                Avg residency       P-states (frequencies)
C0 (cpu running)        ( 0.3%)         2.00 Ghz     0.0%
C1                0.0ms ( 0.0%)         1.67 Ghz     0.0%
C2                0.0ms ( 0.0%)         1333 Mhz     0.0%
C3               31.5ms (99.7%)         1000 Mhz   100.0%

In addition, the ACPI power estimate reported about 25 watts for 23-mm1,
but only 21 watts for -rc8-mm2, a significant regression.

I bisected this down to this set of patches:

pm-qos-infrastructure-and-interface.patch
pm-qos-infrastructure-and-interface-fix.patch
pm-qos-infrastructure-and-interface-vs-git-acpi.patch
pm-qos-infrastructure-and-interface-vs-git-acpi-2.patch
latencyc-use-qos-infrastructure.patch

The patch says:

  To register the default pm_qos target for the specific parameter, the
  process must open one of /dev/[cpu_dma_latency, network_latency,
  network_throughput]

  As long as the device node is held open that process has a registered
  requirement on the parameter.  The name of the requirement is
  "process_<PID>" derived from the current->pid from within the open system
  call.

I shouldn't have to have a process open a /dev/file, write a number, and then
stay around forever so the file doesn't close in order to get the same behavior
I was getting by default before.  What needs to happen to get this to not
be a behavior regression/change?





--==_Exmh_1194542384_3143P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHM0UwcC3lWbTT17ARAht9AKCGHKp43NZXYB6rZwGk4vaWJHeU9wCgzqG3
iF9ZKXsWsXlvnvj+Pu8/r7k=
=XTrD
-----END PGP SIGNATURE-----

--==_Exmh_1194542384_3143P--
