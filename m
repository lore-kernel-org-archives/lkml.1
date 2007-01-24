Return-Path: <linux-kernel-owner+w=401wt.eu-S965626AbXAXCk0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965626AbXAXCk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 21:40:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965628AbXAXCk0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 21:40:26 -0500
Received: from cantor.suse.de ([195.135.220.2]:42722 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965626AbXAXCkZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 21:40:25 -0500
From: Neil Brown <neilb@suse.de>
To: "yang yin" <yinyang801120@gmail.com>
Date: Wed, 24 Jan 2007 13:39:59 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17846.50943.624833.922264@notabene.brown>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] md: bitmap read_page error
In-Reply-To: message from yang yin on Tuesday January 23
References: <34781ae60701220003v76bd43c8h79c59b2b474b3c57@mail.gmail.com>
	<17845.16620.741319.612842@notabene.brown>
	<34781ae60701221731k508d8e97yed69929de5a38977@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday January 23, yinyang801120@gmail.com wrote:
> I think your patch is not enough to slove the read_page error
> completely. I think in the bitmap_init_from_disk we also need to check
> the 'count' never exceeds the size of file before calling the
> read_page function. How do your think about it.
> Thanks your reply.

bitmap_init_from_disk already has a test:

	if (file && i_size_read(file->f_mapping->host) < bytes + sizeof(bitmap_super_t)) {
		printk(KERN_INFO "%s: bitmap file too short %lu < %lu\n",
			bmname(bitmap),
			(unsigned long) i_size_read(file->f_mapping->host),
			bytes + sizeof(bitmap_super_t));
		goto out;
	}

so 'bytes' of the bitmap must fit entirely within the file, and count
is set:
			if (index == num_pages-1)
				count = bytes + sizeof(bitmap_super_t)
					- index * PAGE_SIZE;
			else
				count = PAGE_SIZE;
which ensures that it will not go beyond the end of the file.

So I don't think count can ever exceed the size of the file in this
case. 

Can you still see a problem?

Thanks,
NeilBrown
