Return-Path: <linux-kernel-owner+w=401wt.eu-S1758594AbXFMO6e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594AbXFMO6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 10:58:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755446AbXFMO62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 10:58:28 -0400
Received: from twin.jikos.cz ([213.151.79.26]:60931 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbXFMO61 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 10:58:27 -0400
Date: Wed, 13 Jun 2007 16:58:23 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Islam Amer <pharon@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: USB remote control missing keycodes
In-Reply-To: <1181743734.6163.1.camel@iamer-laptop>
Message-ID: <Pine.LNX.4.64.0706131654180.23280@twin.jikos.cz>
References: <20070611101319.GA14284@DervishD>  <466D2DF7.9020709@aladin.ro>
  <1181563063.19258.11.camel@iamer-laptop>  <Pine.LNX.4.64.0706111656340.23280@twin.jikos.cz>
 <1181743734.6163.1.camel@iamer-laptop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jun 2007, Islam Amer wrote:

> back ( not working )
> [  829.897373] drivers/hid/hid-core.c: report (size 5) (numbered)
> [  829.897380] drivers/hid/hid-core.c: report 4 (size 4) =  fa 00 00 00
> [  829.897389] hid-debug: input Consumer.0000 = 0
[...]
> txt ( not working )
> [  900.156751] drivers/hid/hid-core.c: report (size 5) (numbered)
> [  900.156762] drivers/hid/hid-core.c: report 5 (size 4) =  5a 00 00 00
> [  900.156771] hid-debug: input ffbc.0000 = 0
> [  900.156781] hid-debug: input ffbc.005a = 1

Oh my, another 'creative' vendor :( We really desperately need the 
hidbus, so that we could handle those misbehaving vendors in cleaner 
way, I am constantly moving that up in my todo :) 

Does the patch below fix the behavior for you? (against 2.6.21)

Also, how about the three remaining buttons you stated previously to be 
not working?



diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index c843402..9fb8845 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -474,6 +474,11 @@ static void hidinput_configure_usage(str
 				case 0x0e5: map_key_clear(KEY_BASSBOOST);	break;
 				case 0x0e9: map_key_clear(KEY_VOLUMEUP);	break;
 				case 0x0ea: map_key_clear(KEY_VOLUMEDOWN);	break;
+
+				/* reserved in HUT 1.12. Reported on Elmak MAXTER
+				 * 0x18b1/0x0037 remote control */
+				case 0x0fa: map_key_clear(KEY_BACK);		break;
+
 				case 0x183: map_key_clear(KEY_CONFIG);		break;
 				case 0x184: map_key_clear(KEY_WORDPROCESSOR);	break;
 				case 0x185: map_key_clear(KEY_EDITOR);		break;
@@ -592,7 +597,8 @@ static void hidinput_configure_usage(str
 			}
 			break;
 
-		case HID_UP_LOGIVENDOR: /* Reported on Logitech Ultra X Media Remote */
+		case HID_UP_LOGIVENDOR: /* Reported on Logitech Ultra X Media Remote 
+					 * and Elmak MAXTER Remote */
 
 			set_bit(EV_REP, input->evbit);
 			switch(usage->hid & HID_USAGE) {
@@ -613,6 +619,10 @@ static void hidinput_configure_usage(str
 				case 0x04d: map_key_clear(KEY_SUBTITLE);	break;
 				case 0x051: map_key_clear(KEY_RED);		break;
 				case 0x052: map_key_clear(KEY_CLOSE);		break;
+
+				/* Reported on Elmak 0x18b1/0x0037 remote control */
+				case 0x05a: map_key_clear(KEY_TEXT);		break;
+
 				default:    goto ignore;
 			}
 			break;
