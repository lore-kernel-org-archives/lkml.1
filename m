Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbYAIMuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbYAIMuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 07:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbYAIMuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 07:50:04 -0500
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:52167 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752383AbYAIMuD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 07:50:03 -0500
Date: Wed, 9 Jan 2008 07:49:13 -0500
From: Theodore Tso <tytso@MIT.EDU>
To: Valdis.Kletnieks@vt.edu
Cc: Kyle Moffett <mrmacman_g4@mac.com>, Andi Kleen <andi@firstfloor.org>,
       LKML Kernel <linux-kernel@vger.kernel.org>
Subject: Re: The ext3 way of journalling
Message-ID: <20080109124913.GO21097@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Valdis.Kletnieks@vt.edu,
	Kyle Moffett <mrmacman_g4@mac.com>,
	Andi Kleen <andi@firstfloor.org>,
	LKML Kernel <linux-kernel@vger.kernel.org>
References: <slrnfo77tv.2rr.tuomov@jolt.modeemi.cs.tut.fi> <p73odbwqmx2.fsf@bingen.suse.de> <slrnfo7b3a.6m2.tuomov@jolt.modeemi.cs.tut.fi> <20080108181525.GL27800@mit.edu> <p734pdoqbva.fsf@bingen.suse.de> <8DEA7347-120C-4A97-A208-2577ED88F799@mac.com> <22619.1199865353@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22619.1199865353@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2008 at 02:55:53AM -0500, Valdis.Kletnieks@vt.edu wrote:
> 
> Does this create a snapshot of the *disk* at that moment, or does it
> capture "disk plus still-to-be-written blocks in the cache"?
> (Phrased differently, does it Do The Right Thing regarding "blocks
> queued before lvcreate" and "blocks queued for write after
> lvcreate")?
> 
> If the snapshot doesn't capture the blocks queued but still
> unwritten by kjournald and similar, then you're still hitting the
> same old problems that you always get when you fsck an "active
> disk".

Actually, it does better than that.  For ext3 and xfs, it will take a
snapshot of the filesystem in a quiscent state; that is, it will force
the journal transaction to close, suspend all filesystem activity,
take a snapshot of the disk as if it had been unmounted, and then
allow filesystem activity to continue.

So if you look at an ext3 filesystem taken in this way, you will see
that the NEEDS_RECOVERY flag is not set, since the ext3 journal is
empty on the snapshot.  So snapshots are also a great way of doing
stable backups.  For the purposes of stable backups, you'll also want
to quiesce your application files, particularly databases.  

For example, in the case of mysql, send the server the sql commands
"flush tables with read lock; flush logs", take the snapshot, and
then after the snapshot send the server the sql command "unlock tables".
For more information, see: 

    http://forums.mysql.com/read.php?26,185026,185302#msg-185302

If you do this, you will get a snapshot of your disk where *both* the
database and the filesystem is at a stable state, perfect for doing a
backup.

						- Ted
