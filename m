Return-Path: <linux-kernel-owner+w=401wt.eu-S932131AbZGMWoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbZGMWoG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 18:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbZGMWoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 18:44:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39265 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753517AbZGMWoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 18:44:04 -0400
Date: Mon, 13 Jul 2009 15:43:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robert Hancock <hancockrwd@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Floppy constantly accessed in 2.6.31-rc2
Message-Id: <20090713154332.f2a60b93.akpm@linux-foundation.org>
In-Reply-To: <h3ehgd$mti$1@ger.gmane.org>
References: <h3ehgd$mti$1@ger.gmane.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Jul 2009 23:44:19 -0600
Robert Hancock <hancockrwd@gmail.com> wrote:

> On 2.6.31-rc2 (actually current git as of today) the floppy drive is 
> constantly being accessed with these messages being reported:
> 
> Platform driver 'floppy' needs updating - please use dev_pm_ops
> Floppy drive(s): fd0 is 1.44M
> FDC 0 is a post-1991 82077
> end_request: I/O error, dev fd0, sector 0
> end_request: I/O error, dev fd0, sector 0
> end_request: I/O error, dev fd0, sector 0
> end_request: I/O error, dev fd0, sector 0
> end_request: I/O error, dev fd0, sector 0
> end_request: I/O error, dev fd0, sector 0
> end_request: I/O error, dev fd0, sector 0
> 
> lsof reports no process with /dev/fd0 open so it is not clear what is 
> causing this activity. It looks like the access starts when I log in to 
> X, but doesn't stop when I log out. I'm guessing HAL or something checks 
> the floppy drive and then the kernel somehow gets stuck in a loop 
> retrying the request..
> 
> Anyone have any ideas what might be causing this? Commit 
> 5e50b9ef975219304cc91d601530994861585bfe seemed a bit suspicious but 
> reverting it didn't seem to help. (It did get rid of the dev_pm_ops 
> message, though..)

I'd suggest doing something like this:

--- a/drivers/block/floppy.c~a
+++ a/drivers/block/floppy.c
@@ -2975,6 +2975,7 @@ static struct cont_t rw_cont = {
 
 static void process_fd_request(void)
 {
+	dump_stack();
 	cont = &rw_cont;
 	schedule_bh(redo_fd_request);
 }
_

to find out who is poking the floppy.

If you're correct and some process is stuck doing infinite retries then
that process should be visible in the `ps' output, probably stuck in D
state.  Please have a look, see if you can work out which process is
hitting the problem and gather its kernel stack backtrace, thanks.

Meanwhile I'll ask Rafael to add this to the regression list.

