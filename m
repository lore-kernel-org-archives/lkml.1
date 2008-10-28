Return-Path: <linux-kernel-owner+w=401wt.eu-S1753960AbYJ1Rm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbYJ1Rm6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 13:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYJ1Rmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 13:42:46 -0400
Received: from vervifontaine.sonytel.be ([80.88.33.193]:51509 "EHLO
	vervifontaine.sonycom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752478AbYJ1Rmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 13:42:45 -0400
Date: Tue, 28 Oct 2008 18:42:36 +0100 (CET)
From: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
To: Phillip Lougher <phillip@lougher.demon.co.uk>
cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
Subject: Re: Subject: [PATCH 02/16] Squashfs: directory lookup operations
In-Reply-To: <E1KqrTW-0001xG-Cl@dylan>
Message-ID: <Pine.LNX.4.64.0810281835150.23080@vixen.sonytel.be>
References: <E1KqrTW-0001xG-Cl@dylan>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-584349381-2120149839-1225215365=:23080"
Content-ID: <Pine.LNX.4.64.0810281836180.23080@vixen.sonytel.be>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---584349381-2120149839-1225215365=:23080
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <Pine.LNX.4.64.0810281836181.23080@vixen.sonytel.be>

On Fri, 17 Oct 2008, Phillip Lougher wrote:
> --- /dev/null
> +++ b/fs/squashfs/namei.c

> +static int get_dir_index_using_name(struct super_block *s,
> +			long long *next_block, unsigned int *next_offset,
> +			long long index_start, unsigned int index_offset,
> +			int i_count, const char *name, int len)
> +{
> +	struct squashfs_sb_info *msblk = s->s_fs_info;
> +	int i, size, length = 0;
> +	struct squashfs_dir_index *index;
> +	char *str;
> +
> +	TRACE("Entered get_dir_index_using_name, i_count %d\n", i_count);
> +
> +	str = kmalloc(sizeof(*index) + (SQUASHFS_NAME_LEN + 1) * 2, GFP_KERNEL);
> +	if (str == NULL) {
> +		ERROR("Failed to allocate squashfs_dir_index\n");
> +		goto out;
> +	}
> +
> +	index = (struct squashfs_dir_index *) (str + SQUASHFS_NAME_LEN + 1);

As str has been returned by kmalloc(), and SQUASHFS_NAME_LEN is equal to 256,
`str + SQUASHFS_NAME_LEN + 1` is an odd address.

> +	strncpy(str, name, len);
> +	str[len] = '\0';
> +
> +	for (i = 0; i < i_count; i++) {
> +		squashfs_read_metadata(s, index, index_start, index_offset,
> +					sizeof(*index), &index_start,
> +					&index_offset);
> +
> +		size = le32_to_cpu(index->size) + 1;
                                   ^^^^^^^^^^^
> +
> +		squashfs_read_metadata(s, index->name, index_start,
> +					index_offset, size, &index_start,
> +					&index_offset);
> +
> +		index->name[size] = '\0';
> +
> +		if (strcmp(index->name, str) > 0)
> +			break;
> +
> +		length = le32_to_cpu(index->index);
				     ^^^^^^^^^^^
> +		*next_block = le32_to_cpu(index->start_block) +
					  ^^^^^^^^^^^^^^^^^^
> +					msblk->directory_table_start;
> +	}

Hence accessing multi-byte fields in struct squashfs_dir_index causes unaligned
accesses, which are emulated on some architectures (e.g. on MIPS).

Use get_unaligned_le32() for unaligned accesses.

Signed-off-by: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
---
Actual patch is against current squashfs4.

 fs/squashfs/namei.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/squashfs/namei.c
+++ b/fs/squashfs/namei.c
@@ -59,6 +59,8 @@
 #include <linux/dcache.h>
 #include <linux/zlib.h>
 
+#include <asm/unaligned.h>
+
 #include "squashfs_fs.h"
 #include "squashfs_fs_sb.h"
 #include "squashfs_fs_i.h"
@@ -101,7 +103,7 @@ static int get_dir_index_using_name(stru
 			break;
 
 
-		size = le32_to_cpu(index->size) + 1;
+		size = get_unaligned_le32(&index->size) + 1;
 
 		err = squashfs_read_metadata(sb, index->name, &index_start,
 					&index_offset, size);
@@ -113,8 +115,8 @@ static int get_dir_index_using_name(stru
 		if (strcmp(index->name, str) > 0)
 			break;
 
-		length = le32_to_cpu(index->index);
-		*next_block = le32_to_cpu(index->start_block) +
+		length = get_unaligned_le32(&index->index);
+		*next_block = get_unaligned_le32(&index->start_block) +
 					msblk->directory_table;
 	}
 

With kind regards,

Geert Uytterhoeven
Software Architect

Sony Techsoft Centre Europe
The Corporate Village · Da Vincilaan 7-D1 · B-1935 Zaventem · Belgium

Phone:    +32 (0)2 700 8453
Fax:      +32 (0)2 700 8622
E-mail:   Geert.Uytterhoeven@sonycom.com
Internet: http://www.sony-europe.com/

A division of Sony Europe (Belgium) N.V.
VAT BE 0413.825.160 · RPR Brussels
Fortis · BIC GEBABEBB · IBAN BE41293037680010
---584349381-2120149839-1225215365=:23080--
