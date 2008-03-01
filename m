Return-Path: <linux-kernel-owner+w=401wt.eu-S1762179AbYCABUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762179AbYCABUy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 20:20:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932801AbYCABUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 20:20:18 -0500
Received: from 187.Red-80-37-203.staticIP.rima-tde.net ([80.37.203.187]:27112
	"EHLO betty.it.uc3m.es" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933632AbYCABUP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 20:20:15 -0500
X-Greylist: delayed 484 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Feb 2008 20:20:14 EST
From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Message-Id: <200803010112.m211C5h4027092@betty.it.uc3m.es>
Subject: sysctl in 2.6.24.2 excludes unapproved files from /proc/sys?
X-ELM-OSV: (Our standard violations) hdr-charset=US-ASCII; no-hdr-encoding=1
To: linux kernel <linux-kernel@vger.kernel.org>
Date: Sat, 1 Mar 2008 02:12:05 +0100 (CET)
Reply-To: ptb@inv.it.uc3m.es
X-Anonymously-To: 
X-message-flag: Had your Outlook virus, today?
 http://www.counterpane.com/crypto-gram-0103.html#4
X-WebTV-Stationery: Standard\; BGColor=black\; TextColor=black
X-Mailer: ELM [version 2.4ME+ PL123]
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A change in 2.6.24.x kernel/sysctl.c seems to exclude exo-kernel drivers
from using the /proc/sys/ interface:

@@ -1275,7 +1481,9 @@ static void sysctl_set_parent(struct ctl

 static __init int sysctl_init(void)
 {
+       int err;
        sysctl_set_parent(NULL, root_table);
+       err = sysctl_check_table(root_table);
        return 0;
 }
 
and

@@ -1360,6 +1568,10 @@ struct ctl_table_header *register_sysctl
        tmp->used = 0;
        tmp->unregistering = NULL;
        sysctl_set_parent(NULL, table);
+       if (sysctl_check_table(tmp->ctl_table)) {
+               kfree(tmp);
+               return NULL;
+       }
        spin_lock(&sysctl_lock);
        list_add_tail(&tmp->ctl_entry, &root_table_header.ctl_entry);
        spin_unlock(&sysctl_lock);

and IT TURNS OUT THAT (sorry, did I scream?) sysctl_check_table can't
succeed on anything that's now not been hardwired into the core kernel
because of the new sysctl_check.c file  which contains gazzilions of
explict tables aying what is supposed to be in there in excruciating
detail and which are consulted through sysctl_check_table and
sysctl_binary_lookup.  E.g:

static struct trans_ctl_table trans_random_table[] = {
        { RANDOM_POOLSIZE,      "poolsize" },
        { RANDOM_ENTROPY_COUNT, "entropy_avail" },
        { RANDOM_READ_THRESH,   "read_wakeup_threshold" },
        { RANDOM_WRITE_THRESH,  "write_wakeup_threshold" },
        { RANDOM_BOOT_ID,       "boot_id" },
        { RANDOM_UUID,          "uuid" },
        {}
};

It appears to me, not that I am totally sure because of the lack of
comments, that every attempt to add a new direcotry in the tree with
a number that is not listed in the above mess fails through
sysctl_binary_lookup.sysctl_binary_lookup, and every attempt to add
a directory with CTL_UNNUMBERED instead fails if it has children because
the children cry about having an unnumbered parent. Every attempt to
add a directory usurping an existing number fails through some string
mismatch against the trans_.._tables on the dirnames in one of the
numerous lookup functions (forget which).

(somebody has really spent their holidays on this).

What's a person to do? 

Peter
