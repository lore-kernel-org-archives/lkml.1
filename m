Return-Path: <linux-kernel-owner+w=401wt.eu-S1754677AbYGUPCx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754677AbYGUPCx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 11:02:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbYGUPCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 11:02:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:4611 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751099AbYGUPCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 11:02:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Rp9VcS/dT1TyuYfiOnbKd2M3/uN5u2/97O2E0o7HrJmOT4vhOdRLoUBjt9qIl9KHND
         W3jFHWc7kab8PGCAanqBDOdiWvOF9mESOa+psB6aQr0Y5hx9gZmUWhlJ1GwI7Xpug2Zr
         7BJSfGo5+4l9PQna/uF9V0B29MQwRh95FdGg8=
Date: Mon, 21 Jul 2008 10:04:16 -0500
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, airlied@redhat.com, davem@davemloft.net
Subject: Re: Suspend to RAM regression (bisected)
Message-ID: <20080721150415.GA3804@localhost>
References: <20080721020349.GA4328@localhost> <alpine.LFD.1.10.0807202119240.31863@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0807202119240.31863@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 20.Jul'08 at 21:21:06 -0700, Linus Torvalds wrote:
> On Sun, 20 Jul 2008, Carlos R. Mafra wrote:
> > 
> > I bisected this regression down to c0e09200dc0813972442e550a5905a132768e56c
> > ("drm: reorganise drm tree to be more future proof"), and I checked that
> > reverting this commit (it reverts cleanly) really makes the regression go
> > away.
> 
> Hmm. That did almost only just renames, so maybe it's fixed by the pull I 
> just did that added the commit "gpu: re-order GPU subdirectory vs char for 
> AGP vs DRM startup".
> 
> I _just_ pushed out the end result, so it should be in my git tree in a 
> couple of minutes when the mirroring finishes.

Ok, I tried your new v2.6.26-5253-g14b395e and unfortunately suspend to
RAM fails completely now. The backlight doesn't turn off and the keyboard
leds keep blinking.

After several boots I bisected this new regression down to 
37437bb2e1ae8af470dfcd5b4ff454110894ccaf ("pkt_sched: Schedule qdiscs 
instead of netdev_queue.") by David Miller. 

I could not check whether reverting this commit on top of current 
kernel fixes the problem because it does not revert cleanly.

But the "good" kernels marked below with the exception of the first one 
(5b664cb23) did not have the original regression from my report of yesterday, 
so they were really good.

This is the bisection log:

# good: [5b664cb235e97afbf34db9c4d77f08ebd725335e] Merge branch 'upstream-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/mfasheh/ocfs2
git-bisect good 5b664cb235e97afbf34db9c4d77f08ebd725335e
# bad: [14b395e35d1afdd8019d11b92e28041fad591b71] Merge branch 'for-2.6.27' of git://linux-nfs.org/~bfields/linux
git-bisect bad 14b395e35d1afdd8019d11b92e28041fad591b71
# good: [6ba33ac8a47d33d0b5996d24ddf66c457cd7180b] amd8111e: delete non NAPI code from the driver.
git-bisect good 6ba33ac8a47d33d0b5996d24ddf66c457cd7180b
# skip: [db6d8c7a4027b48d797b369a53f8470aaeed7063] Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6
git-bisect skip db6d8c7a4027b48d797b369a53f8470aaeed7063
# bad: [3a682fbd732d3d27bec722a923952b0938e8a404] pkt_sched: Fix build with NET_SCHED disabled.
git-bisect bad 3a682fbd732d3d27bec722a923952b0938e8a404
# good: [925068dcdc746236264d1877d3d5df656e87882a] Merge branch 'davem-next' of master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/netdev-2.6
git-bisect good 925068dcdc746236264d1877d3d5df656e87882a
# bad: [17715e62a5e5c7224e5f906a4b8f9e5084100118] pkt_sched: Use per-queue locking in shutdown_scheduler_queue.
git-bisect bad 17715e62a5e5c7224e5f906a4b8f9e5084100118
# good: [70efce27fc3d54271519244dc5e47da4ed711dd4] net/ipv4/tcp.c: Fix use of PULLHUP instead of POLLHUP in comments.
git-bisect good 70efce27fc3d54271519244dc5e47da4ed711dd4
# good: [9a6d276e85aa3d8f308fc5e8de6892daeb60ae5f] core: add stat to track unresolved discards in neighbor cache
git-bisect good 9a6d276e85aa3d8f308fc5e8de6892daeb60ae5f
# good: [51cb6db0f5654f08a4a6bfa3888dc36a51c2df3e] mac80211: Reimplement WME using ->select_queue().
git-bisect good 51cb6db0f5654f08a4a6bfa3888dc36a51c2df3e
# good: [d3b753db7c4f1f37a98b51974d484fda5d86dab5] pkt_sched: Move gso_skb into Qdisc.
git-bisect good d3b753db7c4f1f37a98b51974d484fda5d86dab5
# bad: [37437bb2e1ae8af470dfcd5b4ff454110894ccaf] pkt_sched: Schedule qdiscs instead of netdev_queue.
git-bisect bad 37437bb2e1ae8af470dfcd5b4ff454110894ccaf
# good: [7698b4fcabcd790efc4f226bada1e7b5870653af] pkt_sched: Add and use qdisc_root() and qdisc_root_lock().
git-bisect good 7698b4fcabcd790efc4f226bada1e7b5870653af
