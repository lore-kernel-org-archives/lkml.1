Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbZLBTbA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbZLBTbA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 14:31:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755494AbZLBTa7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 14:30:59 -0500
Received: from pancho.name ([92.48.73.7]:53219 "EHLO pancho.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755442AbZLBTa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 14:30:58 -0500
Date: Wed, 2 Dec 2009 20:31:04 +0100
From: pancho horrillo <pancho@pancho.name>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Fix a bug on appledisplay.c regarding signedness
Message-ID: <20091202193104.GB7362@pancho.name>
References: <20091202191942.GA7362@pancho.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091202191942.GA7362@pancho.name>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

bug description:  If the brightness level on the apple display is 128 or
higher, the driver will complain on startup:

"Error while getting initial brightness: -128"

Actual                  Driver
Brightness level        Reported value
0                       0
...                     ...
126                     126
127                     127
128                     -128 (aha! :-)
129                     -127
...                     ...
255                     -1

Also, the reported brightness via /sys interface will present the same
inconsistency.

I realized that this was simply because the monitor transmits its data
as an unsigned char (uint8_t), and in the code it is treated as a signed
char.

I consulted Caskey L. Dickson's acdctl sources to ascertain this.  He
used uint8_t there.   I also checked the usb_* functions definitions to be
sure that I was not second-guessing them.  Yep, they accept (void *) in
the relevant parameters, so it's up to us to decide the type of the
payload.

I've tested it and works like a charm now.

I have emailed the author of the driver, Michael Hanselmann, and he said:
On Wed, Dec 02, 2009 at 05:14:26PM +0000, Michael Hanselmann wrote:
[...]
> If I remember correctly, Linux on PowerPC uses unsigned chars by
> default. I never tested the driver on a non-PowerPC platform and hence
> may never have seen this.


Please, review and push the patch, if you deem it adequate.

Thanks a bunch!

Signed-off-by: pancho horrillo <pancho@pancho.name>

diff -purN a/drivers/usb/misc/appledisplay.c b/drivers/usb/misc/appledisplay.c
--- a/drivers/usb/misc/appledisplay.c	2009-11-10 01:32:31.000000000 +0100
+++ b/drivers/usb/misc/appledisplay.c	2009-12-02 20:05:00.000000000 +0100
@@ -72,8 +72,8 @@ struct appledisplay {
 	struct usb_device *udev;	/* usb device */
 	struct urb *urb;		/* usb request block */
 	struct backlight_device *bd;	/* backlight device */
-	char *urbdata;			/* interrupt URB data buffer */
-	char *msgdata;			/* control message data buffer */
+	uint8_t *urbdata;		/* interrupt URB data buffer */
+	uint8_t *msgdata;		/* control message data buffer */
 
 	struct delayed_work work;
 	int button_pressed;

-- 
pancho horrillo

To be conscious that
you are ignorant is a great step
to knowledge.

		Benjamin Disraeli
