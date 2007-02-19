Return-Path: <linux-kernel-owner+w=401wt.eu-S932099AbXBSGFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099AbXBSGFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 01:05:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932107AbXBSGFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 01:05:33 -0500
Received: from gateway.insightbb.com ([74.128.0.19]:9640 "EHLO
	asav05.insightbb.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099AbXBSGFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 01:05:32 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoXANrM2EVKhRO4UGdsb2JhbACHQ4dLAQEqkj0BAQE
From: Dmitry Torokhov <dtor@insightbb.com>
To: Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH] platform: reorder platform_device_del
Date: Mon, 19 Feb 2007 01:05:30 -0500
User-Agent: KMail/1.9.3
Cc: Greg Kroah-Hartman <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>
References: <20070218213020.5618eb98.khali@linux-fr.org>
In-Reply-To: <20070218213020.5618eb98.khali@linux-fr.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702190105.31051.dtor@insightbb.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jean,

On Sunday 18 February 2007 15:30, Jean Delvare wrote:
> In platform_device_del(), we currently delete the device resources
> first, then we delete the device itself. This causes a (minor) bug to
> occur when one unregisters a platform device before unregistering its
> platform driver, and the driver is requesting (in .probe()) and
> releasing (in .remove()) a resource of the device. The device
> resources are already gone by the time the driver gets the chance to
> release the resources it had been requesting, causing an error like:
> Trying to free nonexistent resource <0000000000000295-0000000000000296>
> 
> If the platform driver is unregistered first, the problem doesn't
> occur, as the driver will have the opportunity to release the
> resources it had requested before the device resources themselves are
> released. It's a bit odd that unregistering the driver first or the
> device first doesn't lead to the same result.

I am not sure that this is correct argument. Why does a driver request
and release device's resources? "Higher power" has already requested 
these resources for the device and this is not drivers task to free
them. However you are right that we should not free resources until
device is marked for deletion and driver's ->remove() method completes
but I would not rely on surrounding code for keeping an extra reference
and would just take one explicitely in platform_device_del().

-- 
Dmitry
