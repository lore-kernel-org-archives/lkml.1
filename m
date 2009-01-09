Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbZAISgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbZAISgT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 13:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753133AbZAISgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 13:36:09 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:40561 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408AbZAISgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 13:36:08 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <496798FE.8030900@s5r6.in-berlin.de>
Date: Fri, 09 Jan 2009 19:35:42 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
       Jay Fenlason <fenlason@redhat.com>
Subject: post 2.6.28 regression: device_initialize() now sleeps, and may fail
 without recovery strategy
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From commit 2831fe6f9cc4e16c103504ee09a47a084297c0f3, "driver core:
create a private portion of struct device":

 void device_initialize(struct device *dev)
 {
+	dev->p = kzalloc(sizeof(*dev->p), GFP_KERNEL);
+	if (!dev->p) {
+		WARN_ON(1);
+		return;
+	}
+	dev->p->device = dev;
 	dev->kobj.kset = devices_kset;
 	kobject_init(&dev->kobj, &device_ktype);


First of all, this prevents initialization of struct device in atomic
contexts, such as drivers/firewire/fw-device.c::fw_node_event.

This is a bug in current mainline.

We can fix the bug by changing firewire-core, but
  a) it'd be more than a one-liner,
  b) who knows which other subsystems are affected.

Next, the above code is bogus.  In 2.6.28, device_initialize() could
never fail and was thus safe to use as a void-valued function.

How does driver core handle dev->p == NULL in subsequent usages of dev now?
-- 
Stefan Richter
-=====-==--= ---= -=--=
http://arcgraph.de/sr/
