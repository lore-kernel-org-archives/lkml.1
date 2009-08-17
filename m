Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbZHQTQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbZHQTQr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 15:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbZHQTQq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 15:16:46 -0400
Received: from sg2ehsobe004.messaging.microsoft.com ([207.46.51.78]:47308 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752944AbZHQTQp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 15:16:45 -0400
X-SpamScore: -16
X-BigFish: VPS-16(zz1432R98dNzz1202hzzz2fh6bh62h)
X-Spam-TCS-SCL: 1:0
Message-ID: <4A89AC40.2040109@am.sony.com>
Date: Mon, 17 Aug 2009 12:15:12 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Robert Schwebel <r.schwebel@pengutronix.de>
CC: Denys Vlasenko <vda.linux@googlemail.com>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>, kernel@pengutronix.de
Subject: Re: New fast(?)-boot results on ARM
References: <20090814170228.GM13320@pengutronix.de> <1158166a0908141304y70300ab3p899b0d4609efded9@mail.gmail.com> <20090814204305.GA31727@pengutronix.de>
In-Reply-To: <20090814204305.GA31727@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-OriginalArrivalTime: 17 Aug 2009 19:15:13.0354 (UTC) FILETIME=[0BD0BAA0:01CA1F6F]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Schwebel wrote:
> On Fri, Aug 14, 2009 at 10:04:57PM +0200, Denys Vlasenko wrote:
>>> [ �5.082616] < �0.007992> RPC: Registered tcp transport module.
>>> [ �5.605159] < �0.522543> eth0: config: auto-negotiation on, 100FDX, 100HDX, 10FDX, 10HDX.
>>> [ �6.602621] < �0.997462> IP-Config: Complete:
>>> [ �6.606638] < �0.004017> � � �device=eth0, addr=192.168.23.197, mask=255.255.0.0, gw=192.168.23.2,
>>> [ �6.614588] < �0.007950> � � �host=192.168.23.197, domain=, nis-domain=(none),
>>> [ �6.618652] < �0.004064> � � �bootserver=192.168.23.2, rootserver=192.168.23.2, rootpath=
>> Well, this ~1 second is not really kernel's fault, it's DHCP delay.
>> But, do you need to do it at this moment?
>> You do not seem to be using networking filesystems.
>> You can run DHCP client in userspace.
> 
> The board has ip autoconfig configured in, because we also use tftp/nfs
> boot for development. But it had been disabled on the commandline:
> 
> ip=192.168.23.197:192.168.23.2:192.168.23.2:255.255.0.0:::
> 
> That shouldn't do dhcp, right?

I think it doesn't, but I'm not positive.  The DHCP trasmissions
themselves don't take very long.  There are some very long timeouts
in the network code paths, which appear to be used whether you specify
a static address or not.

See the definitions of CONF_PRE_OPEN and CON_POST_OPEN
in net/ipv4/ipconfig.c

They are set to ridiculously long values.  In my experience,
you can cut them down considerably with no dangerous side
effects (but I haven't asked the network guys about the
possible downsides).

Here's a patch which I've used in the past.  (Sorry
if it doesn't apply cleanly, I just extracted it from
a PDF and the whitespace may have gotten messed up.
It's short enough that you can hand-edit the files if
there's a problem.)

I'd like to hear back, if you apply this, whether it shortens
the network startup time for you.

diff --git a/net/ipv4/ipconfig.c b/net/ipv4/ipconfig.c
index 42065ff..e42d83f 100644
--- a/net/ipv4/ipconfig.c
+++ b/net/ipv4/ipconfig.c
@@ -86,8 +86,10 @@
 #endif

 /* Define the friendly delay before and after opening net devices */
-#define CONF_PRE_OPEN 500 /* Before opening: 1/2 second */
-#define CONF_POST_OPEN 1 /* After opening: 1 second */
+/*#define CONF_PRE_OPEN 500 /* Before opening: 1/2 second */
+/*#define CONF_POST_OPEN 1 /* After opening: 1 second */
+#define CONF_PRE_OPEN 5 /* Before opening: 5 milli seconds */
+#define CONF_POST_OPEN 10 /* After opening: 10 milli seconds */

 /* Define the timeout for waiting for a DHCP/BOOTP/RARP reply */
 #define CONF_OPEN_RETRIES 2 /* (Re)open devices twice */
@@ -1292,7 +1294,7 @@ static int __init ip_auto_config(void)
 		return -1;
 	/* Give drivers a chance to settle */
-	ssleep(CONF_POST_OPEN);
+	msleep(CONF_POST_OPEN);

 	/*
 	 * If the config information is insufficient (e.g., our IP address or

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

