Return-Path: <linux-kernel-owner+w=401wt.eu-S1758914AbXINXm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914AbXINXm1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 19:42:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758512AbXINXmU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 19:42:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33319 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757952AbXINXmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 19:42:19 -0400
Date: Fri, 14 Sep 2007 16:42:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org
Subject: Re: [PATCH 1/5] Use existing macros for distinguishing mandatory
 locks
Message-Id: <20070914164215.60d7d8b2.akpm@linux-foundation.org>
In-Reply-To: <46E7CAE6.8040803@openvz.org>
References: <46E7CAE6.8040803@openvz.org>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Sep 2007 15:17:58 +0400
Pavel Emelyanov <xemul@openvz.org> wrote:

> The combination of S_ISGID bit set and S_IXGRP bit unset is 
> used to mark the inode as "mandatory lockable" and there's a 
> macro for this check called MANDATORY_LOCK(inode). However, 
> fs/locks.c and some filesystems still perform the explicit 
> i_mode checking. 
> 
> Switch the fs/locks.c to macro making the code shorter and 
> more readable.
> 
> The __MANDATORY_LOCK() macro is to be used in places where
> the IS_MANDLOCK() for superblock is already known to be true.
> 

If we're going to churn this code then it would be better to switch from
ugly-upper-case-macro to nice-lower-case-C-function while we're doing it,
please.

> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 291d40b..035ffda 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1488,8 +1488,8 @@ extern int locks_mandatory_area(int, str
>   * Candidates for mandatory locking have the setgid bit set
>   * but no group execute bit -  an otherwise meaningless combination.
>   */
> -#define MANDATORY_LOCK(inode) \
> -	(IS_MANDLOCK(inode) && ((inode)->i_mode & (S_ISGID | S_IXGRP)) == S_ISGID)
> +#define __MANDATORY_LOCK(ino) (((ino)->i_mode & (S_ISGID | S_IXGRP)) == S_ISGID)
> +#define MANDATORY_LOCK(inode) (IS_MANDLOCK(inode) && __MANDATORY_LOCK(inode))

Especially as the macro is a buggy one which references its argument more
than once.

