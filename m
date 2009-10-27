Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbZJ0OcL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbZJ0OcL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 10:32:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755310AbZJ0OcK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 10:32:10 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57595 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755188AbZJ0OcH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 10:32:07 -0400
From: "Dasgupta, Romit" <romit@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: "Hilman, Kevin" <khilman@ti.com>, "rjw@sisk.pl" <rjw@sisk.pl>,
       "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 27 Oct 2009 20:00:51 +0530
Subject: RE: [linux-pm] [PATCH] PM: Fixes warning on suspend errors
Thread-Topic: [linux-pm] [PATCH] PM: Fixes warning on suspend errors
Thread-Index: AcpXCucqZ0DHElPoRlWfujt4Gh4lLQABwbYw
Message-ID: <B85A65D85D7EB246BE421B3FB0FBB59301DE0DCA79@dbde02.ent.ti.com>
References: <B85A65D85D7EB246BE421B3FB0FBB59301DE0DC96A@dbde02.ent.ti.com>
 <Pine.LNX.4.44L0.0910270936450.2882-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0910270936450.2882-100000@iolanthe.rowland.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok. Then the following is the refined and probably more appropriate one.



This fixes the point where we need to complete the power transition when 
device suspend fails.

Signed-off-by: Romit Dasgupta <romit@ti.com>
---

diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
index e0dc407..3d0b26a 100644
--- a/drivers/base/power/main.c
+++ b/drivers/base/power/main.c
@@ -444,6 +444,7 @@ static void dpm_resume(pm_message_t state)
 
 	INIT_LIST_HEAD(&list);
 	mutex_lock(&dpm_list_mtx);
+	transition_started = false;
 	while (!list_empty(&dpm_list)) {
 		struct device *dev = to_device(dpm_list.next);





> -----Original Message-----
> From: linux-omap-owner@vger.kernel.org [mailto:linux-omap-
> owner@vger.kernel.org] On Behalf Of Alan Stern
> Sent: Tuesday, October 27, 2009 7:08 PM
> To: Dasgupta, Romit
> Cc: Hilman, Kevin; rjw@sisk.pl; linux-pm@lists.linux-foundation.org; linux-
> omap@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [linux-pm] [PATCH] PM: Fixes warning on suspend errors
> 
> On Tue, 27 Oct 2009, Dasgupta, Romit wrote:
> 
> > Hi,
> >      I get the following errors when I choose devices in /sys/power/pm_test. It
> also shows that if 'dpm_suspend_start' fails somewhere down the line then
> the kernel does not reset the 'transition_started' variable and we can get
> warning similar to below. IMHO 'dpm_resume_noirq' is not the right place for
> setting this variable. Please see the patch below which fixes the issue.
> 
> > Fixes the location where we decide that our power transition is complete.
> > Signed-off-by: Romit Dasgupta <romit@ti.com>
> > ---
> > diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> > index e0dc407..6b9e991 100644
> > --- a/drivers/base/power/main.c
> > +++ b/drivers/base/power/main.c
> > @@ -365,7 +365,6 @@ void dpm_resume_noirq(pm_message_t state)
> >  	struct device *dev;
> >
> >  	mutex_lock(&dpm_list_mtx);
> > -	transition_started = false;
> >  	list_for_each_entry(dev, &dpm_list, power.entry)
> >  		if (dev->power.status > DPM_OFF) {
> >  			int error;
> > @@ -529,6 +528,7 @@ static void dpm_complete(pm_message_t state)
> >  		put_device(dev);
> >  	}
> >  	list_splice(&list, &dpm_list);
> > +	transition_started = false;
> >  	mutex_unlock(&dpm_list_mtx);
> >  }
> 
> The second hunk is okay, but the first hunk isn't.  We want to set
> transition_started to false as soon as devices start resuming, because
> once a resume has begun it's okay to add new devices.
> 
> Alan Stern
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

