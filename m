Return-Path: <linux-kernel-owner+w=401wt.eu-S1030291AbXBZOt1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030291AbXBZOt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Feb 2007 09:49:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030292AbXBZOt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Feb 2007 09:49:27 -0500
Received: from tim.rpsys.net ([194.106.48.114]:57106 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030291AbXBZOt0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Feb 2007 09:49:26 -0500
Subject: Re: 2.6.21-rc1 dims my LCD
From: Richard Purdie <rpurdie@rpsys.net>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Jiri Kosina <jikos@jikos.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <20070226142157.GA2909@khazad-dum.debian.net>
References: <Pine.LNX.4.64.0702260154460.10496@twin.jikos.cz>
	 <1172490091.5824.30.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0702261329270.10496@twin.jikos.cz>
	 <20070226142157.GA2909@khazad-dum.debian.net>
Content-Type: text/plain
Date: Mon, 26 Feb 2007 14:49:17 +0000
Message-Id: <1172501357.5824.91.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-02-26 at 11:21 -0300, Henrique de Moraes Holschuh wrote:
> On Mon, 26 Feb 2007, Jiri Kosina wrote:
> > On Mon, 26 Feb 2007, Richard Purdie wrote:
> > > > When I hit the keyboard, the brightness stays low (it's 50% of light 
> > > > or so, so I could read what's on the screen, but it's uncomfortably 
> > > > dim), and I have to manually raise the brightness on the LCD. Quite 
> > > > annoying :) I have bisected this to your commit 
> > > > 994efacdf9a087b52f71e620b58dfa526b0cf928
> > > Which framebuffer driver and backlight driver are you using?
> > > ("ls /sys/class/backlight/" will show which backlight it is)
> > 
> > It's IBM:
> 
> Please add me to the CC, then.  I noticed this thread by accident.
> 
> > $ ll /sys/class/backlight/
> > drwxr-xr-x 2 root root 0 Feb 26 13:28 ibm
> > 
> > At the time the brightness goes low, there is '0' in 
> > /sys/class/backlight/ibm/actual_brightness and 
> > /sys/class/backlight/ibm/brightness
> 
> ibm-acpi does not implement display poweroff, so if a screen-saving function
> on the kernel is trying to use it to shut the display off, it will either
> fail to do anything, or if it ALSO sets brightness to zero, it will just dim
> the display.

I think I can explain whats going on. The commit you pointed to isn't
really at fault, it just happens to trigger an extra framebuffer
blanking call and this exposes a bug in the ibm backlight code which
there is already a fix for.

Basically, console blanking triggers a backlight_update_status() call
and bd->props.brightness wasn't set correctly at boot time. If
bd->props.brightness is set correctly, that call won't cause a problem. 

Jiri: I've appended a patch that should already be queued, could you
test and see if it solves the problem.

> Richard, would you like a patch to -ENOSYS if a display power management
> event reaches ibm-acpi?

The ibm backlight driver should really try and work with the system a
little more. Even if it can't turn the display off, the power attribute
should  minimise power usage as best it can. If that means just dimming
the display, so be it. Ideally, I'd still prefer for it to gain support
for turning the display off.

In the update_status function, there are three sources of information
you need to combine:

bd->props.brightness
bd->props.power
bd->props.fb_blank

Since the backlight class doesn't know the capabilities of the hardware,
it is left to each implementation to combine these options in a way that
makes sense. Currently ibm just looks at the first one but it could dim
if the latter two are anything other than FB_BLANK_UNBLANK. See corgi_bl
as an example (which also looks at its own variables too).

Richard

----

From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

ACPI: ibm-acpi: fix initial status of backlight device

The brightness class core does not update the initial status of the
device's brightness at register time.  Do it by ourselves.

Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Acked-by: Richard Purdie <rpurdie@rpsys.net>
---
 drivers/acpi/ibm_acpi.c |   10 +++++++++-
 1 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/drivers/acpi/ibm_acpi.c b/drivers/acpi/ibm_acpi.c
index 4cc534e..7c1b418 100644
--- a/drivers/acpi/ibm_acpi.c
+++ b/drivers/acpi/ibm_acpi.c
@@ -1711,6 +1711,12 @@ static struct backlight_ops ibm_backlight_data = {
 
 static int brightness_init(void)
 {
+       int b;
+
+       b = brightness_get(NULL);
+       if (b < 0)
+               return b;
+
        ibm_backlight_device = backlight_device_register("ibm", NULL, NULL,
                                                         &ibm_backlight_data);
        if (IS_ERR(ibm_backlight_device)) {
@@ -1718,7 +1724,9 @@ static int brightness_init(void)
                return PTR_ERR(ibm_backlight_device);
        }
 
-        ibm_backlight_device->props.max_brightness = 7;
+       ibm_backlight_device->props.max_brightness = 7;
+       ibm_backlight_device->props.brightness = b;
+       backlight_update_status(ibm_backlight_device);
 
        return 0;
 }




