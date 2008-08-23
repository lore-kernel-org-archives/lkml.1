Return-Path: <linux-kernel-owner+w=401wt.eu-S1753855AbYHWDzB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855AbYHWDzB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 23:55:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752138AbYHWDyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 23:54:53 -0400
Received: from py-out-1112.google.com ([64.233.166.182]:6499 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751978AbYHWDyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 23:54:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=KlrBwoHMt/rA4q5xXW/hHHU0MP6ixLQU5h5YWvwaRg0fD4ZYZCOFahhmC7Gowvt8SL
         y+RDBXppmIqPce0PldqBGW5nty1GBizMB3vYeRqdMX+dsWoqNaCnE8FRNU8qv4dz4TVa
         Q/580w2d8SkpCCOZEUgzTPyFiK9zxNn3djtzk=
Message-ID: <9e4733910808222054i56d9d481v97df477617445ab8@mail.gmail.com>
Date: Fri, 22 Aug 2008 23:54:51 -0400
From: "Jon Smirl" <jonsmirl@gmail.com>
To: "Eric Miao" <eric.y.miao@gmail.com>
Subject: Re: Fundamental Design Flaw of the Device Driver Model?
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <f17812d70808221802t250e4210y826a635d6e9688ed@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f17812d70808212325m24f25518t5e8dd2fc5e7919b@mail.gmail.com>
	 <9e4733910808220733o7a8904do9dec947dde7d09c0@mail.gmail.com>
	 <f17812d70808221802t250e4210y826a635d6e9688ed@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/22/08, Eric Miao <eric.y.miao@gmail.com> wrote:
> On Fri, Aug 22, 2008 at 10:33 AM, Jon Smirl <jonsmirl@gmail.com> wrote:
>  > On 8/22/08, Eric Miao <eric.y.miao@gmail.com> wrote:
>  > ======================================================
>  >>    This, however, creates many questions you have to face with:
>  >>
>  >>    1. on what bus shall these sub-devices be?
>  >>       ** this is the reason I choose to use "platform_device", at least they
>  >>       can reside on the platform_bus_type, thus platform_driver can be used
>  >>       for this sub-device
>  >
>  > Another option is making your own bus. If I understand your hardware
>  > it effectively has an internal bus.
>  >
>
>
> That's another option around, but it didn't solve my fundamental question
>  of, (e.g. an PCI card with multiple network interfaces and other functionality):
>
>  Why should I have to create an intermediate device provided that a
>  "struct net_device" already contains a "struct device"? And that
>  device-driver binding, parameter passing (platform_data), bus and
>  other functionalities of this "struct net_device" is not used while
>  that's used solely by that intermediate device (platform_device maybe)?
>
>  They should have perfectly been combined into a single virtual device.
>

First device represent the hardware with the PCI interface for the
card. Instantiating it creates a bus for the card. You then auto add
devices to this bus for each of the sub-devices on the card.  Auto add
is fine in this case since the sub-devices aren't optional.
A multifunction card really is a local private bus with multiple
devices on it. First device is a real device - it's the bus controller
for the multifunction card.

A stranger problem is encountered with audio hardware. The SOC CPU
code loads an i2s/ac97 driver. A generic driver for the audio codec is
also loaded. Now you have to create a strange "fabric" device which
represent the specific PCB the generic codec and SOC have been
soldered into. The fabric driver describes how the codec and CPU are
wired together and if all of the codec functions are brought out to
jacks. For example, you don't want to display an ALSA capture device
if the codec supports it but no mic-in jack has been soldered to the
PCB. Is the fabric device a real device? You can't program it but you
can't get rid of it either.

-- 
Jon Smirl
jonsmirl@gmail.com
