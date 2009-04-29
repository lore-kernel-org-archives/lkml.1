Return-Path: <linux-kernel-owner+w=401wt.eu-S1761153AbZD2RDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761153AbZD2RDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 13:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760412AbZD2RAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 13:00:33 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:26595 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760554AbZD2RAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 13:00:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GZ7XGnnyabZ9b04z61dsjAueSB8pCCk2lD3SWgpfIe0aJSKuTVQqBxlA++O0knTuih
         lATHPyUj2Tel08UQ1TAlleeguWpL8Bg+I6I+Nkr1HcwthANmU8qytF2z30j771KJG5FX
         nbOStFf5kh4ixnpZovY+gjz/Rq3Q3Wu1GF/WI=
MIME-Version: 1.0
In-Reply-To: <ac3eb2510904290330r563f3717ue72029cbe24b39bb@mail.gmail.com>
References: <ac3eb2510903290936tc80e904o2266108bd6c04cf2@mail.gmail.com>
	 <20090427172710.5a0c7f48@hyperion.delvare>
	 <437908170904271023k3eefd4c1ma0cacdb78ad7acd7@mail.gmail.com>
	 <20090428101020.0e4c2b0c@hyperion.delvare>
	 <20090428173929.GA5006@sysman-doug.us.dell.com>
	 <ac3eb2510904281046i6e9899acg89f7606da783f72c@mail.gmail.com>
	 <20090428215844.GA1396@sysman-doug.us.dell.com>
	 <ac3eb2510904281842i785ee135h98502522f242f3f6@mail.gmail.com>
	 <437908170904282019h6a10ef9dg594002e22842b366@mail.gmail.com>
	 <ac3eb2510904290330r563f3717ue72029cbe24b39bb@mail.gmail.com>
Date: Wed, 29 Apr 2009 12:00:29 -0500
X-Google-Sender-Auth: 31541f7bc36aa070
Message-ID: <437908170904291000s10fe6a92q8a595e0bbbd159a6@mail.gmail.com>
Subject: Re: Class device namespaces
From: Michael Brown <mebrown@michaels-house.net>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Doug Warzecha <Douglas_Warzecha@dell.com>,
       Jean Delvare <khali@linux-fr.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@infradead.org>,
       Matt Domsch <Matt_Domsch@dell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 29, 2009 at 5:30 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
>> Overall, the interface is pretty pathetic because it doesnt fit our
>> use case *at all*, but way back in the day that is what we had to do
>> to get it reviewed and approved for merge upstream. At least it is
>> better than the earlier versions where we had to do a separate
>> request_firmware() for every 4k packet (and spin waiting for files to
>> disappear/reappear)
>
> It handles huge files just fine, since the beginning. The space is
> realloced in the kernel. I have a modem which loads 200kb files since
> years.

Sorry, to be brief in my email I probably didnt give quite enough
info. There are two types of bios update: monolithic and packetized.
The monolithic mode requires *physically* contiguous memory below the
4GB boundary, usually 1MB worth. This is unbelievably hard to get
normally, and is almost definitely different from your modem upload
which almost certainly just needs a virtually contiguous 200kB.
Packetized mode lifts the physically-contiguous restriction and just
has to have page-aligned packets.

>
>> All this code is in libsmbios(*) if you want to see the ugly details,
>> but the short version is this:
>>
>> 1) we poke the image_type file and packet_size files with appropriate
>> data, which causes the driver to do a request firmware
>> 2) spin until request_firmware creates the files we need
>
> This is totally insane!

Yes, that was the point. :)

>
>> 2) loop over our file packet_size bytes at a time writing data into
>> the data file
>> 3) set loading to 0 when done
>>
>> *) src/python/libsmbios_c/rbu_update.py
>>
>> The code basically "packetizes" the bios update into page-sized chunks
>> with a header so BIOS can find them and reassemble them for the final
>> update.
>>
>> For older systems (monolithic mode), the kernel code has to allocate
>> physically contiguous region to hold the entire firmware image.
>
> Yeah, maybe you can not use the in-kernel firmware-request filled
> memory. But you can copy it just fine, once it is in the kernel. There
> is no reason to fiddle around with chunks here in userspace.

Pretty much describes exactly what dell_rbu does, except that the
in-kernel packetizing code was rejected on our first submission, so we
moved it into userspace.

> How do you make sure udev does not handle the request at the same
> time? This interface is not public at all, on a general system. As
> long as udev is active you can not use it at all. Udev will run at the
> same time and write to the same files, and even cancel the request if
> the requested file is not found. How does your software cope with
> that?

That is a very interesting question, as I've never seen udev do
anything to interfere with our process. We dont do anything special to
disable udev. Like I said above, we scribble some values to one file,
wait for the request_firmware() files to appear and write stuff to
them when they do. Udev hasnt ever tried to handle this that I have
seen, especially since we dont have any appropriate files sitting
around that udev would ever have access to in order to feed
request_firmware().
--
Michael
