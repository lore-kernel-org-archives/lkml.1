Return-Path: <linux-kernel-owner+w=401wt.eu-S1752920AbXLaTyx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbXLaTyx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 14:54:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbXLaTyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 14:54:45 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:44225 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935AbXLaTyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 14:54:44 -0500
Subject: getting rid of filp search in fs_may_remount_ro()
From: Dave Hansen <haveblue@us.ibm.com>
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20071226141214.GA31455@lst.de>
References: <20071126135220.GA17244@lst.de>  <20071226141214.GA31455@lst.de>
Content-Type: text/plain
Date: Mon, 31 Dec 2007 11:54:26 -0800
Message-Id: <1199130866.13731.27.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-12-26 at 15:12 +0100, Christoph Hellwig wrote:
> Btw, I just noticed in current -mm fs_may_remount_ro() is still around
> and not replaced by ther per-sb writers count.  That surely sounds like
> some kind of mismerge..

I was actually leaving that for later.  Getting rid of the filp search
is a great benefit of the r/o bind patches, but it isn't strictly
necessary and it doesn't really hurt anything to keep it.

The reason that it was contentious was that we need some way to be able
to do an sb-to-mount mapping.  When remounting the sb, we need to
determine whether *any* of the mounts of that sb have any writers.

We don't currently have any mechanisms to do direct lookups from sb to
mount.  The only alternative I can see right now is to walk over all
tasks, then walk over all vfs namespaces, and walk each mount tree to
see if any mounts are of the sb we're looking for.  This needs to be
done while already holding the mnt_writers[] locks so that no new mnt
writers can come in.

*THAT* is going to be a heavyweight operation.  I need to go look in
detail at how the mount trees are kept, and we'll need some kind of
mechanism to keep track of which vfs namespaces we've looked at during
the search so we don't search them twice. 

Can you think of a simpler way to do it?

-- Dave

