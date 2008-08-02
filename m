Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbYHBQv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbYHBQv2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2008 12:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754786AbYHBQvW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Aug 2008 12:51:22 -0400
Received: from phoenix.slamd64.com ([217.10.145.2]:51320 "EHLO
	phoenix.slamd64.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbYHBQvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2008 12:51:21 -0400
X-Greylist: delayed 1343 seconds by postgrey-1.27 at vger.kernel.org; Sat, 02 Aug 2008 12:51:21 EDT
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Sven Wegener <sven.wegener@stealer.net>
Subject: Re: acer-wmi broken in latest git kernel on TravelMate 6492 (Insufficient arguments - method [WQAA])
Date: Sat, 2 Aug 2008 17:28:45 +0100
User-Agent: KMail/1.9.9
Cc: Bob Moore <robert.moore@intel.com>, Andi Kleen <ak@linux.intel.com>,
       Lin Ming <ming.m.lin@intel.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <alpine.LNX.1.10.0808021640310.2294@titan.stealer.net>
In-Reply-To: <alpine.LNX.1.10.0808021640310.2294@titan.stealer.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808021728.46046.carlos@strangeworlds.co.uk>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (phoenix.slamd64.com [217.10.145.2]); Sat, 02 Aug 2008 16:28:47 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 August 2008 16:50:54 Sven Wegener wrote:
> Is it a bug in acer-wmi or in Acer's ACPI implementation? I can provide 
> more information as necessary.

Neither - it's a bug in wmi.c

Try the following patch:
---
ACPI: WMI: Set instance for query block calls

From: Carlos Corbacho <carlos@strangeworlds.co.uk>

Although the necessary data structure was set up, it was never actually
passed in, so data block calls have only been working by sheer chance.

(On Acer laptops. the data block methods we've been calling never look at
the instance value, hence acer-wmi never triggered this before).

f3454ae8104efb2dbf0d08ec42c6f5d0fe9225bc brought this to light.

Signed-off-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
---

 drivers/acpi/wmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)


diff --git a/drivers/acpi/wmi.c b/drivers/acpi/wmi.c
index c33b1c6..cfe2c83 100644
--- a/drivers/acpi/wmi.c
+++ b/drivers/acpi/wmi.c
@@ -347,7 +347,7 @@ struct acpi_buffer *out)
 	strcpy(method, "WQ");
 	strncat(method, block->object_id, 2);
 
-	status = acpi_evaluate_object(handle, method, NULL, out);
+	status = acpi_evaluate_object(handle, method, &input, out);
 
 	/*
 	 * If ACPI_WMI_EXPENSIVE, call the relevant WCxx method, even if
