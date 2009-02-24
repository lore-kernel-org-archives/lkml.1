Return-Path: <linux-kernel-owner+w=401wt.eu-S1761243AbZBXXXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761243AbZBXXXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Feb 2009 18:23:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754278AbZBXXXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Feb 2009 18:23:08 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:57523 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754256AbZBXXXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Feb 2009 18:23:05 -0500
Date: Tue, 24 Feb 2009 17:23:03 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, clg@fr.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.osdl.org
Subject: Re: [PATCH 4/4] mqueue namespace: adapt sysctl
Message-ID: <20090224232303.GA1435@us.ibm.com>
References: <20090224220256.GA31001@us.ibm.com> <20090224141651.70155ebd.akpm@linux-foundation.org> <20090224223245.GA17473@x200.localdomain> <20090224144800.4c7e3fcb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090224144800.4c7e3fcb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Wed, 25 Feb 2009 01:32:45 +0300
> Alexey Dobriyan <adobriyan@gmail.com> wrote:
> 
> > > > +proc_handler *proc_mq_dointvec = NULL;
> > > > +proc_handler *proc_mq_dointvec_minmax = NULL;
> > > > +#endif
> > > 
> > > looks odd.  Was this
> > > 
> > > --- a/ipc/mq_sysctl.c~mqueue-namespace-adapt-sysctl-update-fix
> > > +++ a/ipc/mq_sysctl.c
> > > @@ -52,8 +52,8 @@ static int proc_mq_dointvec_minmax(ctl_t
> > >  					lenp, ppos);
> > >  }
> > >  #else
> > > -proc_handler *proc_mq_dointvec = NULL;
> > > -proc_handler *proc_mq_dointvec_minmax = NULL;
> > > +#define proc_mq_dointvec NULL
> > > +#define proc_mq_dointvec_minmax NULL
> > >  #endif
> > 
> > I hope, not.
> > 
> > "#define foo NULL" is the least intrusive thing.
> 
> well the original code would have spat a warning at compile time
> then tried to execute code from BSS at runtime, methinks.
> 
> But I can't be assed working out how to disable CONFIG_SYSCTL to
> test that.  Gawd I hate `select'.

Yeah that's a pain...  but so I tested it with the below userspace
program before sending the patch and the 'if (myhandler)' check (which
is analogous to the check in proc_sys_call_handler) worked as expected.

thanks,
-serge

#include <stdio.h>

typedef int proc_handler (int a, int b);

#ifdef FOO
int myhandler(int a, int b) {
	printf("a was %d b was %d\n", a, b);
}
#else
proc_handler *myhandler = NULL;
#endif

int main()
{
	if (myhandler)
		myhandler(1, 2);
}
