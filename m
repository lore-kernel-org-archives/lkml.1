Return-Path: <linux-kernel-owner+w=401wt.eu-S1754794AbYJBQ1X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794AbYJBQ1X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 12:27:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753692AbYJBQ1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 12:27:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:28673 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753577AbYJBQ1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 12:27:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,352,1220252400"; 
   d="scan'208";a="446247564"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC PATCH 07/12] e1000e: debug contention on NVM SWFLAG
Date: Thu, 2 Oct 2008 09:27:12 -0700
Message-ID: <36D9DB17C6DE9E40B059440DB8D95F52064FB25C@orsmsx418.amr.corp.intel.com>
In-Reply-To: <200810021703.43770.okir@suse.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC PATCH 07/12] e1000e: debug contention on NVM SWFLAG
Thread-Index: AckkoBSVL2WGi3ebQjKTDIsvPze3oQACf8gA
References: <20080930030825.22950.18891.stgit@jbrandeb-bw.jf.intel.com> <20080930031952.22950.45228.stgit@jbrandeb-bw.jf.intel.com> <Pine.LNX.4.64.0810021624380.1887@twin.jikos.cz> <200810021703.43770.okir@suse.de>
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
To: "Olaf Kirch" <okir@suse.de>, "Jiri Kosina" <jkosina@suse.cz>
Cc: <linux-kernel@vger.kernel.org>, <linux-netdev@vger.kernel.org>,
       <kkeil@suse.de>, <agospoda@redhat.com>, <arjan@linux.intel.com>,
       "Graham, David" <david.graham@intel.com>,
       "Allan, Bruce W" <bruce.w.allan@intel.com>,
       "Ronciak, John" <john.ronciak@intel.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, <chris.jones@canonical.com>,
       <tim.gardner@intel.com>, <airlied@gmail.com>
X-OriginalArrivalTime: 02 Oct 2008 16:27:13.0597 (UTC) FILETIME=[BA099ED0:01C924AB]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olaf Kirch wrote:
> Looks like the e1000 watchdog racing with some dhclient activity
> (upping the interface). 
 
> I just noticed that the driver actually uses register pages. So it
> looks like it's possible to have something like this without the
> mutex: 
> 
> 	process A selects page A
> 	process B selects page B
> 	process A writes to register at offset A'

I think that is possible, which is why the mutex patch would be good for
the future.  However we have not shown that to be happening as a root
cause, but I don't rule it out.

so, why now?  Drivers since before the e1000/e1000e split had this same
code, with no reports of problems.  This code has been heavily tested,
and one of the platforms easily reproducing this has been available for
3 years now (ich8), with code that is basically unchanged in the driver.
 
> So we may end up writing to the wrong register. I think I heard
> Vojtech mention 
> that the e1000e also has a register based interface to erase/rewrite
> the NVM programmatically. Do we know at which offsets these registers
> live? 

The flash control registers are documented in the ICH documentation, and
are located at physical memory location indicated by BAR1 in the config
space of device 0:19.0

I wonder if we couldn't put a check in to see if the value we end up
reading from the register controlling the operation matches the
operation we were expecting (read vs write vs block erase)
