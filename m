Return-Path: <linux-kernel-owner+w=401wt.eu-S1756029AbYFCAL5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029AbYFCAL5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 20:11:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753078AbYFCALr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 20:11:47 -0400
Received: from smtpq2.groni1.gr.home.nl ([213.51.130.201]:59711 "EHLO
	smtpq2.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997AbYFCALr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 20:11:47 -0400
Message-ID: <48448D09.3000701@keyaccess.nl>
Date: Tue, 03 Jun 2008 02:15:05 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Andrew Morton <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
       avuton@gmail.com, rene.herman@gmail.com, len.brown@intel.com,
       linux-kernel@vger.kernel.org, rjw@sisk.pl
Subject: Re: 53052feb6 (PNP: remove pnp_mem_flags() as an lvalue) breaks my
 ALSA intel8x0 sound card regression
References: <3aa654a40806010742r1d61caa2j681882145533b56a@mail.gmail.com>	<200806021605.14519.bjorn.helgaas@hp.com>	<3aa654a40806021523k5b89cd0cjbcddf5810d05072b@mail.gmail.com>	<200806021642.50491.bjorn.helgaas@hp.com> <20080602164954.2aff2d77.akpm@linux-foundation.org> <48448932.80803@keyaccess.nl>
In-Reply-To: <48448932.80803@keyaccess.nl>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03-06-08 01:58, Rene Herman wrote:

> Bjorn, before you repost the option series due to this, wait a minute. 
> Am now looking at/testing 14/15 and see some stuff that needs changing 
> as well.

Well, or not if you're in a hurry. Just see it's 02:00+ here again so 
I'm off. But at least this bit from 14/15 isn't right:

===
@ -176,33 +184,10 @@ static void quirk_ad1815_mpu_resources(s
  	if (!irq || irq->next)
  		return;

-	res = dev->dependent;
-	if (!res)
-		return;
-
-	while (1) {
-		struct pnp_irq *copy;
-
-		copy = pnp_alloc(sizeof *copy);
-		if (!copy)
-			break;
-
-		bitmap_copy(copy->map.bits, irq->map.bits, PNP_IRQ_NR);
-		copy->flags = irq->flags;
-
-		copy->next = res->irq; /* Yes, this is NULL */
-		res->irq = copy;
-
-		if (!res->next)
-			break;
-		res = res->next;
-	}
-	kfree(irq);
+	irq->flags |= IORESOURCE_IRQ_OPTIONAL;
+	dev_info(&dev->dev, "made independent IRQ optional\n");

  	res->next = quirk_isapnp_mpu_options(dev);
-
-	res = dev->independent;
-	res->irq = NULL;
  }
===

The deleted while loop traversedf the dependent optiosn so that at the 
end res->next= added to the end of teh dependent chain. Now this adds to 
the independent optiion.

Fortunately fix is simple; just delete the res->next = line completely. 
This previously distributed the independent IRQ over the dependents so I 
_could_ have an IRQ-less option by adding IRQ-less dependents but with 
an OPTIONAL flag this is no longer needed.

Specifically, ad1815 MPU401 starts out as:

rene@ax6bc:~$ cat /sys/devices/pnp1/01\:01/01\:01.01/options
irq 5,7,2/9,11,12 High-Edge
Dependent: 00 - Priority preferred
   port 0x330-0x330, align 0x0, size 0x2, 10-bit address decoding
Dependent: 01 - Priority acceptable
   port 0x300-0x300, align 0x0, size 0x2, 10-bit address decoding
Dependent: 02 - Priority functional
   port 0x100-0x3fe, align 0x1, size 0x2, 10-bit address decoding

and with your current code ends up as:

rene@ax6bc:~$ cat /sys/devices/pnp1/01\:01/01\:01.01/options
irq 5,7,2/9,11,12 High-Edge
Dependent: 00 - Priority preferred
   port 0x330-0x330, align 0x0, size 0x2, 10-bit address decoding
Dependent: 01 - Priority acceptable
   port 0x300-0x300, align 0x0, size 0x2, 10-bit address decoding
Dependent: 02 - Priority functional
   port 0x100-0x3fe, align 0x1, size 0x2, 10-bit address decoding
Dependent: 03 - Priority functional
   port 0x330-0x330, align 0x0, size 0x2, 10-bit address decoding
Dependent: 04 - Priority functional
   port 0x300-0x300, align 0x0, size 0x2, 10-bit address decoding
Dependent: 05 - Priority functional
   port 0x100-0x3fe, align 0x1, size 0x2, 10-bit address decoding

As you see, no need for 4, 5 and 6. So no need fior the cloning. This 
also means functi9ons can be folded back in but I'll do that later if 
you prefer.

Unfortunately, the optional thing doesn't seem to work at all at the 
moment (this is post your series):

ad1816a 01:01.01: pnp_assign_resources, try dependent set 0
ad1816a 01:01.01:   couldn't assign irq 0
ad1816a 01:01.01: pnp_assign_resources failed (-16)
ad1816a 01:01.01: pnp_assign_resources, try dependent set 1
ad1816a 01:01.01:   couldn't assign irq 0
ad1816a 01:01.01: pnp_assign_resources failed (-16)
ad1816a 01:01.01: pnp_assign_resources, try dependent set 2
ad1816a 01:01.01:   couldn't assign irq 0
ad1816a 01:01.01: pnp_assign_resources failed (-16)
ad1816a 01:01.01: pnp_assign_resources, try dependent set 3
ad1816a 01:01.01:   couldn't assign irq 0
ad1816a 01:01.01: pnp_assign_resources failed (-16)
ad1816a 01:01.01: pnp_assign_resources, try dependent set 4
ad1816a 01:01.01:   couldn't assign irq 0
ad1816a 01:01.01: pnp_assign_resources failed (-16)
ad1816a 01:01.01: pnp_assign_resources, try dependent set 5
ad1816a 01:01.01:   couldn't assign irq 0
ad1816a 01:01.01: pnp_assign_resources failed (-16)
ad1816a 01:01.01: unable to assign resources
ad1816a: MPU401 PnP configure failure

but I ran out of day again. Will look.

Rene.
