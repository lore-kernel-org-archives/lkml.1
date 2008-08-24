Return-Path: <linux-kernel-owner+w=401wt.eu-S1752870AbYHXEpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbYHXEpn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 00:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750801AbYHXEpf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 00:45:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:43739 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbYHXEpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 00:45:34 -0400
Date: Sat, 23 Aug 2008 21:45:21 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Carlos Corbacho <carlos@strangeworlds.co.uk>,
       torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Fix oops in acer_wmi
Message-ID: <20080823214521.3d6e2f8c@infradead.org>
In-Reply-To: <200808240219.41946.carlos@strangeworlds.co.uk>
References: <20080823140509.4b197021@infradead.org>
	<200808240219.41946.carlos@strangeworlds.co.uk>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Aug 2008 02:19:41 +0100

Linus, 
below is a patch for a bug that's showing quite hot on kerneloops.org; please consider merging

Carlos Corbacho <carlos@strangeworlds.co.uk> wrote:

> On Saturday 23 August 2008 22:05:09 Arjan van de Ven wrote:
> > this is due to a null pointer due to a misordered initialization...
> > when the DMI quirks get run, the "interface" variable might not
> > have been initialized. The patch below 1) prevents the oops and 2)
> > runs the quirks again after all the "interface" initialization has
> > completed.
> 
> Acked-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
> 
> (Although this patch is missing an SOB from yourself).

oh whoops; updated below
> 
> > This oops is new in 2.6.27-rc and thus counts as a regression...
> 
> NAK - I disagree. This has been broken since day one, there is
> nothing special, as far as I am concerned, about 2.6.27 in this
> respect.

interesting; I have no reports of this in kerneloops.org (but if this got introduced
in 2.6.26 that's possible; there's not that many 2.6.26 users yet);
you can see this yourself at
http://www.kerneloops.org/search.php?search=acer_wmi_init
on the left side it shows how often it happens for which versions/

I'll still call it a tentative regression ;=)

> 
> (If this is showing up that much in kerneloops.org, then I would
> recommend CC'ing it to stable).
> 

--
From: Arjan van de Ven <arjan@linux.intel.com>
Subject: Fix oops in acer_wmi driver (acer_wmi_init)

The acer_wmi driver does a DMI scan for quirks, and then sets flags into the
"interface" datastructure for some cases. However, the quirks happen real early
before "interface" is per se initialized from NULL.

The patch below 1) adds a NULL pointer check and 2) (re)runs the quirks at the
end, when "interface" has it's final value. 

Reported-by: kerneloops.org
Acked-by: Carlos Corbacho <carlos@strangeworlds.co.uk>
CC: stable@vger.kernel.org
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>


--- linux.trees.git/drivers/misc/acer-wmi.c~	2008-08-23 13:59:22.000000000 -0700
+++ linux.trees.git/drivers/misc/acer-wmi.c	2008-08-23 14:00:32.000000000 -0700
@@ -192,6 +192,9 @@ static struct quirk_entry *quirks;
 
 static void set_quirks(void)
 {
+	if (!interface)
+		return;
+
 	if (quirks->mailled)
 		interface->capability |= ACER_CAP_MAILLED;
 
@@ -1237,6 +1240,8 @@ static int __init acer_wmi_init(void)
 		return -ENODEV;
 	}
 
+	set_quirks();
+
 	if (platform_driver_register(&acer_platform_driver)) {
 		printk(ACER_ERR "Unable to register platform driver.\n");
 		goto error_platform_register;


