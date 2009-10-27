Return-Path: <linux-kernel-owner+w=401wt.eu-S1754281AbZJ0WZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281AbZJ0WZY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Oct 2009 18:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753994AbZJ0WZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Oct 2009 18:25:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:8006 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907AbZJ0WZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Oct 2009 18:25:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,635,1249282800"; 
   d="scan'208";a="204395209"
Subject: Re: [PATCH] [GIT PULL] tracing: allow to change permissions for
 text with dynamic ftrace enabled
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "rostedt@goodmis.org" <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <1256679318.26028.468.camel@gandalf.stny.rr.com>
References: <1256666023.26028.411.camel@gandalf.stny.rr.com>
	 <1256671227.2691.15.camel@sbs-t61.sc.intel.com>
	 <1256668438.26028.414.camel@gandalf.stny.rr.com>
	 <1256682364.2691.33.camel@sbs-t61.sc.intel.com>
	 <1256679318.26028.468.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Tue, 27 Oct 2009 15:23:46 -0800
Message-Id: <1256685826.15873.41.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-10-27 at 14:35 -0700, Steven Rostedt wrote: 
> On Tue, 2009-10-27 at 14:26 -0800, Suresh Siddha wrote:
> >  
> > +	/*
> > +	 * On x86_64, we use the kernel identity mapping instead of the
> > +	 * kernel text mapping to modify the kernel text. This is a nop
> > +	 * for 32bit kernels.
> > +	 */
> 
> Is it really a nop on 32bit? Does it just turn into ip = ip?

Yes. it will be ip = ip for 32bit.

> > +	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
> > +		ip = (unsigned long)__va(__pa(ip));
> > +
> >  	/* replace the text with the new text */
> >  	if (do_ftrace_mod_code(ip, new_code))
> >  		return -EPERM;
> 
> I'll test it out, and if it does work, you can write up a formal patch
> and remove the !define that I added.

I just saw one more place calling do_ftrace_mod_code(). So moved this
check inside the do_ftrace_mod_code(). Does this cover all the cases?
Thanks.

diff --git a/arch/x86/kernel/ftrace.c b/arch/x86/kernel/ftrace.c
index 5a1b975..e239fd7 100644
--- a/arch/x86/kernel/ftrace.c
+++ b/arch/x86/kernel/ftrace.c
@@ -189,9 +189,23 @@ static void wait_for_nmi(void)
 	nmi_wait_count++;
 }
 
+static inline int
+within(unsigned long addr, unsigned long start, unsigned long end)
+{
+	return addr >= start && addr < end;
+}
+
 static int
 do_ftrace_mod_code(unsigned long ip, void *new_code)
 {
+	/*
+	 * On x86_64, we use the kernel identity mapping instead of the
+	 * kernel text mapping to modify the kernel text. For 32bit kernels,
+	 * these mappings are same.
+	 */
+	if (within(ip, (unsigned long)_text, (unsigned long)_etext))
+		ip = (unsigned long)__va(__pa(ip));
+
 	mod_code_ip = (void *)ip;
 	mod_code_newcode = new_code;
 




