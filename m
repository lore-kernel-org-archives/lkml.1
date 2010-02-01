Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab0BAQcA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:32:00 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:22955 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab0BAQb7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:31:59 -0500
Date: Mon, 1 Feb 2010 11:30:44 -0500
From: Chris Mason <chris.mason@oracle.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alex Chiang <achiang@hp.com>
Subject: [PATCH] set dock_station->flags to zero during dock_add
Message-ID: <20100201163043.GA3240@think>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alex Chiang <achiang@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4B6701EC.01C5:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Before fe06fba292af5ed5c1c6ad9af3a9ef68da7a5088 the dock_station struct
was allocated and zero filled by kzalloc.  Now it is allocated by
platform_device_register_data(), apparently via a kmemdup of a variable
on the stack?

Now we no longer init dock_station->flags to zero, and my x60 laptop was
lucky enough to always have DOCK_DOCKING set.  So, I always saw -EBUSY
when I tried to undock.

With the patch below, I can dock and undock properly again.  I double
checked that dock_station->flags was the only field that we were not
setting up.

This was just brute force guessing, I have no idea what this code does.

Signed-off-by: Chris Mason <chris.mason@oracle.com>

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index bbc2c13..0a449ad 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -944,6 +945,7 @@ static int dock_add(acpi_handle handle)
 	dock_station->handle = handle;
 	dock_station->dock_device = dd;
 	dock_station->last_dock_time = jiffies - HZ;
+	dock_station->flags = 0;
 
 	mutex_init(&dock_station->hp_lock);
 	spin_lock_init(&dock_station->dd_lock);
