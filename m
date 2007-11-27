Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbXK0J1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbXK0J1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 04:27:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753475AbXK0J1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 04:27:23 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:50220 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbXK0J1W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 04:27:22 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: kvm-devel@lists.sourceforge.net
Subject: Re: [kvm-devel] [PATCH 3/3] virtio PCI device
Date: Tue, 27 Nov 2007 10:25:59 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
References: <11944899922822-git-send-email-aliguori@us.ibm.com> <474B1BF3.20901@us.ibm.com> <474BDD28.7050801@qumranet.com>
In-Reply-To: <474BDD28.7050801@qumranet.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?iso-8859-1?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-1?q?Y=2Ea=5E3zb?=)
 =?iso-8859-1?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-1?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
Cc: Anthony Liguori <aliguori@us.ibm.com>,
       Eric Van Hensbergen <ericvanhensbergen@us.ibm.com>,
       kvm-devel@lists.sourceforge.net, lguest <lguest@ozlabs.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711271026.00084.arnd@arndb.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX1/UGLN10NoKqY0a8PxnplSu12IHjAmUBbtb49v
 Y8MZm7aEsQOyD38aNcJHO3dmnBlwIGfddGVayG9zHBQ0lgnKHn
 jk4NgEyKAX51t4gTVgI2w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 November 2007, Avi Kivity wrote:
> > :-)  Do you know if there is a hard limit on the number of devices on 
> > a PCI bus?  My concern was that it was limited by something stupid 
> > like an 8-bit identifier.
> 
> IIRC pci slots are 8-bit, but you can have multiple buses, so 
> effectively 16 bits of device address space (discounting functions which 
> are likely not hot-pluggable).

You have an 8 bit bus number and an 8 bit device/function number.
The function number is 3 bits, so if you want to use only function 0
for everything, you are limited to a little under 8192 (2^(8+5)) devices
per PCI domain. PC style hardware cannot easily address multiple PCI
domains, but I think you can have them if you assume that the guest is
using mmconfig.

For using multiple buses, the easiest way could be to have every
device/function on bus 0 be a bridge by itself, so you end up with a
flat number space for the actual devices,

$ lspci -t
 [0000:00]-+-00.0-[0000:01]--+-00.0
           |                 +-01.0
           |                 +-02.0
           |                 + ...
           |                 \-3f.0
           +-00.1-[0000:02]--+-00.0
           |                 +-01.0
           |                 +-02.0
           |                 + ...
           |                 \-3f.0
           + ...
           |
           +-3f.6-[0000:ff]--+-00.0
                             +-01.0
                             +-02.0
                             + ...
                             \-3f.0

	Arnd <><
