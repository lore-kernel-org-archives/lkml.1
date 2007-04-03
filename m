Return-Path: <linux-kernel-owner+w=401wt.eu-S1753497AbXDCHXM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497AbXDCHXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 03:23:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753493AbXDCHXL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 03:23:11 -0400
Received: from smtp-102-tuesday.nerim.net ([62.4.16.102]:3841 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753458AbXDCHXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 03:23:10 -0400
Date: Tue, 3 Apr 2007 09:21:02 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Moore, Robert" <robert.moore@intel.com>
Cc: "Pavel Machek" <pavel@ucw.cz>, "Brown, Len" <len.brown@intel.com>,
       "Matthew Garrett" <mjg59@srcf.ucam.org>,
       "Chuck Ebbert" <cebbert@redhat.com>,
       "Rudolf Marek" <r.marek@assembler.cz>, <linux-acpi@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       <lm-sensors@lm-sensors.org>
Subject: Re: Could the k8temp driver be interfering with ACPI?
Message-Id: <20070403092102.1b3d3a23.khali@linux-fr.org>
In-Reply-To: <B28E9812BAF6E2498B7EC5C427F293A40232DFA9@orsmsx415.amr.corp.intel.com>
References: <20070402174859.80b74b05.khali@linux-fr.org>
	<B28E9812BAF6E2498B7EC5C427F293A40232DFA9@orsmsx415.amr.corp.intel.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bob,

On Mon, 2 Apr 2007 13:55:49 -0700, Moore, Robert wrote:
> The ACPI specification allows concurrent execution of control methods
> although methods cannot be preempted. The ACPICA interpreter mutex is
> used to implement this model. 
> 
> From section 5.5.2, "Control Method Execution": Interpretation of a
> Control Method is not preemptive, but it can block. When a control
> method does block, the operating software can initiate or continue the
> execution of a different control method. A control method can only
> assume that access to global objects is exclusive for any period the
> control method does not block.

Do I/O regions count as "global objects"?

> Therefore, the interpreter lock is acquired and a control method is
> allowed to execute to completion unless it blocks on one of the events
> described below. If the method blocks, the interpreter is unlocked and
> other control methods may execute.
> 
> I'm not sure what you mean by "in the middle of an SMBus transaction", I
> don't know how long such a transaction is valid. I might guess that a
> single transaction can only span a single operation region access, but
> I'm not sure of this.

Basically an SMBus transaction looks like this:
1* Prepare the transaction.
2* Start the transaction.
3* Wait for the transaction to complete, typically a few ms.
4* Read the result of the transaction.

Steps 1 and 2 require writing to the SMBus I/O region. Step 4 requires
reading from it, and so does step 3 if the wait loop is poll-based. The
transaction is only safe if we have an exclusive access to the I/O
region during all the 4 steps. My fear is that step 3 could be
implemented by ACPI using either a Sleep() or Acquire() or Wait()
opcode. If it is, we're doomed. OTOH, if it does, it is probably not
even safe for itself, unless there's an additional,
implementation-specific mutex to protect SMBus transactions. I yet have
to get my hands on the DSDT of ACPI implementations which actually
access the SMBus to see exactly how they do it.

> A user-installed operation region handler is an operation region handler
> that is installed by a device driver. This feature would probably only
> be used for custom (OEM-defined) operation region address spaces. (I
> have not seen one yet.) For the standard address spaces (memory, I/O,
> etc.), usually only the default handlers are used.

Could regular Linux device drivers install such handlers for a specific
I/O region? I'm asking because Rudolf Marek's proposal [1] to solve the
concurrent access problem involved extending struct resource with
callbacks to driver-specific routines to handle external access to an
I/O region. This sounds somewhat similar to these "user-installed
operation region handler" defined by ACPI, doesn't it? If ACPI already
has an infrastructure to handle this problem, we probably want to use
it rather than implementing our own.

[1] http://marc.info/?l=linux-kernel&m=117302946017204&w=2

-- 
Jean Delvare
