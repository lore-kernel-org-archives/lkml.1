Return-Path: <linux-kernel-owner+w=401wt.eu-S1755499AbZKMOvd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755499AbZKMOvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 09:51:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbZKMOv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 09:51:27 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:11973 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbZKMOv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 09:51:26 -0500
Message-ID: <4AFD726E.40101@natemccallum.com>
Date: Fri, 13 Nov 2009 09:51:26 -0500
From: Nathaniel McCallum <nathaniel@natemccallum.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH] Devices that ignore USB spec generate invalid modaliases
References: <4AFA73C7.4070002@natemccallum.com> <20091112234255.GA23889@kroah.com> <4AFCB1AE.6030200@natemccallum.com>
In-Reply-To: <4AFCB1AE.6030200@natemccallum.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/12/2009 08:09 PM, Nathaniel McCallum wrote:
> On 11/12/2009 06:42 PM, Greg KH wrote:
>> On Wed, Nov 11, 2009 at 03:20:23AM -0500, Nathaniel McCallum wrote:
>>> Please CC me as I'm not subscribed to LKML.
>>>
>>> The current code to generate usb modaliases from usb_device_id assumes
>>> that the device's bcdDevice descriptor will actually be in BCD format.
>>> While this should be a sane assumption, some devices don't follow spec
>>> and just use plain old hex. This causes drivers for these devices to
>>> generate invalid modalias lines which will never actually match for the
>>> hardware.
>>>
>>> The following patch adds hex support for bcdDevice in file2alias.c.
>>> Drivers for devices which have bcdDevice conforming to BCD will have no
>>> change in modalias output. Drivers for devices which don't conform
>>> (primarily usb-storage and ibmcam in my initial survey) should now
>>> generate valid modaliases.
>>>
>>> EXAMPLE OUTPUT (ibmcam; space added to highlight change)
>>> Old: usb:v0545p800D d030[10-9] dc*dsc*dp*ic*isc*ip*
>>> New: usb:v0545p800D d030a dc*dsc*dp*ic*isc*ip*
>>
>> Huh? The old one had '[]' in it?
>>
>> What does the bcdDevice for this really look like in the device itself?
>> If it is messed up in the descriptor, then how can we know to fix it up
>> here?
>
> The device contains 0x030A (an invalid value since 0x0309 + 1 == 0x0310
> in BCD format) in the bcdDevice descriptor. The driver matches against
> this descriptor (see the usb_device_id table in
> drivers/media/video/usbvideo/ibmcam.c).
>
> There are three possible solutions:
> 1. Fix the ibmcam driver not to match against bcdDevice. I'm not sure if
> this is possible. Nor does it solve the problem for future devices which
> may be misprogrammed.
> 2. Change *all* usb modaliases to be generated assuming hex ranges. This
> makes file2alias.c a little simpler at the cost of changing a large
> number of existing modaliases. The impact of this change is potentially
> large.
> 3. My solution, which is to detect if either bcdDevice_lo or
> bcdDevice_hi is in hexadecimal rather than BCD format. We do this by
> checking each character to see if it is above 0x9. If either of these
> fields is in hex format, we switch into hex mode and render the modalias
> appropriately. This also has some potential impact on userspace tools,
> however, since currently the only modalias that is affected is ibmcam,
> the change is measurably small in impact.
>
> The second bug (related here: http://lkml.org/lkml/2009/11/11/245) is
> just simply a bug in the modalias generation code. Namely, 0x59 + 1 ==
> 0x60 in BCD format, not 0x5A. Therefore, you cannot rely on i++ to
> increment. Fixing it has no impact other than fixing a broken modalias
> (which occurs in usb-storage).

Just in case it is helpful, here is a diff between the old modules.alias 
and the new modules.alias generated with my patches applied.  The 
usb_storage line is fixed by the increment patch.  The ibmcam lines are 
fixed by the bcd/hex patch.

--- modules.alias.old   2009-11-13 09:46:36.191640578 -0500
+++ modules.alias.fixed 2009-11-13 09:46:36.549891821 -0500
@@ -345,7 +345,6 @@
  alias usb:v041Ep4064d*dc*dsc*dp*ic*isc*ip* gspca_ov519
  alias usb:v041Ep4068d*dc*dsc*dp*ic*isc*ip* gspca_ov519
  alias usb:v0420p0001d0100dc*dsc*dp*ic*isc*ip* usb_storage
-alias usb:v0421p0019d05[10-9]*dc*dsc*dp*ic*isc*ip* usb_storage
  alias usb:v0421p0019d059[2-9]dc*dsc*dp*ic*isc*ip* usb_storage
  alias usb:v0421p0019d060*dc*dsc*dp*ic*isc*ip* usb_storage
  alias usb:v0421p0019d0610dc*dsc*dp*ic*isc*ip* usb_storage
@@ -1021,12 +1020,12 @@
  alias usb:v0543p1921d*dc*dsc*dp*ic*isc*ip* ipaq
  alias usb:v0543p1922d*dc*dsc*dp*ic*isc*ip* ipaq
  alias usb:v0543p1923d*dc*dsc*dp*ic*isc*ip* ipaq
-alias usb:v0545p8002d030[10-9]dc*dsc*dp*ic*isc*ip* ibmcam
-alias usb:v0545p800Cd030[10-9]dc*dsc*dp*ic*isc*ip* ibmcam
-alias usb:v0545p800Dd030[10-9]dc*dsc*dp*ic*isc*ip* ibmcam
+alias usb:v0545p8002d030Adc*dsc*dp*ic*isc*ip* ibmcam
+alias usb:v0545p800Cd030Adc*dsc*dp*ic*isc*ip* ibmcam
+alias usb:v0545p800Dd030Adc*dsc*dp*ic*isc*ip* ibmcam
  alias usb:v0545p8080d0002dc*dsc*dp*ic*isc*ip* ibmcam
-alias usb:v0545p8080d030[10-9]dc*dsc*dp*ic*isc*ip* ibmcam
  alias usb:v0545p8080d0301dc*dsc*dp*ic*isc*ip* ibmcam
+alias usb:v0545p8080d030Adc*dsc*dp*ic*isc*ip* ibmcam
  alias usb:v0545p808Bd*dc*dsc*dp*ic*isc*ip* gspca_tv8532
  alias usb:v0545p8333d*dc*dsc*dp*ic*isc*ip* gspca_tv8532
  alias usb:v0546p3155d*dc*dsc*dp*ic*isc*ip* gspca_sunplus
