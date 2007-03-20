Return-Path: <linux-kernel-owner+w=401wt.eu-S1752868AbXCTUev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbXCTUev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 16:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbXCTUeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 16:34:50 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:49380 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858AbXCTUet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 16:34:49 -0400
Date: Tue, 20 Mar 2007 21:35:29 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc4-mm1 + 3 hot-fixes -- WARNING: could not find versions for .tmp_versions/built-in.mod
Message-ID: <20070320203529.GA13349@uranus.ravnborg.org>
References: <a44ae5cd0703200735k197bc50cqeb2856f9f50f88c9@mail.gmail.com> <20070320081138.2a5fdb1e.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070320081138.2a5fdb1e.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2007 at 08:11:38AM -0800, Andrew Morton wrote:
> On Tue, 20 Mar 2007 07:35:06 -0700 "Miles Lane" <miles.lane@gmail.com> wrote:
> 
> > It looks like the number of section mismatches is much reduced, which
> > is great.
> 
> We fixed something?   Maybe we just broke the checker ;)
> 
> >  But, I don't remember seeing "WARNING: could not find
> > versions for ..." warnings before.  Is this an artifact of the
> > init/.missing_syscalls.h problem I encountered earlier?
> 
> Sam says these are harmless and he's working on making them go away.
> 
> >   MODPOST vmlinux
> > WARNING: could not find versions for .tmp_versions/head.mod
> > WARNING: could not find versions for .tmp_versions/init_task.mod

They were caused by modpost now being called with several .o files
that are not modules. The fix was just to get rid of the
warning.
I have committed the following to kbuild.git.

	Sam

commit 84b48a0275b4474587cefecb455372e8df6dabda
Author: Sam Ravnborg <sam@ravnborg.org>
Date:   Tue Mar 20 21:30:23 2007 +0100

    kbuild: do not emit src version warning for non-modules
    
    modpost is now called with .o files that are not modules.
    So do not warn if there is no corresponding .mod
    file listing .o files (in .tmp_versions/).
    
    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

diff --git a/scripts/mod/sumversion.c b/scripts/mod/sumversion.c
index 8a28756..6873d5a 100644
--- a/scripts/mod/sumversion.c
+++ b/scripts/mod/sumversion.c
@@ -397,10 +397,9 @@ void get_src_version(const char *modname, char sum[], unsigned sumlen)
 		(int) strlen(basename) - 2, basename);
 
 	file = grab_file(filelist, &len);
-	if (!file) {
-		warn("could not find versions for %s\n", filelist);
+	if (!file)
+		/* not a module or .mod file missing - ignore */
 		return;
-	}
 
 	sources = strchr(file, '\n');
 	if (!sources) {
