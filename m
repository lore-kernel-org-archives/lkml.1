Return-Path: <linux-kernel-owner+w=401wt.eu-S1755865AbXFUS2M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865AbXFUS2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 14:28:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbXFUS16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 14:27:58 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:60937 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752872AbXFUS15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 14:27:57 -0400
Date: Thu, 21 Jun 2007 11:27:53 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Marco Berizzi <pupilla@hotmail.com>
cc: Satyam Sharma <satyam.sharma@gmail.com>, linux-kernel@vger.kernel.org,
       David Chinner <dgc@sgi.com>, xfs@oss.sgi.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.21.3 Oops (was Re: XFS internal error xfs_da_do_buf(2) at
 line 2087 of file fs/xfs/xfs_da_btree.c. Caller 0xc01b00bd)
In-Reply-To: <BAY103-DAV717DD455F57B3BB064E3CB2100@phx.gbl>
Message-ID: <Pine.LNX.4.64.0706211121520.7711@schroedinger.engr.sgi.com>
References: <BAY103-DAV717DD455F57B3BB064E3CB2100@phx.gbl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2007, Marco Berizzi wrote:

> > > Some RCU callback (that calls kmem_cache_free()) oopsed and
> > > panic'ed his box. [ Marco had experienced fs issues lately, so we
> > could
> > > suspect file_free_rcu() here, but I can't really tell from the stack
> > trace;
> > > BTW whats with the rampant disease in the kernel to declare as
> inline
> > > even those functions exclusively meant to be dereferenced and passed
> > > as pointers to call_rcu()?! ]


The BUG_ON that triggers this signals us that someone tried to perform
a kfree or kmem_cache_free on an object that is not in a slab page.


> Hello everybody.
> Few minutes ago 2.6.22-rc5 has been
> crashed with this error (see also the
> bitmap at http://80.204.235.230/foto2.jpg).
> Just for record: if I build linux
> with 'Debug slab memory allocations'
> the box doesn't crash.

Hmmm.. That is strange and could point to some sort of race condition.

1. The object is freed. It is the last page on the slab. Thus slab 
decommissions the page and resets PageSlab.

2. Another process tries to free the object again. Now the page is no 
longer marked as being a SLAB page. Thus the BUG_ON is triggered.

Can you try the same with SLUB? Boot with "slub_debug". If you cannot 
trigger the error anymore do limited debugging by booting with
"slub_debug=F". Maybe that will be enough to trigger the race.

> Jun 21 14:27:43 Pleiadi kernel: ------------[ cut here ]------------
> Jun 21 14:27:43 Pleiadi kernel: kernel BUG at mm/slab.c:591!

BUG_ON(!PageSlab(page));

> Jun 21 14:27:43 Pleiadi kernel: Call Trace:
> Jun 21 14:27:43 Pleiadi kernel:  [<c016a9c0>] d_kill+0x40/0x52
> Jun 21 14:27:43 Pleiadi kernel:  [<c016aa3c>] dput+0x6a/0xdc
> Jun 21 14:27:43 Pleiadi kernel:  [<c015be3f>] __fput+0xf8/0x15b
> Jun 21 14:27:43 Pleiadi kernel:  [<c015a5c3>] filp_close+0x3c/0x7b
> Jun 21 14:27:43 Pleiadi kernel:  [<c021342d>] copy_to_user+0x32/0x45
> Jun 21 14:27:43 Pleiadi kernel:  [<c015a665>] sys_close+0x63/0xb2
> Jun 21 14:27:43 Pleiadi kernel:  [<c0102834>] syscall_call+0x7/0xb

dentry already freed?
