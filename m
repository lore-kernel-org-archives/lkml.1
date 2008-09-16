Return-Path: <linux-kernel-owner+w=401wt.eu-S1755318AbYIPO53@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318AbYIPO53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 10:57:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbYIPO5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 10:57:19 -0400
Received: from web26206.mail.ukl.yahoo.com ([217.12.10.243]:23376 "HELO
	web26206.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753826AbYIPO5R convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 10:57:17 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=mbajPEGC83ecqyKq+4lYNOSXuwsCTlUy+Fpzlee0Lb+IKKMHcoerUl+OzQzQXct55/c4L0z8jp+0toifWsp8ONm0S08abkkcV2M43gfVYSzSfjMFTPjlEkmR0N1oLSNN8kGU/QM6yR+RNnDI7eioUleig5+c3bDrK5QxQtDdZVg=;
X-YMail-OSG: bGzXV70VM1kEQpJppOe33FISeexChmBfq6laER3bd_ByHAVlVXInGwdJkiZjkzQSgg--
X-Mailer: YahooMailRC/1096.28 YahooMailWebService/0.7.218.2
Date: Tue, 16 Sep 2008 14:57:16 +0000 (GMT)
From: Michael Trimarchi <trimarchimichael@yahoo.it>
Subject: Re: [PATCH] VFS: make file->f_pos access atomic on 32bit arch
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <84867.22024.qm@web26206.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

----- Messaggio originale -----
> Da: Nick Piggin <nickpiggin@yahoo.com.au>
> A: Michael Trimarchi <trimarchimichael@yahoo.it>
>
Cc: Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>;
akpm@linux-foundation.org; linux-kernel@vger.kernel.org;
linux-fsdevel@vger.kernel.org
> Inviato: Martedì 16 settembre 2008, 16:11:21
> Oggetto: Re: [PATCH] VFS: make file->f_pos access atomic on 32bit arch
> 
...
> >  i was thinking about introducing a file_pos_update() not implemented using
> > file_pos_read()/file_pos_write() and taking the seq_lock or
> > disabling preemption only one time
> 
> AFAIK, the only way to do an atomic 64 bit store on 32-bit x86 is
> "cmpxchg8b" (with lock prefix on SMP). That would be far slower
> I'm sure.

Maybe it is clear with an example:
 
+/*
+ * file_pos_read/write is atomic by using sequence lock on 32bit arch.
+ */
+static inline loff_t file_pos_read(struct file *file)
+{
+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
+	loff_t pos;
+	unsigned int seq;
+
+	do {
+		seq = read_seqbegin(&file->f_pos_seqlock);
+		pos = file->f_pos;
+	} while (read_seqretry(&file->f_pos_seqlock, seq));
+	return pos;
+#elif BITS_PER_LONG == 32 && defined(CONFIG_PREEMPT)
+	loff_t pos;
+
+	preempt_disable();
+	pos = file->f_pos;
+	preempt_enable();
+	return pos;
+#else
+	return file->f_pos;
+#endif
+}
+
+static inline void file_pos_write(struct file *file, loff_t pos)
+{
+#if BITS_PER_LONG == 32 && defined(CONFIG_SMP)
+	write_seqlock(&file->f_pos_seqlock);
+	file->f_pos = pos;
+	write_sequnlock(&file->f_pos_seqlock);
+#elif BITS_PER_LONG == 32 && defined(CONFIG_PREEMPT)
+	preempt_disable();
+	file->f_pos = pos;
+	preempt_enable();
+#else
+	file->f_pos = pos;
+#endif
+}
+
if (offset != file_pos_read(file))
                 file_pos_write(file, offset);

Compile with:
BITS_PER_LONG=32
CONFIG_PREEMPT

The code does:

file_pos_read(...)
preempt_disable
....
preempt_enable

file_pos_write(...)
preempt_disable
....
preempt_enable

with the file_pos_update() the code does:

preempt_disable
...
...
preempt_enable

Regards Michael

__________________________________________________
Do You Yahoo!?
Poco spazio e tanto spam? Yahoo! Mail ti protegge dallo spam e ti da tanto spazio gratuito per i tuoi file e i messaggi 
http://mail.yahoo.it 
