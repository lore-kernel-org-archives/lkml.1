Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445AbZK1AaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbZK1AaG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 19:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZK1AaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 19:30:05 -0500
Received: from ey-out-2122.google.com ([74.125.78.27]:12070 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbZK1AaD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 19:30:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=mKpwv300k7JwRcChD/WyNKZZmI3QabQLJ1MN7E9ysY7exF5cUIm2aSIrqi3HaqIfOC
         0GDLMET/xbLOYCfOiSypk4clLLbIQCMd7LuUL+CRQ4yhYuwClGKR1Y9qT+qcblLXQq7S
         fEMV+DPx2icGTvNf6QEI9hxDqgx+aGymIgGk0=
MIME-Version: 1.0
Date: Sat, 28 Nov 2009 01:30:08 +0100
Message-ID: <b170af450911271630k63fb857auf8314cecd6219eba@mail.gmail.com>
Subject: Backlight device class redesign
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As discussed in http://marc.info/?t=124947671300008&r=1&w=2 we need to
redesign our backlight device class. If you wish you can read whole
thread and even http://bugs.freedesktop.org/show_bug.cgi?id=20963 but
I'll try to summarize everything anyway.

1) One display can be controlled (I mean backlight) in more than one
way. For example: ACPI, something platform-specific and GPU encoder.
2) Exporting many ways of controlling one display at the same time
drives us to inconsistencies.
3) We have to decide some priority like: ACPI > platform > GPU
4) We have to keep list of all registered controllers for one display.
We can not just unregister lower prioritised as we will hit problem
after (for example) unloading acpi module.
5) We should not export more than one way and let userspace decide.

Currently we keep all registered controllers in /sys/class/backlgiht/
without any grouping per display or per anything. We can not use
grouping per GPU (as somewhere proposed) because one GPU can control
(for example) two PANELS and TV - 3 displays needing backlight
management. The most obvious and stable solution seems to be grouping
per display.

So staying with idea of grouping per display I tried to imagine the
most crazy notebook with external displays configuration we should
handle. Let's consider following displays in notebook (yes, two
panel-notebook!):
1) PANEL#A controlled by ACPI + platform-specific + GPU
2) PANEL#B controlled by ACPI + platform-specific
3) TV connected by S-VIDEO controlled by GPU
4) LCD#A connected by USB controlled by LCD-specific driver
5) LCD#B connected by USB controlled by LCD-specific driver (same
model as LCD#A, driven by the same driver)

Let's do reverse order:
a) For two USB-LCDs driver should generate two other names. Depends on
properties received from LCD that could be serial number or usb port
number. So we would get /sys/class/lcd-vendor-0000:00:1d.2 and
/sys/class/lcd-vendor-0000:00:a3.5
b) For TV gpu kernel module would use name with GPU card number and
output name. Let's say /sys/class/card0-svideo
c) The most complicated case is for PANELs. We have to pick up same
names in: ACPI, platform-specific and GPU driver. For most cases,
which means notebooks with one panel, we could just use "panel".
However I do not want to redesign this after year when we get more
notebooks with two PANELs. So do you have any idea about this? How we
could generate correct names in 3 almost unrelated modules (ACPI,
platform, GPU driver)? We should end with something like
/sys/class/internal-panel-1 and /sys/class/internal-panel-2 but that
won't be so easy. Any ideas?

Please use "Reply to all", as I do cross-ML-post and I am not
subscribed to LKML.

-- 
Rafał
