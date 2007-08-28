Return-Path: <linux-kernel-owner+w=401wt.eu-S1763809AbXH1T0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763809AbXH1T0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 15:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761674AbXH1TLT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 15:11:19 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36779 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761653AbXH1TLS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 15:11:18 -0400
Date: Tue, 28 Aug 2007 20:11:14 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-cifs-client@lists.samba.org, nfs@lists.sourceforge.net
Subject: Re: [PATCH 0/4] add killattr inode operation to allow filesystems to interpret ATTR_KILL_S*ID bits
Message-ID: <20070828191114.GA3419@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Jeff Layton <jlayton@redhat.com>, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-cifs-client@lists.samba.org,
	nfs@lists.sourceforge.net
References: <200708271727.l7RHR36m007248@dantu.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708271727.l7RHR36m007248@dantu.rdu.redhat.com>
User-Agent: Mutt/1.4.2.3i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Sorry for not replying to the previsious revisions, but I've been out
for on vacation.

I can't say I like this version.  Now we've got callouts at two rather close
levels which is not very nice from the interface POV.

Maybe preference is for the first scheme where we simply move interpreation
of the ATTR_KILL_SUID/ATTR_KILL_SGID into the setattr routine and provide
a nice helper for the normal filesystem to use.

If people are really concerned about adding two lines of code to the
handfull of setattr operation there's a variant of this scheme that can
avoid it:

 - notify_change is modified to not clear the ATTR_KILL_SUID/ATTR_KILL_SGID
   but update ia_mode and the ia_valid flag to include ATTR_MODE.
 - disk filesystems stay unchanged and never look at
   ATTR_KILL_SUID/ATTR_KILL_SGID, but nfs can check for it and ignore
   the ATTR_MODE flags and ia_valid in this case and do the right thing
   on the server side.

