Return-Path: <linux-kernel-owner+w=401wt.eu-S1759836AbYEYTcY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759836AbYEYTcY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2008 15:32:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756722AbYEYTcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 May 2008 15:32:14 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33968 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755871AbYEYTcM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2008 15:32:12 -0400
Date: Sun, 25 May 2008 15:32:11 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
       "xfs@oss.sgi.com" <xfs@oss.sgi.com>,
       "dm-devel@redhat.com" <dm-devel@redhat.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 1/3] Implement generic freeze feature
Message-ID: <20080525193211.GA24328@infradead.org>
References: <20080522175020t-sato@mail.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080522175020t-sato@mail.jp.nec.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	if (test_and_set_bit(BD_FREEZE_OP, &bdev->bd_state))
> +		return ERR_PTR(-EBUSY);
> +
> +	sb = get_super_without_lock(bdev);
> +
> +	/* If super_block has been already frozen, return. */
> +	if (sb && sb->s_frozen != SB_UNFROZEN) {
> +		put_super(sb);
> +		clear_bit(BD_FREEZE_OP, &bdev->bd_state);
> +		return sb;
> +	}

The BD_FREEZE_OP flag in the block_device already prevents multiple
freezes for a singe block device, so there is no need for this
additional check and the get_super_without_lock helper.

>  	down(&bdev->bd_mount_sem);

And with that flag bd_mount_sem is also obsolete for preventing the
multiple freeze operations.  We still need investigate what
synchronization we need vs unmount which also takes bd_mount_sem without
every having document what it exactly protects.

