Return-Path: <linux-kernel-owner+w=401wt.eu-S1756881AbXL2Sg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbXL2Sg1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 13:36:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755560AbXL2Sf4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 13:35:56 -0500
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:29227 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755309AbXL2Sfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 13:35:55 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=6TWHo2TT6OdPfdcIQ6+r2vWavqG38jbUeSOUXr/J1vAMqg7TfiFsAWueyCpB3oTt+ijf6dFGynoll+xNpL0P6lFOIMGUjZXjc3Hpb1w8kiy8x2kXm8qHEQTMMmfIYUMw0pSMOxhGcdRCd0P7GOJ19RLzCLDS9G4aooT/daj47vQ=  ;
X-YMail-OSG: fHbhd2EVM1kwnSml4fCKWuybio2_fzTOB8CHz2rzY0IaUTSwNDl8ElZj7QX4oXU3VPvlXF9Hhw--
From: David Brownell <david-b@pacbell.net>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 2.6.24-rc6-mm 2/9] gpiolib: add gpio provider infrastructure
Date: Sat, 29 Dec 2007 10:35:46 -0800
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       eric miao <eric.y.miao@gmail.com>
References: <200712281927.32575.david-b@pacbell.net> <200712281954.34704.david-b@pacbell.net> <20071229071023.GC16569@uranus.ravnborg.org>
In-Reply-To: <20071229071023.GC16569@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712291035.47345.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 December 2007, Sam Ravnborg wrote:
> For this an the other setters of desc->label a small helper function
> would be better. The helper function could then contain the necessary
> ifdef in only one place.

Good point; see the appended.


> > +/* add/remove chips */
> > +extern int gpiochip_add(struct gpio_chip *chip);
> > +extern int __must_check gpiochip_remove(struct gpio_chip *chip);
> 
> The use of "extern" is not needed in .h files for function prototypes.

But it's widely used nonetheless, and many people prefer to
see those annotations.  Heck, /usr/include is full of them...

- Dave


============ CUT HERE
Minor gpiolib.c cleanup: remove most #ifdefs for CONFIG_FS.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
---
 drivers/gpio/gpiolib.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- at91.orig/drivers/gpio/gpiolib.c
+++ at91/drivers/gpio/gpiolib.c
@@ -50,6 +50,12 @@ struct gpio_desc {
 };
 static struct gpio_desc gpio_desc[ARCH_NR_GPIOS];
 
+static inline void desc_set_label(struct gpio_desc *d, const char *label)
+{
+#ifdef CONFIG_DEBUG_FS
+	d->label = label;
+#endif
+}
 
 /* Warn when drivers omit gpio_request() calls -- legal but ill-advised
  * when setting direction, and otherwise illegal.  Until board setup code
@@ -61,9 +67,7 @@ static void gpio_ensure_requested(struct
 {
 	if (test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0) {
 		pr_warning("GPIO-%d autorequested\n", (int)(desc - gpio_desc));
-#ifdef CONFIG_DEBUG_FS
-		desc->label = "[auto]";
-#endif
+		desc_set_label(desc, "[auto]");
 	}
 }
 
@@ -178,9 +182,7 @@ int gpio_request(unsigned gpio, const ch
 	 */
 
 	if (test_and_set_bit(FLAG_REQUESTED, &desc->flags) == 0) {
-#ifdef CONFIG_DEBUG_FS
-		desc->label = (label == NULL) ? "?" : label;
-#endif
+		desc_set_label(desc, label ? : "?");
 		status = 0;
 	} else
 		status = -EBUSY;
@@ -207,11 +209,9 @@ void gpio_free(unsigned gpio)
 	spin_lock_irqsave(&gpio_lock, flags);
 
 	desc = &gpio_desc[gpio];
-	if (desc->chip && test_and_clear_bit(FLAG_REQUESTED, &desc->flags)) {
-#ifdef CONFIG_DEBUG_FS
-		desc->label = NULL;
-#endif
-	} else
+	if (desc->chip && test_and_clear_bit(FLAG_REQUESTED, &desc->flags))
+		desc_set_label(desc, NULL);
+	else
 		WARN_ON(extra_checks);
 
 	spin_unlock_irqrestore(&gpio_lock, flags);

