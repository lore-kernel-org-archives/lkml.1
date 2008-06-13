Return-Path: <linux-kernel-owner+w=401wt.eu-S1758042AbYFMVmq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042AbYFMVmq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 17:42:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753325AbYFMVmi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 17:42:38 -0400
Received: from mout.perfora.net ([74.208.4.194]:50217 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062AbYFMVmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 17:42:37 -0400
X-Greylist: delayed 306 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jun 2008 17:42:37 EDT
Date: Fri, 13 Jun 2008 16:36:43 -0500 (CDT)
From: "R.L. Horn" <lists@eastcheap.org>
X-X-Sender: rlhorn@hani.compact.internal
To: linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: serial problem (minicom)
Message-ID: <alpine.LNX.1.00.0806131635260.1294@hani.compact.internal>
User-Agent: Alpine 1.00 (LNX 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Provags-ID: V01U2FsdGVkX1+GvTQa9XC6MrUskVU3TI7ExNyefLbj3N4Ah9u
 amUVE9IxoXqhhWyCuuja4OxTh2AcCSmXvQ3COgbzNC3IqR+PsB
 fLOIqMImxATVoz2bnsW5w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is kind of an old thread, but I'm seeing something similar and, perhaps, 
can throw some light on the subject.

On Fri, 16 May 2008, Andrew Morton wrote:

> On Thu, 15 May 2008 20:06:23 +0100 (BST) Chris Rankin <rankincj@yahoo.com> 
> wrote:

>> I have two Linux boxes connected by a null-modem cable between their serial 
>> ports; one box exports a serial console, which the other reads using the 
>> minicom program. However, I have noticed that minicom can no longer use the 
>> serial console when it is running on a 2.6.25.3 kernel, although it works 
>> fine running on a 2.6.24.4 kernel.

>> Specifically, with minicom running on 2.6.25.3, the console does not accept 
>> keystrokes although it does receive the boot log from the remote machine.

>> The serial console is being exported by a 2.6.25.3 kernel, and appears to be 
>> working correctly.

> We did make some changes to serial_core.c in that timeframe which might have 
> caused this, such as:

...

> Author: Yinghai Lu <Yinghai.Lu@Sun.COM>  2008-02-04 22:27:46
> Committer: Linus Torvalds <torvalds@woody.linux-foundation.org> 2008-02-05 
> 09:44:09
> Parent: 149b36eae2ab6aa6056664f4bc461f3d3affc9c1 (serial: stop passing
>         NULL to functions that expect data)
> Child:  9d778a69370cc1b643b13648df971c83ff5654ef (serial: avoid waking
>         up closed serial ports on resume)
> Branches: many (89)
> Follows: v2.6.24
> Precedes: v2.6.25-rc1
>
>     serial: keep the DTR setting for serial console.

That looks like a possibility.  minicom has a DTR toggle function that drops 
DTR by setting the baud rate to B0 (thereby clearing both DTR and RTS) and then 
restoring the previous rate.  It's called pretty early upon execution.

With kernels prior to 2.6.25 or so, resetting the baud rate would again raise 
DTR and RTS, but I'm not seeing this with the current stable version (2.6.25.6 
as of this writing).

Specifically:

   Opening a serial device (e.g. 16550 as ttyS0) raises DTR and RTS.

   Setting the baud rate to B0 clears both (as per SUS).

   Subsequently setting the baud rate to something other than B0 leaves the
   control lines low.

As it happens, apart from the fact that it breaks minicom, I actually prefer 
this behavior.

Right now I have a patch that will fix minicom and I'm trying to convince the 
maintainers to accept it.  I need a definitive answer, though, as to whether 
I'm seeing a bug or a feature.


If it's not too much trouble, please CC: to my address.  The volume of this 
list is a little overwhelming...
