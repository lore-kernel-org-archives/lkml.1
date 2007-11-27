Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbXK0G4K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbXK0G4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 01:56:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751069AbXK0Gz5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 01:55:57 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51326 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751066AbXK0Gz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 01:55:56 -0500
Date: Mon, 26 Nov 2007 22:55:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utsns: Restore proper namespace handling.
Message-Id: <20071126225517.0245a86d.akpm@linux-foundation.org>
In-Reply-To: <20071126151917.GF547@sergelap.austin.ibm.com>
References: <m11wagpxw6.fsf@ebiederm.dsl.xmission.com>
	<20071126151917.GF547@sergelap.austin.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Nov 2007 09:19:17 -0600 "Serge E. Hallyn" <serue@us.ibm.com> wrote:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
> > 
> > When CONFIG_UTS_NS was removed it seems that we also deleted
> > the code for handling sysctls in the other then the initial
> > uts namespace.   This patch restores that code.
> > 
> > Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> 
> Thanks, Eric.
> 
> Acked-by: Serge Hallyn <serue@us.ibm.com>
> 
> > ---
> >  kernel/utsname_sysctl.c |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/utsname_sysctl.c b/kernel/utsname_sysctl.c
> > index c76c064..71f58c3 100644
> > --- a/kernel/utsname_sysctl.c
> > +++ b/kernel/utsname_sysctl.c
> > @@ -18,6 +18,8 @@
> >  static void *get_uts(ctl_table *table, int write)
> >  {
> >  	char *which = table->data;
> > +	struct uts_namespace *uts_ns = current->nsproxy->uts_ns;
> > +	which = (which - (char *)&init_uts_ns) + (char *)uts_ns;
> > 
> >  	if (!write)
> >  		down_read(&uts_sem);

I already have a (more codingstylely attractive) version of this from
Pavel, for which I shall steal your ack.

--- a/kernel/utsname_sysctl.c~isolate-the-uts-namespaces-domainname-and-hostname-back
+++ a/kernel/utsname_sysctl.c
@@ -18,6 +18,10 @@
 static void *get_uts(ctl_table *table, int write)
 {
 	char *which = table->data;
+	struct uts_namespace *uts_ns;
+
+	uts_ns = current->nsproxy->uts_ns;
+	which = (which - (char *)&init_uts_ns) + (char *)uts_ns;
 
 	if (!write)
 		down_read(&uts_sem);
_


Those pointer tricksies are revolting.  What's going on in there?
