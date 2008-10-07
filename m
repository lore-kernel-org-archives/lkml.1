Return-Path: <linux-kernel-owner+w=401wt.eu-S1755300AbYJGSAs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300AbYJGSAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 14:00:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753353AbYJGSAi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 14:00:38 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:55387 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbYJGSAi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 14:00:38 -0400
Date: Tue, 7 Oct 2008 12:00:21 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Andi Kleen <andi@firstfloor.org>,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RESEND] [PATCH] VFS: make file->f_pos access atomic on 32bit arch
Message-ID: <20081007180020.GI25780@parisc-linux.org>
References: <6.0.0.20.2.20081007140438.0580f110@172.19.0.2> <6.0.0.20.2.20081007183452.0f052210@172.19.0.2> <20081007102942.GE20740@one.firstfloor.org> <200810080327.44530.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200810080327.44530.nickpiggin@yahoo.com.au>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2008 at 03:27:44AM +1100, Nick Piggin wrote:
> So.. is everyone agreed that corrupting f_pos is a bad thing? (serious
> question) If so, then we should get something like this merged sooner
> rather than later.

I'm not convinced it's a bad thing.  f_pos is going to get 'corrupted'
(ie not pointing where you think it's going to point) sooner or later
anyway if you have two threads accessing the same file without locking.
The fact that it can point to an offset that was accessed by neither
thread A nor thread B seems irrelevant to me.


Separately, if we do decide something along these lines is a good idea,
then file_pos_update() needs to be better.  The current patch has:

 	if (offset>=0 && offset<=inode->i_sb->s_maxbytes) {
 		/* Special lock needed here? */
-		if (offset != file->f_pos) {
-			file->f_pos = offset;
+		if (file_pos_update(file, offset))
 			file->f_version = 0;
-		}
 		retval = offset;
 	}

It seems to me that the set of f_version to 0 should be atomic with 
the changing of f_pos.  So something like this might work better:

+static inline void file_pos_update(struct file *file, loff_t offset, int v)
+{
+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
+	write_seqlock(&file->f_pos_seqlock);
+	if (offset != file->f_pos) {
+		file->f_pos = offset;
+		if (v)
+			file->f_version = 0;
+	}
+	write_sequnlock(&file->f_pos_seqlock);
+#elif BITS_PER_LONG == 32 && defined(CONFIG_PREEMPT)
+	preempt_disable();
+	if (offset != file->f_pos) {
+		file->f_pos = offset;
+		if (v)
+			file->f_version = 0;
+	}
+	preempt_enable();
+#else
+	if (offset != file->f_pos) {
+		file->f_pos = offset;
+		if (v)
+			file->f_version = 0;
+	}
+#endif
+}

Since 'v' will be known at compile time, the tests optimise away to nothing.

I also think the patch would be more favourably received if it were
structured as:

+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
+static inline loff_t file_pos_read(struct file *file)
+{
...
+}
+
+static inline void file_pos_write(struct file *file, loff_t pos)
+{
...
+}
+
...
+#elif BITS_PER_LONG == 32 && defined(CONFIG_PREEMPT)
...
+#else
...
+#endif


-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
