Return-Path: <linux-kernel-owner+w=401wt.eu-S1755057AbZEZQtJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755057AbZEZQtJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 12:49:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754059AbZEZQs7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 12:48:59 -0400
Received: from mta.netezza.com ([12.148.248.132]:50430 "EHLO netezza.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753863AbZEZQs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 12:48:58 -0400
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 May 2009 12:48:58 EDT
Subject: Re: [2.6.27.24] Kernel coredump to a pipe is failing
From: Paul Smith <paul@mad-scientist.net>
Reply-To: paul@mad-scientist.net
To: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: GNU's Not Unix!
Date: Tue, 26 May 2009 12:33:54 -0400
Message-Id: <1243355634.29250.331.camel@psmith-ubeta.netezza.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 May 2009 16:33:54.0315 (UTC) FILETIME=[C25F55B0:01C9DE1F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for not following up to my previous message to get the threading
headers correct: the original is on another system I don't have access
to and I can't find a way to reply from any of the web archived
versions.  Anyway, this is a link to the original FYI:

http://marc.info/?l=linux-kernel&m=124299629611706

In that post I observed that my short cores were being caused by
dump_write() returning 0; taking another look at dump_write():

        static int dump_write(struct file *file, const void *addr, int nr)
        {
        	return file->f_op->write(file, addr, nr, &file->f_pos) == nr;
        }

If the write operation returns an error of any kind, or it fails to
write the complete set of bytes (nr here is always PAGE_SIZE, as this
function is called when it fails), then dump_write() returns 0 and we
get a short core.

So I annotated dump_write() to printk() if this operation is false, and
I get:

        file ffff8803b95d0180: dump_write: -512 < 4096

Well, -512 is ERESTARTSYS.  That, to me, seems like a reasonable error
code to get when we're trying to dump core to a pipe.  Yes?  No?

Shouldn't we be doing some kind of error handling here, at least for
basic things like signals?  Should a process that's dumping core be set
to ignore signals?  Should dump_write() try again on ERESTARTSYS?

Any advice or comments would be greatly appreciated!


