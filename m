Return-Path: <linux-kernel-owner+w=401wt.eu-S1758854AbYAFQUF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854AbYAFQUF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 11:20:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754239AbYAFQT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 11:19:56 -0500
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:25626 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754209AbYAFQTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 11:19:55 -0500
Message-ID: <4780FF85.4020501@panasas.com>
Date: Sun, 06 Jan 2008 18:19:17 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Matthew Wilcox <matthew@wil.cx>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Osterlund <petero2@telia.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [patch] scsi: revert "[SCSI] Get rid of scsi_cmnd->done"
References: <20080102162534.GA4041@elte.hu> <1199292381.3258.32.camel@localhost.localdomain> <alpine.LFD.1.00.0801021113150.32517@woody.linux-foundation.org> <20080102194030.GC11638@parisc-linux.org> <1199304735.3258.53.camel@localhost.localdomain> <alpine.LFD.1.00.0801021227140.32517@woody.linux-foundation.org> <1199316785.3258.85.camel@localhost.localdomain> <alpine.LFD.1.00.0801021756310.3010@woody.linux-foundation.org> <m3ir27oe7f.fsf@telia.com> <alpine.LFD.1.00.0801051900500.2811@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0801051900500.2811@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 06 Jan 2008 16:19:22.0955 (UTC) FILETIME=[E5FAD9B0:01C8507F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 06 2008 at 5:43 +0200, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> 
> This all still leaves the question unanswered why that commit 
> 6f5391c283d7fdcf24bf40786ea79061919d1e1d changed any behaviour at all. 
> Because the thing that Peter is describing has nothing to do with any 
> low-level drivers what-so-ever.
> 
> 		Linus
> 

James Matthew.
I have a (very) wild guess at what maybe have changed with the cmnd->done
patch:

Do you remember the effective loop in scsi_lib:scsi_end_request() where
if bufflen was smaller then original request size, do to truncation
of bufflen by ULD, then the remaining of the request is re-queued again
as a new scsi-command. Well I think that the old system would call
cmnd->done for every iteration, and the new system, since the done is
called by the block-Q, does not see the resubmit of the new command.

I have not followed all code path of the matter, but I know that sr does
alters bufflen in some cases. 
All this is not a bug in itself, but it is a change in behavior that might 
cause the current sr hack to fail.

Boaz
