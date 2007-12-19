Return-Path: <linux-kernel-owner+w=401wt.eu-S1753911AbXLSMdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911AbXLSMdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 07:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752092AbXLSMde
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 07:33:34 -0500
Received: from mx40.mail.ru ([194.67.23.36]:53587 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033AbXLSMdd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 07:33:33 -0500
Date: Wed, 19 Dec 2007 15:35:46 +0300
From: Anton Vorontsov <cbou@mail.ru>
To: Andres Salomon <dilinger@queued.net>
Cc: cbouatmailru@gmail.com, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 1/5] power: RFC: introduce a new power API
Message-ID: <20071219123546.GA6277@localhost.localdomain>
Reply-To: cbou@mail.ru
References: <20071216212443.4a1fff3d@ephemeral> <1197858984.3798.201.camel@shinybook.infradead.org> <20071217055123.GA2274@zarina> <20071217024139.2f81e36d@ephemeral> <20071217112416.GA25948@localhost.localdomain> <20071218021001.46783004@ephemeral>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20071218021001.46783004@ephemeral>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2007 at 02:10:01AM -0500, Andres Salomon wrote:
> On Mon, 17 Dec 2007 14:24:16 +0300
> Anton Vorontsov <cbou@mail.ru> wrote:
> 
> > On Mon, Dec 17, 2007 at 02:41:39AM -0500, Andres Salomon wrote:
> > [...]
> > > > > On Sun, 2007-12-16 at 21:24 -0500, Andres Salomon wrote:
> > > > > > This API has the power_supply drivers device their own device_attribute
> > > > > > list; I find this to be a lot more flexible and cleaner.  
> > > > 
> > > > I don't see how this is more flexible and cleaner. See below.
> > > > 
> > > > > > For example,
> > > > > > rather than having a function with a huge switch statement (as olpc_battery
> > > > > > currently has), we have separate callback functions.
> > > > 
> > > > Is this an improvement? Look into ds2760_battery.c. I scared to
> > > > imagine what it will look like after conversion.
> > > 
> [...]
> > 
> > I see your point now. Basically, now I'm encourage to think just one
> > more time: is there third (better) option in addition to current and
> > this? I still hope there is some not obvious, but elegant solution.
> > If there isn't, I'm ready to surrender and will help with everything
> > I can.
> > 
> 
> Hm.  It occurs to me that there's nothing keeping us from having a
> single callback for the driver properties.  Keeping the other patches
> the same, do you prefer the following approach versus what was originally
> in patch#3?

Why so difficult? Maybe like this:

diff --git a/drivers/power/olpc_battery.c b/drivers/power/olpc_battery.c
index c998e68..00f0b71 100644
--- a/drivers/power/olpc_battery.c
+++ b/drivers/power/olpc_battery.c
@@ -176,13 +176,13 @@ static int olpc_bat_get_property(struct power_supply *psy,
 
 		switch (ec_byte >> 4) {
 		case 1:
-			val->strval = "Gold Peak";
+			ret = sprintf(val->strval, "%s\n", "Gold Peak");
 			break;
 		case 2:
-			val->strval = "BYD";
+			ret = sprintf(val->strval, "%s\n", "BYD");
 			break;
 		default:
-			val->strval = "Unknown";
+			ret = sprintf(val->strval, "%s\n", "Unknown");
 			break;
 		}
 		break;
diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 249f61b..83e127d 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -54,7 +54,9 @@ static ssize_t power_supply_show_property(struct device *dev,
 	ssize_t ret;
 	struct power_supply *psy = dev_get_drvdata(dev);
 	const ptrdiff_t off = attr - power_supply_attrs;
-	union power_supply_propval value;
+	union power_supply_propval value = {
+		.strval = buf,
+	};
 
 	ret = psy->get_property(psy, off, &value);
 
@@ -75,7 +77,7 @@ static ssize_t power_supply_show_property(struct device *dev,
 		return sprintf(buf, "%s\n",
 			       capacity_level_text[value.intval]);
 	else if (off >= POWER_SUPPLY_PROP_MODEL_NAME)
-		return sprintf(buf, "%s\n", value.strval);
+		return ret;
 
 	return sprintf(buf, "%d\n", value.intval);
 }
