Return-Path: <linux-kernel-owner+w=401wt.eu-S1760208AbZFWXAu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760208AbZFWXAu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 19:00:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757509AbZFWXAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 19:00:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:54551 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756411AbZFWXAl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 19:00:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,277,1243839600"; 
   d="scan'208";a="701934166"
From: "Justen, Jordan L" <jordan.l.justen@intel.com>
To: Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
CC: "sfi-devel@simplefirmware.org" <sfi-devel@simplefirmware.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 23 Jun 2009 16:00:43 -0700
Subject: RE: [SFI-devel] [RFC/PATCH 2.6.32] Simple Firmware Interface (SFI):
	initial support
Thread-Topic: [SFI-devel] [RFC/PATCH 2.6.32] Simple Firmware Interface
 (SFI):	initial support
Thread-Index: Acn0UOVrbaWLjgi1Rmmqjb10+0wItgAA5mzg
Message-ID: <5B8ABB4480AEBB4ABFF06629589B20CD7230EEF8@orsmsx509.amr.corp.intel.com>
References: <1245741246-6503-1-git-send-email-lenb@kernel.org>
	<20090623183153.GB12814@srcf.ucam.org>
	<alpine.LFD.2.00.0906231438190.23079@localhost.localdomain>
	<20090623185120.GA13824@srcf.ucam.org>
	<alpine.LFD.2.00.0906231541400.23079@localhost.localdomain>
	<20090623202302.GA15265@srcf.ucam.org>
	<20090623204524.GA15891@srcf.ucam.org>
 <alpine.LFD.2.00.0906231734170.32098@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0906231734170.32098@localhost.localdomain>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Len,

> Should a platform require them, any and all of the ACPI
> defined/reserved tables can be accessed on an SFI system
> if needed.  Today, the PCI MCFG is the only ACPI table
> implemented in the known universe of SFI systems.

When for ACPI tables are used in SFI, they retain the common
ACPI header format, including the OEM Revision, Creator ID and
Creator Revision fields unlike the other SFI structure, correct?

Regarding stripping those fields from the SFI structures,
how much space does it save in a typical system versus if they
had retained the common header format that ACPI defines?

-Jordan

-----Original Message-----
From: sfi-devel-bounces@simplefirmware.org [mailto:sfi-devel-bounces@simplefirmware.org] On Behalf Of Len Brown
Sent: Tuesday, June 23, 2009 3:20 PM
To: Matthew Garrett
Cc: sfi-devel@simplefirmware.org; linux-kernel@vger.kernel.org
Subject: Re: [SFI-devel] [RFC/PATCH 2.6.32] Simple Firmware Interface (SFI): initial support

On Tue, 23 Jun 2009, Matthew Garrett wrote:

> I think I've got a clearer understanding of my objections to this now. 
> The first is that SFI is designed to support the subset of information 
> that's in ACPI and which can't be intuited by the OS. However, that 
> subset is predicated on the system looking like Moorestown. A system 
> that wants to provide any information beyond that subset can't use SFI 
> unless it defines additional tables.

Correct.

Per my previous message...

Should a platform require them, any and all of the ACPI
defined/reserved tables can be accessed on an SFI system
if needed.  Today, the PCI MCFG is the only ACPI table implemented
in the known universe of SFI systems.

WRT to native SFI table names...

int sfi_table_parse(char *signature, char *oem_id, char *oem_table_id,
                        uint flag, sfi_table_handler handler);

While the invocations in the tree today have NULL oem_id
and NULL oem_table_id, it is possible for a vendor to
stick their own name in there with their own table_id
and get the OS or a driver to find their home-brewed table
without reserving a table signature to the SFI spec.

However, should overwhemling demand for table signatures materialize,
I'm sure that a process can be put in place to manage collisions...

> And that brings me onto my second issue. ACPI is sufficiently 
> generalised that there's little need for vendors to add additional 
> tables. SFI isn't, and so vendor adoption is going to require 
> vendor-specific tables. This potentially results in SFI bloating out to 
> cover much of the functionality of ACPI, while at the same time turning 
> into a namespacing nightmare. Without a formal process for adding new 
> tables and without any kind of certification requirements before 
> claiming SFI compatibility, we're looking at a real risk of collisions.

The SFI table signatures are totally independent of the ACPI table
signatures -- they can not collide.  The only overlap is the XSDT
itself, which exists in SFI explicitly to separate the ACPI namespace
from the SFI namespace.

> SFI appears to be presented as a generic firmware interface, but in 
> reality it's currently tightly wed to Moorestown and I don't see any way 
> that that can be fixed without reinventing chunks of ACPI. I'm certainly 
> not enthusiastic about seeing this presented as a fait accompli in 
> generic driver code, rather than under arch/x86/moorestown.

SFI was invented with the goal to help a somewhat generic 
distro-supported kernel to boot and run optimally
on the Moorestown platform.  If SFI helps enable Moorestown
to participate in even just a small part of the vibrant
x86 open source development community, than it has been successful.

Yes, SFI is written to be "generic enough" so that it can be
used by more than Moorestown.  It is not trying to displace ACPI
on systems that are willing and able to support ACPI, but it
is freely available for those platforms that can't.

cheers,
-Len Brown, Intel Open Source Technology Center

_______________________________________________
sfi-devel mailing list
sfi-devel@simplefirmware.org
http://lists.simplefirmware.org/listinfo/sfi-devel
