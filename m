Return-Path: <linux-kernel-owner+w=401wt.eu-S1755417AbZD2DTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbZD2DTj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 23:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751847AbZD2DTa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 23:19:30 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:24137 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbZD2DT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 23:19:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=MHy2hewM1i9YCjxPajRKg2MZeia0TvlKRkwT4dVKQ1MdQSLD4QXXi/UAXQymxe4HB3
         oFYTpxogmeWpdgjeOoLmnTYwRu4U7+bVlUi+5XL0HLaCpgRxyGZ8flXlieGzHOXnel4o
         cKlkzBJr2SNrDrlbSA8DFcTumYjJqpmkNV1kk=
MIME-Version: 1.0
In-Reply-To: <ac3eb2510904281842i785ee135h98502522f242f3f6@mail.gmail.com>
References: <ac3eb2510903290936tc80e904o2266108bd6c04cf2@mail.gmail.com>
	 <20090426085401.3788fc9c@hyperion.delvare>
	 <20090427132041.GA18391@sc1430.michaels-house.net>
	 <20090427172710.5a0c7f48@hyperion.delvare>
	 <437908170904271023k3eefd4c1ma0cacdb78ad7acd7@mail.gmail.com>
	 <20090428101020.0e4c2b0c@hyperion.delvare>
	 <20090428173929.GA5006@sysman-doug.us.dell.com>
	 <ac3eb2510904281046i6e9899acg89f7606da783f72c@mail.gmail.com>
	 <20090428215844.GA1396@sysman-doug.us.dell.com>
	 <ac3eb2510904281842i785ee135h98502522f242f3f6@mail.gmail.com>
Date: Tue, 28 Apr 2009 22:19:28 -0500
X-Google-Sender-Auth: 2072421ca6d2b65f
Message-ID: <437908170904282019h6a10ef9dg594002e22842b366@mail.gmail.com>
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

On Tue, Apr 28, 2009 at 8:42 PM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Tue, Apr 28, 2009 at 23:58, Doug Warzecha <Douglas_Warzecha@dell.com> wrote:
>> On Tue, Apr 28, 2009 at 07:46:57PM +0200, Kay Sievers wrote:
>>> On Tue, Apr 28, 2009 at 19:39, Doug Warzecha <Douglas_Warzecha@dell.com> wrote:
>>>
>>> > /sys/class/firmware/dell_rbu/loading
>>> > /sys/class/firmware/dell_rbu/data
>>>
>>> These pathes only ever exist for a fraction of a second, during a
>>> kernel initiated firmware request. This request is usually only
>>> handled by the udev firmware loader script, and not interesting for
>>> anything else. Are you replacing the udev firmware script here? Are
>>> you sure you do something else here?
>>
>> A Dell library writes data to those paths when a Dell BIOS Update Package is run and requests the BIOS image to be loaded into memory.
>
> How do you do this? These paths exist for a short time only. How do
> you get udev out of your way handling the firmware request for you?
> How do you plug into the event processing with a custom tool?

Overall, the interface is pretty pathetic because it doesnt fit our
use case *at all*, but way back in the day that is what we had to do
to get it reviewed and approved for merge upstream. At least it is
better than the earlier versions where we had to do a separate
request_firmware() for every 4k packet (and spin waiting for files to
disappear/reappear)

All this code is in libsmbios(*) if you want to see the ugly details,
but the short version is this:

1) we poke the image_type file and packet_size files with appropriate
data, which causes the driver to do a request firmware
2) spin until request_firmware creates the files we need
2) loop over our file packet_size bytes at a time writing data into
the data file
3) set loading to 0 when done

*) src/python/libsmbios_c/rbu_update.py

The code basically "packetizes" the bios update into page-sized chunks
with a header so BIOS can find them and reassemble them for the final
update.

For older systems (monolithic mode), the kernel code has to allocate
physically contiguous region to hold the entire firmware image.
--
Michael
