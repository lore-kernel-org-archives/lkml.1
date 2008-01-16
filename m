Return-Path: <linux-kernel-owner+w=401wt.eu-S1753938AbYAPRFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938AbYAPRFX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:05:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751210AbYAPRFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:05:11 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36025 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbYAPRFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:05:09 -0500
Subject: Re: [PATCH 04/27] kill filp_open()
From: Dave Hansen <haveblue@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, miklos@szeredi.hu, hch@infradead.org,
       Bryn Reeves <breeves@redhat.com>, Alasdair G Kergon <agk@redhat.com>
In-Reply-To: <20080116005200.0165dc67.akpm@linux-foundation.org>
References: <20071101230826.9A4F6E00@kernel>
	 <20071101230831.904FDE9A@kernel>
	 <20080116005200.0165dc67.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Wed, 16 Jan 2008 09:04:56 -0800
Message-Id: <1200503096.22674.171.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-01-16 at 00:52 -0800, Andrew Morton wrote:
> On Thu, 01 Nov 2007 16:08:31 -0700 Dave Hansen <haveblue@us.ibm.com> wrote:
> > Replace all callers with open_namei() directly, and move the
> > nameidata stack allocation into open_namei().
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-loop.patch
> is using filp_open() and hence doesn't work very well.
> 
> A shall revert dm-loop.patch and run away.

This one's pretty easy, thank goodness.  Just replace filp_open() with
open_namei():

	/filp_open(/open_namei(AT_FDCWD, /

BTW, why do we need this on top of the existing loopback driver?  Can
they really share no code?

 linux-2.6.git-dave/drivers/md/dm-loop.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/md/dm-loop.c~fix-dm-loop drivers/md/dm-loop.c
--- linux-2.6.git/drivers/md/dm-loop.c~fix-dm-loop	2008-01-16 09:02:06.000000000 -0800
+++ linux-2.6.git-dave/drivers/md/dm-loop.c	2008-01-16 09:02:06.000000000 -0800
@@ -757,7 +757,7 @@ static int loop_get_file(struct dm_targe
 	int r = 0;
 
 	ti->error = "could not open backing file";
-	filp = filp_open(lc->path, flags, 0);
+	filp = open_namei(AT_FDCWD, lc->path, flags, 0);
 	if (IS_ERR(filp))
 		return PTR_ERR(filp);
 	lc->filp = filp;
_


-- Dave

