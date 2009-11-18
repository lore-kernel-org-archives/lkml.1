Return-Path: <linux-kernel-owner+w=401wt.eu-S1758159AbZKRRxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758159AbZKRRxI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 12:53:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758150AbZKRRxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 12:53:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41555 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758146AbZKRRxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 12:53:03 -0500
Date: Wed, 18 Nov 2009 18:53:07 +0100
From: Jan Blunck <jblunck@suse.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-fsdevel@vger.kernel.org,
       Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, Arnd Bergmann <arnd@arndb.de>,
       Christoph Hellwig <hch@infradead.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/2] BKL: Remove BKL from default_llseek()
Message-ID: <20091118175307.GQ21750@bolzano.suse.de>
References: <1258560457-15129-1-git-send-email-jblunck@suse.de> <20091118171524.4d2f8cec@lxorguk.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091118171524.4d2f8cec@lxorguk.ukuu.org.uk>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, Alan Cox wrote:

> > Using the BKL in llseek() does not protect the inode's i_size from
> > modification since the i_size is protected by a seqlock nowadays. Since
> > default_llseek() is already using the i_size_read() wrapper it is not the
> > BKL which is serializing the access here.
> > The access to file->f_pos is not protected by the BKL either since its
> > access in vfs_write()/vfs_read() is not protected by any lock. If the BKL
> > is not protecting anything here it can clearly get removed.
> 
> No. Your logic is flawed
> 
> The BKL is protected something here - it protects the change of offset
> with respect to other BKL users within drivers. The question is what if
> anything in any other driver code depends upon the BKL and uses it to
> protect f_pos. Probably very little if anything but a grep for f_pos
> through the drivers might not be a bad idea before assuming this. Very
> few touch f_pos except in their own llseek method.

As I said, f_pos is changed without holding BKL in the VFS already. Therefore
even if the driver tries to protect f_pos by holding the BKL it is racing
against concurrent read()/write() anyway on f_pos.

Regards,
	Jan

-- 
Jan Blunck <jblunck@suse.de>
