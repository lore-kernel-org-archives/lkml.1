Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933344Ab0CKQ7G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 11:59:06 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63226 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933302Ab0CKQ7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 11:59:04 -0500
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: linux-kernel@vger.kernel.org
Subject: Re: howto combat highly pathologic latencies on a server?
Date: Thu, 11 Mar 2010 17:58:49 +0100
User-Agent: KMail/1.9.10
Cc: Dave Chinner <david@fromorbit.com>
References: <201003101817.42812.hpj@urpla.net> <20100310232940.GB16344@discord.disaster>
In-Reply-To: <20100310232940.GB16344@discord.disaster>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003111758.50224.hpj@urpla.net>
X-Provags-ID: V01U2FsdGVkX1/4+7m7lGOLWmVxpcq7L7W82QKPDgqDeaAy17R
 HkOyYtkorPjwdbJtFK4Pu9UuKbQKUzGmDBy1czr5bXgv36GUNk
 bJo6vaNWDWpeGVHtkmmjw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 March 2010, 00:29:40 Dave Chinner wrote:
> On Wed, Mar 10, 2010 at 06:17:42PM +0100, Hans-Peter Jansen wrote:
> >
> > The xfs filesystems are mounted with rw,noatime,attr2,nobarrier,noquota
> > (yes, I do have a BBU on the areca, and disk write cache is effectively
> > turned off).
>
> Make sure the filesystem has the "lazy-count=1" attribute set (use
> xfs_info to check, xfs_admin to change). That will remove the
> superblock from most transactions and significant reduce latency of
> transactions as they serialise while locking it...

Done that now on my local test system, but on one of its filesystems, 
xfs_admin -c1 didn't succeed, it simply stopped (waiting for a futex):

Famous last syscall:
6750  futex(0x868330c8, FUTEX_WAIT_PRIVATE, 0, NULL <unfinished ...>

Consequently, xfs_repair behaved similar, hanging in phase 6, traversing 
filesystem... I have a huge strace from this run, if someone is interested.

It's an 3 TB Raid 5 array (4 * 1 TB hd) with one FS also driven by areca:

meta-data=/dev/sdb1              isize=256    agcount=4, agsize=183105406 
blks
         =                       sectsz=512   attr=2
data     =                       bsize=4096   blocks=732421623, imaxpct=5
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=4096   blocks=32768, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Luckily, xfs_repair -P finally did succeed. Phuah.. 

This is with: xfs_repair version 2.10.1.

After calling xfs_admin -c1, all filesystems showed differences in 
superblock features (from a xfs_repair -n run). Is xfs_repair mandatory, or 
does the initial mount fix this automatically? 

Thanks,
Pete
