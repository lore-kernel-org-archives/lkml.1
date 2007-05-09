Return-Path: <linux-kernel-owner+w=401wt.eu-S1755451AbXEIJkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451AbXEIJkz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 05:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbXEIJks
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 05:40:48 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:3601 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754275AbXEIJkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 05:40:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=GdfG7FYP+Yhe0wW6B20DVpUX1j1x0AVj91lcTIXdtascDNGp1JodJD0XroWL5Uo23u1xecdCLKwoqi5tuhC9qAiyiPHzLkYS2xBB51HMyOS6rtENPgHppLm43v1j8YIBxS2QuE7PskRCP64ELeOQ9/xBSKQp6zII8TIVcbi+cRU=
Message-ID: <46419711.8050003@gmail.com>
Date: Wed, 09 May 2007 11:40:33 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Chris Rankin <rankincj@yahoo.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
       linux-usb-devel@lists.sourceforge.net,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>
Subject: Re: [linux-usb-devel] Bug creating USB endpoints in 2.6.20.x (kernel
 bug 8198)
References: <963898.10047.qm@web52906.mail.re2.yahoo.com>
In-Reply-To: <963898.10047.qm@web52906.mail.re2.yahoo.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[adding back linux-usb-devel.  please don't drop cc]
[also adding lkml and Greg K-H]

Chris Rankin wrote:
> --- Tejun Heo <htejun@gmail.com> wrote:
>> Okay, here's patch against 2.6.20.11.  Let's hope we're not chasing
>> something which is already fixed.
> 
> Hooray! The trick was to trace the "dev" file instead of the endpoint directory itself. The
> compressed oops is attached.

Alright, it took a lot of work but the winner is the "dev" node.  Gee...
We could have caught this earlier unless I forgot to print the name of
the last component in the initial debug patch.  Well, better late than
never.  :-(

Anyways, the problem is that the attribute "dev" is dynamically
allocated using kmalloc() in device_add() and freed immediately after
the file is removed in device_del().  It's basically assuming
immediate-disconnect but that apparently isn't true yet.

The dynamic allocation is to set the owner of the attribute to the owner
of the device being registered.  This is twisted in that the field is
added to work around sysfs/module lifetime problem but the workaround
itself is broken with regard to lifetime rules.  Aieeeeeeee...  This
sort of things are why I implemented immediate disconnect on sysfs in
the first place.

So, we can fix the problem Chris is seeing by breaking module unload (by
allowing it to unload too early).  It doesn't sound too hot but module
unloading race is much less likely than sysfs node deletion/open race.

Thanks.

-- 
tejun
