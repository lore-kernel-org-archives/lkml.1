Return-Path: <linux-kernel-owner+w=401wt.eu-S1756085AbZIKTUL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085AbZIKTUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 15:20:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755918AbZIKTUJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 15:20:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38114 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755905AbZIKTUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 15:20:08 -0400
Subject: Re: [PATCHv3 3/3] [PATCHv3 3/3] tracing - trace parser support for
 set_graph_function set_ftrace_filter set_ftrace_notrace
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: jolsa@redhat.com
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <1252682969-3366-4-git-send-email-jolsa@redhat.com>
References: <1252682969-3366-1-git-send-email-jolsa@redhat.com>
	 <1252682969-3366-4-git-send-email-jolsa@redhat.com>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Fri, 11 Sep 2009 15:20:10 -0400
Message-Id: <1252696810.18996.733.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nit - fix your scripts again. The subject duplicates the [PATCHv3 3/3].

On Fri, 2009-09-11 at 17:29 +0200, jolsa@redhat.com wrote:

> Fixed minor in set_graph_function display - g_show function.

> @@ -2499,7 +2456,7 @@ static int g_show(struct seq_file *m, void *v)
>  		return 0;
>  	}
>  
> -	seq_printf(m, "%pf\n", v);
> +	seq_printf(m, "%p\n", (void *) *ptr);
>  
>  	return 0;
>  }


I changed this, because it has a bug itself. You just changed the way
set_graph_function works.

It use to do:

# echo sys_open > set_graph_function
# cat set_graph_function
sys_open

After this change, it does

# echo sys_open > set_graph_function
# cat set_graph_function
ffffffff811020d0

Which is not very helpful.

But, you did catch a bug. Another clean up patch, made it from *ptr to
v, which is wrong. Half that change is correct ;-)

Thus I modified this patch with the following change:

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7d68163..8b23d56 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2456,7 +2456,7 @@ static int g_show(struct seq_file *m, void *v)
 		return 0;
 	}
 
-	seq_printf(m, "%p\n", (void *) *ptr);
+	seq_printf(m, "%pf\n", (void *)*ptr);
 
 	return 0;
 }


-- Steve


