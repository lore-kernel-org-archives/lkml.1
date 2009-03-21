Return-Path: <linux-kernel-owner+w=401wt.eu-S1757064AbZCUHlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064AbZCUHlX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 03:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753811AbZCUHlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 03:41:08 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43452 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871AbZCUHlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 03:41:05 -0400
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Jan Beulich <jbeulich@novell.com>,
       tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, Gautham R Shenoy <ego@in.ibm.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Alexey Dobriyan <adobriyan@gmail.com>, <netdev@vger.kernel.org>
References: <49B91A7E.76E4.0078.0@novell.com>
	<tip-6a09dfa870ba0ed21b1124539968a36b42660661@git.kernel.org>
	<1236934491.5188.209.camel@laptop> <49BA33BE.76E4.0078.0@novell.com>
	<1236937423.22914.3698.camel@twins> <20090313103828.GB31094@elte.hu>
	<m1d4cd9n4k.fsf@fess.ebiederm.org> <20090320085205.GB16021@elte.hu>
	<m14oxo8qis.fsf@fess.ebiederm.org> <20090320182404.GA31629@elte.hu>
	<1237575134.4667.5.camel@laptop> <1237577688.4667.68.camel@laptop>
	<m1iqm3xr2n.fsf_-_@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 21 Mar 2009 00:40:58 -0700
In-Reply-To: <m1iqm3xr2n.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's message of "Sat\, 21 Mar 2009 00\:39\:28 -0700")
Message-ID: <m1eiwrxr05.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.169.126.145;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.169.126.145
X-SA-Exim-Rcpt-To: akpm@linux-foundation.org, netdev@vger.kernel.org, adobriyan@gmail.com, peterz@infradead.org, ego@in.ibm.com, linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, jbeulich@novell.com, mingo@elte.hu
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andrew Morton <akpm@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  3.0 XMNoVowels Alpha-numberic number with no vowels
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  1.0 XMPlayFrnd1 XMPlayFrnd: Play Friend Spam 1 Or More Qualities
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: [PATCH 1/2] sysctl: Don't take the use count of multiple heads at a time.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The current code works fine, and is actually not buggy but it
does prevent enabling the use of lockdep to check refcounting
vs lock holding ordering problems.   So since we can ensure
that we are only hold a single sysctl_head at a time.  Allowing
lockdep to complain.

Signed-off-by: Eric Biederman <ebiederm@aristanetworks.com>
---
 fs/proc/proc_sysctl.c |   24 ++++++++++--------------
 1 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 94fcfff..46eb34c 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -79,7 +79,6 @@ static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
 {
 	struct ctl_table_header *head = grab_header(dir);
 	struct ctl_table *table = PROC_I(dir)->sysctl_entry;
-	struct ctl_table_header *h = NULL;
 	struct qstr *name = &dentry->d_name;
 	struct ctl_table *p;
 	struct inode *inode;
@@ -97,10 +96,11 @@ static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
 
 	p = find_in_table(table, name);
 	if (!p) {
-		for (h = sysctl_head_next(NULL); h; h = sysctl_head_next(h)) {
-			if (h->attached_to != table)
+		sysctl_head_finish(head);
+		for (head = sysctl_head_next(NULL); head; head = sysctl_head_next(head)) {
+			if (head->attached_to != table)
 				continue;
-			p = find_in_table(h->attached_by, name);
+			p = find_in_table(head->attached_by, name);
 			if (p)
 				break;
 		}
@@ -110,9 +110,7 @@ static struct dentry *proc_sys_lookup(struct inode *dir, struct dentry *dentry,
 		goto out;
 
 	err = ERR_PTR(-ENOMEM);
-	inode = proc_sys_make_inode(dir->i_sb, h ? h : head, p);
-	if (h)
-		sysctl_head_finish(h);
+	inode = proc_sys_make_inode(dir->i_sb, head, p);
 
 	if (!inode)
 		goto out;
@@ -243,7 +241,6 @@ static int proc_sys_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	struct inode *inode = dentry->d_inode;
 	struct ctl_table_header *head = grab_header(inode);
 	struct ctl_table *table = PROC_I(inode)->sysctl_entry;
-	struct ctl_table_header *h = NULL;
 	unsigned long pos;
 	int ret = -EINVAL;
 
@@ -277,14 +274,13 @@ static int proc_sys_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	if (ret)
 		goto out;
 
-	for (h = sysctl_head_next(NULL); h; h = sysctl_head_next(h)) {
-		if (h->attached_to != table)
+	sysctl_head_finish(head);
+	for (head = sysctl_head_next(NULL); head; head = sysctl_head_next(head)) {
+		if (head->attached_to != table)
 			continue;
-		ret = scan(h, h->attached_by, &pos, filp, dirent, filldir);
-		if (ret) {
-			sysctl_head_finish(h);
+		ret = scan(head, head->attached_by, &pos, filp, dirent, filldir);
+		if (ret)
 			break;
-		}
 	}
 	ret = 1;
 out:
-- 
1.6.1.2.350.g88cc

