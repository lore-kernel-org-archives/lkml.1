Return-Path: <linux-kernel-owner+w=401wt.eu-S1759767AbYAaAjS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759767AbYAaAjS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2008 19:39:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754816AbYAaAjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jan 2008 19:39:04 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:36694 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597AbYAaAjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2008 19:39:01 -0500
X-Greylist: delayed 380 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jan 2008 19:39:00 EST
Date: Wed, 30 Jan 2008 17:32:31 -0700
From: Andreas Dilger <adilger@Sun.COM>
Subject: Re: [RFC] ext3: per-process soft-syncing data=ordered mode
In-reply-to: <200801300929.21778.chris.mason@oracle.com>
To: Chris Mason <chris.mason@oracle.com>
Cc: Al Boldi <a1426z@gawab.com>, Jan Kara <jack@suse.cz>,
       Chris Snook <csnook@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Message-id: <20080131003231.GK23836@webber.adilger.int>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
X-GPG-Key: 1024D/0D35BED6
X-GPG-Fingerprint: 7A37 5D79 BF1B CECA D44F  8A29 A488 39F5 0D35 BED6
References: <200801242336.00340.a1426z@gawab.com>
 <20080129172232.GA9770@atrey.karlin.mff.cuni.cz>
 <200801300904.48299.a1426z@gawab.com>
 <200801300929.21778.chris.mason@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 30 January 2008, Al Boldi wrote:
> And, a quick test of successive 1sec delayed syncs shows no hangs until
> about 1 minute (~180mb) of db-writeout activity, when the sync abruptly
> hangs for minutes on end, and io-wait shows almost 100%.

How large is the journal in this filesystem?  You can check via
"debugfs -R 'stat <8>' /dev/XXX".  Is this affected by increasing
the journal size?  You can set the journal size via "mke2fs -J size=400" 
at format time, or on an unmounted filesystem by running
"tune2fs -O ^has_journal /dev/XXX" then "tune2fs -J size=400 /dev/XXX".

I suspect that the stall is caused by the journal filling up, and then
waiting while the entire journal is checkpointed back to the filesystem
before the next transaction can start.

It is possible to improve this behaviour in JBD by reducing the amount
of space that is cleared if the journal becomes "full", and also doing
journal checkpointing before it becomes full.  While that may reduce
performance a small amount, it would help avoid such huge latency problems.
I believe we have such a patch in one of the Lustre branches already,
and while I'm not sure what kernel it is for the JBD code rarely changes
much....

Cheers, Andreas
--
Andreas Dilger
Sr. Staff Engineer, Lustre Group
Sun Microsystems of Canada, Inc.

