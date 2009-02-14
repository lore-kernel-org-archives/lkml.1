Return-Path: <linux-kernel-owner+w=401wt.eu-S1758290AbZBNXd2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290AbZBNXd2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Feb 2009 18:33:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbZBNXdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Feb 2009 18:33:17 -0500
Received: from fias.uni-frankfurt.de ([141.2.248.1]:54432 "EHLO
	fias.uni-frankfurt.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398AbZBNXdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Feb 2009 18:33:16 -0500
X-Greylist: delayed 2447 seconds by postgrey-1.27 at vger.kernel.org; Sat, 14 Feb 2009 18:33:15 EST
From: Jan Scholz <scholz@fias.uni-frankfurt.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Jiri Kosina <jkosina@suse.cz>,
       Jan Scholz <Scholz@fias.uni-frankfurt.de>,
       Torsten Rausche <torsten@rausche.net>,
       Paul Collins <paul@burly.ondioline.org>
Subject: Re: [patch 41/47] bluetooth hid: enable quirk handling for Apple Wireless Keyboards in 2.6.27
References: <20090214005130.617401075@mini.kroah.org>
	<20090214005924.GP11282@kroah.com>
Date: Sat, 14 Feb 2009 23:50:39 +0100
In-Reply-To: <20090214005924.GP11282@kroah.com> (Greg KH's message of "Fri, 13
	Feb 2009 16:59:24 -0800")
Message-ID: <873aegws3k.fsf@scholz.fias.uni-frankfurt.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@suse.de> writes:

> 2.6.27-stable review patch.  If anyone has any objections, please let us know.
>
> ------------------
>
> From: Torsten Rausche <torsten@rausche.net>
>
> This patch is basically a backport of
> commit ee8a1a0a1a5817accd03ced7e7ffde3a4430f485 upstream
> which was made after the big HID overhaul in 2.6.28.
>
> Kernel 2.6.27 fails to handle quirks for the aluminum Apple Wireless
> Keyboard because it is handled as USB device and not as Bluetooth
> device. This patch expands 'hidp_blacklist' to make the kernel handle
> the keyboard in the same way as the Apple wireless Mighty Mouse (also a
> Bluetooth device).
>
> Signed-off-by: Torsten Rausche <torsten@rausche.net>
> Cc: Jan Scholz <Scholz@fias.uni-frankfurt.de>
> Cc: Jiri Kosina <jkosina@suse.cz>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
>
> ---
> ---
>  net/bluetooth/hidp/core.c |    4 ++++
>  1 file changed, 4 insertions(+)
>
> --- a/net/bluetooth/hidp/core.c
> +++ b/net/bluetooth/hidp/core.c
> @@ -684,6 +684,10 @@ static const struct {
>  } hidp_blacklist[] = {
>  	/* Apple wireless Mighty Mouse */
>  	{ 0x05ac, 0x030c, HID_QUIRK_MIGHTYMOUSE | HID_QUIRK_INVERT_HWHEEL },
> +	/* Apple Wireless Keyboard */
> +	{ 0x05ac, 0x022c, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
> +	{ 0x05ac, 0x022d, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN | HID_QUIRK_APPLE_ISO_KEYBOARD },
> +	{ 0x05ac, 0x022e, HID_QUIRK_APPLE_NUMLOCK_EMULATION | HID_QUIRK_APPLE_HAS_FN },
>  
>  	{ }	/* Terminating entry */
>  };
>
>

A very similar fix has been proposed by Paul Collins (see
http://lkml.org/lkml/2008/6/14/26 ) a while ago.

Here on my ppc32 G4 it works only if I apply the following as well.
I can't test it on x86, though.

Jan Scholz

--
    removed 2 calls to le16_to_cpu from the bluetooth hid quirks
    
    seems we're doing some endianness conversion one time to much

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 28dc035..6b95a6d 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -699,8 +699,8 @@ static void hidp_setup_quirks(struct hid_device *hid)
        unsigned int n;
 
        for (n = 0; hidp_blacklist[n].idVendor; n++)
-               if (hidp_blacklist[n].idVendor == le16_to_cpu(hid->vendor) &&
-                               hidp_blacklist[n].idProduct == le16_to_cpu(hid->product))
+               if (hidp_blacklist[n].idVendor == hid->vendor &&
+                               hidp_blacklist[n].idProduct == hid->product)
                        hid->quirks = hidp_blacklist[n].quirks;
 }

