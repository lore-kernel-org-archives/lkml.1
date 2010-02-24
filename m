Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551Ab0BXS6c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 13:58:32 -0500
Received: from mga01.intel.com ([192.55.52.88]:54682 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757442Ab0BXS6b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 13:58:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,534,1262592000"; 
   d="scan'208";a="543618806"
From: "Moore, Robert" <robert.moore@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>
CC: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       "Lin, Ming M" <ming.m.lin@intel.com>
Date: Wed, 24 Feb 2010 10:58:29 -0800
Subject: RE: [RFC][PATCH] ACPI: Eliminate race conditions related to
 removing event handlers
Thread-Topic: [RFC][PATCH] ACPI: Eliminate race conditions related to
 removing event handlers
Thread-Index: Acqyj9/B5XILyjkcROmAmWRNuQHTFQC8i1IA
Message-ID: <4911F71203A09E4D9981D27F9D83085859B327F4@orsmsx503.amr.corp.intel.com>
References: <201002210151.01159.rjw@sisk.pl>
In-Reply-To: <201002210151.01159.rjw@sisk.pl>
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


Rafael,

I've got some issues with this design.

First of all, are the two interfaces, acpi_remove_notify_handler() and acpi_remove_gpe_handler(), really being used in such a way to require such synchronization? Is there any way to limit their use to times where it is known that no handlers will be executing?

In addition, I'm afraid that this whole "events" mechanism, with an interface to wait for event completion, and now the concept of adding "barriers" to the event queue, is much too OS-specific for the core ACPICA code. In the first place, the acpi_os_wait_events_complete is not part of the ACPICA code (it is not called by ACPICA in the code base, only in the Linux version). Such a mechanism has not been requested by any of the other users of ACPICA, so we have not attempted to add it. This is not to say that such a mechanism will not be required by other users in the future however.

Bob


>-----Original Message-----
>From: Rafael J. Wysocki [mailto:rjw@sisk.pl]
>Sent: Saturday, February 20, 2010 4:51 PM
>To: ACPI Devel Maling List
>Cc: Len Brown; Moore, Robert; LKML; Matthew Garrett
>Subject: [RFC][PATCH] ACPI: Eliminate race conditions related to removing
>event handlers
>
>From: Rafael J. Wysocki <rjw@sisk.pl>
>
>The current ACPI events handling code has two design issues that
>need fixing.  First, there is a race condition between the event
>queues and the removal of GPE handlers and notify handlers that may
>cause a handler to be removed while it's being executed, which in
>turn may lead to udefined behavior.  Second, the GPE handler removal
>routine, acpi_remove_gpe_handler(), releases ACPI_MTX_EVENTS in the
>middle of the operation, which effectively renders the locking
>useless.  It turns out that the both of them can be fixed at the same
>time.
>
>To fix the first issue use the observation that all of the ACPI
>workqueues are singlethread, so it is possible to flush the
>execution of queued work by inserting a cleverly crafted work item
>into the appropriate workqueue.  For this purpose use a barrier work
>structure containing two completion objects, 'run' and 'exit', and a
>pair of interface functions, acpi_os_add_events_barrier() and
>acpi_os_remove_events_barrier(), the first of which puts a barrier
>work into the workqueue indicated by its argument and waits for the
>'run' completion to be completed, and the second of which completes
>the 'exit' completion (the first one returns a pointer to the barrier
>work object to be passed as an argument to the second one).  The work
>function inserted into the workqueue by acpi_os_add_events_barrier()
>completes the 'run' completion and waits for the 'exit' completion.
>Thus, by executing acpi_os_add_events_barrier() with an appropriate
>type argument the caller ensures that all events of this type queued
>up earlier will be handled before it is allowed to continue running
>and all events of this type queued up later will be handled until
>acpi_os_remove_events_barrier() is called.
>
>Modify acpi_remove_notify_handler() and acpi_remove_gpe_handler() to
>use this interface, which also fixes the second issue, because the
>new interface replaces acpi_os_wait_events_complete() that was the
>reason for the releasing of ACPI_MTX_EVENTS in the middle of the
>operation by acpi_remove_gpe_handler().
>
