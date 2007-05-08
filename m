Return-Path: <linux-kernel-owner+w=401wt.eu-S935004AbXEHQYL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935004AbXEHQYL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 12:24:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S968242AbXEHQYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 12:24:10 -0400
Received: from twin.jikos.cz ([213.151.79.26]:55165 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934928AbXEHQYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 12:24:08 -0400
Date: Tue, 8 May 2007 18:23:57 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Satyam Sharma <satyam.sharma@gmail.com>,
       Marcel Holtmann <marcel@holtmann.org>
cc: chris@pcburn.com, linux-kernel@vger.kernel.org,
       bluez-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: Re: Getting make net/built-in.o Error with 2.6.21.1 Build
In-Reply-To: <a781481a0705080905l609dc925s93357e6eb0d4c318@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705081815130.16923@twin.jikos.cz>
References: <463FB6B0.3070005@pcburn.com>  <a781481a0705071725i1d802dfejbcdaca4ab0a1ff55@mail.gmail.com>
  <Pine.LNX.4.64.0705081740550.16923@twin.jikos.cz>
 <a781481a0705080905l609dc925s93357e6eb0d4c318@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 May 2007, Satyam Sharma wrote:

> Sure, my aim here was to only solve the _build breakage_ by fixing the 
> Kconfig for this module (that used code from another kernel module 
> without listing it in its dependencies). If, as you say, the real 
> solution is that we should actually be taking out the offending call to 
> the other module itself, then please go ahead -- I don't know much about 
> the Bluetooth / HIDP subsytem anyway.

Converting the hid-ff drivers to be also transport-independent is on my 
TODO list, but it didn't happen yet.

Marcel - are you aware of any devices currently supported by USB HID 
force-feedback code, which have a bluetooth version, please? 

I'd propose the patch below, until I make the usbhid force-feedback code 
transport independent. Thanks.



From: Jiri Kosina <jkosina@suse.cz>

[Bluetooth] HIDP - don't initialize force feedback

The current implementation of force feedback for HID devices is 
USB-transport only and therefore calling hid_ff_init() from hidp code is 
not going to work (plus it creates unwanted dependency of hidp on usbhid). 
Remove the hid_ff_init() until either the hid-ff is made 
transport-independent, or at least support for bluetooth transport is 
added.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index d342e89..3e77e81 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -737,10 +737,8 @@ static inline void hidp_setup_hid(struct
 	list_for_each_entry(report, &hid->report_enum[HID_FEATURE_REPORT].report_list, list)
 		hidp_send_report(session, report);
 
-	if (hidinput_connect(hid) == 0) {
+	if (hidinput_connect(hid) == 0)
 		hid->claimed |= HID_CLAIMED_INPUT;
-		hid_ff_init(hid);
-	}
 }
 
 int hidp_add_connection(struct hidp_connadd_req *req, struct socket *ctrl_sock, struct socket *intr_sock)
