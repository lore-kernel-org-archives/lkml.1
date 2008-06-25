Return-Path: <linux-kernel-owner+w=401wt.eu-S1753919AbYFYRTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919AbYFYRTa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 13:19:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbYFYRTV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 13:19:21 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:50675 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750758AbYFYRTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 13:19:20 -0400
X-Greylist: delayed 1470 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Jun 2008 13:19:20 EDT
Message-ID: <48627851.9010804@cs.wisc.edu>
Date: Wed, 25 Jun 2008 11:54:41 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ashutosh Naik <ashutosh.naik@gmail.com>
CC: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       open-iscsi@googlegroups.com
Subject: Re: Kernel Crash when using the open-iscsi initiator on 2.6.25.6
References: <81083a450806242236m62754185t3099c06f9f77676@mail.gmail.com>
In-Reply-To: <81083a450806242236m62754185t3099c06f9f77676@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ashutosh Naik wrote:
> Please find the kernel log attached. I was using the open-iscsi
> initiator on kernel 2.6.25.6 with a chelsio iSCSI target and the crash
> happened on the initiator machine.
> 
>  connection5:0: ping timeout of 5 secs expired, last rx 4309640121,
> last ping 4309645121, now 4309650121
>  connection5:0: detected conn error (1011)

This happens when we cannot reach the target for the noop timout and 
interval seconds, which can happen if a cable is unplugged or the 
network is not reach able or is dropping packets.


>  connection5:0: ping timeout of 5 secs expired, last rx 4309652882,
> last ping 4309657882, now 4309662882


However, once it happens we should not report it again like is done 
here. There is something weird there. Do you have the iscsid output? 
Between these two reports of pings timing out is there any messages from 
iscsid about reconnecting?

>  connection5:0: detected conn error (1011)
>  connection5:0: detected conn error (1011)
>  session5: host reset succeeded


And we should not get here. The iscsi driver's scsi command timeout 
handler should prevent the command from firing the scsi eh, because in 
this case we think it is a transport problem.

What version of the iscsi tools are you using? Are they from a distro or 
open-iscsi.org?

Are you running with the iscsi kernel modules from 2.6.25.6, or are you 
using the iscsi modules from the open-iscsi.org website that come with 
the tarball?

Is the kernel a unmodified 2.6.25.6 or does it have some distro patches 
or patches that you have created?


> INFO: task fdisk:5226 blocked for more than 120 seconds.

I think you get this message and what follows, is a result of the above 
problem. While the iscsi initiator is trying to reconnect, IO is queued 
by the scsi layer so fdisk is going to be waiting around until we 
recover or give up.
