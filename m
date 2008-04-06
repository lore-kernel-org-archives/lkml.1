Return-Path: <linux-kernel-owner+w=401wt.eu-S1755747AbYDFUWU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755747AbYDFUWU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2008 16:22:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752808AbYDFUWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Apr 2008 16:22:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50352 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730AbYDFUWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2008 16:22:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Nick Nobody" <me@nikosapi.org>
Subject: Re: Suspend on Lenovo 3000 V200 - Linux 2.6.25rc8
Date: Sun, 6 Apr 2008 22:21:57 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <3e8fd0440804052010xbe8f59bw3268d8206b97ac3e@mail.gmail.com>
In-Reply-To: <3e8fd0440804052010xbe8f59bw3268d8206b97ac3e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804062221.59011.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 6 of April 2008, Nick Nobody wrote:
> Hello,

Hi,

> I'm trying to get suspend working properly on my Lenovo 3000 V200. I'm
> using Linux 2.6.25rc8 and the latest xf86-video-intel. Before I was
> using kernel-2.6.23.15-137.fc8, xorg-x11-drv-i810-2.1.1-8.fc8 and
> suspend worked perfectly.
> 
> The laptop will go to sleep properly but it doesn't seem to enjoy
> waking up. When it starts up it will either display a black screen and
> remain frozen or I will end up at a virtual term login prompt but when
> I put in my username it never prompts me for my password.
> 
> The only way to get suspend working reasonably well is to first
> hibernate and then suspend. After a hibernation suspend seems to work
> fine :S
> 
> I'm a real noob when it comes to figuring out these sort of things, so
> any pointers on things I could try would be much appreciated.
> 
> Here's what s2ram has to say about my hardware:
> Machine is unknown.
> This machine can be identified by:
>     sys_vendor   = "LENOVO"
>     sys_product  = "07642CU"
>     sys_version  = "LENOVO3000 V200"
>     bios_version = "65ET32WW (1.06 )"
> 
> Here's the output of dmidecode: http://pastebin.ca/973442

Can you try to run "echo mem > /sys/power/state" instead of s2ram and see
if the symptoms are the same?

Also, please try reverting commit 7c0ea45be4f114d85ee35caeead8e1660699c46f
(reproduced below for conveninence) and see if that helps.

Thanks,
Rafael

---
commit 7c0ea45be4f114d85ee35caeead8e1660699c46f
Author: Zhao Yakui <yakui.zhao@intel.com>
Date:   Tue Mar 11 16:56:47 2008 +0800

    ACPI: Ignore _BQC object when registering backlight device
    
    According to acpi spec , the objects of  _BCL and _BCM are required if
    integrated LCD is present and supports brightness level .The _BQC is
    the optional object. So the _BQC object is ignored when the backlight device
    is registered in ACPI video driver.
    
    http://bugzilla.kernel.org/show_bug.cgi?id=10206
    
    Signed-off-by: Zhao Yakui <yakui.zhao@intel.com>
    Signed-off-by: Zhang Rui  <rui.zhang@intel.com>
    Signed-off-by: Len Brown <len.brown@intel.com>

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 12cce69..ace958c 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -713,7 +713,7 @@ static void acpi_video_device_find_cap(struct acpi_video_device *device)
 
 	kfree(obj);
 
-	if (device->cap._BCL && device->cap._BCM && device->cap._BQC && max_level > 0){
+	if (device->cap._BCL && device->cap._BCM && max_level > 0) {
 		int result;
 		static int count = 0;
 		char *name;
