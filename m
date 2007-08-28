Return-Path: <linux-kernel-owner+w=401wt.eu-S1760908AbXH1Vyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760908AbXH1Vyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 17:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754437AbXH1Vyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 17:54:44 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52292 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751217AbXH1Vyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 17:54:43 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Moore, Robert" <robert.moore@intel.com>
Subject: Re: [PATCH -mm 3/3] PM: Improve handling of ACPI system state indicator (rev. 3)
Date: Wed, 29 Aug 2007 00:05:11 +0200
User-Agent: KMail/1.9.5
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "ACPI Devel Maling List" <linux-acpi@vger.kernel.org>,
       "Len Brown" <lenb@kernel.org>, "LKML" <linux-kernel@vger.kernel.org>,
       "Pavel Machek" <pavel@ucw.cz>,
       "pm list" <linux-pm@lists.linux-foundation.org>
References: <200708272347.45438.rjw@sisk.pl> <200708272353.09380.rjw@sisk.pl> <B28E9812BAF6E2498B7EC5C427F293A4031EF65B@orsmsx415.amr.corp.intel.com>
In-Reply-To: <B28E9812BAF6E2498B7EC5C427F293A4031EF65B@orsmsx415.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708290005.12323.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, 28 August 2007 21:57, Moore, Robert wrote:
> Since these changes appear to affect the ACPICA core in a fairly big
> way, I would like to see a short, concise description of each change and
> why it is necessary.

All right.  I'll describe the changes made by the current version of the
patches, but please note that if it's safe to run the AML interpreter with
IRQs disabled, it's better to do some of them in a different way.

1. Remove the execution of _GTS from acpi_enter_sleep_state_prep()

	acpi_enter_sleep_state_prep() is called before disabling the nonboot
	CPUs and _GTS should be executed after that, according to the spec.

2. Introduce acpi_enter_sleep_state_prep_late() that will execute _GTS

	Necessary because of 1.

3. Split acpi_leave_sleep_state() into two functions:
   acpi_leave_sleep_state_prep() and acpi_leave_sleep_state().

	acpi_leave_sleep_state_prep() contains the code that should be executed
	before enabling the nonboot CPUs, most importantly the execution of
	_BFS, and acpi_leave_sleep_state() contains the remaining code (the
	enabling of GPEs, the execution of _WAK and the enabling of power
	buttons)

4. Change the code ordering in acpi_leave_sleep_state_prep() (introduced
   in 3.) so that _SST is executed after _BFS

	According to the spec, _BFS should be the first ACPI method executed
	after leaving a sleep state

5. Introduce acpi_set_sleep_state_indicator() that will execute _SST for given
   ACPI sleep state

	Needed so that we can set the state indicator independently of the
	other lower-level operations.

6. Remove the execution of _SST from acpi_leave_sleep_state()

	No longer needed, because we can use acpi_set_sleep_state_indicator()
	to set the state indicator appropriately from higher level routines.

The other changes affect only drivers/acpi/sleep/main.c and the files in
kernel/power .

Greetings,
Rafael
