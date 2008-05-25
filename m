Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbYEYSYF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbYEYSYF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 14:24:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbYEYSXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 14:23:54 -0400
Received: from senator.holtmann.net ([87.106.208.187]:52729 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755974AbYEYSXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 14:23:53 -0400
Cc: Michael Buesch <mb@bu3sch.de>, David Woodhouse <dwmw2@infradead.org>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org,
       aoliva@redhat.com, alan@lxorguk.ukuu.org.uk,
       Abhay Salunke <Abhay_Salunke@dell.com>, kay.sievers@vrfy.org,
       Takashi Iwai <tiwai@suse.de>
Message-Id: <41FE0259-522B-4B9B-A75D-7B97A9FD723F@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1211724803.17151.36.camel@johannes.berg>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Date: Sun, 25 May 2008 20:23:46 +0200
References: <1211550282.28967.8.camel@pmac.infradead.org> <1211707837.17151.14.camel@johannes.berg> <95BCF0F0-755A-4501-9B44-B421AD3E8F42@holtmann.org> <200805251405.05684.mb@bu3sch.de> <09817CD9-2158-4EC3-8AB4-17BBAF34A8DA@holtmann.org> <1211724803.17151.36.camel@johannes.berg>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,


>> No it is not. The kobject doesn't allow "/" and why should
>> request_firmware() be an exception. Also see my other comment on how
>> the kernel handles device nodes and on how udev maps them to real
>> device nodes on the filesystem.
>
> As I said, kobjects have nothing to do with it, they don't need to  
> have
> a filename based on the firmware key.

our current usage is suboptimal and we should use kobjects for  
representing the loading entity. Please keep in mind that when we  
created request_firmware() most of the driver model developers still  
thought that having class devices was a good idea. That has changed  
and to represent firmware loading in a clean and race free environment  
where you could load multipl firmwares at the same time for the same  
driver, we need changes here.

>> And again. This is up to the userspace to handle and not the kernel.
>> In userspace you could do a general approach to support these kind of
>> testing, but you decide to only do this for your driver. You are  
>> fully
>> exploiting the request_firmware() interface and making any kind of
>> userspace policy impossible. This in return actually means that if we
>> would improve the request_firmware(), we have to maintain special
>> cases for the b43 drivers, because your driver does some hacking of
>> firmware files inside the kernel. You actually proved my point that  
>> we
>> should not allow this inside the kernel.
>
> That makes no sense at all.
>
> Michael is exploiting the firmware API that you are suggesting to
> change, and so far I don't see a technical reason for changing it. In
> kernel space, he's simply requesting varying firmware blobs based on
> different keys, which happen to be "b43%s/%s" because that's making
> things simpler for him on the other end.
>
> On the other hand, you're saying that we have all kinds of policy  
> about
> this in userspace, so why are you saying that directory separators
> (slashes, but you seem to distinguish those on some level I do not
> understand) should be special in the firmware key?
>
> The firmware key is just that, a *key*. It's only exposed to userspace
> via an environment variable in a kobject named
> "/devices/pci0001:10/0001:10:12.0/ssb0:0/firmware/ssb0:0" or similar.
>
> The fact that userspace uses the key as a filename is maybe  
> unfortunate,
> maybe fortunate, but shouldn't have anything to do with what sort of
> keys the kernel allows.

I disagree with you. The kernel should be free of these kind of  
subdirectory stuff. We saw devfs failing and we have a flat device  
node names in the kernel. Why do we have to duplicate information in  
the firmware filenames where we have all the information already  
present in the driver model. The reason that people are lazy doesn't  
work for me.

> Also, you said above (quoting again):
>
>> You are fully
>> exploiting the request_firmware() interface and making any kind of
>> userspace policy impossible.
>
> That's not true at all. If you decide that the userspace policy should
> be to load $modulename/$firmwarekey then you'd maybe have something
> like /lib/firmware/b43/b43-test/ucode5.fw
> and /lib/firmware/b43/b43-osfw/ucode5.fw
> and /lib/firmware/b43/b43/ucode5.fw, this doesn't preclude the use.
>
> Now, if it had been like that from the beginning, Michael probably
> wouldn't have used the string "b43" (or "b43-*") but rather requested
> "broadcom/ucode5.fw" by default and "osfw/ucode5.fw" for the open  
> source
> firmware, but since it's just a key that doesn't matter.

That something works at the moment is not a reason for me not to fix  
it and improve the current framework around firmware loading. I have  
been a lot of times saying that the request_firmware() should not  
include "/" in the filename and driver authors followed it. Some of  
them did it anyway and so these need fixing now.

Regards

Marcel

