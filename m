Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbZJEQi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbZJEQi6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 12:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbZJEQi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 12:38:58 -0400
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:41295 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707AbZJEQi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 12:38:57 -0400
Date: Mon, 5 Oct 2009 18:37:53 +0200
From: Cornelia Huck <cornelia.huck@de.ibm.com>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       Phil Carmody <ext-phil.2.carmody@nokia.com>
Subject: Re: [PATCH 1/1] Kobject: bail early if no new_parent in
 kobject_move()
Message-ID: <20091005183753.4d77afcb@gondolin>
In-Reply-To: <c4b4c2e3155280589fb539f952e58c77a1fa7e96.1254408493.git.ext-phil.2.carmody@nokia.com>
References: <c4b4c2e3155280589fb539f952e58c77a1fa7e96.1254408493.git.ext-phil.2.carmody@nokia.com>
Organization: IBM Deutschland Research & Development GmbH Vorsitzender des
 Aufsichtsrats: Martin Jetter =?ISO-8859-1?Q?Gesch=E4ftsf=FChrung:?= Erich
 Baier Sitz der Gesellschaft: =?ISO-8859-1?Q?B=F6blingen?= Registergericht:
 Amtsgericht Stuttgart, HRB 243294
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  1 Oct 2009 17:50:48 +0300,
Phil Carmody <ext-phil.2.carmody@nokia.com> wrote:

> From: Phil Carmody <ext-phil.2.carmody@nokia.com>
> 
> In the absense of kobj->kset, new_parent would remain NULL.
> NULL-dereference shenanighans then ensues in the subsequent
> sysfs_move_dir(..., new_parent) call. Bail early instead.

But sysfs_move_dir(..., NULL) should work and fall back to the sysfs
root...

<looks at code>

It seems that has been broken for some time. Should probably be
something like this instead (uncompiled); I can send it with proper
description and s-o-b once I gave it a test.

---
 fs/sysfs/dir.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.orig/fs/sysfs/dir.c
+++ linux-2.6/fs/sysfs/dir.c
@@ -894,7 +894,8 @@ int sysfs_move_dir(struct kobject *kobj,
 
 	mutex_lock(&sysfs_rename_mutex);
 	BUG_ON(!sd->s_parent);
-	new_parent_sd = new_parent_kobj->sd ? new_parent_kobj->sd : &sysfs_root;
+	new_parent_sd = (new_parent_kobj && new_parent_kobj->sd) ?
+		new_parent_kobj->sd : &sysfs_root;
 
 	error = 0;
 	if (sd->s_parent == new_parent_sd)
