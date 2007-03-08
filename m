Return-Path: <linux-kernel-owner+w=401wt.eu-S933354AbXCHVZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354AbXCHVZF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 16:25:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030274AbXCHVZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 16:25:05 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:60856 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933354AbXCHVZD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 16:25:03 -0500
Date: Thu, 8 Mar 2007 22:25:12 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>, dmitry.torokhov@gmail.com
Cc: Christoph Hellwig <hch@infradead.org>, Deepak Saxena <dsaxena@plexity.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix building kernel under Solaris
Message-ID: <20070308212512.GA10584@uranus.ravnborg.org>
References: <20070306180940.GA3240@plexity.net> <20070307094229.GG14863@infradead.org> <Pine.LNX.4.61.0703072342310.2448@yvahk01.tjqt.qr> <20070308083543.GA5213@infradead.org> <Pine.LNX.4.61.0703082142240.521@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.61.0703082142240.521@yvahk01.tjqt.qr>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2007 at 09:43:46PM +0100, Jan Engelhardt wrote:
> 
> On Mar 8 2007 08:35, Christoph Hellwig wrote:
> >On Wed, Mar 07, 2007 at 11:45:11PM +0100, Jan Engelhardt wrote:
> >> 
> >> On Mar 7 2007 09:42, Christoph Hellwig wrote:
> >> >>  #include <sys/time.h>
> >> >>  #include <sys/ioctl.h>
> >> >>  #include <sys/types.h>
> >> >> +#ifndef __sun__
> >> >>  #include <asm/types.h>
> >> >>  #endif
> >> >> +#endif
> >> >
> >> >So if solaris doesn't need it, why do we need it on Linux?
> >> 
> >> For __s32 and __s16.
> >
> >We shouldn't use those from asm/types.h on Linux either, but
> >get them consitantly by defining them to the C99 or BSD types
> >from the libc headers.
> 
> It's a bit icky. file2alias.c includes "../../include/linux/input.h" and it is
> _input.h_ that requires __s16/__s32 and hence includes <asm/types.h>.
> If you ask me, it's file2alias.c that's broken.
Took a closer look and agree on that.
I have queued up below patch to fix it.
I expect to see an updated patch on the other issues from Deepak.

	Sam

diff --git a/include/linux/input.h b/include/linux/input.h
index bde65c8..13d510c 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -1010,6 +1010,10 @@ struct input_dev {
 #error "EV_MAX and INPUT_DEVICE_ID_EV_MAX do not match"
 #endif
 
+#if KEY_MIN_INTERESTING != INPUT_DEVICE_ID_KEY_MIN_INTERESTING
+#error "KEY_MIN_INTERESTING and INPUT_DEVICE_ID_KEY_MIN_INTERESTING do not match"
+#endif
+
 #if KEY_MAX != INPUT_DEVICE_ID_KEY_MAX
 #error "KEY_MAX and INPUT_DEVICE_ID_KEY_MAX do not match"
 #endif
diff --git a/include/linux/mod_devicetable.h b/include/linux/mod_devicetable.h
index e0c393c..5e89204 100644
--- a/include/linux/mod_devicetable.h
+++ b/include/linux/mod_devicetable.h
@@ -262,6 +262,7 @@ struct i2c_device_id {
 
 /* Input */
 #define INPUT_DEVICE_ID_EV_MAX		0x1f
+#define INPUT_DEVICE_ID_KEY_MIN_INTERESTING	0x71
 #define INPUT_DEVICE_ID_KEY_MAX		0x1ff
 #define INPUT_DEVICE_ID_REL_MAX		0x0f
 #define INPUT_DEVICE_ID_ABS_MAX		0x3f
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index f61c9cc..96319eb 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -37,7 +37,6 @@ typedef unsigned char	__u8;
  * even potentially has different endianness and word sizes, since
  * we handle those differences explicitly below */
 #include "../../include/linux/mod_devicetable.h"
-#include "../../include/linux/input.h"
 
 #define ADD(str, sep, cond, field)                              \
 do {                                                            \
@@ -416,31 +415,33 @@ static int do_input_entry(const char *filename, struct input_device_id *id,
 
 	sprintf(alias + strlen(alias), "-e*");
 	if (id->flags & INPUT_DEVICE_ID_MATCH_EVBIT)
-		do_input(alias, id->evbit, 0, EV_MAX);
+		do_input(alias, id->evbit, 0, INPUT_DEVICE_ID_EV_MAX);
 	sprintf(alias + strlen(alias), "k*");
 	if (id->flags & INPUT_DEVICE_ID_MATCH_KEYBIT)
-		do_input(alias, id->keybit, KEY_MIN_INTERESTING, KEY_MAX);
+		do_input(alias, id->keybit,
+			 INPUT_DEVICE_ID_KEY_MIN_INTERESTING,
+			 INPUT_DEVICE_ID_KEY_MAX);
 	sprintf(alias + strlen(alias), "r*");
 	if (id->flags & INPUT_DEVICE_ID_MATCH_RELBIT)
-		do_input(alias, id->relbit, 0, REL_MAX);
+		do_input(alias, id->relbit, 0, INPUT_DEVICE_ID_REL_MAX);
 	sprintf(alias + strlen(alias), "a*");
 	if (id->flags & INPUT_DEVICE_ID_MATCH_ABSBIT)
-		do_input(alias, id->absbit, 0, ABS_MAX);
+		do_input(alias, id->absbit, 0, INPUT_DEVICE_ID_ABS_MAX);
 	sprintf(alias + strlen(alias), "m*");
 	if (id->flags & INPUT_DEVICE_ID_MATCH_MSCIT)
-		do_input(alias, id->mscbit, 0, MSC_MAX);
+		do_input(alias, id->mscbit, 0, INPUT_DEVICE_ID_MSC_MAX);
 	sprintf(alias + strlen(alias), "l*");
 	if (id->flags & INPUT_DEVICE_ID_MATCH_LEDBIT)
-		do_input(alias, id->ledbit, 0, LED_MAX);
+		do_input(alias, id->ledbit, 0, INPUT_DEVICE_ID_LED_MAX);
 	sprintf(alias + strlen(alias), "s*");
 	if (id->flags & INPUT_DEVICE_ID_MATCH_SNDBIT)
-		do_input(alias, id->sndbit, 0, SND_MAX);
+		do_input(alias, id->sndbit, 0, INPUT_DEVICE_ID_SND_MAX);
 	sprintf(alias + strlen(alias), "f*");
 	if (id->flags & INPUT_DEVICE_ID_MATCH_FFBIT)
-		do_input(alias, id->ffbit, 0, FF_MAX);
+		do_input(alias, id->ffbit, 0, INPUT_DEVICE_ID_FF_MAX);
 	sprintf(alias + strlen(alias), "w*");
 	if (id->flags & INPUT_DEVICE_ID_MATCH_SWBIT)
-		do_input(alias, id->swbit, 0, SW_MAX);
+		do_input(alias, id->swbit, 0, INPUT_DEVICE_ID_SW_MAX);
 	return 1;
 }
 
