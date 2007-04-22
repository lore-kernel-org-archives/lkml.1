Return-Path: <linux-kernel-owner+w=401wt.eu-S1030819AbXDVTuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030819AbXDVTuS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 15:50:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030824AbXDVTuR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 15:50:17 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:39424 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030819AbXDVTuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 15:50:15 -0400
Date: Sun, 22 Apr 2007 20:50:01 +0100
From: Christoph Hellwig <hch@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Simon Horman <horms@verge.net.au>,
       "Eric W. Biederman" <ebiederm@xmission.com>, containers@lists.osdl.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, Wensong Zhang <wensong@linux-vs.org>,
       Julian Anastasov <ja@ssi.bg>
Subject: Re: [PATCH] ipv4/ipvs: Convert to kthread API
Message-ID: <20070422195001.GB18561@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Simon Horman <horms@verge.net.au>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	containers@lists.osdl.org, Oleg Nesterov <oleg@tv-sign.ru>,
	linux-kernel@vger.kernel.org, Wensong Zhang <wensong@linux-vs.org>,
	Julian Anastasov <ja@ssi.bg>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com> <11769696262330-git-send-email-ebiederm@xmission.com> <20070419090435.GB26050@verge.net.au> <20070419155944.e5fb8e66.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419155944.e5fb8e66.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2007 at 03:59:44PM -0700, Andrew Morton wrote:
> There still seems to be quite a lot of complexity in this driver's
> thread handling which could be removed if we did a full conversion 
> to the kthread API.
> 
> It all looks.... surprisingly complex in there.

It is.  There quite a few interesting oddities in this code:

 - creation of a forker thread.  This is superflous when using the
   kthread infrastructure as a thread created by kthread_create
   always comes from our dedicated forker thread.
 - the infinite retry on failure looks very bogus, the system
   doesn't recover very well if you try to fork forever in a loop :)
 - a lot of very overlapping state variables.  My reading of the
   code suggests that both a 'master' and 'backup' thread can
   run at the same time.  I think the code would benefit a lot
   from totally separating these codepathes.
 - start_sync_thread and stop_sync_thread are called with
   unchecked user supplied arguments and bug if they don't
   match the expected values.  While all this is under
   capable(CAP_NET_ADMIN) it still sounds like something to
   fix.
 - and the usual removal of semaphores and completions for
   startup/shutdown would benefit the code a lot, as for most
   thread users.
