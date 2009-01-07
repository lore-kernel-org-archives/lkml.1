Return-Path: <linux-kernel-owner+w=401wt.eu-S1755369AbZAGGck@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbZAGGck (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 01:32:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751845AbZAGGc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 01:32:28 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:62332 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136AbZAGGc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 01:32:27 -0500
Message-Id: <200901070632.n076W9UO060263@www262.sakura.ne.jp>
Subject: Re: [PATCH] Introduce d_realpath().
From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
To: miklos@szeredi.hu
Cc: viro@ZenIV.linux.org.uk, hch@lst.de, linux-fsdevel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Wed, 07 Jan 2009 15:32:09 +0900
References: <200901060322.n063MBOt046756@www262.sakura.ne.jp> <E1LKIeB-0006qv-Bv@pomaz-ex.szeredi.hu>
In-Reply-To: <E1LKIeB-0006qv-Bv@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: K-Prox Anti-Virus Powered by Kaspersky, bases: 07012009 #1412118, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi wrote:
> > Three differences compared to d_path().
> > (1) Ignores current process's root directory.
> 
> I'd suggest calling __d_path() and passing in the namespace root
> instead of the process root.  That would be a lot simpler and result
> in less code duplication.
> 
Yes, that'll be possible. But I won't do so. See (3).

> > (2) Trailing '/' is added if the pathname refers to a directory.
> 
> Caller can do this.
> 
Yes. But I'd like to add trailing '/' here.

Appending trailing '/' have to worry about buffer size, but removing trailing
'/' needn't to. Thus, I think it is more convenient for callers that trailing
'/' is automatically added.

> > (3) /proc/PID/ is represented as /proc/self/ if PID equals current->tgid.
> 
> This too.  Such hacks really don't belong in generic VFS functions.
> 
No.

How can the caller of __d_path() detect the /PID/ part and convert
to /self/ from returned string? You might think that I can use
strstr(returned_path, "/proc/") and strict_strtoul() .

The procfs is mounted on /proc/ by convention, but that is not guaranteed.
Some systems might mount procfs on /proc2/ , /p/ or /var/tmp/proc/100/proc/ .

Also, a pathname like /var/tmp/proc/100/file1.txt is possible.
In this case, /var/tmp/proc/ is not the mount point of the procfs.

Thus, it is too late for the caller of __d_path() to detect the /PID/ part.

If the caller of __d_path() traverses {dentry,mount} tree for checking
dentry->d_sb->s_magic == PROC_SUPER_MAGIC, the reason to call __d_path()
disappears.

Thus, I need to detect /proc/PID/ and convert it to /proc/self/ in
d_realpath().
