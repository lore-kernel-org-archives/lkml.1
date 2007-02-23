Return-Path: <linux-kernel-owner+w=401wt.eu-S932378AbXBWOFx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbXBWOFx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 09:05:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932375AbXBWOFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 09:05:53 -0500
Received: from zombie.ncsc.mil ([144.51.88.131]:61066 "EHLO jazzdrum.ncsc.mil"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932378AbXBWOFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 09:05:52 -0500
Subject: [patch 1/1] selinux:  always initialize arguments to
	security_sid_to_context (Was: Re: [GIT PULL] audit patches)
From: Stephen Smalley <sds@tycho.nsa.gov>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: viro@ftp.linux.org.uk, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, sgrubb@redhat.com, jmorris@namei.org
In-Reply-To: <20070222131931.1ed6ffa4.akpm@linux-foundation.org>
References: <20070218040127.GA5422@ftp.linux.org.uk>
	 <20070221160319.6de08b64.akpm@linux-foundation.org>
	 <1172150567.14363.337.camel@moss-spartans.epoch.ncsc.mil>
	 <20070222131931.1ed6ffa4.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: National Security Agency
Date: Fri, 23 Feb 2007 09:00:18 -0500
Message-Id: <1172239218.19041.22.camel@moss-spartans.epoch.ncsc.mil>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-1.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-02-22 at 13:19 -0800, Andrew Morton wrote:
> > On Thu, 22 Feb 2007 08:22:47 -0500 Stephen Smalley <sds@tycho.nsa.gov> wrote:
> > On Wed, 2007-02-21 at 16:03 -0800, Andrew Morton wrote:
> > > 
> > > Looking at the changes to audit_receive_msg():
> > > 
> > > 
> > > 				if (sid) {
> > > 					if (selinux_sid_to_string(
> > > 							sid, &ctx, &len)) {
> > > 						audit_log_format(ab,
> > > 							" ssid=%u", sid);
> > > 						/* Maybe call audit_panic? */
> > > 					} else
> > > 						audit_log_format(ab,
> > > 							" subj=%s", ctx);
> > > 					kfree(ctx);
> > > 				}
> > > 
> > > This is assuming that selinux_sid_to_string() always initialises `ctx'.
> > > 
> > > But AFAICT there are two error paths in security_sid_to_context() which
> > > forget to do that, so we end up doing kfree(uninitialised-local).
> > > 
> > > I'd consider that a shortcoming in security_sid_to_context(), so not a
> > > problem in this patch, as long as people agree with my blaming above.
> > 
> > I wouldn't assume that the function initializes an argument if it
> > returns an error, and at least some of the callers (in auditsc.c) appear
> > to correctly initialize ctx to NULL themselves before calling
> > selinux_sid_to_string().  But if you'd prefer the function to always
> > handle it, we can do that.
> > 
> 
> Well we now have (at least) one caller which assumes that *ctx is
> initialied in error cases.
> 
> And I think it's sane to make it do that: safer, and will simplify coding
> in the callers.

Ok, patch below.

Always initialize *scontext and *scontext_len in security_sid_to_context.

Signed-off-by:  Stephen Smalley <sds@tycho.nsa.gov>

---

 security/selinux/ss/services.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index ca9154d..1e52356 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -609,6 +609,9 @@ int security_sid_to_context(u32 sid, char **scontext, u32 *scontext_len)
 	struct context *context;
 	int rc = 0;
 
+	*scontext = NULL;
+	*scontext_len  = 0;
+
 	if (!ss_initialized) {
 		if (sid <= SECINITSID_NUM) {
 			char *scontextp;

-- 
Stephen Smalley
National Security Agency

