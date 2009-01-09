Return-Path: <linux-kernel-owner+w=401wt.eu-S1755685AbZAIMVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbZAIMVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 07:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752763AbZAIMVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 07:21:41 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46429 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752729AbZAIMVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 07:21:40 -0500
Date: Fri, 9 Jan 2009 13:21:30 +0100
From: Jiri Pirko <jpirko@redhat.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-audit@redhat.com,
       viro@zeniv.linux.org.uk, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: audit: EXECVE record - removed bogus newline
Message-ID: <20090109132130.0bc87c02@psychotron.englab.brq.redhat.com>
In-Reply-To: <1231428798.31089.80.camel@localhost.localdomain>
References: <20090108153829.7d063a4b@psychotron.englab.brq.redhat.com>
	<1231428798.31089.80.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Jan 2009 10:33:18 -0500
Eric Paris <eparis@redhat.com> wrote:

> On Thu, 2009-01-08 at 15:38 +0100, Jiri Pirko wrote:
> > EXECVE records contain a newline after every argument. auditd converts
> > "\n" to " " so you cannot see newlines even in raw logs, but they're
> > there nevertheless. If you're not using auditd, you need to work round
> > them. These '\n' chars are can be easily replaced by spaces when
> > creating record in kernel. Note there is no need for trailing '\n' in
> > an audit record. 
> 
> While I completely agree the \n was my mistake and should be
> dropped/fixed can you fix one more thing and look at another?  First
> arg_num_len is being miscalculated since I included the \n in that
> calculation (might be the only place....)
I think that calculation is correct only the comment needs to be changed like this:
-       /* how many digits are in arg_num? 3 is the length of a=\n */
+       /* how many digits are in arg_num? 3 is the length of " a=" */

the count is still 3 - with '\n' or with ' '.


> and I remember not wanting to
> follow convention and put the space at the beginning of the aX= for some
> reason.  If you add thousands of arguments so this is larger than
> MAX_EXECVE_AUDIT_LEN do you end up with an extra space somewhere in the
> second EXECVE record? 
Is this a problem? We can do some workaround but is it necessary?
> Or maybe it was a single argument that was larger
> than the max
This would do the same thing (leading space in record).
> , can't remember which, but I do remember having a random
> extra space (maybe we'd rather have that for consistency?)
Yes that's right - the space might be good if userspace client just
concatenates two records, the space should be good to be there. But I'm
unable to judge this. What do others think?

Jirka
> 
> -Eric
> 
> > 
> > record before this patch:
> > "type=EXECVE msg=audit(1231421801.566:31): argc=4 a0=\"./test\"\na1=\"a\"\na2=\"b\"\na3=\"c\"\n"
> > 
> > record after this patch:
> > "type=EXECVE msg=audit(1231421801.566:31): argc=4 a0=\"./test\" a1=\"a\" a2=\"b\" a3=\"c\""
> > 
> > 
> > Signed-off-by: Jiri Pirko <jpirko@redhat.com>
> > ---
> >  kernel/auditsc.c |    7 +++----
> >  1 files changed, 3 insertions(+), 4 deletions(-)
> > 
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index 8cbddff..c7012e0 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -1109,7 +1109,7 @@ static int audit_log_single_execve_arg(struct audit_context *context,
> >  		 * so we can be sure nothing was lost.
> >  		 */
> >  		if ((i == 0) && (too_long))
> > -			audit_log_format(*ab, "a%d_len=%zu ", arg_num,
> > +			audit_log_format(*ab, " a%d_len=%zu", arg_num,
> >  					 has_cntl ? 2*len : len);
> >  
> >  		/*
> > @@ -1129,7 +1129,7 @@ static int audit_log_single_execve_arg(struct audit_context *context,
> >  		buf[to_send] = '\0';
> >  
> >  		/* actually log it */
> > -		audit_log_format(*ab, "a%d", arg_num);
> > +		audit_log_format(*ab, " a%d", arg_num);
> >  		if (too_long)
> >  			audit_log_format(*ab, "[%d]", i);
> >  		audit_log_format(*ab, "=");
> > @@ -1137,7 +1137,6 @@ static int audit_log_single_execve_arg(struct audit_context *context,
> >  			audit_log_n_hex(*ab, buf, to_send);
> >  		else
> >  			audit_log_format(*ab, "\"%s\"", buf);
> > -		audit_log_format(*ab, "\n");
> >  
> >  		p += to_send;
> >  		len_left -= to_send;
> > @@ -1165,7 +1164,7 @@ static void audit_log_execve_info(struct audit_context *context,
> >  
> >  	p = (const char __user *)axi->mm->arg_start;
> >  
> > -	audit_log_format(*ab, "argc=%d ", axi->argc);
> > +	audit_log_format(*ab, "argc=%d", axi->argc);
> >  
> >  	/*
> >  	 * we need some kernel buffer to hold the userspace args.  Just
> 
> 
