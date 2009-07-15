Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbZGOLQM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbZGOLQM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 07:16:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbZGOLQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 07:16:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:35848 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbZGOLQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 07:16:11 -0400
Subject: [PATCH] SOUND: riptide.c proper handling of pci_register_driver
 for joystick
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <s5hfxcyxqew.wl%tiwai@suse.de>
References: <1247639250.2437.11.camel@ht.satnam>
	 <s5hfxcyxqew.wl%tiwai@suse.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Jul 2009 16:45:40 +0530
Message-Id: <1247656540.2432.3.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-15 at 11:10 +0200, Takashi Iwai wrote:
> At Wed, 15 Jul 2009 11:57:30 +0530,
> Jaswinder Singh Rajput wrote:
> > 
> > I am getting this compiler warning in linus tree :
> > 
> >   CC [M]  sound/pci/riptide/riptide.o
> > sound/pci/riptide/riptide.c: In function ‘alsa_card_riptide_init’:
> > sound/pci/riptide/riptide.c:2200: warning: ignoring return value of ‘__pci_register_driver’, declared with attribute warn_unused_result
> > 
> > This fixes the warning in my case, hope this will be helpful :
> > 
> > diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
> > index 235a71e..fd8a552 100644
> > --- a/sound/pci/riptide/riptide.c
> > +++ b/sound/pci/riptide/riptide.c
> > @@ -2197,9 +2197,9 @@ static int __init alsa_card_riptide_init(void)
> >  	if (err < 0)
> >  		return err;
> >  #if defined(SUPPORT_JOYSTICK)
> > -	pci_register_driver(&joystick_driver);
> > +	err = pci_register_driver(&joystick_driver);
> >  #endif
> > -	return 0;
> > +	return err;
> 
> In that case, the formerly registered audio driver should be
> unregistered before returning the error from the probe callback.
> Could you fix that?
> 

[PATCH] SOUND: riptide.c proper handling of pci_register_driver for joystick

We need to check returning error for pci_register_driver(&joystick_driver)

On failure, we should unregister formerly registered audio drivers

This also fixed the compiler warning :

  CC [M]  sound/pci/riptide/riptide.o
 sound/pci/riptide/riptide.c: In function ‘alsa_card_riptide_init’:
 sound/pci/riptide/riptide.c:2200: warning: ignoring return value of ‘__pci_register_driver’, declared with attribute warn_unused_result

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 sound/pci/riptide/riptide.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/pci/riptide/riptide.c b/sound/pci/riptide/riptide.c
index 235a71e..b5ca02e 100644
--- a/sound/pci/riptide/riptide.c
+++ b/sound/pci/riptide/riptide.c
@@ -2197,9 +2197,12 @@ static int __init alsa_card_riptide_init(void)
 	if (err < 0)
 		return err;
 #if defined(SUPPORT_JOYSTICK)
-	pci_register_driver(&joystick_driver);
+	err = pci_register_driver(&joystick_driver);
+	/* On failure unregister formerly registered audio driver */
+	if (err < 0)
+		pci_unregister_driver(&driver);
 #endif
-	return 0;
+	return err;
 }
 
 static void __exit alsa_card_riptide_exit(void)
-- 
1.6.0.6



