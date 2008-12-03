Return-Path: <linux-kernel-owner+w=401wt.eu-S1753516AbYLCURU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516AbYLCURU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 15:17:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbYLCTyt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:54:49 -0500
Received: from kroah.org ([198.145.64.141]:60470 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751775AbYLCTyr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:54:47 -0500
Date: Wed, 3 Dec 2008 11:53:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Steve French <smfrench@gmail.com>,
       Jeff Layton <jlayton@redhat.com>,
       Shirish S Pargaonkar <shirishp@us.ibm.com>,
       Steve French <sfrench@us.ibm.com>,
       Suresh Jayaraman <sjayaraman@suse.de>
Subject: [patch 069/104] cifs: remove unused list, add new cifs sock list
	to prepare for mount/umount fix
Message-ID: <20081203195327.GR8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cifs-remove-unused-list-add-new-cifs-sock-list-to-prepare-for-mount-umount-fix.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Steve French <sfrench@us.ibm.com>

commit fb396016647ae9de5b3bd8c4ee4f7b9cc7148bd5 upstream.

Also adds two lines missing from the previous patch (for the need reconnect flag in the
/proc/fs/cifs/DebugData handling)

The new global_cifs_sock_list is added, and initialized in init_cifs but not used yet.
Jeff Layton will be adding code in to use that and to remove the GlobalTcon and GlobalSMBSession
lists.

CC: Jeff Layton <jlayton@redhat.com>
CC: Shirish Pargaonkar <shirishp@us.ibm.com>
Signed-off-by: Steve French <sfrench@us.ibm.com>
Cc: Suresh Jayaraman <sjayaraman@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/cifs/cifs_debug.c |    4 ++--
 fs/cifs/cifsfs.c     |    6 +++---
 fs/cifs/cifsglob.h   |   23 ++++++++---------------
 3 files changed, 13 insertions(+), 20 deletions(-)

--- a/fs/cifs/cifs_debug.c
+++ b/fs/cifs/cifs_debug.c
@@ -204,7 +204,7 @@ static int cifs_debug_data_proc_show(str
 		else
 			seq_printf(m, " type: %d ", dev_type);
 
-		if (tcon->tidStatus == CifsNeedReconnect)
+		if (tcon->need_reconnect)
 			seq_puts(m, "\tDISCONNECTED ");
 	}
 	read_unlock(&GlobalSMBSeslock);
@@ -311,7 +311,7 @@ static int cifs_stats_proc_show(struct s
 		i++;
 		tcon = list_entry(tmp, struct cifsTconInfo, cifsConnectionList);
 		seq_printf(m, "\n%d) %s", i, tcon->treeName);
-		if (tcon->tidStatus == CifsNeedReconnect)
+		if (tcon->need_reconnect)
 			seq_puts(m, "\tDISCONNECTED ");
 		seq_printf(m, "\nSMBs: %d Oplock Breaks: %d",
 			atomic_read(&tcon->num_smbs_sent),
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1013,9 +1013,9 @@ init_cifs(void)
 {
 	int rc = 0;
 	cifs_proc_init();
-/*	INIT_LIST_HEAD(&GlobalServerList);*/	/* BB not implemented yet */
-	INIT_LIST_HEAD(&GlobalSMBSessionList);
-	INIT_LIST_HEAD(&GlobalTreeConnectionList);
+	INIT_LIST_HEAD(&global_cifs_sock_list);
+	INIT_LIST_HEAD(&GlobalSMBSessionList); /* BB to be removed by jl */
+	INIT_LIST_HEAD(&GlobalTreeConnectionList); /* BB to be removed by jl */
 	INIT_LIST_HEAD(&GlobalOplock_Q);
 #ifdef CONFIG_CIFS_EXPERIMENTAL
 	INIT_LIST_HEAD(&GlobalDnotifyReqList);
--- a/fs/cifs/cifsglob.h
+++ b/fs/cifs/cifsglob.h
@@ -590,22 +590,15 @@ require use of the stronger protocol */
 #define GLOBAL_EXTERN extern
 #endif
 
-/*
- * The list of servers that did not respond with NT LM 0.12.
- * This list helps improve performance and eliminate the messages indicating
- * that we had a communications error talking to the server in this list.
- */
-/* Feature not supported */
-/* GLOBAL_EXTERN struct servers_not_supported *NotSuppList; */
-
-/*
- * The following is a hash table of all the users we know about.
- */
-GLOBAL_EXTERN struct smbUidInfo *GlobalUidList[UID_HASH];
 
-/* GLOBAL_EXTERN struct list_head GlobalServerList; BB not implemented yet */
-GLOBAL_EXTERN struct list_head GlobalSMBSessionList;
-GLOBAL_EXTERN struct list_head GlobalTreeConnectionList;
+/* the list of TCP_Server_Info structures, ie each of the sockets
+ * connecting our client to a distinct server (ip address), is
+ * chained together by global_cifs_sock_list. The list of all our SMB
+ * sessions (and from that the tree connections) can be found
+ * by iterating over global_cifs_sock_list */
+GLOBAL_EXTERN struct list_head global_cifs_sock_list;
+GLOBAL_EXTERN struct list_head GlobalSMBSessionList; /* BB to be removed by jl*/
+GLOBAL_EXTERN struct list_head GlobalTreeConnectionList; /* BB to be removed */
 GLOBAL_EXTERN rwlock_t GlobalSMBSeslock;  /* protects list inserts on 3 above */
 
 GLOBAL_EXTERN struct list_head GlobalOplock_Q;

