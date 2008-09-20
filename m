Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187AbYITPCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187AbYITPCA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 11:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751276AbYITPBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 11:01:52 -0400
Received: from mx2.redhat.com ([66.187.237.31]:34851 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbYITPBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 11:01:51 -0400
Date: Sat, 20 Sep 2008 17:01:44 +0200
From: Jiri Pirko <jpirko@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] audit: removed bogus newline
Message-ID: <20080920170144.3ac76176@psychotron.englab.brq.redhat.com>
In-Reply-To: <20080919143847.0589646f.akpm@linux-foundation.org>
References: <20080919165146.0aa2ab80@psychotron.englab.brq.redhat.com>
	<20080919143847.0589646f.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Sep 2008 14:38:47 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Fri, 19 Sep 2008 16:51:46 +0200
> Jiri Pirko <jpirko@redhat.com> wrote:
> 
> > Hi.
> > 
> > PATH records, as output by the kernel, contain a newline after the
> > flags fields, which is in the middle of the record. EXECVE records
> > contain a newline after every argument. auditd seems to hide this,
> > but they're there nevertheless. If you're not using auditd, you
> > need to work round them.
> > 
> > What do you think about it?
> > 
> 
> It would be easier to understand your proposal if you were to include
> before- and after- samples of the log record.
> 
record before:
"argc=4 a0=\"./test\"\na1=\"a\"\na2=\"b\"\na3=\"c\"\n"

record after:
"argc=4 a0=\"./test\" a1=\"a\" a2=\"b\" a3=\"c\" "

auditd converts "\n" to " ". But if you are reading this directly, you must
count with it. These "\n" are completely worthless and do not appear in any
other type of audit records.

To be 100% correct here comes the patch that replaces previous. This removes
also the space on the very end of the record:


Signed-off-by: Jiri Pirko <jpirko@redhat.com>

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 59cedfb..f6c7f09 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1111,6 +1111,8 @@ static int audit_log_single_execve_arg(struct audit_context *context,
 		buf[to_send] = '\0';
 
 		/* actually log it */
+		if (arg_num)
+			audit_log_format(*ab, " ");
 		audit_log_format(*ab, "a%d", arg_num);
 		if (too_long)
 			audit_log_format(*ab, "[%d]", i);
@@ -1119,7 +1121,6 @@ static int audit_log_single_execve_arg(struct audit_context *context,
 			audit_log_n_hex(*ab, buf, to_send);
 		else
 			audit_log_format(*ab, "\"%s\"", buf);
-		audit_log_format(*ab, "\n");
 
 		p += to_send;
 		len_left -= to_send;

> 
> > 
> > 
> > Signed-off-by: Jiri Pirko <jpirko@redhat.com>
> > 
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index 59cedfb..bf10cb0 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -1119,7 +1119,7 @@ static int audit_log_single_execve_arg(struct audit_context *context,
> >  			audit_log_n_hex(*ab, buf, to_send);
> >  		else
> >  			audit_log_format(*ab, "\"%s\"", buf);
> > -		audit_log_format(*ab, "\n");
> > +		audit_log_format(*ab, " ");
> >  
> >  		p += to_send;
> >  		len_left -= to_send;
> 
> Is no newline needed after this loop has terminated?
No newline is not needed on the end.
