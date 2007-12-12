Return-Path: <linux-kernel-owner+w=401wt.eu-S1751706AbXLLL5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706AbXLLL5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 06:57:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751948AbXLLL45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 06:56:57 -0500
Received: from holomorphy.com ([66.93.40.71]:59076 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbXLLL44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 06:56:56 -0500
Date: Wed, 12 Dec 2007 03:56:55 -0800
From: William Lee Irwin III <wli@holomorphy.com>
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: acpi ->video_device_list corruption
Message-ID: <20071212115655.GB18472@holomorphy.com>
References: <20071212101505.GA18472@holomorphy.com> <18271.51833.872482.880312@harpo.it.uu.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18271.51833.872482.880312@harpo.it.uu.se>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2007 at 12:48:09PM +0100, Mikael Pettersson wrote:
> IMO the memset(ptr, 0, sizeof(*ptr)) idiom is both safer
> and avoids having to write an uninteresting type name.

How about this, then?

The ->cap fields of struct acpi_video_device and struct acpi_video_bus
are 1B each, not 4B. The oversized memset()'s corrupted the subsequent
list_head fields. This resulted in silent corruption without
CONFIG_DEBUG_LIST and BUG's with it. This patch uses sizeof() to pass
the proper bounds to the memset() calls and thereby correct the bugs.

The patch was seen to resolve the issue on the affected system.

vs. 2.6.24-rc5

Signed-off-by: William Irwin <wli@holomorphy.com>

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 44a0d9b..bd77e81 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -577,7 +577,7 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
 	struct acpi_video_device_brightness *br = NULL;
 
 
-	memset(&device->cap, 0, 4);
+	memset(&device->cap, 0, sizeof(device->cap));
 
 	if (ACPI_SUCCESS(acpi_get_handle(device->dev->handle, "_ADR", &h_dummy1))) {
 		device->cap._ADR = 1;
@@ -697,7 +697,7 @@ static void acpi_video_bus_find_cap(struct acpi_video_bus *video)
 {
 	acpi_handle h_dummy1;
 
-	memset(&video->cap, 0, 4);
+	memset(&video->cap, 0, sizeof(video->cap));
 	if (ACPI_SUCCESS(acpi_get_handle(video->device->handle, "_DOS", &h_dummy1))) {
 		video->cap._DOS = 1;
 	}
