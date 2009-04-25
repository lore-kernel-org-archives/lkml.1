Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbZDYJlm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbZDYJlm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Apr 2009 05:41:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbZDYJlc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Apr 2009 05:41:32 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:40415 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751657AbZDYJlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Apr 2009 05:41:31 -0400
Date: Sat, 25 Apr 2009 10:42:34 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: npiggin@suse.de
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 01/27] fs: cleanup files_lock
Message-ID: <20090425104234.3c2ea3b4@lxorguk.ukuu.org.uk>
In-Reply-To: <20090425012209.061706790@suse.de>
References: <20090425012020.457460929@suse.de>
	<20090425012209.061706790@suse.de>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Apr 2009 11:20:21 +1000
npiggin@suse.de wrote:

> Lock tty_files with tty_mutex, provide helpers to manipulate the per-sb
> files list, and unexport the files_lock spinlock.

This looks half like a backward step to me: It swaps clean method calls
for open coded stuff and it adds more random undocumented uses to
tty_mutex, which has far too much already.

I don't think

-	file_move(filp, &tty->tty_files);
+
+	mutex_lock(&tty_mutex);
+	file_list_del(filp);
+	list_add(&filp->f_u.fu_list, &tty->tty_files);
+	mutex_unlock(&tty_mutex);

is exactly an improvement, nor is 

-	file_move(filp, &tty->tty_files);
-	check_tty_count(tty, "tty_open");
+	mutex_lock(&tty_mutex);
+	BUG_ON(list_empty(&filp->f_u.fu_list));
+	file_list_del(filp); /* __dentry_open has put it on the sb list
  */
+	list_add(&filp->f_u.fu_list, &tty->tty_files);
+	__check_tty_count(tty, "tty_open");
+	mutex_unlock(&tty_mutex);

The basic idea looks totally sound but it can use its own lock and there
should be helpers so this stuff doesn't have to get open coded.

