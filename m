Return-Path: <linux-kernel-owner+w=401wt.eu-S1755977AbYIRHLn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755977AbYIRHLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 03:11:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751576AbYIRHLe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 03:11:34 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:48642 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbYIRHLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 03:11:33 -0400
Message-Id: <6.0.0.20.2.20080918153651.04e39b70@172.19.0.2>
X-Mailer: QUALCOMM Windows Eudora Version 6J-Jr3
Date: Thu, 18 Sep 2008 16:08:35 +0900
To: Michael Trimarchi <trimarchimichael@yahoo.it>,
       Nick Piggin <nickpiggin@yahoo.com.au>, akpm@linux-foundation.org
From: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>
Subject: Re: [PATCH] VFS: make file->f_pos access atomic on 32bit arch
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <84867.22024.qm@web26206.mail.ukl.yahoo.com>
References: <84867.22024.qm@web26206.mail.ukl.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
>Maybe it is clear with an example:
> 
>+/*
>+ * file_pos_read/write is atomic by using sequence lock on 32bit arch.
>+ */
>+static inline loff_t file_pos_read(struct file *file)
>+{
>+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
>+	loff_t pos;
>+	unsigned int seq;
>+
>+	do {
>+		seq = read_seqbegin(&file->f_pos_seqlock);
>+		pos = file->f_pos;
>+	} while (read_seqretry(&file->f_pos_seqlock, seq));
>+	return pos;
>+#elif BITS_PER_LONG == 32 && defined(CONFIG_PREEMPT)
>+	loff_t pos;
>+
>+	preempt_disable();
>+	pos = file->f_pos;
>+	preempt_enable();
>+	return pos;
>+#else
>+	return file->f_pos;
>+#endif
>+}
>+
>+static inline void file_pos_write(struct file *file, loff_t pos)
>+{
>+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
>+	write_seqlock(&file->f_pos_seqlock);
>+	file->f_pos = pos;
>+	write_sequnlock(&file->f_pos_seqlock);
>+#elif BITS_PER_LONG == 32 && defined(CONFIG_PREEMPT)
>+	preempt_disable();
>+	file->f_pos = pos;
>+	preempt_enable();
>+#else
>+	file->f_pos = pos;
>+#endif
>+}
>+
>if (offset != file_pos_read(file))
>                 file_pos_write(file, offset);
>
>Compile with:
>BITS_PER_LONG=32
>CONFIG_PREEMPT
>
>The code does:
>
>file_pos_read(...)
>preempt_disable
>....
>preempt_enable
>
>file_pos_write(...)
>preempt_disable
>....
>preempt_enable
>
>with the file_pos_update() the code does:
>
>preempt_disable
>...
>...
>preempt_enable
>
>Regards Michael
>

I think file_pos_update() with BITS_PER_LONG=32 && CONFIG_PREEMPT is easy,
this is like this.

static inline void file_pos_update(struct file *file, loff_t pos)
{
	preempt_disable();
	if (pos != file->f_pos)
		file->f_pos = pos;
	preempt_enable();
}


But I think BITS_PER_LONG=32 && CONFIG_SMP version has a problem, this is like this.

static inline void file_pos_update(struct file *file, loff_t pos)
{
	write_seqlock(&file->f_pos_seqlock);
	if (pos != file->f_pos)
		file->f_pos = pos;
	write_sequnlock(&file->f_pos_seqlock);
}

file_pos_update acquires seqlock only once, but write_seqlock is called whether file->f_pos
is overwritten or not.

