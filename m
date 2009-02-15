Return-Path: <linux-kernel-owner+w=401wt.eu-S1755873AbZBOT7r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873AbZBOT7r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Feb 2009 14:59:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751325AbZBOT7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Feb 2009 14:59:37 -0500
Received: from acsinet11.oracle.com ([141.146.126.233]:43018 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbZBOT7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Feb 2009 14:59:36 -0500
Message-ID: <49987418.40606@oracle.com>
Date: Sun, 15 Feb 2009 11:59:20 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@skynet.be>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [PATCH] UVC: uvc_status_cleanup(): undefined reference to `input_unregister_device'
References: <20090208145835.GA1649@elte.hu> <200902111247.39922.laurent.pinchart@skynet.be> <20090211105600.32eefe7b@pedra.chehab.org> <200902150119.48355.laurent.pinchart@skynet.be>
In-Reply-To: <200902150119.48355.laurent.pinchart@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt700.oracle.com [141.146.40.70]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.499873F1.00D9:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Pinchart wrote:
> Hi Mauro,
> 
> On Wednesday 11 February 2009 13:56:00 Mauro Carvalho Chehab wrote:
>> On Wed, 11 Feb 2009 12:47:39 +0100
>>
>> Laurent Pinchart <laurent.pinchart@skynet.be> wrote:
>>> Hi Mauro,
>>>
>>> On Wednesday 11 February 2009 09:29:33 Mauro Carvalho Chehab wrote:
> [snip]
>>> That's even worse. The following configurations would then be valid
>>>
>>> INPUT = m/y
>>> USB_VIDEO_CLASS = n
>>> USB_VIDEO_CLASS_INPUT_EVDEV = m/y
>>>
>>> USB_VIDEO_CLASS_INPUT_EVDEV must depend on USB_VIDEO_CLASS to be
>>> displayed as a child of USB_VIDEO_CLASS in the configuration menu.
>> USB_VIDEO_CLASS_INPUT_EVDEV can't be m, since it is bool.
> 
> Oops, sorry, my bad.
> 
>> But, you're right: we'll loose the dependency of USB_VIDEO_CLASS_INPUT_EVDEV 
>> and USB_VIDEO_CLASS.
>>
>> There's another alternative, if we consider that all systems but a few
>> embedded ones have input defined.
>>
>> We may do something like:
>>
>> diff --git a/drivers/media/video/uvc/Kconfig
>> b/drivers/media/video/uvc/Kconfig index c2d9760..14e7537 100644 ---
>> a/drivers/media/video/uvc/Kconfig
>> +++ b/drivers/media/video/uvc/Kconfig
>> @@ -1,5 +1,6 @@
>>  config USB_VIDEO_CLASS
>>  	tristate "USB Video Class (UVC)"
>> +	depends on INPUT
>>  	---help---
>>  	  Support for the USB Video Class (UVC).  Currently only video
>>  	  input devices, such as webcams, are supported.
>>
>> I suspect that this will work fine for all practical usages.
> 
> Then we could as well remove the USB_VIDEO_CLASS_INPUT_EVDEV option. Its sole 
> purpose was to remove the hard dependency of USB_VIDEO_CLASS on INPUT.
> 
>> Another option would be to have a generic option at V4L for evdev
>> interfaces (config MEDIA_EVDEV), that is independent of uvc (the same kind
>> of dependency exists on other drivers at the subsystem, like cx88, saa7134,
>> etc). It will be a larger changeset, but maybe useful, since someone may
>> disable EVDEV interface for other V4L/DVB drivers as well.
> 
> What I need here is a way to express the following in Kconfig:
> 
> - USB_VIDEO_CLASS_INPUT_EVDEV is a boolean sub-option of USB_VIDEO_CLASS
> - It can only be selected if the USB_VIDEO_CLASS and INPUT options "match"
> - Ideally, the options should always be visible (otherwise people would only 
> notice the option if INPUT support is enabled), but should not be selectable 
> if USB_VIDEO_CLASS and INPUT don't match.
> 
> Is this possible ?

This should allow INPUT=y or USB_VIDEO_CLASS=INPUT, i.e., they don't always
have to match, in the case where INPUT=y and UVC=m (same problem exists
with pwc in -mm & linux-next, btw.  PWC patch follows this one.).



From: Randy Dunlap <randy.dunlap@oracle.com>

Fix build errors when USB_VIDEO_CLASS=y and INPUT=m.
Fixes kernel bugzilla #12671.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 drivers/media/video/uvc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm-2009-0214-0049.orig/drivers/media/video/uvc/Kconfig
+++ mmotm-2009-0214-0049/drivers/media/video/uvc/Kconfig
@@ -9,7 +9,7 @@ config USB_VIDEO_CLASS
 config USB_VIDEO_CLASS_INPUT_EVDEV
 	bool "UVC input events device support"
 	default y
-	depends on USB_VIDEO_CLASS && INPUT
+	depends on USB_VIDEO_CLASS=INPUT || INPUT=y
 	---help---
 	  This option makes USB Video Class devices register an input device
 	  to report button events.
