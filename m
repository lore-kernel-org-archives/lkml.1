Return-Path: <linux-kernel-owner+w=401wt.eu-S1752995AbYKCSO2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995AbYKCSO2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 13:14:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751279AbYKCSOT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 13:14:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52801 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750932AbYKCSOT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 13:14:19 -0500
Date: Mon, 3 Nov 2008 10:14:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] /proc/uptime fix
In-Reply-To: <20081103145023.GA3986@x200.localdomain>
Message-ID: <alpine.LFD.2.00.0811031000020.3459@nehalem.linux-foundation.org>
References: <20081103145023.GA3986@x200.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 3 Nov 2008, Alexey Dobriyan wrote:
> 
> Alexey Dobriyan (1):
>       proc: revert /proc/uptime to ->read_proc hook

Ok, pulled, but it's a bit sad. 

Al: the commit is 6c87df37dcb9c6c33923707fa5191e0a65874d60, and the 
message explains it all:

    Turned out some VMware userspace does pread(2) on /proc/uptime, but
    seqfiles currently don't allow pread() resulting in -ESPIPE.
    
    Seqfiles in theory can do pread(), but this can be a long story,
    so revert to ->read_proc until then.
    
and I bet that the pread() usage is just with a constant loff_t of 0, and 
just there to avoid a simple case of "lseek+read". 

I wonder how hard it is to make seqfiles support pread. Maybe it's 
something as trivial as just flushing the buffer whenever 'pos' doesn't 
match f_pos?

ie something like the following (TOTALLY UNTESTED!)

I may be way off base here, Al needs to whack some sense into this.

		Linus

---
 fs/seq_file.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index eba2eab..eb95ec9 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -48,8 +48,8 @@ int seq_open(struct file *file, const struct seq_operations *op)
 	 */
 	file->f_version = 0;
 
-	/* SEQ files support lseek, but not pread/pwrite */
-	file->f_mode &= ~(FMODE_PREAD | FMODE_PWRITE);
+	/* SEQ files support lseek, but not pwrite */
+	file->f_mode &= ~(FMODE_PWRITE);
 	return 0;
 }
 EXPORT_SYMBOL(seq_open);
@@ -91,6 +91,8 @@ ssize_t seq_read(struct file *file, char __user *buf, size_t size, loff_t *ppos)
 		if (!m->buf)
 			goto Enomem;
 	}
+	if (pos != file->f_pos)
+		m->count = 0;
 	/* if not empty - flush it first */
 	if (m->count) {
 		n = min(m->count, size);
@@ -175,6 +177,8 @@ Done:
 	else
 		*ppos += copied;
 	file->f_version = m->version;
+	if (pos != file->f_pos)
+		m->count = 0;
 	mutex_unlock(&m->lock);
 	return copied;
 Enomem:
