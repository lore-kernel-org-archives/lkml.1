Return-Path: <linux-kernel-owner+w=401wt.eu-S1763352AbXGJLzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763352AbXGJLzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 07:55:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754812AbXGJLz3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 07:55:29 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56108 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219AbXGJLz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 07:55:28 -0400
Date: Tue, 10 Jul 2007 12:55:20 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "YOSHIFUJI Hideaki / ?$B5HF#1QL@" <yoshfuji@linux-ipv6.org>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: sysfs: release mutex when kmalloc() failed in sysfs_open_file().
Message-ID: <20070710115519.GA1519@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"YOSHIFUJI Hideaki / ?$B5HF#1QL@" <yoshfuji@linux-ipv6.org>,
	gregkh@suse.de, linux-kernel@vger.kernel.org
References: <20070710.135646.84167888.yoshfuji@linux-ipv6.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070710.135646.84167888.yoshfuji@linux-ipv6.org>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2007 at 01:56:46PM +0900, YOSHIFUJI Hideaki / ?$B5HF#1QL@ wrote:
> @@ -283,6 +283,7 @@ static int sysfs_open_file(struct inode *inode, struct file *file)
>  	mutex_lock(&inode->i_mutex);
>  	if (!(set = inode->i_private)) {
>  		if (!(set = inode->i_private = kmalloc(sizeof(struct sysfs_buffer_collection), GFP_KERNEL))) {
> +			mutex_unlock(&inode->i_mutex);
>  			error = -ENOMEM;
>  			goto Done;
>  		} else {

Not related to your code, but whoever wrote this code originally deserves
a big slap in the face for writing such obsfucated code.  This should be
something like:

 	mutex_lock(&inode->i_mutex);
 	set = inode->i_private;
	if (!set) {
 		set = kmalloc(sizeof(struct sysfs_buffer_collection),
				GFP_KERNEL))) {
		if (!set)
			mutex_unlock(&inode->i_mutex);
 			error = -ENOMEM;
 			goto Done;
 		}
		INIT_LIST_HEAD(&set->associates);
		inode->i_private = set;
	}
	mutex_unlock(&inode->i_mutex);

