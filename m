Return-Path: <linux-kernel-owner+w=401wt.eu-S932169AbXAVVBw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932169AbXAVVBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jan 2007 16:01:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932659AbXAVVBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jan 2007 16:01:52 -0500
Received: from mx1.suse.de ([195.135.220.2]:51029 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932647AbXAVVBv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jan 2007 16:01:51 -0500
From: Neil Brown <neilb@suse.de>
To: noah <noah123@gmail.com>
Date: Tue, 23 Jan 2007 08:01:20 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17845.9760.806387.670182@notabene.brown>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Bug in drivers/md/md.c ?
In-Reply-To: message from noah on Tuesday January 16
References: <d00698fb0701160013w53d13a4eo6e22ff658fb460bb@mail.gmail.com>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday January 16, noah123@gmail.com wrote:
> Hi!
> 
> I'm getting "md: bug in file drivers/md/md.c, line 1652" (see below) after
> writing data to a md-device using dd.
> Is it really a bug or am I just using mdadm in the wrong way? I'm unsure
> about the --assume-clean flag when creating the raid5 volume.

It is a bug, not an incorrect usage.

This patch (against 2.6.19-rcX) should fix it.

Thanks,
NeilBrown



Make sure the events count in an md array never returns to zero.

Now that we sometimes step the array events count backwards
(when transitioning dirty->clean where nothing else interesting
has happened - so that we don't need to write to spares all the time),
it is possible for the event count to return to zero, which is
potentially confusing and triggers and MD_BUG.

We could possibly remove the MD_BUG, but is just as easy, and
probably safer, to make sure we never return to zero.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2007-01-22 09:08:17.000000000 +1100
+++ ./drivers/md/md.c	2007-01-23 07:53:32.000000000 +1100
@@ -1633,7 +1633,8 @@ repeat:
 	 * and 'events' is odd, we can roll back to the previous clean state */
 	if (nospares
 	    && (mddev->in_sync && mddev->recovery_cp == MaxSector)
-	    && (mddev->events & 1))
+	    && (mddev->events & 1)
+	    && mddev->events != 1)
 		mddev->events--;
 	else {
 		/* otherwise we have to go forward and ... */
