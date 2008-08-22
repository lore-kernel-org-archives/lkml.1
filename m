Return-Path: <linux-kernel-owner+w=401wt.eu-S1758805AbYHVCWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805AbYHVCWu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 22:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbYHVCWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 22:22:40 -0400
Received: from anchor-post-30.mail.demon.net ([194.217.242.88]:3884 "EHLO
	anchor-post-30.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751732AbYHVCWj (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 22:22:39 -0400
Message-ID: <48AE22F5.3000309@lougher.demon.co.uk>
Date: Fri, 22 Aug 2008 03:22:45 +0100
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.6 (X11/20071008)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: jaredeh@gmail.com, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?windows-1252?Q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
Subject: Re: [PATCH 04/10] AXFS: axfs_inode.c
References: <48AD00F0.5030403@gmail.com> <200808211417.14425.arnd@arndb.de>
In-Reply-To: <200808211417.14425.arnd@arndb.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Thursday 21 August 2008, Jared Hulbert wrote:
>> +       array_index = AXFS_GET_INODE_ARRAY_INDEX(sbi, ino_number);
>> +       array_index += page->index;
>> +
>> +       node_index = AXFS_GET_NODE_INDEX(sbi, array_index);
>> +       node_type = AXFS_GET_NODE_TYPE(sbi, array_index);
>> +
>> +       if (node_type == Compressed) {
>> +               /* node is in compessed region */
>> +               cnode_offset = AXFS_GET_CNODE_OFFSET(sbi, node_index);
>> +               cnode_index = AXFS_GET_CNODE_INDEX(sbi, node_index);
>> +               down_write(&sbi->lock);
>> +               if (cnode_index != sbi->current_cnode_index) {
>> +                       /* uncompress only necessary if different cblock */
>> +                       ofs = AXFS_GET_CBLOCK_OFFSET(sbi, cnode_index);
>> +                       len = AXFS_GET_CBLOCK_OFFSET(sbi, cnode_index + 1);
>> +                       len -= ofs;
>> +                       axfs_copy_data(sb, cblk1, &(sbi->compressed), ofs, len);
>> +                       axfs_uncompress_block(cblk0, cblk_size, cblk1, len);
>> +                       sbi->current_cnode_index = cnode_index;
>> +               }
>> +               downgrade_write(&sbi->lock);
>> +               max_len = cblk_size - cnode_offset;
>> +               len = max_len > PAGE_CACHE_SIZE ? PAGE_CACHE_SIZE : max_len;
>> +               src = (void *)((unsigned long)cblk0 + cnode_offset);
>> +               memcpy(pgdata, src, len);
>> +               up_read(&sbi->lock);
> 
> This looks very nice, but could use some comments about how the data is
> actually stored on disk. It took me some time to figure out that it actually
> allows to do tail merging into compressed blocks, which I was about to suggest
> you implement ;-). Cramfs doesn't have them, and I found that they are the
> main reason why squashfs compresses better than cramfs, besides the default
> block size, which you can change on either one.

Squashfs has much larger block sizes than cramfs (last time I looked it 
was limited to 4K blocks), and it compresses the metadata which helps to 
get better compression.  But tail merging (fragments in Squashfs 
terminology) is obviously a major reason why Squashfs gets good compression.

The AXFS code is rather obscure but it doesn't look to me that it does 
tail merging.  The following code wouldn't work if the block in question 
was a tail contained in a larger block.  It assumes the block extends to 
the end of the compressed block (cblk_size - cnode_offset).

 >> +               max_len = cblk_size - cnode_offset;
 >> +               len = max_len > PAGE_CACHE_SIZE ? PAGE_CACHE_SIZE : 
max_len;
 >> +               src = (void *)((unsigned long)cblk0 + cnode_offset);
 >> +               memcpy(pgdata, src, len);

Perhaps the AXFS authors could clarify this?

Phillip
