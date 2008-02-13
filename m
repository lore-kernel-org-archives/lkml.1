Return-Path: <linux-kernel-owner+w=401wt.eu-S1762520AbYBMIZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762520AbYBMIZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 03:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755846AbYBMIZN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 03:25:13 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:50094 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110AbYBMIZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 03:25:10 -0500
Message-Id: <010901c86e19$adaf1730$41a8400a@bsd.tnes.nec.co.jp>
From: "Takashi Sato" <t-sato@yk.jp.nec.com>
To: "Theodore Tso" <tytso@MIT.EDU>, <linux-ext4@vger.kernel.org>,
       <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20080125195938t-sato@mail.jp.nec.com> <20080125121851.GA3361@dmon-lap.sw.ru> <20080125133329.GB8184@mit.edu>
Subject: Re: [RFC] ext3 freeze feature
Date: Wed, 13 Feb 2008 17:23:14 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.3028
X-MIMEOLE: Produced By Microsoft MimeOLE V6.00.2900.3198
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> P.S.  Oh yeah, it should be noted that freezing at the filesystem
> layer does *not* guarantee that changes to the block device aren't
> happening via mmap()'ed files.  The LVM needs to freeze writes the
> block device level if it wants to guarantee a completely stable
> snapshot image.  So the proposed patch doens't quite give you those
> guarantees, if that was the intended goal.

I don't think a mmap()'ed file is written to a block device while a filesystem
is frozen.  pdflush starts the writing procedure of the mmap()'ed file's
data and calls ext3_ordered_writepage.  ext3_ordered_writepage calls
ext3_journal_start to get the journal handle.  As a result, the process
waits for unfreeze in start_this_handle.
pdflush
:    :
ext3_ordered_writepage
ext3_journal_start
ext3_journal_start_sb
journal_start
start_this_handle <--- wait here

I actually tried freezing the filesystem after updating the mmap()'ed
file's data.  But, the writing to the block device didn't happen.
(It happened right after unfreeze.)

I don't think the freeze feature on the block device level is needed
because the writing for the mmap()'ed file is suspended on
the frozen filesystem.

Any comments are very welcome.

Cheers, Takashi 

