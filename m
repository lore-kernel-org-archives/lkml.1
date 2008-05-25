Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbYEYNM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbYEYNM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 09:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751156AbYEYNMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 09:12:50 -0400
Received: from senator.holtmann.net ([87.106.208.187]:49518 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbYEYNMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 09:12:49 -0400
Cc: David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, aoliva@redhat.com,
       alan@lxorguk.ukuu.org.uk, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Takashi Iwai <tiwai@suse.de>,
       Michael Buesch <mb@bu3sch.de>
Message-Id: <54EDAF0A-907B-46D0-925E-56ADDA37E106@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1211716784.17151.19.camel@johannes.berg>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Date: Sun, 25 May 2008 15:12:43 +0200
References: <1211550282.28967.8.camel@pmac.infradead.org> <1211550374.28967.10.camel@pmac.infradead.org> <20080523164108.GA31545@uranus.ravnborg.org> <1211640377.540.14.camel@pmac.infradead.org> <20080524152214.GA12582@uranus.ravnborg.org> <1211642706.31212.85.camel@shinybook.infradead.org> <1211643245.31212.88.camel@shinybook.infradead.org> <D56F641E-9FDB-48E5-AF0B-B8E84B08504A@holtmann.org> <1211707837.17151.14.camel@johannes.berg> <95BCF0F0-755A-4501-9B44-B421AD3E8F42@holtmann.org> <1211716784.17151.19.camel@johannes.berg>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

>> The kernel should not in any case have knowledge about directories or
>> subdirectories where the firmware files are stored. That is fully
>> irrelevant for the kernel.
>
> Exactly my point! Hence, the kernel just gives it an arbitrary name.  
> The
> fact that userspace uses this as a filename could be regarded as a  
> bug,
> but it works fine. Therefore, the kernel simply assigns an arbitrary,
> NULL-terminated string as the name. It happens to include a /  
> because it
> is convenient with the current userspace implementation, but that's  
> mere
> detail, the ABI/API here is to allow any arbitrary names.
>
>> Especially with the case of built-in firmwares now, it because more
>> important to do it right. The one reason why we have to handover the
>> struct device to request_firmware() is that we can give the helper
>> script full access to the device and driver information of the  
>> caller.
>> Hence adding for example b43/ as prefix simply duplicates everything
>> since the struct device has a link to the driver that is requesting a
>> firmware file.
>
> But that doesn't matter at all! Dave's work to build firmware files  
> into
> the kernel will simply result in an entry in the kernel firmware table
> that has a '.name = "b43/pcm5.fw"', nothing needs to know that b43  
> is a
> module name, in fact, it could very well be 'broadcom wlan/pcm5.fw' as
> well.
>
>> That is not what I am proposing. What I am proposing is that we do
>> this the right way. Meaning that we fix udev to do the namespacing. I
>> am working on a way to have this change in a backward compatible way.
>
> That will introduce a "flag-day" where you have to upgrade userspace
> with the kernel, and vice versa, OR userspace will have to guess.  
> Not a
> good solution either.

not it does not. I have a fix for udev that will allow a smooth  
transition and keep full backward compatibility. Need to do some more  
testing.

And bumping the required udev version after 12 month is perfectly fine  
since we have the future removal document.

> Why are you so fixated on special-casing the single character '/'?

It is not the "/" character. It is the directory separator. Just  
happened to be "/" on Unix operating systems. You are really missing  
my point here. The kernel should not be involved in enforcing this  
kind of namespaces.

Look at the device nodes. The kernel has mouse0 for example and udev  
will translate this into /dev/input/mouse0. Nobody expects the kernel  
to use input/mouse0 and actually you even can't do that at all since  
the device model forbids "/" as bus id. Same applies for the firmware  
filenames.

Also at some point we might change the actual implementation of  
request_firmware() to allow running multiple request_firmware() at the  
same time to improve the init time of devices (if that makes sense).  
In that case the filename would become a kobject and then the  
directory separator would become illegal.

Regards

Marcel

