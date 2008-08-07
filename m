Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbYHGRZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbYHGRZl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 13:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752809AbYHGRZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 13:25:32 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:23478 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbYHGRZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 13:25:31 -0400
Date: Thu, 7 Aug 2008 11:25:29 -0600
From: Alex Chiang <achiang@hp.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Matthew Wilcox <matthew@wil.cx>, Pierre Ossman <drzeus-list@drzeus.cx>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: [PATCH 0/7] Fixups for duplicate slot names
Message-ID: <20080807172529.GB25902@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>,
	Matthew Wilcox <matthew@wil.cx>,
	Pierre Ossman <drzeus-list@drzeus.cx>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
References: <20080806050745.GA31319@ldl.fc.hp.com> <489AB595.7000006@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <489AB595.7000006@jp.fujitsu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>:
> Hi Alex-san,
>
> Thank you for patches!
>
> I looked at your patches and it looks good. But I have only one
> concern about how to allocate/free memory for slot name.
>
> With your change, memory region for slot name will be allocated
> by hotplug *controller* driver and it can be freed using kfree()
> by hotplug *core* driver (not hotplug controller driver). So all
> hotplug controller drivers including drivers implemented in the
> future need to take it into account.
>
> I think it will be more robust if we can allocate and free memory
> in the same component (maybe hotplug core driver in this case).

Hm, I didn't think this would be a problem. The sequence is:

	- controller allocates memory for slot name
	- if core detects a collision:
		- it frees the name
		- it allocates new memory for name
		- it assigns that memory to the name parameter
	- controller->release will eventually free the name

So it shouldn't matter if the core frees the original name
pointer and allocates new memory, because the core will change
the pointer for the controller.

This is why I had to change the interface of pci_create_slot()
from taking a const char *name to a char *name.

Is there something I'm missing?

/ac

