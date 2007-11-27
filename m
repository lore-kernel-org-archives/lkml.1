Return-Path: <linux-kernel-owner+w=401wt.eu-S1758784AbXK0Q2m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784AbXK0Q2m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 11:28:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756876AbXK0Q2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 11:28:35 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:41338 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753570AbXK0Q2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 11:28:34 -0500
Date: Tue, 27 Nov 2007 10:28:32 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utsns: Restore proper namespace handling.
Message-ID: <20071127162832.GE32362@sergelap.austin.ibm.com>
References: <m11wagpxw6.fsf@ebiederm.dsl.xmission.com> <20071126151917.GF547@sergelap.austin.ibm.com> <20071126225517.0245a86d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071126225517.0245a86d.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Mon, 26 Nov 2007 09:19:17 -0600 "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> 
> > Quoting Eric W. Biederman (ebiederm@xmission.com):
> > > 
> > > When CONFIG_UTS_NS was removed it seems that we also deleted
> > > the code for handling sysctls in the other then the initial
> > > uts namespace.   This patch restores that code.
> > > 
> > > Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> > 
> > Thanks, Eric.
> > 
> > Acked-by: Serge Hallyn <serue@us.ibm.com>
> > 
> > > ---
> > >  kernel/utsname_sysctl.c |    2 ++
> > >  1 files changed, 2 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/kernel/utsname_sysctl.c b/kernel/utsname_sysctl.c
> > > index c76c064..71f58c3 100644
> > > --- a/kernel/utsname_sysctl.c
> > > +++ b/kernel/utsname_sysctl.c
> > > @@ -18,6 +18,8 @@
> > >  static void *get_uts(ctl_table *table, int write)
> > >  {
> > >  	char *which = table->data;
> > > +	struct uts_namespace *uts_ns = current->nsproxy->uts_ns;
> > > +	which = (which - (char *)&init_uts_ns) + (char *)uts_ns;
> > > 
> > >  	if (!write)
> > >  		down_read(&uts_sem);
> 
> I already have a (more codingstylely attractive) version of this from
> Pavel, for which I shall steal your ack.

Cool, thanks.

> --- a/kernel/utsname_sysctl.c~isolate-the-uts-namespaces-domainname-and-hostname-back
> +++ a/kernel/utsname_sysctl.c
> @@ -18,6 +18,10 @@
>  static void *get_uts(ctl_table *table, int write)
>  {
>  	char *which = table->data;
> +	struct uts_namespace *uts_ns;
> +
> +	uts_ns = current->nsproxy->uts_ns;
> +	which = (which - (char *)&init_uts_ns) + (char *)uts_ns;
> 
>  	if (!write)
>  		down_read(&uts_sem);
> _
> 
> 
> Those pointer tricksies are revolting.  What's going on in there?

This is true.  There is only one sysctl table, and it's data points
to the location of the desired field in the initial namespace.  So
the trickery finds the same field in the target namespace.

I believe Eric and Pavel are working on a patchset that will make
this trickery unnecessary by having sort of shadow sysctls.

-serge
