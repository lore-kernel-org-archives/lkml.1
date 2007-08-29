Return-Path: <linux-kernel-owner+w=401wt.eu-S1755626AbXH2Qyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbXH2Qyz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 12:54:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753421AbXH2Qyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 12:54:47 -0400
Received: from mga03.intel.com ([143.182.124.21]:17692 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752497AbXH2Qyq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 12:54:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,322,1183359600"; 
   d="scan'208";a="269684064"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH -mm 3/3] PM: Improve handling of ACPI system state indicator (rev. 3)
Date: Wed, 29 Aug 2007 09:54:43 -0700
Message-ID: <B28E9812BAF6E2498B7EC5C427F293A4031EFC32@orsmsx415.amr.corp.intel.com>
In-Reply-To: <200708290005.12323.rjw@sisk.pl>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH -mm 3/3] PM: Improve handling of ACPI system state indicator (rev. 3)
thread-index: Acfpvgyjt/CsVIrmR/SPj/YtmUl/IgAnP6PA
References: <200708272347.45438.rjw@sisk.pl> <200708272353.09380.rjw@sisk.pl> <B28E9812BAF6E2498B7EC5C427F293A4031EF65B@orsmsx415.amr.corp.intel.com> <200708290005.12323.rjw@sisk.pl>
From: "Moore, Robert" <robert.moore@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>,
       "Len Brown" <lenb@kernel.org>, "LKML" <linux-kernel@vger.kernel.org>,
       "Pavel Machek" <pavel@ucw.cz>,
       "pm list" <linux-pm@lists.linux-foundation.org>
X-OriginalArrivalTime: 29 Aug 2007 16:54:44.0456 (UTC) FILETIME=[4CCAB680:01C7EA5D]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

No, it's not safe to run the AML interpreter with interrupts disabled.

I don't have any problem with introducing finer granularity enter/exit
sleep interfaces if they are required.

I would suggest that we rename things a bit however.

Currently:
acpi_enter_sleep_state_prep
acpi_enter_sleep_state_prep_late
acpi_enter_sleep_state

acpi_leave_sleep_state_prep
acpi_leave_sleep_state

I think we can truncate and clarify:

acpi_sleep_setup1
acpi_sleep_setup2
acpi_sleep

acpi_wake_setup1
acpi_wake


acpi_set_sleep_state_indicator:

I'm not sure if we have any external interfaces that simply execute a
control method, seems like overkill.

Please give me more information as to why _SSI needs to be moved (other
than executing it after _BFS)

Thanks,
Bob





-----Original Message-----
From: Rafael J. Wysocki [mailto:rjw@sisk.pl] 
Sent: Tuesday, August 28, 2007 3:05 PM
To: Moore, Robert
Cc: Andrew Morton; ACPI Devel Maling List; Len Brown; LKML; Pavel
Machek; pm list
Subject: Re: [PATCH -mm 3/3] PM: Improve handling of ACPI system state
indicator (rev. 3)

On Tuesday, 28 August 2007 21:57, Moore, Robert wrote:
> Since these changes appear to affect the ACPICA core in a fairly big
> way, I would like to see a short, concise description of each change
and
> why it is necessary.

All right.  I'll describe the changes made by the current version of the
patches, but please note that if it's safe to run the AML interpreter
with
IRQs disabled, it's better to do some of them in a different way.

1. Remove the execution of _GTS from acpi_enter_sleep_state_prep()

	acpi_enter_sleep_state_prep() is called before disabling the
nonboot
	CPUs and _GTS should be executed after that, according to the
spec.

2. Introduce acpi_enter_sleep_state_prep_late() that will execute _GTS

	Necessary because of 1.

3. Split acpi_leave_sleep_state() into two functions:
   acpi_leave_sleep_state_prep() and acpi_leave_sleep_state().

	acpi_leave_sleep_state_prep() contains the code that should be
executed
	before enabling the nonboot CPUs, most importantly the execution
of
	_BFS, and acpi_leave_sleep_state() contains the remaining code
(the
	enabling of GPEs, the execution of _WAK and the enabling of
power
	buttons)

4. Change the code ordering in acpi_leave_sleep_state_prep() (introduced
   in 3.) so that _SST is executed after _BFS

	According to the spec, _BFS should be the first ACPI method
executed
	after leaving a sleep state

5. Introduce acpi_set_sleep_state_indicator() that will execute _SST for
given
   ACPI sleep state

	Needed so that we can set the state indicator independently of
the
	other lower-level operations.

6. Remove the execution of _SST from acpi_leave_sleep_state()

	No longer needed, because we can use
acpi_set_sleep_state_indicator()
	to set the state indicator appropriately from higher level
routines.

The other changes affect only drivers/acpi/sleep/main.c and the files in
kernel/power .

Greetings,
Rafael
