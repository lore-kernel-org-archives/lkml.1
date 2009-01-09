Return-Path: <linux-kernel-owner+w=401wt.eu-S1756496AbZAIFS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbZAIFS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 00:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752122AbZAIFSQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 00:18:16 -0500
Received: from wf-out-1314.google.com ([209.85.200.169]:64111 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbZAIFSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 00:18:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dBFpGasz7crrWZ8mle5JLbywT4a7eLJ/ZyyLuJ50pPNujSbvjcq4mnzwOyBqoIcmcE
         RFNRQ3oPPoD4/O5Df1eU0NDSfD/rGZSyRcX/8uQdWqqsfzWFM5mbpV5pFTV5WIZNPvdy
         6LjCK3HWcGoVZcNUC7PpdeypMIFby7m7exKuc=
Message-ID: <a0adeea50901082118g543aec82ifc574291ab0592d5@mail.gmail.com>
Date: Fri, 9 Jan 2009 13:18:14 +0800
From: Grissiom <chaos.proton@gmail.com>
To: "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>
Subject: Re: "BUG: scheduling while atomic: pdflush/30/0x00000002" in latest git
Cc: linux-kernel@vger.kernel.org, "Arjan van de Ven" <arjan@infradead.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <1231425472.21528.13.camel@norville.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a0adeea50901080007q5a3ed5c8y5a744ce37e677325@mail.gmail.com>
	 <1231425472.21528.13.camel@norville.austin.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 8, 2009 at 22:37, Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:
>
> The offender is
> http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=efaee192
>
> async_synchronize_full_special() shouldn't be called while holding a
> spinlock, sb_lock.
>
> I think this patch should fix it.  Arjan, would this work?
>
> Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
>
> diff --git a/fs/super.c b/fs/super.c
> index cb20744..7d67387 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -458,7 +458,6 @@ void sync_filesystems(int wait)
>                if (sb->s_flags & MS_RDONLY)
>                        continue;
>                sb->s_need_sync_fs = 1;
> -               async_synchronize_full_special(&sb->s_async_list);
>        }
>
>  restart:
> @@ -471,6 +470,7 @@ restart:
>                sb->s_count++;
>                spin_unlock(&sb_lock);
>                down_read(&sb->s_umount);
> +               async_synchronize_full_special(&sb->s_async_list);
>                if (sb->s_root && (wait || sb->s_dirt))
>                        sb->s_op->sync_fs(sb, wait);
>                up_read(&sb->s_umount);
>
> --
> David Kleikamp
> IBM Linux Technology Center
>
>

Problem gone with this patch applied. Thanks for the fixing.

-- 
Cheers,
Grissiom
