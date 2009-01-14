Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbZANUD1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbZANUD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 15:03:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753836AbZANUDR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 15:03:17 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:34319 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbZANUDQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 15:03:16 -0500
From: "Hunter, Jon" <jon-hunter@ti.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 14 Jan 2009 14:03:09 -0600
Subject: [RFC] Dynamic Tick and Deferrable Timer Support
Thread-Topic: [RFC] Dynamic Tick and Deferrable Timer Support
Thread-Index: Acl2gx9jeqfIjHueTQaihVCgLJMoAQ==
Message-ID: <CF7665F795A4BE438425FE728CEACFA302F2436B52@dlee01.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All,

I have been working to maximise the kernel sleep time on an embedded device by utilising the dynamic tick and deferrable timer features.

During the course of this work I found that although timers were configured as deferrable, only timers for time interval tv1 were actually being deferred. Reviewing the deferrable timer patch [1], it does appear that the code is written to only defer timers for interval tv1. Therefore, I wanted to ask if this is intentional or not?

I have applied the below patch to defer all deferrable timers regardless of interval and so far it is working on the embedded device. I wanted to share this in case this could be something that could be applied to the mainline.

Please excuse any foolish mistakes I may have made here as this is my first post to your mailing list. Any feedback you could offer would be appreciated.

Cheers
Jon

[1] Deferrable timer patch: http://marc.info/?l=linux-kernel&m=117512286417320&w=2


Signed-off-by: Jon Hunter <jon-hunter@ti.com>
---
 kernel/timer.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index dee3f64..76a3ac6 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -930,6 +930,9 @@ cascade:
                index = slot = timer_jiffies & TVN_MASK;
                do {
                        list_for_each_entry(nte, varp->vec + slot, entry) {
+                               if (tbase_get_deferrable(nte->base))
+                                       continue;
+
                                found = 1;
                                if (time_before(nte->expires, expires))
                                        expires = nte->expires;
--
1.5.6.3
