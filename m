Return-Path: <linux-kernel-owner+w=401wt.eu-S1752262AbXCaIFi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbXCaIFi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 04:05:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbXCaIFh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 04:05:37 -0400
Received: from h80ad2689.async.vt.edu ([128.173.38.137]:38900 "EHLO
	h80ad2689.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752262AbXCaIFe (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 04:05:34 -0400
Message-Id: <200703310805.l2V85PA4004332@turing-police.cc.vt.edu>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Len Brown <len.brown@intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.21-rc5-mm3 - cpuidle, acpi, and C-states
In-Reply-To: Your message of "Fri, 30 Mar 2007 01:05:59 PDT."
             <20070330010559.2a232d9a.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070330010559.2a232d9a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1175328325_3891P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 31 Mar 2007 04:05:25 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1175328325_3891P
Content-Type: text/plain; charset="us-ascii"
Content-Id: <4319.1175328312.1@turing-police.cc.vt.edu>

On Fri, 30 Mar 2007 01:05:59 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm3/

Somebody is confused (possibly me).  Running an x86_64 kernel, and I have:

% cat /proc/acpi/processor/CPU0/power
active state:            C0
max_cstate:              C8
bus master activity:     00000000
maximum allowed latency: 2000 usec
states:
    C1:                  type[C1] promotion[--] demotion[--] latency[001] usage[00000003] duration[00000000000000000000]
    C2:                  type[C2] promotion[--] demotion[--] latency[001] usage[00166266] duration[00000000000000000000]
    C3:                  type[C3] promotion[--] demotion[--] latency[057] usage[02045938] duration[00000000000000000000]

Wow. Lots of zeros in that last column..

The 'duration' is output by this code in drivers/acpi/processor_idle.c that
thinks the value is an 'unsigned long long':

                seq_printf(seq, "latency[%03d] usage[%08d] duration[%020llu]\n",
                           pr->power.states[i].latency,
                           pr->power.states[i].usage,
                           (unsigned long long)pr->power.states[i].time);

However, over in /sys, we have non-zero values for the usage/time:

%  cat /sys/devices/system/cpu/cpu0/cpuidle/state?/time
0
110861364
-2091818383

That's because in drivers/cpuidle/sysfs.c, we have this code that thinks
a %d is suitable to output that number:

#define define_show_state_function(_name) static ssize_t show_state_##_name(struct cpuidle_state *state, char *buf) { \     
        return sprintf(buf, "%d\n", state->_name);\
}
...
define_one_state_ro(time, show_state_time);

But the negative number for state2/time indicates that *this* isn't right either....

--==_Exmh_1175328325_3891P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGDhZFcC3lWbTT17ARAi7nAKDlvwYnzkMxorBXocNDcxNlJrwYcACgtz/M
0Ua/ABwYIxF9srL0V/wVNeQ=
=iu39
-----END PGP SIGNATURE-----

--==_Exmh_1175328325_3891P--
