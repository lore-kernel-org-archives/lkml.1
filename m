Return-Path: <linux-kernel-owner+w=401wt.eu-S1761662AbZCNAkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761662AbZCNAkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 20:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753880AbZCNATg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 20:19:36 -0400
Received: from kroah.org ([198.145.64.141]:34844 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750857AbZCNATX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 20:19:23 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Fri Mar 13 17:07:48 2009
Message-Id: <20090314000748.556195682@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Fri, 13 Mar 2009 17:06:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Clemens Ladisch <clemens@ladisch.de>,
       Takashi Iwai <tiwai@suse.de>
Subject: [patch 63/96] sound: usb-audio: fix uninitialized variable with M-Audio MIDI interfaces
References: <20090314000508.803142980@mini.kroah.org>
Content-Disposition: inline; filename=sound-usb-audio-fix-uninitialized-variable-with-m-audio-midi-interfaces.patch
In-Reply-To: <20090314001449.GA4485@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Clemens Ladisch <clemens@ladisch.de>

commit e156ac4c571e3be741bc411e58820b74a9295c72 upstream.

Fix the snd_usbmidi_create_endpoints_midiman() function, which forgot to
set the out_interval member of the endpoint info structure for Midiman/
M-Audio devices.  Since kernel 2.6.24, any non-zero value makes the
driver use interrupt transfers instead of bulk transfers.  With EHCI
controllers, these random interval values result in unbearably large
latencies for output MIDI transfers.

Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
Reported-by: David <devurandom@foobox.com>
Tested-by: David <devurandom@foobox.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/usb/usbmidi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/usb/usbmidi.c
+++ b/sound/usb/usbmidi.c
@@ -1583,6 +1583,7 @@ static int snd_usbmidi_create_endpoints_
 	}
 
 	ep_info.out_ep = get_endpoint(hostif, 2)->bEndpointAddress & USB_ENDPOINT_NUMBER_MASK;
+	ep_info.out_interval = 0;
 	ep_info.out_cables = endpoint->out_cables & 0x5555;
 	err = snd_usbmidi_out_endpoint_create(umidi, &ep_info, &umidi->endpoints[0]);
 	if (err < 0)


