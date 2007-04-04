Return-Path: <linux-kernel-owner+w=401wt.eu-S1751934AbXDDVfU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934AbXDDVfU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 17:35:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751970AbXDDVfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 17:35:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:30977 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751988AbXDDVfO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 17:35:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,372,1170662400"; 
   d="scan'208"; a="68833229:sNHT21113856"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Could the k8temp driver be interfering with ACPI?
Date: Wed, 4 Apr 2007 14:35:01 -0700
Message-ID: <B28E9812BAF6E2498B7EC5C427F293A40236B9E3@orsmsx415.amr.corp.intel.com>
In-Reply-To: <20070403092102.1b3d3a23.khali@linux-fr.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Could the k8temp driver be interfering with ACPI?
Thread-Index: Acd1wPIfzkr486rISNqU+TZNWCDGXQBPvfWQ
From: "Moore, Robert" <robert.moore@intel.com>
To: "Jean Delvare" <khali@linux-fr.org>
Cc: "Pavel Machek" <pavel@ucw.cz>, "Brown, Len" <len.brown@intel.com>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Rudolf Marek" <r.marek@assembler.cz>, <linux-acpi@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       <lm-sensors@lm-sensors.org>
X-OriginalArrivalTime: 04 Apr 2007 21:35:04.0340 (UTC) FILETIME=[1B801540:01C77701]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Could regular Linux device drivers install such handlers for a
specific
> I/O region?

No. ACPICA only supports operation region handlers on a
per-address-space basis, not per-region.

> Basically an SMBus transaction looks like this:
> 1* Prepare the transaction.
> 2* Start the transaction.
> 3* Wait for the transaction to complete, typically a few ms.
> 4* Read the result of the transaction.

As far as the AML interpreter is concerned, access to the SMBus is via
an operation region. So, each access to such a region would encompass a
single SMBus transaction. Also, the interpreter remains locked during
this access (I'm fairly sure) even though the EC driver is involved.

> > execution of a different control method. A control method can only
> > assume that access to global objects is exclusive for any period the
> > control method does not block.
> 
> Do I/O regions count as "global objects"?

I think the spec is referring to any global namespace object. This
includes operation regions, so the answer is yes, as long as access to
the region does not block and cause the interpreter to be released. As
far as ACPICA, none of the default handlers for operation regions will
block.

Bob


> -----Original Message-----
> From: Jean Delvare [mailto:khali@linux-fr.org]
> Sent: Tuesday, April 03, 2007 12:21 AM
> To: Moore, Robert
> Cc: Pavel Machek; Brown, Len; Matthew Garrett; Chuck Ebbert; Rudolf
Marek;
> linux-acpi@vger.kernel.org; linux-kernel; lm-sensors@lm-sensors.org
> Subject: Re: Could the k8temp driver be interfering with ACPI?
> 
> Hi Bob,
> 
> On Mon, 2 Apr 2007 13:55:49 -0700, Moore, Robert wrote:
> > The ACPI specification allows concurrent execution of control
methods
> > although methods cannot be preempted. The ACPICA interpreter mutex
is
> > used to implement this model.
> >
> > From section 5.5.2, "Control Method Execution": Interpretation of a
> > Control Method is not preemptive, but it can block. When a control
> > method does block, the operating software can initiate or continue
the
> > execution of a different control method. A control method can only
> > assume that access to global objects is exclusive for any period the
> > control method does not block.
> 
> Do I/O regions count as "global objects"?
> 
> > Therefore, the interpreter lock is acquired and a control method is
> > allowed to execute to completion unless it blocks on one of the
events
> > described below. If the method blocks, the interpreter is unlocked
and
> > other control methods may execute.
> >
> > I'm not sure what you mean by "in the middle of an SMBus
transaction", I
> > don't know how long such a transaction is valid. I might guess that
a
> > single transaction can only span a single operation region access,
but
> > I'm not sure of this.
> 
> Basically an SMBus transaction looks like this:
> 1* Prepare the transaction.
> 2* Start the transaction.
> 3* Wait for the transaction to complete, typically a few ms.
> 4* Read the result of the transaction.
> 
> Steps 1 and 2 require writing to the SMBus I/O region. Step 4 requires
> reading from it, and so does step 3 if the wait loop is poll-based.
The
> transaction is only safe if we have an exclusive access to the I/O
> region during all the 4 steps. My fear is that step 3 could be
> implemented by ACPI using either a Sleep() or Acquire() or Wait()
> opcode. If it is, we're doomed. OTOH, if it does, it is probably not
> even safe for itself, unless there's an additional,
> implementation-specific mutex to protect SMBus transactions. I yet
have
> to get my hands on the DSDT of ACPI implementations which actually
> access the SMBus to see exactly how they do it.
> 
> > A user-installed operation region handler is an operation region
handler
> > that is installed by a device driver. This feature would probably
only
> > be used for custom (OEM-defined) operation region address spaces. (I
> > have not seen one yet.) For the standard address spaces (memory,
I/O,
> > etc.), usually only the default handlers are used.
> 
> Could regular Linux device drivers install such handlers for a
specific
> I/O region? I'm asking because Rudolf Marek's proposal [1] to solve
the
> concurrent access problem involved extending struct resource with
> callbacks to driver-specific routines to handle external access to an
> I/O region. This sounds somewhat similar to these "user-installed
> operation region handler" defined by ACPI, doesn't it? If ACPI already
> has an infrastructure to handle this problem, we probably want to use
> it rather than implementing our own.
> 
> [1] http://marc.info/?l=linux-kernel&m=117302946017204&w=2
> 
> --
> Jean Delvare
