Return-Path: <linux-kernel-owner+w=401wt.eu-S1755915AbZLHPN1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbZLHPN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 10:13:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754216AbZLHPN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 10:13:27 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:33505 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148AbZLHPN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 10:13:26 -0500
Date: Tue, 8 Dec 2009 16:13:32 +0100
From: Jan Kara <jack@suse.cz>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: Possible irq lock inversion dependency detected in JBD
Message-ID: <20091208151332.GA3141@atrey.karlin.mff.cuni.cz>
References: <4B0BD960.5040105@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B0BD960.5040105@vlnb.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

> During testing I had the below trace from lockdep. After some googling seems
> it wasn't reported. The complete trace attached, it's almost 800K uncompressed.
> 
> =========================================================
> [ INFO: possible irq lock inversion dependency detected ]
> 2.6.31-scst-dbg #3
> ---------------------------------------------------------
> kswapd0/290 just changed the state of lock:
>  (jbd_handle){+.+.-.}, at: [<7826a6fa>] journal_start+0xd4/0x13a
> but this lock took another, RECLAIM_FS-unsafe lock in the past:
>  (&type->s_lock_key){+.+.+.}
> 
> and interrupts could create inverse lock ordering between them.
> 
> 
> other info that might help us debug this:
> no locks held by kswapd0/290.
  Thanks for the report. If I'm reading the lockdep messages right, it
complains that page reclaim can be run with sb->s_lock held but we also
start a transaction in the page reclaim path and we take sb->s_lock after
starting a transaction in some paths.
  The warning seems to be false positive to me since we don't really
acquire sb->s_lock in the reclaim path. It would be nice if we could
get this sorted out but I don't see an easy way out of this...

								Honza

-- 
Jan Kara <jack@suse.cz>
SuSE CR Labs
