Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbXGQM6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbXGQM6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 08:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbXGQM62
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 08:58:28 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:36664 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbXGQM62 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 08:58:28 -0400
Date: Tue, 17 Jul 2007 16:57:36 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: Ingo Molnar <mingo@elte.hu>
Cc: akpm@osdl.org, Thomas Gleixner <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, devel@openvz.org, stable@kernel.org
Subject: [PATCH] Fix leak on /proc/lockdep_stats
Message-ID: <20070717125736.GE25083@localhost.sw.ru>
References: <20070717122511.GD25083@localhost.sw.ru> <20070717123511.GB17657@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070717123511.GB17657@elte.hu>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2007 at 02:36:10PM +0200, Ingo Molnar wrote:
> * Alexey Dobriyan <adobriyan@sw.ru> wrote:
> 
> > On every open/close one struct seq_operations leaks.
> > Kudos to /proc/slab_allocators.
> > 
> > Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> 
> ouch ...
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>
> 
> -stable material too, as far as timer_info/stats goes.
>
> > -       .release        = seq_release,
> > +       .release        = single_release,
>
> i think seq_release() definitely needs to grow a WARN_ON() if it's being
> used on an inode that was opened via single_open(). This bug is so
> easily committed, and nothing but a small leak reminds us on it.

Yeah, I'll try to come up with something clean.

Meanwhile full single_open() audit revealed one more such leak.
The rest seems OK.

[PATCH] Fix leak on /proc/lockdep_stats

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 kernel/lockdep_proc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/lockdep_proc.c
+++ b/kernel/lockdep_proc.c
@@ -339,7 +339,7 @@ static const struct file_operations proc_lockdep_stats_operations = {
 	.open		= lockdep_stats_open,
 	.read		= seq_read,
 	.llseek		= seq_lseek,
-	.release	= seq_release,
+	.release	= single_release,
 };
 
 static int __init lockdep_proc_init(void)

