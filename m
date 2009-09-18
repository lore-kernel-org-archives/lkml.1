Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbZIRHCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbZIRHCz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 03:02:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751694AbZIRHCy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 03:02:54 -0400
Received: from adelie.canonical.com ([91.189.90.139]:34220 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751645AbZIRHCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 03:02:53 -0400
Message-ID: <4AB33099.6070607@canonical.com>
Date: Fri, 18 Sep 2009 09:02:49 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Tilman Schmidt <tilman@imap.cc>, Greg KH <gregkh@suse.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       stable-review@kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [Stable-review] [stable] [patch 00/48] 2.6.27.32-stable review
References: <200909112223.n8BMMSHG002530@hera.kernel.org> <20090916210956.GB24567@kroah.com>
In-Reply-To: <20090916210956.GB24567@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------030708040605020203050902"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030708040605020203050902
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Greg KH wrote:
> On Sat, Sep 12, 2009 at 12:22:22AM +0200, Tilman Schmidt wrote:
>> [On holiday, answering from my nominally internet capable cellphone - please make allowances ...]
>>
>> The stable patch claiming to correspond to Linus' tree patch
>> 56f7efe48d57dda9e59e23ab161c118271cce815 and merged in 2.6.27.sth
>> (eyact version not at hand) and 2.6.28.10 differs from the backported
>> patch I submitted for stable myself. It breaks the driver completely,
>> causing an oops and system malfunctions as soon as the device is
>> connected. (Sorry for not noticing the vital difference at the time.)
> 
> No problem.
> 
>> The attached patch would fix the error by moving the code inswrted at
>> the wrong place by the broken backported patch,, to the correct place
>> where it went in the original patch. 
> 
> I see no patch attached here :(
> 
>> Alternativelyy, the broken backported could be reverted and my
>> original bacport merged instead, if you can still find it.
> 
> I can not.
> 
>> Sorry for lack of references as i don't have acces to my development
>> machine from here. Hope to have Cleared up the situation, anyway.
> 
> Can you send me what you need applied to the latest 2.6.27-stable tree
> to fix this up so we can finally resolve this?
> 

I believe it was applicable to 2.6.27.y without problems. This is the patch I 
sent to Tilman and stable. (Sorry, I am currently at the airport and do not 
have 2.6.27.y with me)

-Stefan

> thanks,
> 
> greg k-h
> 
> _______________________________________________
> Stable-review mailing list
> Stable-review@linux.kernel.org
> http://linux.kernel.org/mailman/listinfo/stable-review


--------------030708040605020203050902
Content-Type: text/x-diff;
 name="0001-UBUNTU-SAUCE-Fix-incorrect-stable-backport-to-bas_.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-UBUNTU-SAUCE-Fix-incorrect-stable-backport-to-bas_.patc";
 filename*1="h"

>From 55559d69f6a84ae295e8a1b0cbabc7d6c7e5f18a Mon Sep 17 00:00:00 2001
From: Stefan Bader <stefan.bader@canonical.com>
Date: Tue, 25 Aug 2009 17:35:56 +0200
Subject: [PATCH] Fix incorrect stable backport to bas_gigaset

BugLink: http://bugs.launchpad.net/bugs/417732

commit 56f7efe48d57dda9e59e23ab161c118271cce815
Author: Tilman Schmidt <tilman@imap.cc>
Date:   Wed Apr 15 03:25:43 2009 -0700

    bas_gigaset: correctly allocate USB interrupt transfer buffer

    [ Upstream commit 170ebf85160dd128e1c4206cc197cce7d1424705 ]

This incorrect backport to 2.6.28.10 placed some code into the probe function
which used a pointer before it was initialized. Moving this to the correct
place (as it is in upstream).

Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Acked-by: Tim Gardner <tim.gardner@canonical.com>
Acked-by: Steve Conklin <steve.conklin@canonical.com>
---
 drivers/isdn/gigaset/bas-gigaset.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/isdn/gigaset/bas-gigaset.c b/drivers/isdn/gigaset/bas-gigaset.c
index fcec2df..3990eae 100644
--- a/drivers/isdn/gigaset/bas-gigaset.c
+++ b/drivers/isdn/gigaset/bas-gigaset.c
@@ -2140,8 +2140,16 @@ static int gigaset_initcshw(struct cardstate *cs)
 	struct bas_cardstate *ucs;
 
 	cs->hw.bas = ucs = kmalloc(sizeof *ucs, GFP_KERNEL);
-	if (!ucs)
+	if (!ucs) {
+		pr_err("out of memory\n");
+		return 0;
+	}
+	ucs->int_in_buf = kmalloc(IP_MSGSIZE, GFP_KERNEL);
+	if (!ucs->int_in_buf) {
+		kfree(ucs);
+		pr_err("out of memory\n");
 		return 0;
+	}
 
 	ucs->urb_cmd_in = NULL;
 	ucs->urb_cmd_out = NULL;
@@ -2236,12 +2244,6 @@ static int gigaset_probe(struct usb_interface *interface,
 		}
 		hostif = interface->cur_altsetting;
 	}
-	ucs->int_in_buf = kmalloc(IP_MSGSIZE, GFP_KERNEL);
-	if (!ucs->int_in_buf) {
-		kfree(ucs);
-		pr_err("out of memory\n");
-		return 0;
-	}
 
 	/* Reject application specific interfaces
 	 */
-- 
1.6.0.4


--------------030708040605020203050902--
