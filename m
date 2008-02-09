Return-Path: <linux-kernel-owner+w=401wt.eu-S1757485AbYBILpR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757485AbYBILpR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 06:45:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754144AbYBILpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 06:45:01 -0500
Received: from phoenix.slamd64.com ([217.10.145.2]:47303 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbYBILo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 06:44:58 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PATCH] ACPI patches for 2.6.25-rc0 (#2)
Date: Sat, 9 Feb 2008 11:42:17 +0000
User-Agent: KMail/1.9.7
Cc: Len Brown <lenb@kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <200802080145.16774.lenb@kernel.org> <20080209061718.GA14200@elte.hu> <20080209061936.GA16849@elte.hu>
In-Reply-To: <20080209061936.GA16849@elte.hu>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802091142.18596.carlos@strangeworlds.co.uk>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Sat, 09 Feb 2008 11:42:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 09 February 2008 06:19:36 Ingo Molnar wrote:
> (Carlos Cc:-ed too)
>
> * Ingo Molnar <mingo@elte.hu> wrote:
> > * Len Brown <lenb@kernel.org> wrote:
> > > Len Brown (6):
> > >       ACPI: add newline to printk
> > >       ACPI: build WMI on X86 only
> > >       acer-wmi, tc1100-wmi: select ACPI_WMI
> >
> > hm, this new WMI code caused a bootup crash in the overnight x86.git
> > tests:

I suspect this is a problem on systems without ACPI-WMI in the DSDT - though I 
can't reproduce this here on my other box that lacks ACPI-WMI.

Ingo, can you try the patch below and see if this cures it?
---
ACPI: WMI: Fix crash on WMI free systems

From: Carlos Corbacho <carlos@strangeworlds.co.uk>

We have two pointers in the find_guid() code that aren't checked before
we use them. On ACPI-WMI free systems, this can sometimes cause a crash if
another driver tries to use any of the methods provided by WMI.

Also throw in an extra early check to see if the GUID list is empty, so we
can try to bail out before reaching this code as well.

Spotted by Ingo Molnar.

Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
CC: Ingo Molnar <mingo@elte.hu>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Len Brown <lenb@kernel.org>
---

 drivers/acpi/wmi.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)


diff --git a/drivers/acpi/wmi.c b/drivers/acpi/wmi.c
index 36b84ab..b54e734 100644
--- a/drivers/acpi/wmi.c
+++ b/drivers/acpi/wmi.c
@@ -201,12 +201,20 @@ static bool find_guid(const char *guid_string, struct wmi_block **out)
 	struct guid_block *block;
 	struct list_head *p;
 
+	if (list_empty(&wmi_blocks.list))
+		return 0;
+
 	wmi_parse_guid(guid_string, tmp);
 	wmi_swap_bytes(tmp, guid_input);
 
 	list_for_each(p, &wmi_blocks.list) {
 		wblock = list_entry(p, struct wmi_block, list);
+		if (!wblock)
+			return 0;
+
 		block = &wblock->gblock;
+		if (!block)
+			return 0;
 
 		if (memcmp(block->guid, guid_input, 16) == 0) {
 			if (out)
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
