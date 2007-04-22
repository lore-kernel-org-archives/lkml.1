Return-Path: <linux-kernel-owner+w=401wt.eu-S1030384AbXDVTUg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030384AbXDVTUg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 15:20:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965656AbXDVTUg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 15:20:36 -0400
Received: from fed1rmmtao105.cox.net ([68.230.241.41]:41556 "EHLO
	fed1rmmtao105.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965641AbXDVTUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 15:20:34 -0400
From: Junio C Hamano <junkio@cox.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nicolas Pitre <nico@cam.org>, git@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Today's 'master' leaves .idx/.pack in 0400
References: <7vhcrml4wx.fsf@assigned-by-dhcp.cox.net>
	<7v1widrl0o.fsf@assigned-by-dhcp.cox.net>
	<alpine.LFD.0.98.0704221019100.9964@woody.linux-foundation.org>
	<7vvefonvdz.fsf@assigned-by-dhcp.cox.net>
	<7vmz10nv1h.fsf_-_@assigned-by-dhcp.cox.net>
	<alpine.LFD.0.98.0704221422250.28339@xanadu.home>
	<7vejmcnu28.fsf@assigned-by-dhcp.cox.net>
	<alpine.LFD.0.98.0704221431430.28339@xanadu.home>
	<alpine.LFD.0.98.0704221144250.9964@woody.linux-foundation.org>
	<7vy7kkmdtg.fsf@assigned-by-dhcp.cox.net>
Date: Sun, 22 Apr 2007 12:20:33 -0700
In-Reply-To: <7vy7kkmdtg.fsf@assigned-by-dhcp.cox.net> (Junio C. Hamano's
	message of "Sun, 22 Apr 2007 12:03:39 -0700")
Message-ID: <7vd51wmd1a.fsf@assigned-by-dhcp.cox.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Junio C Hamano <junkio@cox.net> writes:

> Linus Torvalds <torvalds@linux-foundation.org> writes:
>
>> So I think that if the user has a umask that says "nobody else can read", 
>> then we should *not* make it world readable (unless the 
>> "shared_repository" thing is set to override it, of course).
>
> I obviously agree, but as a tentative measure, I'll push out
> 0644 version anyway.

How about this as a replacement (hot off the press -- still
running the tests).

-- >8 --
pack-objects: adjust the permission bits of created files.

The updated pack-objects let mkstemp() to create new pack/idx
pair, without fixing the permission bits on them.

Signed-off-by: Junio C Hamano <junkio@cox.net>
---
 builtin-pack-objects.c |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/builtin-pack-objects.c b/builtin-pack-objects.c
index c72e07a..34350bf 100644
--- a/builtin-pack-objects.c
+++ b/builtin-pack-objects.c
@@ -1612,6 +1612,13 @@ static void get_object_list(int ac, const char **av)
 	traverse_commit_list(&revs, show_commit, show_object);
 }
 
+static int adjust_perm(const char *path, mode_t mode)
+{
+	if (chmod(path, mode))
+		return -1;
+	return adjust_shared_perm(path);
+}
+
 int cmd_pack_objects(int argc, const char **argv, const char *prefix)
 {
 	int depth = 10;
@@ -1780,14 +1787,25 @@ int cmd_pack_objects(int argc, const char **argv, const char *prefix)
 	last_obj_offset = write_pack_file();
 	if (!pack_to_stdout) {
 		unsigned char object_list_sha1[20];
+		mode_t mode = umask(0);
+
+		umask(mode);
+		mode = 0666 & ~mode;
+
 		write_index_file(last_obj_offset, object_list_sha1);
 		snprintf(tmpname, sizeof(tmpname), "%s-%s.pack",
 			 base_name, sha1_to_hex(object_list_sha1));
+		if (adjust_perm(pack_tmp_name, mode))
+			die("unable to make temporary pack file readable: %s",
+			    strerror(errno));
 		if (rename(pack_tmp_name, tmpname))
 			die("unable to rename temporary pack file: %s",
 			    strerror(errno));
 		snprintf(tmpname, sizeof(tmpname), "%s-%s.idx",
 			 base_name, sha1_to_hex(object_list_sha1));
+		if (adjust_perm(idx_tmp_name, mode))
+			die("unable to make temporary index file readable: %s",
+			    strerror(errno));
 		if (rename(idx_tmp_name, tmpname))
 			die("unable to rename temporary index file: %s",
 			    strerror(errno));

