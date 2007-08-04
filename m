Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbXHDFXL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbXHDFXL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 01:23:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbXHDFW6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 01:22:58 -0400
Received: from dsl081-033-126.lax1.dsl.speakeasy.net ([64.81.33.126]:59610
	"EHLO bifrost.lang.hm" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752873AbXHDFW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 01:22:57 -0400
Date: Fri, 3 Aug 2007 22:21:15 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Javier Pello <javier.pello@urjc.es>
cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] request_firmware: skip timeout if userspace was not 
 notified
In-Reply-To: <46B37CF7.2020803@urjc.es>
Message-ID: <Pine.LNX.4.64.0708032219230.6905@asgard.lang.hm>
References: <46B37CF7.2020803@urjc.es>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Aug 2007, Javier Pello wrote:

> Hi,
>
> I have prepared a patch that makes request_firmware skip the usual
> grace period that it gives firmware images to show up, if it determines
> that userspace was not notified at all.
>
> When request_firmware is called, it sends an event to userspace to
> ask for the firmware image that is needed, and then it installs a
> timeout so that it will not wait forever for the image. However,
> if userspace did not receive the event at all (no /sbin/hotplug,
> for instance), then having the kernel wait is pointless. This is
> particularly true during boot, when the wait is done synchronously
> and the whole kernel freezes for a minute.
>
> The attached patch fixes this by making _request_firmware check whether
> the firmware loading event was succesfully sent to userspace, and skip
> the timeout if it has not. The patch comes in two parts:
>
> 1. The first part changes kobject_uevent_env in lib/kobject_uevent.c
> to report a failure if both netlink_broadcast (if applicable) and
> call_usermodehelper fail to send the event to userspace. Nothing in
> the kernel seems to care about the return value of kobject_uevent_env,
> so this should not break anything.
>
> 2. The second part changes _request_firmware in
> drivers/base/firmware_class.c to actually check the return value of
> kobject_uevent and skip the loading_timeout delay if the loading event
> was not delivered to userspace at all.
>
> The patches apply cleanly against 2.6.23-rc1. Any suggestions or feedback
> will be welcome.
>
> Javier
>
> PS  Please CC: me on replies, as I am not subscribed to the list.

I've been told that it's possible to have the kernel pull the firmware off 
of an initrd (or was it initramfs, I keep confusing the two) without 
having any userspace, just put the right file in the right place 
(unfortunantly I've never gotten around to testing this) will this patch 
break this feature?

David Lang
