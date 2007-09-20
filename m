Return-Path: <linux-kernel-owner+w=401wt.eu-S1757724AbXITGbx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757724AbXITGbx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2007 02:31:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbXITGbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Sep 2007 02:31:45 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53869 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750924AbXITGbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2007 02:31:44 -0400
Date: Wed, 19 Sep 2007 23:31:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andreas Herrmann <aherrman@arcor.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Eric Van Hensbergen <ericvh@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p: fix compile error if !CONFIG_SYSCTL
Message-Id: <20070919233110.18a057ac.akpm@linux-foundation.org>
In-Reply-To: <20070918080537.GA14882@devil>
References: <20070918080537.GA14882@devil>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 10:05:37 +0200 Andreas Herrmann <aherrman@arcor.de> wrote:

> Fix compile error if !CONFIG_SYSCTL:
> 
>     ...
>   LD      .tmp_vmlinux1
> net/built-in.o: In function `init_p9':
> net/9p/mod.c:59: undefined reference to `p9_sysctl_register'
> net/built-in.o: In function `exit_p9':
> net/9p/mod.c:75: undefined reference to `p9_sysctl_unregister'
> make: *** [.tmp_vmlinux1] Error 1
>     ...

A better fix would be

--- a/include/net/9p/9p.h~9p-fix-compile-error-if-config_sysctl
+++ a/include/net/9p/9p.h
@@ -412,6 +412,17 @@ int p9_idpool_check(int id, struct p9_id
 
 int p9_error_init(void);
 int p9_errstr2errno(char *, int);
+#ifdef CONFIG_SYSCTL
 int __init p9_sysctl_register(void);
 void __exit p9_sysctl_unregister(void);
+#else
+static inline int p9_sysctl_register(void)
+{
+	return 0;
+}
+
+static inline void p9_sysctl_unregister(void)
+{
+}
+
 #endif /* NET_9P_H */
diff -puN net/9p/mod.c~9p-fix-compile-error-if-config_sysctl net/9p/mod.c
_

I struggled for five minutes trying to work out how to make CONFIG_SYSCTL
go away and gave up in disgust.

God I hate select.

