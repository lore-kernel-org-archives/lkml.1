Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbZHQCql@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbZHQCql (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 22:46:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756658AbZHQCql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 22:46:41 -0400
Received: from mail-px0-f196.google.com ([209.85.216.196]:65517 "EHLO
	mail-px0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756479AbZHQCqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 22:46:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=h1BSuAM4nD3u6+arokX6hGRYHNqsxFUmxKs5XYsLvsTLOcYX2AoqzeoxYeiLJ/roHv
         JOmrF5Cn7t4TT3cqZC6WUvXMq8apXNI7XdjndV5I0nF09zfHPgZZZV0xk4B7cf1qjHi/
         gyF9kNR184BX0TxQ+itxqNksWCzuc5B8eKFxM=
Date: Mon, 17 Aug 2009 10:48:58 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Vincent Li <macli@brc.ubc.ca>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fs/proc/base.c: fix proc_fault_inject_write() input
	sanity check
Message-ID: <20090817024858.GG5039@cr0.nay.redhat.com>
References: <1250281120-3308-1-git-send-email-macli@brc.ubc.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1250281120-3308-1-git-send-email-macli@brc.ubc.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 14, 2009 at 01:18:40PM -0700, Vincent Li wrote:
>Remove obfuscated zero-length input check and return -EINVAL instead of -EIO error
>to make the error message clear to user. Add whitespace stripping. No functionality changes.

If so, why not introduce a new wrapper which is simply strstrip+simple_strtol?
Now, at least it has two users.


>
>The old code:
>
>echo  1  > /proc/pid/make-it-fail (ok)
>echo 1foo > /proc/pid/make-it-fail (-bash: echo: write error: Input/output error)
>
>The new code:
>
>echo  1  > /proc/pid/make-it-fail (ok)
>echo 1foo > /proc/pid/make-it-fail (-bash: echo: write error: Invalid argument)
>
>This patch is conservative in changes to not breaking existing scripts/applications.
>based on v2.6.31-rc6, compiled and tested ok.
>
>Signed-off-by: Vincent Li <macli@brc.ubc.ca>
>---
> fs/proc/base.c |   11 +++++------
> 1 files changed, 5 insertions(+), 6 deletions(-)
>
>diff --git a/fs/proc/base.c b/fs/proc/base.c
>index 175db25..ba345d9 100644
>--- a/fs/proc/base.c
>+++ b/fs/proc/base.c
>@@ -1182,17 +1182,16 @@ static ssize_t proc_fault_inject_write(struct file * file,
> 		count = sizeof(buffer) - 1;
> 	if (copy_from_user(buffer, buf, count))
> 		return -EFAULT;
>-	make_it_fail = simple_strtol(buffer, &end, 0);
>-	if (*end == '\n')
>-		end++;
>+	make_it_fail = simple_strtol(strstrip(buffer), &end, 0);
>+	if (*end)
>+		return -EINVAL;
> 	task = get_proc_task(file->f_dentry->d_inode);
> 	if (!task)
> 		return -ESRCH;
> 	task->make_it_fail = make_it_fail;
> 	put_task_struct(task);
>-	if (end - buffer == 0)
>-		return -EIO;
>-	return end - buffer;
>+
>+	return count;
> }
> 
> static const struct file_operations proc_fault_inject_operations = {
>-- 
>1.6.0.4
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/
