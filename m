Return-Path: <linux-kernel-owner+w=401wt.eu-S1753421AbYHUMSY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421AbYHUMSY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 08:18:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751705AbYHUMSO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 08:18:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:56879 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbYHUMSM (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 08:18:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: jaredeh@gmail.com
Subject: Re: [PATCH 04/10] AXFS: axfs_inode.c
Date: Thu, 21 Aug 2008 14:17:13 +0200
User-Agent: KMail/1.9.9
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?iso-8859-1?q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
References: <48AD00F0.5030403@gmail.com>
In-Reply-To: <48AD00F0.5030403@gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Disposition: inline
Message-Id: <200808211417.14425.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19gBvDc/6gr0rmAaBG/R3JzKQ7aLgzn7JtVnRV
 8czmM/O/GfdEnZyWGgLXSsUzWUc+J/uncQ9ioKLc11gc4NhjUl
 0SaIDZ19epJsxQZFnKQGw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id m7LCIfdq031888

On Thursday 21 August 2008, Jared Hulbert wrote:> +       array_index = AXFS_GET_INODE_ARRAY_INDEX(sbi, ino_number);> +       array_index += page->index;> +> +       node_index = AXFS_GET_NODE_INDEX(sbi, array_index);> +       node_type = AXFS_GET_NODE_TYPE(sbi, array_index);> +> +       if (node_type == Compressed) {> +               /* node is in compessed region */> +               cnode_offset = AXFS_GET_CNODE_OFFSET(sbi, node_index);> +               cnode_index = AXFS_GET_CNODE_INDEX(sbi, node_index);> +               down_write(&sbi->lock);> +               if (cnode_index != sbi->current_cnode_index) {> +                       /* uncompress only necessary if different cblock */> +                       ofs = AXFS_GET_CBLOCK_OFFSET(sbi, cnode_index);> +                       len = AXFS_GET_CBLOCK_OFFSET(sbi, cnode_index + 1);> +                       len -= ofs;> +                       axfs_copy_data(sb, cblk1, &(sbi->compressed), ofs, len);> +                       axfs_uncompress_block(cblk0, cblk_size, cblk1, len);> +                       sbi->current_cnode_index = cnode_index;> +               }> +               downgrade_write(&sbi->lock);> +               max_len = cblk_size - cnode_offset;> +               len = max_len > PAGE_CACHE_SIZE ? PAGE_CACHE_SIZE : max_len;> +               src = (void *)((unsigned long)cblk0 + cnode_offset);> +               memcpy(pgdata, src, len);> +               up_read(&sbi->lock);
This looks very nice, but could use some comments about how the data isactually stored on disk. It took me some time to figure out that it actuallyallows to do tail merging into compressed blocks, which I was about to suggestyou implement ;-). Cramfs doesn't have them, and I found that they are themain reason why squashfs compresses better than cramfs, besides the defaultblock size, which you can change on either one.
Have you seen any benefit of the rwsem over a simple mutex? I would guessthat you can never even get into the situation where you get concurrentreaders since I haven't found a single down_read() in your code, onlydowngrade_write().
	Arnd <><ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
