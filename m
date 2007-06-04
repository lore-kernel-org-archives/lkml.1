Return-Path: <linux-kernel-owner+w=401wt.eu-S1758893AbXFDRGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758893AbXFDRGU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 13:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756119AbXFDRGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 13:06:13 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:57363 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958AbXFDRGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 13:06:11 -0400
Date: Mon, 4 Jun 2007 10:07:39 -0700
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Dependent CPU core speed reporting not updated withCPUFREQ_SHARED_TYPE_HW?
Message-ID: <20070604170738.GB12782@tree.beaverton.ibm.com>
References: <20070602064325.GB7445@redhat.com> <653FFBB4508B9042B5D43DC9E18836F5F5B144@scsmsx415.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <653FFBB4508B9042B5D43DC9E18836F5F5B144@scsmsx415.amr.corp.intel.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jun 02, 2007 at 07:19:03AM -0700, Pallipadi, Venkatesh wrote:

> The problem here is that with hardware coordination, kernel need not
> do what we do for affected_cpus today. Kernel can manage each CPU
> independently in terms of setting freq as underlying hardware
> guarantees to do the coordination (picking up the highest freq
> among a group of dependent cpus). So ideally we can just manage cpu
> frequencies as we do today without affected_cpus. But, in this case
> there is a fyi from hardware which says even though OS is thinking that
> CPUs are independent, hardware is doing the coordination across these
> CPUs.

Yes, and ... it appears that (at least on Intel CPUs), writing
IA32_PERF_CTL on any core in the package causes the speed of all CPUs to
be set to the max of all CPU cores.  Here's what I see when
reading/writing the performance control MSRs:

This is with all CPUs set to 2.6GHz.  0x198 = IA32_PERF_STATUS, 0x199 =
IA32_PERF_CTL.

root@elm3a188:/mnt/src/msr/msr-20060208# ./msr -n 0x198 0x199
CPU 0:
   0x00000198 = 0x0828082806000828
   0x00000199 = 0x0000000000000828
CPU 1:
   0x00000198 = 0x0828082806000828
   0x00000199 = 0x0000000000000828

Now, we set scaling_max_freq of CPU 0 to 2GHz:
root@elm3a188:/mnt/src/msr/msr-20060208# ./msr -n 0x198 0x199
CPU 0:
   0x00000198 = 0x0828082806000828
   0x00000199 = 0x000000000000061a
CPU 1:
   0x00000198 = 0x0828082806000828
   0x00000199 = 0x0000000000000828

And now likewise for CPU 1:
root@elm3a188:/mnt/src/msr/msr-20060208# ./msr -n 0x198 0x199
CPU 0:
   0x00000198 = 0x082808280600061a
   0x00000199 = 0x000000000000061a
CPU 1:
   0x00000198 = 0x082808280600061a
   0x00000199 = 0x000000000000061a

Notice that we've written the slower speed to the control register but
the status register says that we're still running at the higher speed.
This seems to corroborate my finding that the power use does not drop
until _both_ cores are lowered.  Unfortunately, in that middle step we
are reporting an incorrect frequency for CPU 0--sysfs says 2GHz but the
hardware itself says 2.6.  This is clearly a bad thing, because I just
set scaling_max_cpufreq on CPU0 to 2GHz, yet it is running 667MHz faster
than it ought to be because CPU1 wants to go faster.

How about this: When hardware coordination is specified in _PSD,
scaling_{min,max}_freq between CPUs in a cpufreq domain are tied
together so that we can be sure that our caps are being followed.
Requests to change speed can be done as they always have, but
afterwards the value of scaling_cur_freq for all CPUs in the cpufreq
domain  will be determined by reading the speed value from hardware
since we can't really be sure how the hardware decided to coordinate
things anyway.  When it becomes the case that individual cores on a
package can run at different speeds, we can drop the _PSD entries.  Does
this scheme sound reasonable?

We might, however, want another sysfs file to tell userspace what kind
of coordination is taking place.

--D

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGZEbaa6vRYYgWQuURAqpBAJwM2NqUXBQCu3neUEt00BxRTLipQQCgphVH
xjNQT8K503eTyoMxam3cNrc=
=Q3u1
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
