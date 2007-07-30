Return-Path: <linux-kernel-owner+w=401wt.eu-S940116AbXG3WfD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940116AbXG3WfD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 18:35:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939329AbXG3Wew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 18:34:52 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:52703 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932790AbXG3Wev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 18:34:51 -0400
Date: Mon, 30 Jul 2007 15:34:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Adrian Bunk <bunk@stusta.de>
Cc: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: acpi_battery_add(): use-after-free
Message-Id: <20070730153420.317ae2ee.akpm@linux-foundation.org>
In-Reply-To: <20070729150046.GM16817@stusta.de>
References: <20070729150046.GM16817@stusta.de>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 Jul 2007 17:00:46 +0200
Adrian Bunk <bunk@stusta.de> wrote:

> The Coverity checker spotted the following use-after-free in 
> acpi_battery_add():
> 
> <--  snip  -->
> 
> ...
> static int acpi_battery_add(struct acpi_device *device)
> {
> ...
>         if (result) {
>                 acpi_battery_remove_fs(device);
>                 kfree(battery);
>         }
> 
>         mutex_unlock(&battery->mutex);
> ...
> 
> <--  snip  -->
> 

This?

--- a/drivers/acpi/battery.c~acpi_battery_add-use-after-free
+++ a/drivers/acpi/battery.c
@@ -931,13 +931,12 @@ static int acpi_battery_add(struct acpi_
 
       end:
 
+	mutex_unlock(&battery->mutex);
 	if (result) {
 		acpi_battery_remove_fs(device);
 		kfree(battery);
 	}
 
-	mutex_unlock(&battery->mutex);
-
 	return result;
 }
 
_

