Return-Path: <linux-kernel-owner+w=401wt.eu-S1757873AbXJ2QCi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873AbXJ2QCi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 12:02:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbXJ2QCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 12:02:30 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:53068 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbXJ2QC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 12:02:29 -0400
Subject: Re: [PATCH] pidns: Limit kill -1 and cap_set_all
From: Dave Hansen <haveblue@us.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org,
       Linux Containers <containers@lists.osdl.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Pavel Emelyanov <xemul@openvz.org>,
       "Sukadev Bhattiprolu [imap]" <sukadev@us.ibm.com>
In-Reply-To: <m1k5p9zk6b.fsf_-_@ebiederm.dsl.xmission.com>
References: <m1y7dp22d4.fsf@ebiederm.dsl.xmission.com>
	 <alpine.LFD.0.999.0710261105440.30120@woody.linux-foundation.org>
	 <m1r6jhzmov.fsf_-_@ebiederm.dsl.xmission.com>
	 <m1k5p9zk6b.fsf_-_@ebiederm.dsl.xmission.com>
Content-Type: text/plain
Date: Mon, 29 Oct 2007 09:02:18 -0700
Message-Id: <1193673738.24087.176.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-10-26 at 14:37 -0600, Eric W. Biederman wrote:
> 
> +static int pid_in_pid_ns(struct pid *pid, struct pid_namespace *ns)
> +{
> +       return pid && (ns->level <= pid->level) &&
> +               pid->numbers[ns->level].ns == ns;
> +}

Could we blow this out a little bit?  (I think the blown-out version
lends itself to being better commented, and easier to read.)  Also, can
we think of any better name for this?  It seems a bit funky that:

	pid_in_pid_ns(mypid, &init_pid_ns);

would _ever_ return 0.  So, it isn't truly a test for belonging *in* a
namespace, but having that namespace be the lowest level one.  I think
Suka toyed with calling it an "active" or "primary" pid namespace.  That
differentiated mere membership in a pid namespace from the one that
actually molds that pid's view of the world.

static int pid_in_pid_ns(struct pid *pid, struct pid_namespace *ns)
{
	if (!pid)
		return 0;
	if (ns->level > pid->level)
		return 0;
	if (pid->numbers[ns->level].ns != ns)
		return 0;
	return 1;
}

-- Dave

