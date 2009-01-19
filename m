Return-Path: <linux-kernel-owner+w=401wt.eu-S1758331AbZASVHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758331AbZASVHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 16:07:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754170AbZASVHp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 16:07:45 -0500
Received: from mx2.redhat.com ([66.187.237.31]:52050 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118AbZASVHp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 16:07:45 -0500
Date: Mon, 19 Jan 2009 16:07:25 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Bernhard Schmidt <berni@birkenwald.de>
Cc: linux-cifs-client@lists.samba.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-cifs-client] BUG: Possible cifs+IPv6-Regression 2.6.27.4
 -> 2.6.27.9
Message-ID: <20090119160725.34124637@tleilax.poochiereds.net>
In-Reply-To: <20090119103248.GA28699@schleppi.birkenwald.de>
References: <20090118221329.GA12742@pest>
	<20090118210314.30832598@tleilax.poochiereds.net>
	<20090119103248.GA28699@schleppi.birkenwald.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Jan 2009 11:32:48 +0100
Bernhard Schmidt <berni@birkenwald.de> wrote:

> On Sun, Jan 18, 2009 at 09:03:14PM -0500, Jeff Layton wrote:
> 
> > How reproducible is this? Can you make it happen on every attempt?
> > Is this kernel being built with CONFIG_CIFS_DFS_UPCALL=y ?
> 
> Happens every time. CIFS_DFS_UPCALL is set, yes.
> 
> > Could you email me the cifs.ko module from this kernel? I'd like to
> > disassemble it and have a look at where it crashed. I may not be
> > able to tell much, but it's worth a look...
> 
> Will do unicast when I'm back at my workstation at home.
> 
> Thanks,
> Bernhard

Thanks for the kmod. Kernel crashed doing this:

     e00:       8b 43 30                mov    0x30(%ebx),%eax

...which checks out with the register dump. %ebx is 0x69000000.
and the address we failed to look up was 0x69000030.

My guess from a cursory look at the assembly is that %ebx should be
holding a pointer to cifs_sb. It's referenced quite a few times, but
doesn't seem to change until just before returning from the function.
The interesting bit is that there are a lot of other places  (even some
that look like they've probably already been traversed) in this code
where %ebx is dereferenced but they didn't trigger the problem...

That said, there's a lot of jumping around in this assembly code and
it's not completely clear to me how it got to the point where it crashed.
We'll probably need to see if this can be independently reproduced. Can
you email along the details of how you're reproducing this? In
particular:

1) all mount options being used
2) details on the server (what OS, what version of samba, etc)
3) version of mount.cifs being used

-- 
Jeff Layton <jlayton@redhat.com>
