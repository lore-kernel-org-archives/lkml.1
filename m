Return-Path: <linux-kernel-owner+w=401wt.eu-S1756399AbZKKJwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399AbZKKJwU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 04:52:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755036AbZKKJwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 04:52:19 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:58826 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbZKKJwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 04:52:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mz5kchlUvvMDUyiDHRfo9YfHbP9NlwI8n4PNlhWYdTIsSHyi8hqbKVDqxkHIerpbQM
         LWPq7oN76k0cNfjznCXPZFvXb79kPAo2FWORp4Zvqe9oTzVMT78tOBGOaPL8ZKQ/e8H9
         AMi+QMUdVCYLx387rGW3MlB2TcS/dG40tr+ho=
Date: Wed, 11 Nov 2009 01:52:19 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mikko Vinni <mmvinni@yahoo.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: keyboard leds not restored after s2ram in
	2.6.32-rc6-00166-g799dd75
Message-ID: <20091111095218.GA3654@core.coreip.homeip.net>
References: <761296.29412.qm@web58402.mail.re3.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <761296.29412.qm@web58402.mail.re3.yahoo.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mikko,

On Tue, Nov 10, 2009 at 09:27:40AM -0800, Mikko Vinni wrote:
> Hi,
> 
> my laptop shows the caps lock and scroll lock leds as being on after s2ram
> (and resume), even though they are off. If I press the caps lock key, the caps
> lock led stays on, the num lock led turns off, and the screen unlock screen
> warns about the caps lock being on.
> 

Thank you for the report. Could youplease tell me if the patch below
fixes the problem?

Thanks!

-- 
Dmitry


Input: force LED reset on resume

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

We should be sending EV_LED event down to drivers upon resume even in cases
when in-kernel state of the LED is off since device could come up with some
leds turned on.

Reported-by: Mikko Vinni <mmvinni@yahoo.com>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 drivers/input/input.c |   29 ++++++++++++++++++-----------
 1 files changed, 18 insertions(+), 11 deletions(-)


diff --git a/drivers/input/input.c b/drivers/input/input.c
index 61069b2..77b6efe 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -1298,17 +1298,24 @@ static int input_dev_uevent(struct device *device, struct kobj_uevent_env *env)
 	return 0;
 }
 
-#define INPUT_DO_TOGGLE(dev, type, bits, on)			\
-	do {							\
-		int i;						\
-		if (!test_bit(EV_##type, dev->evbit))		\
-			break;					\
-		for (i = 0; i < type##_MAX; i++) {		\
-			if (!test_bit(i, dev->bits##bit) ||	\
-			    !test_bit(i, dev->bits))		\
-				continue;			\
-			dev->event(dev, EV_##type, i, on);	\
-		}						\
+#define INPUT_DO_TOGGLE(dev, type, bits, on)				\
+	do {								\
+		int i;							\
+		bool active;						\
+									\
+		if (!test_bit(EV_##type, dev->evbit))			\
+			break;						\
+									\
+		for (i = 0; i < type##_MAX; i++) {			\
+			if (!test_bit(i, dev->bits##bit))		\
+				continue;				\
+									\
+			active = test_bit(i, dev->bits);		\
+			if (!active && !on)				\
+				continue;				\
+									\
+			dev->event(dev, EV_##type, i, on ? active : 0);	\
+		}							\
 	} while (0)
 
 #ifdef CONFIG_PM
