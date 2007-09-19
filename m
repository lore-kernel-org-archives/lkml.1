Return-Path: <linux-kernel-owner+w=401wt.eu-S1753766AbXISF4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbXISF4b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 01:56:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbXISF4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 01:56:23 -0400
Received: from smtp101.sbc.mail.re2.yahoo.com ([68.142.229.104]:44800 "HELO
	smtp101.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751432AbXISF4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 01:56:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ffmaOYmSDYHqji+IEd0txPRfqXyoG0y1O54UJEhpz0XBPVid/8hctHP5ObvLZKxSxtuubdgvWLPyO5g9W4asvkwxmI3DeRqJfLwhscetarDAtxdi0Dx92kJV5YC0JNkz8AeQqojAMsdZK15X339myAgIyD2GG/j6dEBQXexqdtw=  ;
X-YMail-OSG: RjgSbTIVM1mnR1HJC..4mc9YuO5GGwbNPCTFgitw1RjkA_LzWZ.XZLFgI_jzUnlKjEoDdAcf0w--
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Two identical entries for "rtc" in /proc/devices
Date: Tue, 18 Sep 2007 22:21:14 -0700
User-Agent: KMail/1.9.6
Cc: cebbert@redhat.com, linux-kernel@vger.kernel.org
References: <46E07DDA.2040907@redhat.com> <20070915185020.16BB51F9EAA@adsl-69-226-248-13.dsl.pltn13.pacbell.net> <20070915221015.02aad5ea.akpm@linux-foundation.org>
In-Reply-To: <20070915221015.02aad5ea.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709182221.14751.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 15 September 2007, Andrew Morton wrote:
> On Sat, 15 Sep 2007 11:50:21 -0700 David Brownell <david-b@pacbell.net> wrote:
> 
> > > On Thu, 06 Sep 2007 18:23:22 -0400 Chuck Ebbert <cebbert@redhat.com> wrote:
> > >
> > > > # ls -li
> > > > total 0
> > > > 4026532007 -r--r--r-- 1 root root 0 Sep  6 18:18 nvram
> > > > 4026532067 -r--r--r-- 1 root root 0 Sep  6 18:18 rtc
> > > > 4026532067 -r--r--r-- 1 root root 0 Sep  6 18:18 rtc
> > > > 4026532056 -rw-r--r-- 1 root root 0 Sep  6 18:18 snd-page-alloc
> > >
> > > ...
> > 
> > Semes pretty clear that this must be procfs itself...
> > when a filesystem sees a name in a directory, it should
> > refuse to make another file with the same name.  And it
> > should *never* reuse inode numbers...
>
> ...
>
> procfs can reject the attempt to create the file, but the bottom line
> is that two different callsites are trying to create the same file.  One
> of those callsites needs fixing?

Both of those call sites have code to handle procfs rejecting
the file creation; nothing to fix.  And anyway, there's no way
this is a *caller* bug!

The missing step seems to be that proc_register() doesn't bother
to check whether there's already an entry for that file.  Which
is what the appended *UNTESTED* patch does (it compiles though).

- Dave

--- g26.orig/fs/proc/generic.c	2007-09-18 22:08:44.000000000 -0700
+++ g26/fs/proc/generic.c	2007-09-18 22:14:07.000000000 -0700
@@ -521,10 +521,11 @@ static const struct inode_operations pro
 	.setattr	= proc_notify_change,
 };
 
-static int proc_register(struct proc_dir_entry * dir, struct proc_dir_entry * dp)
+static int proc_register(struct proc_dir_entry *dir, struct proc_dir_entry *dp)
 {
 	unsigned int i;
-	
+	struct proc_dir_entry *de;
+
 	i = get_inode_number();
 	if (i == 0)
 		return -EAGAIN;
@@ -547,6 +548,16 @@ static int proc_register(struct proc_dir
 	}
 
 	spin_lock(&proc_subdir_lock);
+
+	for (de = dir->subdir; de ; de = de->next) {
+		if (de->namelen != dp->namelen)
+			continue;
+		if (!memcmp(de->name, dp->name, de->namelen)) {
+			spin_unlock(&proc_subdir_lock);
+			return -EEXIST;
+		}
+	}
+
 	dp->next = dir->subdir;
 	dp->parent = dir;
 	dir->subdir = dp;

