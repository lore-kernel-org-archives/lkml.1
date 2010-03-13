Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759121Ab0CMMna (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 07:43:30 -0500
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:26436 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756962Ab0CMMn3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 07:43:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAG4Wm0vCTtAn/2dsb2JhbACab3O4CIR7BA
Date: Sat, 13 Mar 2010 13:43:24 +0100
From: Philippe De Muyter <phdm@macqel.be>
To: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: [PATCH kobjects] Fix a rare memory leak in kobject_set_name_vargs
Message-ID: <20100313124324.GA15244@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

This is a possible memory leak that I discovered only by accidental code
reading.

--

If kvasprintf fails in kobject_set_name_vargs, the memory used by
the original kobj->name is leaked.  Fix that.  I also avoid useless
memory accesses to kobj->name by using the local variables old_name
and new_name instead.

Signed-off-by: Philippe De Muyter <phdm@macqel.be>

diff -r 373fdd3df333 linux-2.6.x/lib/kobject.c
--- a/linux-2.6.x/lib/kobject.c	Wed Aug 19 23:26:44 2009 +0200
+++ b/linux-2.6.x/lib/kobject.c	Sat Mar 13 13:35:43 2010 +0100
@@ -216,20 +216,22 @@ int kobject_set_name_vargs(struct kobjec
 				  va_list vargs)
 {
 	const char *old_name = kobj->name;
+	char *new_name;
 	char *s;
 
-	if (kobj->name && !fmt)
+	if (old_name && !fmt)
 		return 0;
 
-	kobj->name = kvasprintf(GFP_KERNEL, fmt, vargs);
-	if (!kobj->name)
+	new_name = kvasprintf(GFP_KERNEL, fmt, vargs);
+	if (!new_name)
 		return -ENOMEM;
 
 	/* ewww... some of these buggers have '/' in the name ... */
-	while ((s = strchr(kobj->name, '/')))
+	while ((s = strchr(new_name, '/')))
 		s[0] = '!';
 
 	kfree(old_name);
+	kobj->name = new_name;
 	return 0;
 }
 
