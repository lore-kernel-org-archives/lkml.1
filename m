Return-Path: <linux-kernel-owner+w=401wt.eu-S1752460AbZHZRjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460AbZHZRjF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 13:39:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZHZRjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 13:39:04 -0400
Received: from verein.lst.de ([213.95.11.210]:54794 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbZHZRjD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 13:39:03 -0400
Date: Wed, 26 Aug 2009 19:38:39 +0200
From: Christoph Hellwig <hch@lst.de>
To: Fernando Luis V??zquez Cao <fernando@oss.ntt.co.jp>
Cc: t-sato@yk.jp.nec.com, m-hamaguchi@ys.jp.nec.com,
       Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Eric Sandeen <sandeen@redhat.com>
Subject: Re: [RFC, PATCH] filesystem freeze: fix sys_umount induced perpetual freeze
Message-ID: <20090826173839.GA20175@lst.de>
References: <4A94C151.8020900@oss.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A94C151.8020900@oss.ntt.co.jp>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 26, 2009 at 02:00:01PM +0900, Fernando Luis V??zquez Cao wrote:
> The current locking scheme for filesystem freeze avoids races between
> freeze_bdev() and do_umount() by taking the s_umount semaphore.
> 
> If freeze_bdev() wins the race the process that invoked sys_umount
> will sleep until thaw_bdev releases the semaphore. Unfortunately, this
> will never happen because thaw_bdev bails out early the
> bd_fsfreeze_count check having failed (the count is 0).
> 
> The problem is that the block_device that ioctl_fsthaw() passes to
> thaw_bdev() is not the one that we freezed because before sleeping in
> deactivate_super() do_umount() released the dentry (dput()) and freed
> the vfs mount (free_vfsmnt()).
> 
> This patch works around this issue by checking the freeze level in
> do_umount()


This should be solved my my freeze locking rewrite:

	http://marc.info/?l=linux-fsdevel&m=124933489118480&w=2
	http://marc.info/?l=linux-fsdevel&m=124933491918517&w=2

