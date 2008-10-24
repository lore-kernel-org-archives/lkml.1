Return-Path: <linux-kernel-owner+w=401wt.eu-S1753436AbYJXGxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436AbYJXGxe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 02:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbYJXGxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 02:53:00 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42528 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbYJXGw5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 02:52:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: James Bottomley <James.Bottomley@hansenpartnership.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: Oops in ACPI with git latest
Date: Fri, 24 Oct 2008 08:57:17 +0200
User-Agent: KMail/1.9.9
Cc: "Moore, Robert" <robert.moore@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Len Brown <lenb@kernel.org>
References: <1224791103.3330.37.camel@localhost.localdomain> <4911F71203A09E4D9981D27F9D830858033D1CC9@orsmsx503.amr.corp.intel.com> <1224811642.3330.57.camel@localhost.localdomain>
In-Reply-To: <1224811642.3330.57.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810240857.18190.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, 24 of October 2008, James Bottomley wrote:
> On Thu, 2008-10-23 at 15:34 -0700, Moore, Robert wrote:
> > +	if (!output.pointer)
> > +		return AE_NULL_OBJECT;
> > +
> > 
> > This probably won't work. acpi_evaluate_object currently doesn't touch the pointer parameter if there is no return value, it only sets the length to zero.
> 
> Actually, it does.

Well, this was the only candidate for a NULL pointer dereference, so I'd be
surprised if it didn't. :-)

> > So, you might try this:
> > 
> > +	if (!output.length)
> > +		return AE_NULL_OBJECT;
> > +

Still, I'd expect the AML interpreter to return error code in this case.

> This also works.

Why don't we make it extra safe, then. ;-)

---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: Prevent acpi_osc_run from using NULL objects

Check if the object returned by acpi_evaluate_object() in
acpi_run_osc() is not NULL.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/pci/pci-acpi.c |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/drivers/pci/pci-acpi.c
===================================================================
--- linux-2.6.orig/drivers/pci/pci-acpi.c
+++ linux-2.6/drivers/pci/pci-acpi.c
@@ -83,6 +83,9 @@ static acpi_status acpi_run_osc(acpi_han
 	if (ACPI_FAILURE(status))
 		return status;
 
+	if (!output.pointer || !output.length)
+		return AE_NULL_OBJECT;
+
 	out_obj = output.pointer;
 	if (out_obj->type != ACPI_TYPE_BUFFER) {
 		printk(KERN_DEBUG "Evaluate _OSC returns wrong type\n");
