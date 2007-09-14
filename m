Return-Path: <linux-kernel-owner+w=401wt.eu-S1756502AbXINKfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502AbXINKfx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 06:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752385AbXINKfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 06:35:45 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:64514 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbXINKfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 06:35:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=elannB18rajnLGgeZaaeoHTAebXuPV9r0mlsU+QfmWSM7QfZ6T9eRp7Al8TnQraFd6S5FciDmapmYbsJ5gPIedH+LeIxGvwGt+IcDz7/3AOWmzf7AN6KYv3zLvYeqDyYti9rpYUagrLGbLGOASAmJAAJYc7EFC2YheibbDHaTl0=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: tapio.laxstrom@iptime.fi
Subject: drivers/usb/misc/emi*.c have the biggest data objects in the whole tree
Date: Fri, 14 Sep 2007 11:35:34 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709141135.35239.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tapio,

You are the author of these files. Are you still maintaining them?
If not, do you know who is the current maintainer?

These two object files hold the biggest data objects in the whole Linux kernel
after lockdep:

   text    data     bss     dec     hex filename
   1258  160516       0  161774   277ee ./drivers/usb/misc/emi26.o
   1504  209296       0  210800   33770 ./drivers/usb/misc/emi62.o

Basically, these are big arrays of the following structures:

typedef struct _INTEL_HEX_RECORD
{
        __u32   length;
        __u32   address;
        __u32   type;
        __u8    data[MAX_INTEL_HEX_RECORD_LENGTH];
} INTEL_HEX_RECORD;

I suggest the following optimizations:

Change structure to

typedef struct _INTEL_HEX_RECORD
{
        __u8   type;
        __u8   length;
        __u16   address;
        __u8    data[MAX_INTEL_HEX_RECORD_LENGTH];
} INTEL_HEX_RECORD __attribute__((__packed__));

Store gzip compressed tables and unpack them at load time.

Declare them const and __initdata.

I can do it if there is no active maintainer.
--
vda
