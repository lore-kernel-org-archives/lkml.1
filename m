Return-Path: <linux-kernel-owner+w=401wt.eu-S1757532AbYEYLuU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757532AbYEYLuU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 07:50:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760862AbYEYLuD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 07:50:03 -0400
Received: from senator.holtmann.net ([87.106.208.187]:56088 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760810AbYEYLtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 07:49:53 -0400
Cc: David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org, aoliva@redhat.com,
       alan@lxorguk.ukuu.org.uk, Abhay Salunke <Abhay_Salunke@dell.com>,
       kay.sievers@vrfy.org, Takashi Iwai <tiwai@suse.de>,
       Michael Buesch <mb@bu3sch.de>
Message-Id: <95BCF0F0-755A-4501-9B44-B421AD3E8F42@holtmann.org>
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1211707837.17151.14.camel@johannes.berg>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: [PATCH 2/3] firmware: Add CONFIG_BUILTIN_FIRMWARE option
Date: Sun, 25 May 2008 13:49:48 +0200
References: <1211550282.28967.8.camel@pmac.infradead.org> <1211550374.28967.10.camel@pmac.infradead.org> <20080523164108.GA31545@uranus.ravnborg.org> <1211640377.540.14.camel@pmac.infradead.org> <20080524152214.GA12582@uranus.ravnborg.org> <1211642706.31212.85.camel@shinybook.infradead.org> <1211643245.31212.88.camel@shinybook.infradead.org> <D56F641E-9FDB-48E5-AF0B-B8E84B08504A@holtmann.org> <1211707837.17151.14.camel@johannes.berg>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Johannes,

>> so using "/" within the name parameter for request_firmware() is
>> actually forbidden. I know that some driver authers think it is a  
>> good
>> idea, but it is not.
>
> Can you explain why it is allowed now? And maybe why the API was
> designed in a way that easily allows it?

in the early days we had something like three drivers using the  
request_firmware() and it was understood between the authors what the  
filename was meant for. And to be quite honest it was an oversight on  
our side to not explicitly fail when the filename contains a "/". So  
it happened that driver authors exploited the fact that they can group  
firmware files under a subdirectory from within the kernel. Nobody  
made the effort and proposed changes to udev.

Personally I think it is fine to have _ALL_ firmware files in one  
directory and not namespace them at all, but it seems that this is  
important for some driver authors.

>> I explained this a couple of times. The request_firmware() is an
>> abstract mechanism that can request a firmware file. The location of
>> the firmware file is up to the userspace. The kernel requests a
>> particular file and that is it. All namespacing has to be done by the
>> firmware helper script (nowadays udev). That the current
>> implementation of the firmware helper maps the filename 1:1 to a file
>> under /lib/firmware/ just works, but doesn't have to work all the
>> time. It is not the agreed contract between kernel and userspace.
>
> I don't buy this argument. I could agree if you said that the "agreed
> contract" between the kernel and userspace is for the kernel to  
> request
> a firmware file /keyed by an arbitrary, null-terminated string/.
>
> The fact that it is usually stored on a filesystem where / means a
> directory (and thus grouping) can be seen as a nice convenience of the
> filesystem storage, but if firmware was stored elsewhere then you  
> could
> degrade to the simple key-based lookup that happens to allow "/" as a
> character in the keys.

The kernel should not in any case have knowledge about directories or  
subdirectories where the firmware files are stored. That is fully  
irrelevant for the kernel.

Especially with the case of built-in firmwares now, it because more  
important to do it right. The one reason why we have to handover the  
struct device to request_firmware() is that we can give the helper  
script full access to the device and driver information of the caller.  
Hence adding for example b43/ as prefix simply duplicates everything  
since the struct device has a link to the driver that is requesting a  
firmware file.

> b43 comes with 22 firmware files for a single driver, and groups them
> using "b43/<name>". What you're proposing will make firmware fail
> *again* for all users, and we got a *LOT* of flak from all kinds of
> stakeholders (not just the users) when firmware upgrades were  
> required,
> doing it again for such a petty reason is ridiculous.

That is not what I am proposing. What I am proposing is that we do  
this the right way. Meaning that we fix udev to do the namespacing. I  
am working on a way to have this change in a backward compatible way.

Regards

Marcel

