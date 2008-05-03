Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbYECN0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbYECN0Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 09:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754891AbYECN0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 09:26:15 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:45479 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351AbYECN0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 09:26:14 -0400
Date: Sat, 3 May 2008 16:26:11 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: WANG Cong <xiyou.wangcong@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>, Eric Youngdale <ericy@cais.com>,
       viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Subject: Re: [Patch] fs/binfmt_elf.c: fix a wrong free
In-Reply-To: <20080503124610.GA3986@hack>
Message-ID: <Pine.LNX.4.64.0805031625150.20470@sbz-30.cs.Helsinki.FI>
References: <20080503124610.GA3986@hack>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2008, WANG Cong wrote:
> Fix a wrong free in fs/binfmt_elf.c::elf_core_dump().
> 
> Signed-off-by: WANG Cong <wangcong@zeuux.org>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Eric Youngdale <ericy@cais.com>
> 
> ---
>  fs/binfmt_elf.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
> index b25707f..43254e3 100644
> --- a/fs/binfmt_elf.c
> +++ b/fs/binfmt_elf.c
> @@ -2032,10 +2032,10 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
>  
>  end_coredump:
>  	set_fs(fs);
> +	free_note_info(&info);
>  
>  cleanup:
>  	kfree(elf);
> -	free_note_info(&info);
>  	return has_dumped;
>  }

Looks like fill_note_info() requires that you call free_note_info() if it 
fails; otherwise we'll leak memory. So perhaps something like the 
following totally untested patch?

		Pekka

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index b25707f..febd208 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1917,7 +1917,7 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 	 */
 	if (!fill_note_info(elf, segs + 1, /* including notes section */
 			    &info, signr, regs))
-		goto cleanup;
+		goto cleanup_note;
 
 	has_dumped = 1;
 	current->flags |= PF_DUMPCORE;
@@ -2033,9 +2033,11 @@ static int elf_core_dump(long signr, struct pt_regs *regs, struct file *file, un
 end_coredump:
 	set_fs(fs);
 
+cleanup_note:
+	free_note_info(&info);
+
 cleanup:
 	kfree(elf);
-	free_note_info(&info);
 	return has_dumped;
 }
 
