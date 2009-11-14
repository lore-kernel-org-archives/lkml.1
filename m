Return-Path: <linux-kernel-owner+w=401wt.eu-S1757821AbZKNElM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821AbZKNElM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 23:41:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757567AbZKNElL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 23:41:11 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:53419 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757424AbZKNElK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 23:41:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vD5YgO0R0/U876Bm5CE1hvxXqxYfyywu2KYvQWv4N1wF/oZ2GR1/MFIdGwpfu0E03S
         QAZfM3mG2RRrK2Znm0cB3g6trpkeyvcqVJ7XyyiomcRckxEoi7qyQUvL62iq6vVzTfSt
         w5pFUe0pp9aW1RODnmYZiWLgfQOmq5r9d4kHQ=
Date: Sat, 14 Nov 2009 12:41:53 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: steve@digidescorp.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] procfs: Use proper units for noMMU statm
Message-ID: <20091114044153.GB2416@hack>
References: <1258163534-3617-1-git-send-email-steve@digidescorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258163534-3617-1-git-send-email-steve@digidescorp.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 07:52:14PM -0600, steve@digidescorp.com wrote:
>On no-MMU systems, sizes reported in /proc/n/statm have units of bytes. 
>Per Documentation/filesystems/proc.txt, these values should be in pages.
>
>Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
>---
>diff -uprN a/fs/proc/task_nommu.c b/fs/proc/task_nommu.c
>--- a/fs/proc/task_nommu.c	2009-11-13 16:48:14.000000000 -0600
>+++ b/fs/proc/task_nommu.c	2009-11-13 16:51:09.000000000 -0600
>@@ -110,8 +110,11 @@ int task_statm(struct mm_struct *mm, int
> 		}
> 	}
> 
>-	size += (*text = mm->end_code - mm->start_code);
>-	size += (*data = mm->start_stack - mm->start_data);
>+	size >>= PAGE_SHIFT;
>+	*text = (PAGE_ALIGN(mm->end_code) - (mm->start_code & PAGE_MASK))
>+		>> PAGE_SHIFT;
>+	*data = (mm->start_stack - mm->start_data) >> PAGE_SHIFT;

Are '->start_stack' and '->start_data' already page aligned on NOMMU arch?

If yes, this patch looks good.


>+	size += *text + *data;
> 	up_read(&mm->mmap_sem);
> 	*resident = size;
> 	return size;
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/

-- 
Live like a child, think like the god.
 
