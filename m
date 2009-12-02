Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbZLBV1J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbZLBV1J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 16:27:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754646AbZLBV1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 16:27:08 -0500
Received: from imap.ru.mvista.com ([213.79.90.228]:31630 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754266AbZLBV1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 16:27:07 -0500
Date: Thu, 3 Dec 2009 00:27:10 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: Madhusudhan <madhu.cr@ti.com>, linux-kernel@vger.kernel.org,
       linux-omap@vger.kernel.org
Subject: Re: [PATCH] power_supply: Add driver for TWL4030/TPS65950 BCI
 charger
Message-ID: <20091202212710.GA24789@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1259333060-24277-1-git-send-email-notasas@gmail.com>
 <012301ca71ed$449cb930$544ff780@am.dhcp.ti.com>
 <20091130185813.GA32522@oksana.dev.rtsoft.ru>
 <6ed0b2680912021238o29d7e773i9379369d7b277614@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6ed0b2680912021238o29d7e773i9379369d7b277614@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 02, 2009 at 10:38:31PM +0200, Grazvydas Ignotas wrote:
> On Mon, Nov 30, 2009 at 8:58 PM, Anton Vorontsov
> <avorontsov@ru.mvista.com> wrote:
> > On Mon, Nov 30, 2009 at 12:45:20PM -0600, Madhusudhan wrote:
> > [...]
> >> > +   case POWER_SUPPLY_PROP_VOLTAGE_NOW:
> >> > +           /* charging must be active for meaningful result */
> >> > +           if (!is_charging) {
> >>
> >> How about putting a kern_info here?
> >
> > It might be better to return -EINVAL.
> 
> That causes lots of warnings from power_supply core (driver failed to
> report XXX property), Not sure what to do here, I'd prefer to keep
> returning 0.

Lying to userspace is a bad idea.

How about this patch + changing the driver to return -ENODATA?


>From 0fe4c834b551c4d4454d57acaf75645675d199ee Mon Sep 17 00:00:00 2001
From: Anton Vorontsov <avorontsov@ru.mvista.com>
Date: Thu, 3 Dec 2009 00:24:51 +0300
Subject: [PATCH] power_supply_sysfs: Handle -ENODATA in a special way

There are cases when some device can not report any meaningful value,
e.g. TWL4030 charger can report voltage only when charging is
active.

In these cases drivers will return -ENODATA, and we shouldn't flood
kernel log with error messages.

Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
---
 drivers/power/power_supply_sysfs.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/power/power_supply_sysfs.c b/drivers/power/power_supply_sysfs.c
index 0814439..c790e0c 100644
--- a/drivers/power/power_supply_sysfs.c
+++ b/drivers/power/power_supply_sysfs.c
@@ -65,7 +65,10 @@ static ssize_t power_supply_show_property(struct device *dev,
 	ret = psy->get_property(psy, off, &value);
 
 	if (ret < 0) {
-		if (ret != -ENODEV)
+		if (ret == -ENODATA)
+			dev_dbg(dev, "driver has no data for `%s' property\n",
+				attr->attr.name);
+		else if (ret != -ENODEV)
 			dev_err(dev, "driver failed to report `%s' property\n",
 				attr->attr.name);
 		return ret;
-- 
1.6.3.3

