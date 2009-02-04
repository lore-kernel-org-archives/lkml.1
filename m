Return-Path: <linux-kernel-owner+w=401wt.eu-S1755810AbZBDMGW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810AbZBDMGW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 07:06:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751057AbZBDMGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 07:06:14 -0500
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42837 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750837AbZBDMGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 07:06:12 -0500
Date: Wed, 4 Feb 2009 07:05:49 -0500
From: Neil Horman <nhorman@tuxdriver.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Simon Horman <horms@verge.net.au>, hbabu@us.ibm.com,
       kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
       Eric Biederman <ebiederm@xmision.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH]: add dmesg log symbols to /proc/vmcoreinfo lists
Message-ID: <20090204120549.GA2182@hmsreliant.think-freely.org>
References: <20090119212127.GA13157@hmsreliant.think-freely.org> <20090120141551.GA5125@redhat.com> <20090120150958.GB18207@hmsreliant.think-freely.org> <20090120152255.GB5125@redhat.com> <20090127001211.f847ea5a.akpm@linux-foundation.org> <20090128041109.GA4943@verge.net.au> <m1ljsnz1up.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ljsnz1up.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> That aside we aren't currently exporting log_buf_len, so I don't
> think this code works actually works.
> 
> Neil can you add a comment in kernel/printk.c of the algorithm
> necessary for external tools to decode the ring buffer?
> 
> We need the comment because people working on kernel/printk.c
> need to know what is happening and without having to review lots
> of user space code, and we need the comment to verify that we
> are exporting the right things.
> 

Ok, as per Erics comment, I've written this.  It applies on top of whats already
in your tree Andrew.  It adds some comments on the function in question so that
anyone working on printk.c will know why we're exporting their symbols.  It also
modifies slightly the symbols we are exporting so that we can handle dmesg
buffers that are longer than the standard PAGE_SIZE configuration, and lets us
detect and handle buffer wraps.

Thanks!

printk.c |   12 +++++++++++-
1 file changed, 11 insertions(+), 1 deletion(-)

Signed-off-by: Neil Horman <nhorman@tuxdriver.com>

diff --git a/kernel/printk.c b/kernel/printk.c
index dd5cc7b..6a1163b 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -138,10 +138,20 @@ static int log_buf_len = __LOG_BUF_LEN;
 static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
 
 #ifdef CONFIG_KEXEC
+/*
+ * This appends the listed symbols to /proc/vmcoreinfo
+ * /proc/vmcoreinfo is used by various utiilties, like
+ * crash and makedumpfile to obtain access to symbols that
+ * are otherwise very difficult to locate.  These symbols 
+ * are specifically used so that utilities 
+ * can access and extract the dmesg log from a vmcore file
+ * after a crash
+ */
 void log_buf_kexec_setup(void)
 {
 	VMCOREINFO_SYMBOL(log_buf);
-	VMCOREINFO_SYMBOL(log_end);
+	VMCOREINFO_SYMBOL(log_buf_len);
+	VMCOREINFO_SYMBOL(logged_chars)
 }
 #endif
 
