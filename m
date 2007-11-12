Return-Path: <linux-kernel-owner+w=401wt.eu-S1760398AbXKLXRX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760398AbXKLXRX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 18:17:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757590AbXKLXRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 18:17:15 -0500
Received: from mail.fieldses.org ([66.93.2.214]:39770 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840AbXKLXRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 18:17:14 -0500
Date: Mon, 12 Nov 2007 18:17:03 -0500
To: Neil Brown <neilb@suse.de>
Cc: nfs@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: nfsd bugfixes
Message-ID: <20071112231703.GD2645@fieldses.org>
References: <1194901503-23105-1-git-send-email-bfields@citi.umich.edu> <18232.52970.213438.902011@notabene.brown> <20071112221349.GA2645@fieldses.org> <18232.54549.271030.214405@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18232.54549.271030.214405@notabene.brown>
User-Agent: Mutt/1.5.17 (2007-11-01)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2007 at 09:35:01AM +1100, Neil Brown wrote:
> 
> (CC: trimmed - as Bruce says: separate discussion)
> 
> On Monday November 12, bfields@fieldses.org wrote:
> > On Tue, Nov 13, 2007 at 09:08:42AM +1100, Neil Brown wrote:
> > > Calling nfsd_setuser an extra time does open us up for a very tiny
> > > possibility of an ENOMEM at an awkward time.
> > 
> > Hm.  Could you give an example of possible consequences?
> 
> Just that you could get an ENOMEM in the middle of a NFSv4 COMPOUND.
> I guess that should result in NFSERR_RESOURCE and we just hope the
> client is able to cope and resend the remainder of the compound.
> Though looking at the code, ENOMEM becomes nfserr_dropit... does that
> mean the we would drop the whole request and the client would need to
> resend, possibly duplicating non-idempotent portions?

Yeah, OK, that's another one for my list of compound processing problems
to worry about.  (Others:

	- a deferral for an export upcall can similarly lead to
	  incorrect behavior on nonidempotent operations; if we could
	  fix this we could also eliminate the nfs4idmap.c special case,
	  which would probably enable some other cleanup.  I've made a
	  couple half-hearted attempts to fix this but don't have
	  anything finished yet.

	- We've still got the reply cache turned off for nfsv4!  I think
	  it was originally turned off just because whoever did it
	  didn't want to figure out which compounds to cache.  That's
	  probably not hard to fix, but last I checked I didn't think
	  our reply cache actually helped much in the tcp case (the only
	  case we care about).  So that needs to be fixed first.  I've
	  done no work on this yet.

)--b.
