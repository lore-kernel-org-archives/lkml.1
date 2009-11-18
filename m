Return-Path: <linux-kernel-owner+w=401wt.eu-S932112AbZKRReD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932112AbZKRReD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:34:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758022AbZKRReD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:34:03 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:61811 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758020AbZKRReB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:34:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Jamie Lokier <jamie@shareable.org>
Subject: Re: [PATCH 1/2] BKL: Remove BKL from default_llseek()
Date: Wed, 18 Nov 2009 18:33:37 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jan Blunck <jblunck@suse.de>,
       linux-fsdevel@vger.kernel.org,
       "Linux-Kernel Mailinglist" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>,
       =?iso-8859-1?q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
References: <1258560457-15129-1-git-send-email-jblunck@suse.de> <20091118171524.4d2f8cec@lxorguk.ukuu.org.uk> <20091118172730.GD28723@shareable.org>
In-Reply-To: <20091118172730.GD28723@shareable.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911181833.37531.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+WGSD/naf6Ptlnvd1fQ3LA2vn+205MnkbaDl9
 NPtORZb8PyRIU3rydxkG7cGuRSzPNVI4Hx51qlsy3StFtS0RSG
 cfxS0As5DGEYFSLj5TndA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 18 November 2009, Jamie Lokier wrote:
> Alan Cox wrote:
> > > Using the BKL in llseek() does not protect the inode's i_size from
> > > modification since the i_size is protected by a seqlock nowadays. Since
> > > default_llseek() is already using the i_size_read() wrapper it is not the
> > > BKL which is serializing the access here.
> > > The access to file->f_pos is not protected by the BKL either since its
> > > access in vfs_write()/vfs_read() is not protected by any lock. If the BKL
> > > is not protecting anything here it can clearly get removed.
> > 
> > No. Your logic is flawed
> > 
> > The BKL is protected something here - it protects the change of offset
> > with respect to other BKL users within drivers. The question is what if
> > anything in any other driver code depends upon the BKL and uses it to
> > protect f_pos. Probably very little if anything but a grep for f_pos
> > through the drivers might not be a bad idea before assuming this. Very
> > few touch f_pos except in their own llseek method.
> 
> Of course, drivers shouldn't be using f_pos outside their llseek
> method, as they should all behave the same with pread/pwrite as with
> llseek+read/write.
> 
> Is that mistaken?

There are drivers touching f_pos in ioctl() methods, which is vaguely
reasonable. There are also driver touching it in their read()/write()
methods, which has no effect whatsoever.

I started grepping through the kernel trying to find any instances
of the first case that uses the BKL, but I only found three instances
of the second case and got heavily demotivated by that.

	Arnd <><
