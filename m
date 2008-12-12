Return-Path: <linux-kernel-owner+w=401wt.eu-S1755237AbYLLVnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbYLLVnL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753368AbYLLVm5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:42:57 -0500
Received: from relay2.sgi.com ([192.48.179.30]:56883 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753327AbYLLVm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:42:57 -0500
Date: Fri, 12 Dec 2008 15:42:56 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org
Subject: Intel x86_64 llc_shared_map/cpu_llc_id anomolies
Message-ID: <20081212214256.GA20559@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing some behavior on a multiblade Intel x86_64 that does not
appear to be correct.

My x86_64 multiblade configuration has llc_shared_map (last level
cache shared map) showing cpus on different blades sharing a last
level cache.  With 2 cpus/blade and 4 blades (8 cpus total), I show
cpus 1,3,5,7 sharing llc, and 0,2,4,6 sharing llc.

The llc_shared_map is set based on matching values of cpu_llc_id
(last level cache ID).  The cpu_llc_id is set based on
cpuinfo_x86->apicid.  This value is set to cpuinfo_x86->initial_apicid.

The value of cpuinfo_x86->initial_apicid appears to be set twice
during startup:

- In generic_identify(), using the value returned by cpuid_ebx(1).
  This is the initial_apicid set at poweron, and results in
  cpuinfo_x86->initial_apicid having a value that is not unique across
  blades (where the blades do not share a cpu bus).

- Later, in detect_extended_topology() using the value for edx returned
  by cpuid_count(0xb,..).  This results in cpuinfo_x86->initial_apicid
  having a value that appears to be unique across blades.

Between those two assignments, cpuinfo_x86->apicid is set to
cpuinfo_x86->initial_apicid, so it is non-unique.  Then cpu_llc_id gets
set in init_intel_cacheinfo(), so cpu_llc_id winds up with a value that
is non-unique across blades, and llc_shared_map winds up showing cpus
on different blades as sharing last level cache.

Is cpu_llc_id supposed to be unique across blades?  I assume
llc_shared_map should not be showing shared cache across blades.
