Return-Path: <linux-kernel-owner+w=401wt.eu-S1757080AbZCYBOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080AbZCYBOk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 21:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757166AbZCYBOZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 21:14:25 -0400
Received: from relay1.sgi.com ([192.48.179.29]:36163 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756864AbZCYBOX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 21:14:23 -0400
Date: Tue, 24 Mar 2009 20:14:18 -0500
From: Robin Holt <holt@sgi.com>
To: Chuck Lever <chuck.lever@oracle.com>, tony.luck@intel.com
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: kernel unaligned accesses on 2.6.29.
Message-ID: <20090325011418.GB8908@sgi.com>
References: <20090324172856.GA8908@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090324172856.GA8908@sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Had a few minutes to look around.

On Tue, Mar 24, 2009 at 12:28:57PM -0500, Robin Holt wrote:
> I just built and booted an ia64 2.6.29 kernel.  While accessing NFS
> filesystems, I occassionally get:
> 
> kernel unaligned access to 0xe00007bc3b8f67b9, ip=0xa00000020a61e370
> kernel unaligned access to 0xe00007bc3b8f67b1, ip=0xa00000020a61e3d1
> 
> grep a00000020a61 /proc/modules
> lockd 146448 1 nfs, Live 0xa00000020a610000
> 
> 
> These come in pairs.  I tracked it down to the lockd.ko kernel module
> and then objdump'd to find we are in:
> 
> 
> nsm_get_handle
> nsm_init_private():
> /data/lwork/attica2/holt/git-linus/v2.6.29/fs/lockd/mon.c:280
>     e370:       0b 00 98 68 98 11       [MMI]       st8 [r52]=r38;;

This one is:
	u64 *p = (u64 *)&nsm->sm_priv.data;
	...
	*p = (unsigned long)nsm;

sm_priv.data is an unsigned char array, so there are no alignment
rules. You either need to use memcpy, or not define it as an unsigned
char.  Tony, any suggestions?

> /data/lwork/attica2/holt/git-linus/v2.6.29/fs/lockd/mon.c:279
>     e376:       00 00 00 02 00 00                   nop.m 0x0
>     e37c:       92 d0 e9 53                         shl r16=r9,5;;
> 
> nsm_display_address():
> /data/lwork/attica2/holt/git-linus/v2.6.29/fs/lockd/mon.c:86
> ...
>     e3d0:       0a 60 28 1c 8d 39       [MMI]       cmp4.eq p12,p13=10,r14;;
>     e3d6:       00 a8 95 30 23 00                   st8 [r37]=r53

Haven't gotten to this one yet.

Robin
