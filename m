Return-Path: <linux-kernel-owner+w=401wt.eu-S1755483AbZJAQkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483AbZJAQkK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 12:40:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754758AbZJAQkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 12:40:09 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:49107 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbZJAQkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 12:40:08 -0400
Message-ID: <4AC4DB65.8070404@natemccallum.com>
Date: Thu, 01 Oct 2009 12:40:05 -0400
From: Nathaniel McCallum <nathaniel@natemccallum.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: greg@kroah.com
Subject: Exposing device ids and driver names
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please CC me on any responses as I'm not subscribed to lkml.

I have the aim at creating two tools helpful to linux.  The first tool 
is a driver regression test of sorts.  I want to be able to create 
essentially a time line of hardware support as they appear in distros. 
The second tool, related to the first, is a program which runs on 
Windows and scans for a user's hardware and tells them which distro will 
best support their hardware.  I already have a working prototype of 
these two tools.  It currently uses the data exported by modinfo.  This 
however does not provide transparency for drivers compiled into the kernel.

Thus, my requirements are as follows.  I need to be able to gather the 
*_device_id tables and driver names from the kernel by scanning the 
kernel/module binaries.  The implementation should be careful not to 
expand memory footprint if at all possible and should seek to expose 
only stable structures to userspace.

Further, I have the limitation that symbol names are unhelpful since 
they are stripped out of the kernel.

My initial investigation has led me to one of two methods (though I am 
certainly open to other suggestions).  Since symbols are most often 
stripped from the kernel, I have largely focused my investigation on 
using ELF sections.

The first method is to expand the MODULE_DEVICE_TABLE() macro to do 
something for built in modules (such as the following):
#define MODULE_DEVICE_TABLE(type, name)                        \
   static const struct type##_device_id *__##name##_dev_tbl     \
     __used __section(.dev.ids.##type)

This has the advantage of being an extremely small change to the kernel 
and being easy to parse out of the binaries.  The disadvantages are that 
it adds a pointer for each device table (expanding memory footprint) and 
does not provide the name of the driver which will be loaded for that 
table (making it hard to track when a driver moves in/out of the kernel 
to/from a module).

The second method is to create a macro for *_driver struct definitions 
(similar to DEFINE_PCI_DEVICE_TABLE() in include/linux/pci.h).  Perhaps 
something like this:
#define DEFINE_DRIVER(type, name) \
   static struct type##_driver name __section(.drv.##type)

The advantages of this method are minimal memory footprint increase 
(only the size of the ELF section header and name) and easy parsing of 
both the driver name and the type##_device_id struct.  The disadvantages 
are that every driver will have to be updated to use the new macro 
(which can probably be done programatically) and that *_driver structs 
have now become part of the kernel ABI (I'm not sure how bad this is). 
I also ran into a wierd problem where the *_driver structs are zeroed 
when built into modules, but I'm not sure what causes that (it wasn't my 
patch).

Which method is preferable? Any other suggestions?

Thanks for your help,
Nathaniel
