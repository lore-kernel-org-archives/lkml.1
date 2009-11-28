Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbZK1MW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbZK1MW3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Nov 2009 07:22:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753968AbZK1MW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Nov 2009 07:22:28 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:56914 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753950AbZK1MW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Nov 2009 07:22:27 -0500
X-Sasl-enc: 20jxiN1se1r5rSklsCp0/ysRQz/cTeGZIS7O/7+LTQvS 1259410953
Date: Sat, 28 Nov 2009 10:22:29 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Rafa?? Mi??ecki <zajec5@gmail.com>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Richard Purdie <rpurdie@rpsys.net>
Subject: Re: Backlight device class redesign
Message-ID: <20091128122229.GB17894@khazad-dum.debian.net>
References: <b170af450911271630k63fb857auf8314cecd6219eba@mail.gmail.com>
 <b170af450911280230g4a2f7f8ao64b46ce7e88ec929@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b170af450911280230g4a2f7f8ao64b46ce7e88ec929@mail.gmail.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Backlight maintainer added to CC.

On Sat, 28 Nov 2009, Rafa?? Mi??ecki wrote:
> W dniu 28 listopada 2009 01:30 u??ytkownik Rafa?? Mi??ecki
> <zajec5@gmail.com> napisa??:
> > Currently we keep all registered controllers in /sys/class/backlgiht/
> > without any grouping per display or per anything. We can not use
> > grouping per GPU (as somewhere proposed) because one GPU can control
> > (for example) two PANELS and TV - 3 displays needing backlight
> > management. The most obvious and stable solution seems to be grouping
> > per display.
> 
> Just in case I was not clear enough. We should make ACPI, platform and
> GPU drivers register same panel backlight control under same name like
> "panel-0". Backlight class device would create
> /sys/class/backlight/panel-0 only. When touching files in this
> backlight/panel-0/, blacklight class would call functions from the
> most proper (ACPI > platform > GPU) driver.
> 

I once suggested some sort of multiplexer backlight device that would do
exactly that.  Various drivers (platform, ACPI, display) would register
backends and specify some sort of dynamic preference so that the kernel
would have a good bet on the default one, and userspace could switch the
active backend later if it wanted.

In this case, we'd have to specify properties or some other way to group the
backends properly and to easily let userspace find the backlight device it
needs to drive a specific device.

> I thought if we could use card number for anything. I recalled that
> notebooks with hybrid gpu, where system should switch between weaker
> and more powerful GPU watching load. In case of that notebooks PANEL
> can be controlled by both: card0 and card1.

That would require backends to be able to runtime register and unregister
themselves with the main backlight device, and that they hook somehow on the
hotplug stuff, to know when to bind/unbind along with the GPU.

> So finally I think we should just register panel0 by default
> everywhere. And in future we could add some quirks in drivers (ACPI,
> platform, GPU) that would register panel1, panel2... for such devices.

If you're going to design something, do it properly from day one.  Address
all the main issues: multiple backends for each device, auto-selection of
the default backend based on data reported by the backend drivers (e.g. a
platform driver usually knows very well if it should be preferred over ACPI
and GPU or not...), *and* multiple devices with hotplug.

These are not, after all, overengineering for the future.  It is a problem
we have _now_ with real world devices that are shipping.

There are other ways to solve this issue, of course, and they're easier:
publish MORE information on sysfs to properly bind backlight devices to the
real device they control, as well as more data to help userspace decide
which one it should use.   It is a cop-out, as we are only solving half the
problem space in-kernel.  But it works, and it is not a hack, so it is also
a viable solution.

I prefer the full kernel solution where we export just one backlight
interface, but when I propesed it, the others made it clear they'd prefer
the less complex "userspace chooses which backlight backend to drive"
currently employed.

Meanwhile, I'd like a LOT to know how I could parent the backlight device I
export in a platform driver to the correct PCI or ACPI device for the main
GPU...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
