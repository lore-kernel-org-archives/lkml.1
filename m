Return-Path: <linux-kernel-owner+w=401wt.eu-S965872AbXDBU4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965872AbXDBU4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2007 16:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965866AbXDBU4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Apr 2007 16:56:18 -0400
Received: from mga03.intel.com ([143.182.124.21]:11857 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965844AbXDBU4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2007 16:56:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,362,1170662400"; 
   d="scan'208"; a="206966853:sNHT59487120"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Could the k8temp driver be interfering with ACPI?
Date: Mon, 2 Apr 2007 13:55:49 -0700
Message-ID: <B28E9812BAF6E2498B7EC5C427F293A40232DFA9@orsmsx415.amr.corp.intel.com>
In-Reply-To: <20070402174859.80b74b05.khali@linux-fr.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Could the k8temp driver be interfering with ACPI?
Thread-Index: Acd1PsaXUwcRYZFtT9SjIsl7ctLFlgAJ1pyQ
From: "Moore, Robert" <robert.moore@intel.com>
To: "Jean Delvare" <khali@linux-fr.org>, "Pavel Machek" <pavel@ucw.cz>,
       "Brown, Len" <len.brown@intel.com>
Cc: "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Rudolf Marek" <r.marek@assembler.cz>, <linux-acpi@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       <lm-sensors@lm-sensors.org>
X-OriginalArrivalTime: 02 Apr 2007 20:55:50.0692 (UTC) FILETIME=[4BCA6640:01C77569]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The ACPI specification allows concurrent execution of control methods
although methods cannot be preempted. The ACPICA interpreter mutex is
used to implement this model. 

>From section 5.5.2, "Control Method Execution": Interpretation of a
Control Method is not preemptive, but it can block. When a control
method does block, the operating software can initiate or continue the
execution of a different control method. A control method can only
assume that access to global objects is exclusive for any period the
control method does not block.

Therefore, the interpreter lock is acquired and a control method is
allowed to execute to completion unless it blocks on one of the events
described below. If the method blocks, the interpreter is unlocked and
other control methods may execute.

I'm not sure what you mean by "in the middle of an SMBus transaction", I
don't know how long such a transaction is valid. I might guess that a
single transaction can only span a single operation region access, but
I'm not sure of this.

A user-installed operation region handler is an operation region handler
that is installed by a device driver. This feature would probably only
be used for custom (OEM-defined) operation region address spaces. (I
have not seen one yet.) For the standard address spaces (memory, I/O,
etc.), usually only the default handlers are used.

Bob



> -----Original Message-----
> From: linux-acpi-owner@vger.kernel.org [mailto:linux-acpi-
> owner@vger.kernel.org] On Behalf Of Jean Delvare
> Sent: Monday, April 02, 2007 8:49 AM
> To: Pavel Machek; Brown, Len
> Cc: Matthew Garrett; Chuck Ebbert; Rudolf Marek; linux-
> acpi@vger.kernel.org; linux-kernel; lm-sensors@lm-sensors.org
> Subject: Re: Could the k8temp driver be interfering with ACPI?
> 
> Looking at the comment before acpi_ex_exit_interpreter raises two
> questions though:
> 
> >  * Cases where the interpreter is unlocked:
> >  *      1) Completion of the execution of a control method
> >  *      2) Method blocked on a Sleep() AML opcode
> >  *      3) Method blocked on an Acquire() AML opcode
> >  *      4) Method blocked on a Wait() AML opcode
> >  *      5) Method blocked to acquire the global lock
> >  *      6) Method blocked to execute a serialized control method
that is
> >  *          already executing
> >  *      7) About to invoke a user-installed opregion handler
> 
> 1* This suggests that the mutex could be released by the AML
> interpreter in the middle of an SMBus transaction. If so, and if it
> happens in practice, this means that we unfortunately cannot use this
> mutex to reliably protect the SMBus drivers from concurrent accesses.
> This even suggests that it's simply not possible to have a mutex we
> take at the beginning when entering the AML interpreter and we release
> when leaving the AML interpreter, as it looks like ACPI itself allows
> interlaced execution of AML functions. Len, is this true?
> 
> What is the purpose of the ACPI_MTX_INTERPRETER mutex in the first
> place, given that it seems it will be released on numerous occasions?
> Is it to prevent concurrent AML execution while still allowing
> interlaced execution?
> 
> 2* What are "user-installed opregion handlers"? Are they something
that
> could help solve the ACPI vs. other drivers problem?
> 
> Thanks.
