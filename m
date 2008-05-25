Return-Path: <linux-kernel-owner+w=401wt.eu-S1762141AbYEYMHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762141AbYEYMHN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 08:07:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756737AbYEYMHB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 08:07:01 -0400
Received: from vs166246.vserver.de ([62.75.166.246]:46217 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948AbYEYMHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 08:07:00 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Date: Sun, 25 May 2008 14:05:05 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Johannes Berg <johannes@sipsolutions.net>,
       David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, aoliva@redhat.com,
       alan@lxorguk.ukuu.org.uk, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Takashi Iwai <tiwai@suse.de>
References: <1211550282.28967.8.camel@pmac.infradead.org> <1211707837.17151.14.camel@johannes.berg> <95BCF0F0-755A-4501-9B44-B421AD3E8F42@holtmann.org>
In-Reply-To: <95BCF0F0-755A-4501-9B44-B421AD3E8F42@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805251405.05684.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 25 May 2008 13:49:48 Marcel Holtmann wrote:
> Hi Johannes,
> 
> >> so using "/" within the name parameter for request_firmware() is
> >> actually forbidden. I know that some driver authers think it is a  
> >> good
> >> idea, but it is not.
> >
> > Can you explain why it is allowed now? And maybe why the API was
> > designed in a way that easily allows it?
> 
> in the early days we had something like three drivers using the  
> request_firmware() and it was understood between the authors what the  
> filename was meant for. And to be quite honest it was an oversight on  
> our side to not explicitly fail when the filename contains a "/". So  
> it happened that driver authors exploited the fact that they can group  
> firmware files under a subdirectory from within the kernel. Nobody  
> made the effort and proposed changes to udev.

There is absolutely _no_ reason to _fail_ on /
The only thing that make sense is:
Treat the firmware name in the kernel as an opaque key.
Userspace can then make policy decisions on that key.
The current policy decisions are to treat / as a directory separator.
(Which is a good thing, as it makes firmware development a lot easier).
That policy decision is a userspace decision made in udev.
Besides that it's ABI that should not be changed all the time.

> Personally I think it is fine to have _ALL_ firmware files in one  
> directory and not namespace them at all, but it seems that this is  
> important for some driver authors.

It is important, if you have to use several different versions of firmware
for one driver. If there are no directories, you'll have so use prefixes
and so on. That will make the firmware directory rather unmaintainable.
You can also move the directories easily around without using weird
sed scripts to rename the file prefixes. a simple mv will do.

> The kernel should not in any case have knowledge about directories or  
> subdirectories where the firmware files are stored. That is fully  
> irrelevant for the kernel.

I completely agree.
But: It should _also_ not enforce any "this and that char is forbidden"
rules.
If a database decides to use / as a separator, it's fine. If it doesn't,
it's also fine.
Currently we use / as a directory separator in udev. We shouldn't change
that for stable-ABI reasons.

If you want to create some other database (built-in into the kernel or whatever),
feel free to not specialcase the slash. That's perfectly fine and even makes
sense for built-in stuff.

> Especially with the case of built-in firmwares now, it because more  
> important to do it right. The one reason why we have to handover the  
> struct device to request_firmware() is that we can give the helper  
> script full access to the device and driver information of the caller.  
> Hence adding for example b43/ as prefix simply duplicates everything  
> since the struct device has a link to the driver that is requesting a  
> firmware file.

No it doesn't duplicate it.
in b43 we support postfixes. A module parameter can be used to
postfix a string to the directory name. So one can fetch firmware
from b43-test/ for testing purposes. This is needed for firmware development,
for example.

-- 
Greetings Michael.
