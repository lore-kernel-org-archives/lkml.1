Return-Path: <linux-kernel-owner+w=401wt.eu-S1751869AbXBVUwX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869AbXBVUwX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 15:52:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbXBVUwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 15:52:23 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:21833 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751869AbXBVUwW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 15:52:22 -0500
Message-ID: <45DE0280.9070700@tls.msk.ru>
Date: Thu, 22 Feb 2007 23:52:16 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Icedove 1.5.0.9 (X11/20061220)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: dsaxena@plexity.net, linux-kernel@vger.kernel.org
Subject: Re: Modprobe as script breaks initramfs kernel?
References: <20070222003309.GA22471@plexity.net> <45DD7EED.7030107@tls.msk.ru> <Pine.LNX.4.61.0702221941290.7553@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0702221941290.7553@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.1.0
OpenPGP: id=4F9CF57E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Feb 22 2007 14:30, Michael Tokarev wrote:
>> Deepak Saxena wrote:
>>> We attempted an experiment in cleaning up some modprobe messages during 
>>> initramfs bootup when the modules directory is missing by moving modprobe 
>>> to modprobe-bin and replacing modprobe with the following simple shell script:
>>>
>>> #!/bin/sh
>>> # Clean up bootup when modules are not present
>>>
>>> if [ -e "/lib/modules/'uname -r'/modules.dep" ] ; then
>>> 	/sbin/modprobe-bin $*
> 
> The nitpick guide says: `uname -r` and "$@" instead of $*  ;-)

Here, it's possible to workaround the pipefs issue... with another kernel
bugfix.  uname -r is available in /proc/sys/kernel/version, but the problem
is that reading almost any file in /proc with shell, which does read by a
single byte, returns only first byte of of the file being read.  The bug
has been addressed by Andrew recently, but I don't remember if the fix is
in 2.6.20 or 2.6.19.x yet.  I discovered it exactly because of this very
issue - hit pipefs bug and tried to work around it by replacing the above
construct with

   read version < /proc/sys/kernel/version
   ... /lib/modules/$version/modules.dep ...

wich results in $version being set to.. "2" (from "2.6...." :)

But sure, the usage is wrong, albiet ok for some minimal debugging.

>>> BUG: unable to handle kernel NULL pointer dereference at virtual address 00000014
>>> Trace; c0107737 <sys_pipe+17/60>

>> This is the same issue I reported much earlier with /sbin/hotplug being a script
>> in initrfamfs.  The problem is because pipefs isn't initialized yet at the time
>> the script gets called, and causes a NULL-pointer deref.  Obviously you're using
>> pipe above.
> 
> Btw, has this pipefs issue been adressed (by moving pipefs before initramfs
> stage), or something?

Not as I know of.  It has been discussed, but seems to be of low priority.

At least, reading /proc file is fixed... somewhere... :)  So it's now possible
to work around it, at least in some places (because sometimes pipe is really
useful anyway and difficult to substitute with something ;)

/mjt
