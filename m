Return-Path: <linux-kernel-owner+w=401wt.eu-S1759548AbXJXOcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548AbXJXOcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 10:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757514AbXJXOcE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 10:32:04 -0400
Received: from mx1.suse.de ([195.135.220.2]:48410 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744AbXJXOcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 10:32:01 -0400
Subject: [PATCH 0/5] Detect hwmon and i2c bus drivers interfering with ACPI
	Operation Region resources
From: Thomas Renninger <trenn@suse.de>
Reply-To: trenn@suse.de
To: linux-acpi <linux-acpi@vger.kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@osdl.org>, Jean Delvare <khali@linux-fr.org>
Content-Type: text/plain
Organization: Novell/SUSE
Date: Wed, 24 Oct 2007 16:31:59 +0200
Message-Id: <1193236319.4590.225.camel@queen.suse.de>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

it seems Len's test tree and Linus tree diverged a bit, at least with
this patch set things do not apply cleanly.

Therefore I post these for discussion whether and in which kernel tree
they should end up before doing work for nothing.
If they are still a candidate for 2.6.24 (rather unintrusive), pls tell
me whether and when I should base them against Len's test/release branch
or whatever other tree.
If not, it would be great if they can be included into the -mm tree and
I can rebase them against this one.

Be aware that there is a small change in ACPICA (first patch, that's
also the reason why this one would not compile on its own).

Many thanks for detailed review, testing and a lot implementation help
go to Jean Delvare, without his help I would not be able to post
anything right now.

Thanks for any help/advise,

  Thomas

--------------
Short general description:

In ACPI, AML can define accesses to IO ports and System Memory by
Operation Regions. Those are not registered as done by PNPACPI using
resource templates (and _CRS/_SRS methods).
The IO ports and System Memory regions may get accessed by arbitrary AML
code. When native drivers are accessing the same resources bad things
can happen (e.g. a critical shutdown temperature of 3000 C every 2
months or so).
It is not really possible to register the operation regions via
request_resource, as they often overlap with pnp or other resources
(e.g. statically setup IO resources below 0x100).
This approach stores all Operation Region declarations (IO and System
Memory only) at ACPI table parse time. It offers a similar functionality
like request_region and let drivers which are known to possibly use the
same IO ports and Memory which are also often used by ACPI (hwmon and
i2c) check for ACPI interference.

A boot parameter acpi_enforce_resources=strict/lax/no is provided, which
is default set to lax:
  - strict: let conflicting drivers fail to load with an error message
  - lax:    let conflicting driver work normal with a warning message
  - no:     no functional change at all
Depending on the feedback and the kind of interferences we see, this
should be set to strict at later time.

Goal of this patch set is:
  - Identify ACPI interferences in bug reports (very hard to reproduce
    and to identify)
  - Find BIOSes for that an ACPI driver should exist for specific HW
    instead of a native one.
  - stability in general


