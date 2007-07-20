Return-Path: <linux-kernel-owner+w=401wt.eu-S939667AbXGTBm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939667AbXGTBm6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2007 21:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764100AbXGTBmj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jul 2007 21:42:39 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:51381 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762916AbXGTBmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2007 21:42:38 -0400
Date: Thu, 19 Jul 2007 21:42:36 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Paul Mundt <lethal@linux-sh.org>,
       Tom Zanussi <zanussi@us.ibm.com>, Karim Yaghmour <karim@opersys.com>,
       Jesper Juhl <jesper.juhl@gmail.com>,
       "David J. Wilder" <wilder@us.ibm.com>
Subject: Re: [PATCH] Fix a use after free bug in kernel->userspace relay file support
Message-ID: <20070720014236.GA5836@Krystal>
References: <20070720010909.GA4298@Krystal> <20070719182952.5f437e64.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070719182952.5f437e64.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:42:12 up 2 days, 20:16,  2 users,  load average: 0.20, 0.18, 0.17
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Thu, 19 Jul 2007 21:09:09 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Coverity spotted what looks like a real possible case of using a 
> > variable after it has been freed.
> > The problem is in kernel/relay.c::relay_open_buf()
> > 
> > If the code hits "goto free_buf;" it ends up in this code :
> > 
> >   free_buf:
> >     	relay_destroy_buf(buf);	<--- calls kfree() on 'buf'.
> >   free_name:
> >    	kfree(tmpname);
> >   end:
> >   	return buf;		<-- use after free of 'buf'.
> > 
> > I read through the callers and they all handle a NULL return 
> > from this function as an error (and hitting the 'free_buf' label 
> > only happens on failure to chan->cb->create_buf_file(), so that 
> > looks like a clear error to me). 
> > 
> > The patch simply sets 'buf' to NULL after the call to 
> > relay_destroy_buf(buf); - as far as I can see that should take 
> > care of the problem.
> > 
> > The patch also corrects a reference to a documentation file while 
> > I was at it.
> > 
> > Note from Mathieu: the documentation reference change should have been
> > done in a separate patch, but I guess no one will really care.
> > 
> > Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
> > Acked-by: "David J. Wilder" <wilder@us.ibm.com>
> > Tested-by: "David J. Wilder" <wilder@us.ibm.com>
> > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> I'm going to infer from all this that the patch was actually written
> by Jesper.  Correct?
> 
> If so, it shuld have had From: Jesper Juhl <jesper.juhl@gmail.com>
> right at the start of the changelog.

Yes, it's the case. Thanks.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
