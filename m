Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbXIRTX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbXIRTX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 15:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755049AbXIRTXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 15:23:47 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:42141 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382AbXIRTXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 15:23:46 -0400
X-Greylist: delayed 1817 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Sep 2007 15:23:46 EDT
Message-ID: <46F01E9F.3010307@tiscali.nl>
Date: Tue, 18 Sep 2007 20:53:19 +0200
From: roel <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Andreas Herrmann <aherrman@arcor.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Van Hensbergen <ericvh@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] 9p: fix compile error if !CONFIG_SYSCTL
References: <20070918080537.GA14882@devil>
In-Reply-To: <20070918080537.GA14882@devil>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Herrmann wrote:
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
> 
> Signed-off-by: Andreas Herrmann <aherrman@arcor.de>
> ---
>  include/net/9p/9p.h |    4 ++++
>  net/9p/mod.c        |    4 ++++
>  2 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
> index 88884d3..f723a03 100644
> --- a/include/net/9p/9p.h
> +++ b/include/net/9p/9p.h
> @@ -412,6 +412,10 @@ int p9_idpool_check(int id, struct p9_idpool *p);
>  
>  int p9_error_init(void);
>  int p9_errstr2errno(char *, int);
> +
> +#ifdef CONFIG_SYSCTL
>  int __init p9_sysctl_register(void);
>  void __exit p9_sysctl_unregister(void);
> +#endif
> +
>  #endif /* NET_9P_H */
> diff --git a/net/9p/mod.c b/net/9p/mod.c
> index 4f9e1d2..b4d435c 100644
> --- a/net/9p/mod.c
> +++ b/net/9p/mod.c
> @@ -56,11 +56,13 @@ static int __init init_p9(void)
>  		return ret;
>  	}
>  
> +#ifdef CONFIG_SYSCTL
>  	ret = p9_sysctl_register();
>  	if (ret) {
>  		printk(KERN_WARNING "9p: registering sysctl failed\n");
>  		return ret;
>  	}
> +#endif
>  
>  	return ret;
>  }
> @@ -72,7 +74,9 @@ static int __init init_p9(void)
>  
>  static void __exit exit_p9(void)
>  {
> +#ifdef CONFIG_SYSCTL
>  	p9_sysctl_unregister();
> +#endif
>  	p9_mux_global_exit();
>  }
>  
isn't it nicer to do something like this instead?
diff --git a/net/9p/sysctl.c b/net/9p/sysctl.c
index 8b61027..e199865 100644
--- a/net/9p/sysctl.c
+++ b/net/9p/sysctl.c
@@ -68,14 +68,17 @@ static struct ctl_table_header *p9_table_header;
 
 int __init p9_sysctl_register(void)
 {
+#ifdef CONFIG_SYSCTL
 	p9_table_header = register_sysctl_table(p9_ctl_table);
 	if (!p9_table_header)
 		return -ENOMEM;
-
+#endif
 	return 0;
 }
 
 void __exit p9_sysctl_unregister(void)
 {
+#ifdef CONFIG_SYSCTL
 	 unregister_sysctl_table(p9_table_header);
+#endif
 }
