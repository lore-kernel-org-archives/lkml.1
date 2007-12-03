Return-Path: <linux-kernel-owner+w=401wt.eu-S1751816AbXLCVKV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816AbXLCVKV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2007 16:10:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750942AbXLCVKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Dec 2007 16:10:08 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:18090 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937AbXLCVKG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2007 16:10:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=JEEke03dbDeVRCqPTTwK/dhjS+8BgwwgqQme4Pvi7ErT5zjENIIe8lP211qxCCNDR/Xt88vKA827b/M1ajTmlHS9Mtczorkf6I1pvd/eablLqgYolKWioDygP4Aw5Rsh8lWIAT4exEK9b1WwDBZRP+msV4X7iZM979vVeoYHcSI=
Date: Tue, 4 Dec 2007 00:09:59 +0300
To: Greg KH <gregkh@suse.de>
Cc: Alexey Dobriyan <adobriyan@sw.ru>, akpm@osdl.org,
       linux-kernel@vger.kernel.org, kay.sievers@vrfy.org
Subject: Re: kobject ->k_name memory leak
Message-ID: <20071203210959.GA1725@martell.zuzino.mipt.ru>
References: <20071203092607.GA22477@localhost.sw.ru> <20071203204716.GA9734@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071203204716.GA9734@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Alexey Dobriyan <adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2007 at 12:47:16PM -0800, Greg KH wrote:
> On Mon, Dec 03, 2007 at 12:26:07PM +0300, Alexey Dobriyan wrote:
> > Hi, Greg!
> > 
> > Commit ce2c9cb0259acd2aed184499ebe41ab00da13b25 aka
> > "kobject: remove the static array for the name" introduced memory leak
> > of a module name after modprobe/rmmod. Apparently for modules ->release
> > callback is NULL.
> > 
> > kobject_cleanup: ->release = 00000000, name = 'foo_sysctl'
> > Pid: 1927, comm: rmmod Not tainted 2.6.24-rc3-e1cca7e8d484390169777b423a7fe46c7021fec1 #5
> >  [<c10d4a58>] kobject_cleanup+0xb8/0xc0
> >  [<c10d4a60>] kobject_release+0x0/0x10
> >  [<c10d587b>] kref_put+0x2b/0xa0
> >  [<c11dbe85>] _spin_unlock+0x25/0x40
> >  [<c1045b78>] free_module+0x78/0xd0
> >  [<c104773f>] sys_delete_module+0x12f/0x1a0
> 
> Hm, _which_ kobject associated with a module, there are 3 of them I
> think :)

Ouch!

> They should all have a release function, and if they do not, we think
> it's a "static" kobject and it is not safe to free that name.
> 
> I've been working on cleaning this up a lot in the -mm tree with over 80
> patches for the kset/kobject apis and interfaces.
> 
> But if we have a dynamic kobject, and we aren't freeing it properly,
> please let me know which one it is and I'll work to fix it for 2.6.24.

The one which is passed to kobject_set_name() in mod_sysfs_init()..
