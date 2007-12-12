Return-Path: <linux-kernel-owner+w=401wt.eu-S1757551AbXLLXDV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757551AbXLLXDV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 18:03:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbXLLXDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 18:03:13 -0500
Received: from smtp-out.google.com ([216.239.45.13]:62518 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772AbXLLXDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 18:03:12 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=Yh+4XJD5Eb4nD7b7a05ECGEc84L+Zga4f+mQ9E9hb2TQiFy5+Dt/6gchFMG+OMeeA
	Wv3WydNHtARNTI4y2WQIg==
Message-ID: <532480950712121503r64dbd51oc4778e96cbd37e3c@mail.gmail.com>
Date: Wed, 12 Dec 2007 15:03:04 -0800
From: "Michael Rubin" <mrubin@google.com>
To: "Peter Zijlstra" <a.p.zijlstra@chello.nl>
Subject: Re: [patch 1/1] Writeback fix for concurrent large and small file writes.
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, wfg@mail.ustc.edu.cn
In-Reply-To: <1197492954.6353.64.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071211020255.CFFB21080E@localhost>
	 <1197492954.6353.64.camel@lappy>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 12, 2007 12:55 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> On Mon, 2007-12-10 at 18:02 -0800, Michael Rubin wrote:
> > From: Michael Rubin <mrubin@google.com>
> The part I miss here is the rationale on _how_ you solve the problem.
>
> The patch itself is simple enough, but I've been staring at this code
> for a while now, and I'm just not getting it.

Apologies for the lack of rationale. I have been staring at this code
for awhile also and it makes my head hurt. I have a patch coming
(hopefully today) that proposes using one data  structure with a more
consistent priority scheme for 2.6.25. To me it's simpler, but I am
biased.

The problem we encounter when we append to a large file at a fast rate
while also writing to smaller files is that the wb_kupdate thread does
not keep up with disk traffic. In this workload often the inodes end
up at fs/fs-writeback.c:287 after do_writepages, since do_writepages
did not write all the pages.  This can be due to congestion but I
think there are other causes also since I have observed so.

The first issue is that the inode is put on the s_more_io queue. This
ensures that more_io is set at the end of sync_sb_inodes. The result
from that is the wb_kupdate routine will perform a sleep at
mm/page-writeback.c:642. This slows us down enough that the wb_kupdate
cannot keep up with traffic.

The other issue is that the inode that has been placed on the
s_more_io queue cannot be processed by sync_sb_inodes until the entire
s_io list is empty. With lots of small files that are not being
dirtied as quickly as the one large inode on the s_more_io queue the
inode with the most pages being dirtied is not given attention and
wb_kupdate cannot keep up again.

mrubin
