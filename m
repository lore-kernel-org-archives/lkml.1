Return-Path: <linux-kernel-owner+w=401wt.eu-S1758112AbZAOCyK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112AbZAOCyK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 21:54:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753575AbZAOCxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 21:53:54 -0500
Received: from mga01.intel.com ([192.55.52.88]:28825 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752754AbZAOCxx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 21:53:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,265,1231142400"; 
   d="scan'208";a="422508203"
Subject: Re: [2.6.28] Kernel panic after closing lid on HP 2510p
From: Zhang Rui <rui.zhang@intel.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Martin Michlmayr <tbm@cyrius.com>,
       "elendil@planet.nl" <elendil@planet.nl>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       fengguang.wu@intel.com
In-Reply-To: <20090115022106.GA19069@srcf.ucam.org>
References: <200901121356.46236.elendil@planet.nl>
	 <20090113123056.GA2464@deprecation.cyrius.com>
	 <20090114162603.c632d82e.akpm@linux-foundation.org>
	 <20090115020311.GA18740@srcf.ucam.org>
	 <20090114181542.34614acf.akpm@linux-foundation.org>
	 <20090115022106.GA19069@srcf.ucam.org>
Content-Type: text/plain; charset=utf-8
Date: Thu, 15 Jan 2009 10:55:03 +0800
Message-Id: <1231988103.20746.149.camel@rzhang-dt>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-01-15 at 10:21 +0800, Matthew Garrett wrote:
> On Wed, Jan 14, 2009 at 06:15:42PM -0800, Andrew Morton wrote:
> > On Thu, 15 Jan 2009 02:03:11 +0000 Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> > > Lid actions typically trigger SMI code, so it's entirely capable of 
> > > destroying CPU state in such a way that the kernel falls over (and 
> > > probably even in ways that cause the kernel to turn green, emit pleasing 
> > > warbling noises or invade neighbouring pieces of hardware). In this case 
> > > it seems to be SMP specific - the system's entirely stable in UP mode. 
> > > It's greatly vexing.
> > 
> > Does it always crash in the same way?
> 
> Not in my experience. Sometimes it falls over in the ACPI parsing code, 
> but sometimes the backtrace is nonsense and the IP is in the middle of 
> nowhere. I've now got a working 2510p again, so maybe I'll have time to 
> look at this on the way to LCA.
> 
please check if this is a duplicate of bug #11259.
http://bugzilla.kernel.org/show_bug.cgi?id=11259


We (Wu, fengguang and me) reproduced this bug on a HP 6910p.
and we found that windows run a different AML code path when closing Lid
on this laptop and the SMI is not invoked...
And I have verified how to make Linux run the same code path by changing
the IGD OpRegion code.

DIDL is an IGD OpRegion field, as the Supported Display Devices ID List.
﻿it's evaluated by the _DOD method when ACPI video driver is loaded.
And according to the spec, "The graphics driver writes to this field
once during its initialization"
if DIDL is not empty, a flag is set and the SMI will not be invoked when
closing the lid.
In our tests, this field (DIDL) is set in windows when _DOD is invoked
while it's not in Linux.
I can workaround this bug by setting the DIDL manually in AML code.

So a patch setting the DIDL in i915_opregion.c should be a proper fix
for this problem. Fengguang will cook up a patch later.

But there is still one mystery left.
Windows doesn't break even if the SMI is invoked...

thanks,
rui




