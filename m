Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1758334AbYLQCpv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334AbYLQCpv (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 21:45:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752346AbYLQCpj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 21:45:39 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46501 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbYLQCpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 21:45:38 -0500
Date: Wed, 17 Dec 2008 11:45:31 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
To: Eric Sandeen <sandeen@redhat.com>
Subject: Re: [Patch/BUG] (ext4) s_mb_maxs[] of ext4_sb_info is too small size
Cc: tytso@mit.edu, adilger@sun.com, Li Zefan <lizf@cn.fujitsu.com>,
        linux-ext4@vger.kernel.org, Miao Xie <miaox@cn.fujitsu.com>,
        Linux Kernel ML <linux-kernel@vger.kernel.org>
In-Reply-To: <4947DE30.2090903@redhat.com>
References: <20081216170409.34EA.E1E9C6FF@jp.fujitsu.com> <4947DE30.2090903@redhat.com>
X-Mailer-Plugin: BkASPil for Becky!2 Ver.2.068
Message-Id: <20081217114124.2011.E1E9C6FF@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.45 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Yasunori Goto wrote:
> > Hello.
> > 
> > I chased the cause of following ext4 oops report which is tested on
> > ia64 box.
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=12018
> > 
> > The cause is the size of s_mb_maxs array that is
> > defined as "unsigned short" in ext4_sb_info structure.
> > Unsigned short is too small.
> > 
> > In this bug report, Li-san formatted with 64Kbyte block size like
> > the following. Ia64 has 64Kbyte page size, then this
> > block size is acceptable.
> > 
> > # mkfs.ext4 -b 65536 /dev/md0
> > 
> > In this case, the maximum value of s_mb_maxs[] becomes 
> > (blocksize << 2) = 256K by the following code.
> > 
> > 2482 int ext4_mb_init(struct super_block *sb, int needs_recovery)
> >                : 
> >                :
> > 2508         max = sb->s_blocksize << 2;    <---- max becomes 0x40000.
> > 2509         do {
> > 2510                 sbi->s_mb_offsets[i] = offset;
> > 2511                 sbi->s_mb_maxs[i] = max;            <--- over flow!!!
> > 2512                 offset += 1 << (sb->s_blocksize_bits - i);
> > 2513                 max = max >> 1;
> > 2514                 i++;
> > 2515         } while (i <= sb->s_blocksize_bits + 1);
> > 
> > Then, some s_mb_maxs[] becomes 0 due to overflow.
> > It is cause of this oops. The following patch is to fix it.
> 
> Looks good to mee; and these lines before it:
> 
>         sbi->s_mb_maxs[0] = sb->s_blocksize << 3;
>         sbi->s_mb_offsets[0] = 0;
> 
> mean that we would have a problem "even" on 8k blocks, yes?

Oh, Yes. :-)

Thanks.

-- 
Yasunori Goto 


