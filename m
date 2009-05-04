Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbZEDNWv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbZEDNWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 09:22:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754668AbZEDNWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 09:22:41 -0400
Received: from vena.lwn.net ([206.168.112.25]:59546 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356AbZEDNWk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 09:22:40 -0400
Date: Mon, 4 May 2009 07:22:37 -0600
From: Jake Edge <jake@lwn.net>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>, Eric Paris <eparis@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Roland McGrath <roland@redhat.com>,
       mingo@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: avoid leaking eip, esp, or wchan to
 non-privileged processes (fwd)
Message-ID: <20090504072237.4045721f@chukar>
In-Reply-To: <m1r5z5jt63.fsf@fess.ebiederm.org>
References: <alpine.LRH.2.00.0905040917240.20251@tundra.namei.org>
	<m1r5z5jt63.fsf@fess.ebiederm.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 03 May 2009 23:09:24 -0700 Eric W. Biederman wrote:
> James Morris <jmorris@namei.org> writes:
> 
> > diff --git a/fs/proc/base.c b/fs/proc/base.c
> > index aa763ab..cd3c0d7 100644
> > --- a/fs/proc/base.c
> > +++ b/fs/proc/base.c
> > @@ -319,6 +319,9 @@ static int proc_pid_wchan(struct task_struct
> > *task, char *buffer)
> >  	unsigned long wchan;
> >  	char symname[KSYM_NAME_LEN];
> >
> > +	if (!ptrace_may_access(task, PTRACE_MODE_READ))
> > +		return 0;
> > +
> >  	wchan = get_wchan(task);
> >
> >  	if (lookup_symbol_name(wchan, symname) < 0)
> 
> If the symbol is in the kernel it should be safe to return it's
> name, all that is an information leak of a different sort.
> Overall I expect we should return  -EPERM here and not simply
> an empty file.

Ah, so if lookup_symbol_name() fails, it should return nothing or an
error?

This was "modeled" after the maps and smaps behavior, in that
they return an empty file if there is insufficient permission rather
than EPERM ... 

> Have you tested these patches against ps top and similar common
> tools?

both ps and top seem to operate just fine ... any of the default values
coming out of stat should be OK as they can be returned under other
circumstances ... the wchan file is a bit different, but it is not
clear to me what uses that rather than the wchan value in the stat file

thanks,

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
