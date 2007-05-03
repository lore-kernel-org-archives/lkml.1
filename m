Return-Path: <linux-kernel-owner+w=401wt.eu-S1754124AbXECUkB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbXECUkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 16:40:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbXECUkA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 16:40:00 -0400
Received: from mail5.sea5.speakeasy.net ([69.17.117.7]:52184 "EHLO
	mail5.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbXECUjp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 16:39:45 -0400
Date: Thu, 3 May 2007 13:39:44 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
       v4l-dvb maintainer list <v4l-dvb-maintainer@linuxtv.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [v4l-dvb-maintainer] [PATCH 35/36] Use menuconfig objects II -
 DVB
In-Reply-To: <Pine.LNX.4.61.0705031453360.18504@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.58.0705031247300.32689@shell2.speakeasy.net>
References: <Pine.LNX.4.61.0704301225060.29151@yvahk01.tjqt.qr> 
 <Pine.LNX.4.61.0704301429450.29151@yvahk01.tjqt.qr>  <1178129426.29579.17.camel@localhost>
  <Pine.LNX.4.58.0705021436050.504@shell2.speakeasy.net> 
 <Pine.LNX.4.61.0705030855000.18504@yvahk01.tjqt.qr> <1178195820.12651.28.camel@localhost>
 <Pine.LNX.4.61.0705031453360.18504@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2007, Jan Engelhardt wrote:
> On May 3 2007 09:37, Mauro Carvalho Chehab wrote:
> >Trent is mentioning an out-of-tree building system to allow easier
> >testing of V4L/DVB patches by end users and developers and during driver
> >development time. The building system allows faster
> >compilation/linkedition during driver development, by allowing you to
> >use:
> >	make menuconfig/qconfig/xconfig
> >
> >inside the tree, unselecting the drivers that you're not working.
>
> Is that all? Because you can do

Before I bore you to death with v4l-dvb stuff, I've written something about
the "use menuconfig objects" patches at the end.

No, it's much more than that.  The v4l-dvb tree at linuxtv.org is
significantly different than just a copy of linux/drivers/media.

For one thing, the v4l-dvb tree will build on kernels between 2.6.12 and the
latest git kernel.  There still some support for pre 2.6 kernels too, but it's
not maintained.

This way we can ask people to download the latest hg (we use Mercurial) and
test it, without also telling them to download and compile the latest kernel
from git.

The out of tree v4l-dvb build system uses the same Kconfig/Makefiles as it
does in the kernel.  This part of the kernel build system is not easily
exported to out of tree modules, so we have some scripts to handle this.

Some drivers won't work on older kernels, and we have a way to detecting this
and modifying kconfig entries to disable the driver.  If someone has ISA
disabled in their kernel, or is lacking OSS header files, they can not use an
ISA radio card driver or compile an OSS tvcard sound module.  On the other
hand, if someone has disabled DVB in their kernel, it's still possible to
build and use the out of tree DVB drivers.  There is a perl script that
understands the kconfig language and deals with resolving kconfig dependencies
(Rather than write a kconfig expression parser and evaluator, I wrote a
kconfig expression to perl expression translator).  We take care of needing to
use the kernel autoconf.h file, yet wanting to override the options set in the
out of tree v4l-dvb configuration.

> >The point rised by Trent is that, currently, this is not prepared to
> >handle the "menuconfig" and "if/endif" tags.

BTW, I've now fixed this.

Jan, have you looked at the effect these changes have when using xconfig, and
not just menuconfig?

While your changes make menuconfig better, they have nearly opposite effect on
xconfig.

xconfig has the menu tree display in the left panel, where one can see the
overall layout of the menu tree and jump directly to any menu (even one
multiple levels deep).  All the menuconfigs that used to be menus don't show
up here anymore.

To turn a menuconfig off, you must go to the top level menu containing the
menuconfig you want (and you must know which one that is!).  Then you have to
drill down through each menu level one by one, by finding that menu in the top
panel (which also has all the config options listed) and clicking on it to get
to the next one.  When you get to the menuconfig you want, you must enter it
and then you finally get the box to turn that menuconfig off.

It looks like your changes are going in, so I suppose the solution is to
improve the way xconfig handles "menuconfig".

I wonder, would it be possible to change the kconfig language so that:
menuconfig XXXX
	boolean "name of menu"

Did the same thing as:
config XXXX
	boolean "name of menu"
menu "name of menu"
	depends on XXXX

This way you could change this:

menuconfig XXXX
if XXXX
[....all the other options....]
endif

Into this:

menuconfig XXXX
[....all the other options....]
endmenu

The reason is that a frontend would easily be able to understand the coupling
between the "menuconfig XXXX" and the "if XXXX".  It will make it easier for
the frontend to see that all the options are inside and controlled by the
enclosing menuconfig.
