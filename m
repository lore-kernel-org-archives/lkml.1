Return-Path: <linux-kernel-owner+w=401wt.eu-S1945964AbXDCVw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945964AbXDCVw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 17:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945994AbXDCVw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 17:52:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:52802 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945964AbXDCVwz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 17:52:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Subject: Re: A set of "standard" virtual devices?
Date: Tue, 3 Apr 2007 23:51:16 +0200
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       Andi Kleen <ak@suse.de>, Christian Borntraeger <borntrae@de.ibm.com>,
       virtualization@lists.linux-foundation.org,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mathiasen@gmail.com
References: <4611652F.700@zytor.com> <4612B303.5000109@zytor.com> <4612C077.60502@goop.org>
In-Reply-To: <4612C077.60502@goop.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200704032351.17823.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+ajq0avkDc1oUYLqSR37Y2g1bJQL5shEKfvmS
 KDDe/8YluLMj8fVejH7yk67V6316M/MYFz9XBSjVQTX0pzo5pZ
 X2PiM3+X7U5SgPoECRgSA==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 03 April 2007, Jeremy Fitzhardinge wrote:
> That said, something like USB is probably the best bet for this kind of
> low-performance device.  I think.  Not that I really know anything about
> USB.

USB has the disadvantage that it is more complex than PCI and requires
significantly more code to simulate on the host side.

On the plus side, I think it should be possible to implement a virtual
USB host on s390, which is not possible with PCI, but that again takes
a lot of work to implement.

One interesting aspect of the PS3 hypervisor is that some of the
low-speed interfaces are implemented as a virtual UART, meaning
something that only has read and write operations and uses an
interrupt for flow control. The implementation in 
drivers/ps3/vuart.c is probably more complex than what we want
as a generic transport mechanism, but simply having a bidirectional
data stream sounds like an ideal abstraction for the "simple"
case. Some more or less obvious users of this include:

- console
- additional tty
- random
- slow network (using ppp)
- printer
- watchdog
- hid (e.g. mouse)
- system management (like ps3)
- fast network (in combination with
  shared memory segment)

The transport can be hypervisor specific, e.g. there could be
a virtual PCI serial port on kvm, an hcall interface on the ps3
and a virtual CTC on s390 (kidding), while all of them can have
the same kind of hardware _behind_ the serial connection.

	Arnd <><
