Return-Path: <linux-kernel-owner+w=401wt.eu-S1750923AbZD0R5N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750923AbZD0R5N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 13:57:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756175AbZD0R44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 13:56:56 -0400
Received: from outbound-mail-119.bluehost.com ([69.89.22.19]:36010 "HELO
	outbound-mail-119.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751257AbZD0R4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 13:56:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:X-Identified-User;
	b=Lkmo/F5mGFN4J5cpal53huBjoage6Wpc45mlb19T+zf2jve/WaJ8a5PNkbOowJt2JpN0q+DIvJQvwe1U9+BD/IKOGIvs1Fpg7CfGloXLpiQckUK7aQ3Q65nhs7DXqEYt;
Date: Mon, 27 Apr 2009 09:46:51 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Dave Airlie" <airlied@redhat.com>,
       "DRI" <dri-devel@lists.sourceforge.net>,
       "Michel =?UTF-8?B?RMOkbnplcg==?=" <michel@daenzer.net>,
       "Sitsofe Wheeler" <sitsofe@yahoo.com>
Subject: Re: [Bug #12765] i915 VT switch with AIGLX causes X lock up
Message-ID: <20090427094651.7cc09227@hobbes>
In-Reply-To: <egHshlwQQFE.A.X4D.-qE9JB@chimera>
References: <tur5OtdUm3E.A.r2B.7oE9JB@chimera>
	<egHshlwQQFE.A.X4D.-qE9JB@chimera>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="MP_/NIRqWWW2G6ffVXmLhTLhGww"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_/NIRqWWW2G6ffVXmLhTLhGww
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sun, 26 Apr 2009 11:46:26 +0200 (CEST)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.28 and 2.6.29.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.28 and 2.6.29.  Please verify if it still
> should be listed and let me know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12765
> Subject		: i915 VT switch with AIGLX causes X lock up
> Submitter	: Sitsofe Wheeler <sitsofe@yahoo.com>
> Date		: 2009-02-21 15:38 (65 days old)
> First-Bad-Commit:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=14d200c5e5bd19219d930bbb9a5a22758c8f5bec
> References	:
> http://marc.info/?l=linux-kernel&m=123523074304955&w=4

I think we had a workaround for this (attached), but it sounds like
Robert has tracked down the root cause (search for "Broken vblanks on
Intel" on dri-devel@lists.sourceforge.net).  Will try to get the fix
into the Intel driver soon.  Fortunately this doesn't seem to be biting
a lot of people (at least not that I've heard); I certainly have a hard
time reproducing it.

-- 
Jesse Barnes, Intel Open Source Technology Center

--MP_/NIRqWWW2G6ffVXmLhTLhGww
Content-Type: text/x-patch
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=drm-vblank-wait-fix.patch

diff --git a/drivers/gpu/drm/drm_irq.c b/drivers/gpu/drm/drm_irq.c
index 69aa0ab..c41cba4 100644
--- a/drivers/gpu/drm/drm_irq.c
+++ b/drivers/gpu/drm/drm_irq.c
@@ -341,7 +341,7 @@ int drm_control(struct drm_device *dev, void *data,
  * vblank events since the system was booted, including lost events due to
  * modesetting activity.
  */
-u32 drm_vblank_count(struct drm_device *dev, int crtc)
+unsigned int drm_vblank_count(struct drm_device *dev, int crtc)
 {
 	return atomic_read(&dev->_vblank_count[crtc]);
 }
@@ -522,6 +522,11 @@ out:
 	return ret;
 }
 
+#define frame_after_eq(a,b)	       \
+	(typecheck(unsigned int, a) && \
+	 typecheck(unsigned int, b) && \
+	 ((int)(a) - (int)(b) >= 0))
+
 /**
  * Wait for VBLANK.
  *
@@ -589,10 +594,12 @@ int drm_wait_vblank(struct drm_device *dev, void *data,
 	DRM_DEBUG("waiting on vblank count %d, crtc %d\n",
 		  vblwait->request.sequence, crtc);
 	dev->last_vblank_wait[crtc] = vblwait->request.sequence;
+
+	/* Wait for the sequence number to pass or IRQs to get disabled */
 	DRM_WAIT_ON(ret, dev->vbl_queue[crtc], 3 * DRM_HZ,
-		    (((drm_vblank_count(dev, crtc) -
-		       vblwait->request.sequence) <= (1 << 23)) ||
-		     !dev->irq_enabled));
+		    frame_after_eq(drm_vblank_count(dev, crtc),
+				   vblwait->request.sequence) ||
+		    !dev->irq_enabled);
 
 	if (ret != -EINTR) {
 		struct timeval now;

--MP_/NIRqWWW2G6ffVXmLhTLhGww--
