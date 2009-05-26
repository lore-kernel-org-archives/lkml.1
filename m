Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbZEZSBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbZEZSBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 14:01:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbZEZSBK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 14:01:10 -0400
Received: from mta.netezza.com ([12.148.248.132]:51254 "EHLO netezza.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754782AbZEZSBJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 14:01:09 -0400
Subject: Re: [2.6.27.24] Kernel coredump to a pipe is failing
From: Paul Smith <paul@mad-scientist.net>
Reply-To: paul@mad-scientist.net
To: linux-kernel@vger.kernel.org
In-Reply-To: <1243355634.29250.331.camel@psmith-ubeta.netezza.com>
References: <1243355634.29250.331.camel@psmith-ubeta.netezza.com>
Content-Type: text/plain
Organization: GNU's Not Unix!
Date: Tue, 26 May 2009 14:01:09 -0400
Message-Id: <1243360869.29250.340.camel@psmith-ubeta.netezza.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 May 2009 18:01:09.0527 (UTC) FILETIME=[F2CD4A70:01C9DE2B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-26 at 12:33 -0400, Paul Smith wrote:
> Sorry for not following up to my previous message to get the threading
> headers correct: the original is on another system I don't have access
> to and I can't find a way to reply from any of the web archived
> versions.  Anyway, this is a link to the original FYI:
> 
> http://marc.info/?l=linux-kernel&m=124299629611706
> 
> In that post I observed that my short cores were being caused by
> dump_write() returning 0; taking another look at dump_write():
> 
>         static int dump_write(struct file *file, const void *addr, int nr)
>         {
>         	return file->f_op->write(file, addr, nr, &file->f_pos) == nr;
>         }
> 
> If the write operation returns an error of any kind, or it fails to
> write the complete set of bytes (nr here is always PAGE_SIZE, as this
> function is called when it fails), then dump_write() returns 0 and we
> get a short core.

I have verified that fs/pipe.c:pipe_write() is returning ERESTARTSYS as
a result of this code:

		if (signal_pending(current)) {
			if (!ret)
				ret = -ERESTARTSYS;
			break;
		}

I'm not exactly sure where to go from here, without knowing what the
design SHOULD be for signals that are received during core dumps.


