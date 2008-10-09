Return-Path: <linux-kernel-owner+w=401wt.eu-S1757164AbYJIVRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164AbYJIVRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 17:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbYJIVRL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 17:17:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:11461 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272AbYJIVRJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 17:17:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,385,1220252400"; 
   d="scan'208";a="389635404"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC][PATCH 0a/3] TXT: Intel(R) Trusted ExecutionTechnologysupport for Linux - Overview
Date: Thu, 9 Oct 2008 14:16:14 -0700
Message-ID: <D936D925018D154694D8A362EEB0892005B12EC4@orsmsx416.amr.corp.intel.com>
In-Reply-To: <20081009184552.GF12507@elf.ucw.cz>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC][PATCH 0a/3] TXT: Intel(R) Trusted ExecutionTechnologysupport for Linux - Overview
Thread-Index: AckqPw/LdRiYrtn+T9O9ZN2TwOAx5wAD4skg
References: <D936D925018D154694D8A362EEB0892005AC105B@orsmsx416.amr.corp.intel.com> <20081009125311.GD1623@ucw.cz> <20081009174427.GB6912@sequoia.sous-sol.org> <20081009175938.GA12507@elf.ucw.cz> <20081009181451.GD6912@sequoia.sous-sol.org> <20081009182149.GE12507@elf.ucw.cz> <D936D925018D154694D8A362EEB0892005B12CC8@orsmsx416.amr.corp.intel.com> <20081009184552.GF12507@elf.ucw.cz>
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: "Pavel Machek" <pavel@suse.cz>
Cc: "Chris Wright" <chrisw@sous-sol.org>, <linux-kernel@vger.kernel.org>,
       "Wang, Shane" <shane.wang@intel.com>, "Wei, Gang" <gang.wei@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       "Chris Wright" <chrisw@redhat.com>, "Jan Beulich" <jbeulich@novell.com>,
       <mingo@elte.hu>, <tytso@mit.edu>
X-OriginalArrivalTime: 09 Oct 2008 21:16:53.0039 (UTC) FILETIME=[59E243F0:01C92A54]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Pavel Machek [mailto:pavel@suse.cz]
> Sent: Thursday, October 09, 2008 11:46 AM
> 
> > > > > You exit/reenter the trusted mode accross sleep... so any
guarantees
> > > > > "trusted" mode does are void, right?
> > > >
> > > > You exit from kernel to tboot on any shutdown, which handles the
proper
> > > > teardown of the measured env (meaning you also come back on via
tboot).
> > > > So things like saving tpm state, scrubbing secrets from memory,
etc.
> > >
> > > Aha, so instead sleep mode is useless because I'll have to remount
all
> > > the crypto filesystems and restart all the apps...
> >
> > Sleep mode works the same as it does today (caveat S4 issue which we
> > will fix), it just goes through the tboot code before putting the
> > platform HW into the appropriate state.  What this process is adding
is
> > that on resume, tboot will get control from BIOS instead of the
kernel.
> > Then tboot will re-launch the TXT environment before going back to
the
> > kernel at the kernel's expected S3 resume vector.  The
re-establishing
> > of the protected environment won't disrupt the subsequent kernel
resume
> > process.
> 
> No, I don't get it. So presumably useful thing to do is to seal my
> crypto partition so that only known-good kernel can access it?
> 
> But then, the crypto keys will be in ram during suspend/resume
> (because I have the filesystem mounted) => I loose any guarantees?

This goes to the threat model for S3.  The current code assumes that the
S3 resume process is trusted.  That is, the memory image will not be
compromised between the time tboot turns off TXT in order to put the
platform into S3 and the time TXT is re-launched.  For this model, the
purpose of re-launching is to re-establish the original PCR values and
the reset protection.

If stronger protection is desired, the apps that manage keys would need
to seal the keys to the current DRTM PCRs and then clear the plaintext
copies, before the system enters S3.  The tboot and Linux code would
also need to put a (U)MAC over all of the image (the kernel could UMAC
userspace and tboot would UMAC the kernel).  The UMAC that tboot
calculates would get sealed before entry into S3 and then unsealed and
validated upon resume.  OF course this adds time to both entry and
resume.

Joe
