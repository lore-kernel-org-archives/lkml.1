Return-Path: <linux-kernel-owner+w=401wt.eu-S1754336AbXDVSeM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336AbXDVSeM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 14:34:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754367AbXDVSeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 14:34:12 -0400
Received: from relais.videotron.ca ([24.201.245.36]:56582 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754336AbXDVSeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 14:34:10 -0400
Date: Sun, 22 Apr 2007 14:34:09 -0400 (EDT)
From: Nicolas Pitre <nico@cam.org>
Subject: Re: Today's 'master' leaves .idx/.pack in 0400
In-reply-to: <7vejmcnu28.fsf@assigned-by-dhcp.cox.net>
X-X-Sender: nico@xanadu.home
To: Junio C Hamano <junkio@cox.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, git@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <alpine.LFD.0.98.0704221431430.28339@xanadu.home>
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=us-ascii
Content-transfer-encoding: 7BIT
References: <7vhcrml4wx.fsf@assigned-by-dhcp.cox.net>
 <7v1widrl0o.fsf@assigned-by-dhcp.cox.net>
 <alpine.LFD.0.98.0704221019100.9964@woody.linux-foundation.org>
 <7vvefonvdz.fsf@assigned-by-dhcp.cox.net>
 <7vmz10nv1h.fsf_-_@assigned-by-dhcp.cox.net>
 <alpine.LFD.0.98.0704221422250.28339@xanadu.home>
 <7vejmcnu28.fsf@assigned-by-dhcp.cox.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Apr 2007, Junio C Hamano wrote:

> Nicolas Pitre <nico@cam.org> writes:
> 
> > On Sun, 22 Apr 2007, Junio C Hamano wrote:
> >
> >> With recent glibc, mkstemp() creates 0400 file.  Updated
> >> pack-objects uses it in pack/idx writing without fixing this,
> >> hence this problem.
> >
> > Oops.  I guess I'm guilty for this.  I didn't bother looking at the 
> > permission on the pack for git-pack-objects since git-repack seemed to 
> > take care of that.  But it only _remove_ write permissions.
> 
> Ok, then probably we can change the 0444 in my "quickfix" patch
> to 0644.  That should also let the 5300 test pass.

Well, actually there is no point making pack files writable.  If they're 
modified, they get corrupted.

Here's the fix I wanted to propose:

diff --git a/builtin-pack-objects.c b/builtin-pack-objects.c
index c72e07a..85c6e6e 100644
--- a/builtin-pack-objects.c
+++ b/builtin-pack-objects.c
@@ -1786,11 +1786,13 @@ int cmd_pack_objects(int argc, const char **argv, const char *prefix)
 		if (rename(pack_tmp_name, tmpname))
 			die("unable to rename temporary pack file: %s",
 			    strerror(errno));
+		chmod(tmpname, 0444);
 		snprintf(tmpname, sizeof(tmpname), "%s-%s.idx",
 			 base_name, sha1_to_hex(object_list_sha1));
 		if (rename(idx_tmp_name, tmpname))
 			die("unable to rename temporary index file: %s",
 			    strerror(errno));
+		chmod(tmpname, 0444);
 		puts(sha1_to_hex(object_list_sha1));
 	}
 	if (progress)


Nicolas

