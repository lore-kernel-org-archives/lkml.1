Return-Path: <linux-kernel-owner+w=401wt.eu-S937828AbZAPWCe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937828AbZAPWCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 17:02:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764184AbZAPWCW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 17:02:22 -0500
Received: from relay3.sgi.com ([192.48.171.31]:43354 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1764005AbZAPWCV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 17:02:21 -0500
Message-ID: <497103EA.9020704@sgi.com>
Date: Fri, 16 Jan 2009 14:02:18 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>
CC: Ingo Molnar <mingo@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Dean Nelson <dcn@sgi.com>, Robert Richter <robert.richter@amd.com>,
       oprofile-list@lists.sf.net
Subject: Re: [PATCH 3/5] cpumask: convert misc driver functions
References: <20090107195832.265117000@polaris-admin.engr.sgi.com>	 <20090107195832.733912000@polaris-admin.engr.sgi.com> <12c511ca0901161042x5aab46edy70d0d89c84792cd9@mail.gmail.com>
In-Reply-To: <12c511ca0901161042x5aab46edy70d0d89c84792cd9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony Luck wrote:
> +void __exit buffer_sync_cleanup(void)
> +{
> +	free_cpumask_var(marked_cpus);
> +}
> 
> This breaks ia64 with CONFIG_OPROFILE=y
> 
> `buffer_sync_cleanup' referenced in section `.init.text' of
> arch/ia64/oprofile/built-in.o: defined in discarded section
> `.exit.text' of arch/ia64/oprofile/built-in.o
> make: *** [.tmp_vmlinux1] Error 1
> 
> -Tony

Hi,

It's a bit hackish but I couldn't think of another workaround.
And curiously, it doesn't affect x86?

Also, CPUMASK_OFFSTACK=n for ia64 so this is really a nop.
(I haven't been able to turn it on for ia64.)

Thanks,
Mike
--- 

Subject: ia64: fix build error when OPROFILE enabled.

Impact: Fix build error.

Add a buffer_sync_cleanup_init() which duplicates the
buffer_sync_cleanup() function but is placed in the
.init.text section.  This eliminates this build error:

`buffer_sync_cleanup' referenced in section `.init.text' of
arch/ia64/oprofile/built-in.o: defined in discarded section
`.exit.text' of arch/ia64/oprofile/built-in.o

Signed-off-by: Mike Travis <travis@sgi.com>
Cc: Tony Luck <tony.luck@gmail.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: <oprofile-list@lists.sf.net>
---
 drivers/oprofile/buffer_sync.c |    6 ++++++
 drivers/oprofile/buffer_sync.h |    1 +
 drivers/oprofile/oprof.c       |    2 +-
 3 files changed, 8 insertions(+), 1 deletion(-)

--- linux-2.6-for-ingo.orig/drivers/oprofile/buffer_sync.c
+++ linux-2.6-for-ingo/drivers/oprofile/buffer_sync.c
@@ -579,6 +579,12 @@ void __exit buffer_sync_cleanup(void)
 	free_cpumask_var(marked_cpus);
 }
 
+/* same as above but in the __init section */
+void __init buffer_sync_cleanup_init(void)
+{
+	free_cpumask_var(marked_cpus);
+}
+
 /* The function can be used to add a buffer worth of data directly to
  * the kernel buffer. The buffer is assumed to be a circular buffer.
  * Take the entries from index start and end at index end, wrapping
--- linux-2.6-for-ingo.orig/drivers/oprofile/buffer_sync.h
+++ linux-2.6-for-ingo/drivers/oprofile/buffer_sync.h
@@ -22,5 +22,6 @@ void sync_buffer(int cpu);
 /* initialize/destroy the buffer system. */
 int buffer_sync_init(void);
 void buffer_sync_cleanup(void);
+void buffer_sync_cleanup_init(void);
 
 #endif /* OPROFILE_BUFFER_SYNC_H */
--- linux-2.6-for-ingo.orig/drivers/oprofile/oprof.c
+++ linux-2.6-for-ingo/drivers/oprofile/oprof.c
@@ -197,7 +197,7 @@ static int __init oprofile_init(void)
 	err = oprofilefs_register();
 	if (err) {
 		oprofile_arch_exit();
-		buffer_sync_cleanup();
+		buffer_sync_cleanup_init();
 	}
 
 	return err;
