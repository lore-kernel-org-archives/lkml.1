Return-Path: <linux-kernel-owner+w=401wt.eu-S1751906AbXBVVUV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906AbXBVVUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 16:20:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbXBVVUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 16:20:21 -0500
Received: from smtp.osdl.org ([65.172.181.24]:39340 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbXBVVUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 16:20:20 -0500
Date: Thu, 22 Feb 2007 13:19:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: viro@ftp.linux.org.uk, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, sgrubb@redhat.com, jmorris@namei.org
Subject: Re: [GIT PULL] audit patches
Message-Id: <20070222131931.1ed6ffa4.akpm@linux-foundation.org>
In-Reply-To: <1172150567.14363.337.camel@moss-spartans.epoch.ncsc.mil>
References: <20070218040127.GA5422@ftp.linux.org.uk>
	<20070221160319.6de08b64.akpm@linux-foundation.org>
	<1172150567.14363.337.camel@moss-spartans.epoch.ncsc.mil>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 22 Feb 2007 08:22:47 -0500 Stephen Smalley <sds@tycho.nsa.gov> wrote:
> On Wed, 2007-02-21 at 16:03 -0800, Andrew Morton wrote:
> > 
> > Looking at the changes to audit_receive_msg():
> > 
> > 
> > 				if (sid) {
> > 					if (selinux_sid_to_string(
> > 							sid, &ctx, &len)) {
> > 						audit_log_format(ab,
> > 							" ssid=%u", sid);
> > 						/* Maybe call audit_panic? */
> > 					} else
> > 						audit_log_format(ab,
> > 							" subj=%s", ctx);
> > 					kfree(ctx);
> > 				}
> > 
> > This is assuming that selinux_sid_to_string() always initialises `ctx'.
> > 
> > But AFAICT there are two error paths in security_sid_to_context() which
> > forget to do that, so we end up doing kfree(uninitialised-local).
> > 
> > I'd consider that a shortcoming in security_sid_to_context(), so not a
> > problem in this patch, as long as people agree with my blaming above.
> 
> I wouldn't assume that the function initializes an argument if it
> returns an error, and at least some of the callers (in auditsc.c) appear
> to correctly initialize ctx to NULL themselves before calling
> selinux_sid_to_string().  But if you'd prefer the function to always
> handle it, we can do that.
> 

Well we now have (at least) one caller which assumes that *ctx is
initialied in error cases.

And I think it's sane to make it do that: safer, and will simplify coding
in the callers.
