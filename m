Return-Path: <linux-kernel-owner+w=401wt.eu-S1763851AbYBZRjs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763851AbYBZRjs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 12:39:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761672AbYBZRjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 12:39:36 -0500
Received: from ag-out-0708.google.com ([72.14.246.241]:9618 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761549AbYBZRje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 12:39:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references:mime-version:content-type:content-disposition:content-transfer-encoding:in-reply-to:user-agent:from;
        b=WQm7yHbEeH4F5ly1NjW6d7hRrH39SNcOfwCaJ0galM5rVVGyTCJm+WsA32YYt7iOozUi5307U9Z6KchMxfpnTh8ytVWqNIWiMEqXGmip2hZ6zkPV18pdD25NAzXA/x2Cu4CrPISEQn3bT7lAw0/BE9jwQVLaJh1hU/g80Ggajpg=
Date: Tue, 26 Feb 2008 18:38:55 +0100
To: bzolnier@gmail.com
Cc: Andreas Schwab <schwab@suse.de>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>,
       linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       j-nomura@ce.jp.nec.com
Subject: Re: 2.6.25-rc1/2 CD/DVD burning broken
Message-ID: <20080226173855.GA5497@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, bzolnier@gmail.com,
	Andreas Schwab <schwab@suse.de>,
	Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, linux-kernel@vger.kernel.org,
	jens.axboe@oracle.com, j-nomura@ce.jp.nec.com
References: <20080218.135827.74754725.k-ueda@ct.jp.nec.com> <jek5kvisih.fsf@sykes.suse.de> <20080224163244.GA11998@gollum.tnic> <jehcfyffyp.fsf@sykes.suse.de> <002101c87759$0fb4f010$58f80d0a@brian> <jeejb0968h.fsf@sykes.suse.de> <20080225204543.GA26788@gollum.tnic> <jeir0c7kp4.fsf@sykes.suse.de> <20080226042414.GB26788@gollum.tnic> <jebq63epnm.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <jebq63epnm.fsf@sykes.suse.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2008 at 03:52:13PM +0100, Andreas Schwab wrote:
> Borislav Petkov <petkovbb@googlemail.com> writes:
> 
> > On Mon, Feb 25, 2008 at 11:08:55PM +0100, Andreas Schwab wrote:
> >> Borislav Petkov <petkovbb@googlemail.com> writes:
> >> 
> >> > On Mon, Feb 25, 2008 at 08:38:22PM +0100, Andreas Schwab wrote:
> >> >> "Kiyoshi Ueda" <k-ueda@ct.jp.nec.com> writes:
> >> >> 
> >> >> > I'm looking at this problem, but currently no idea why the conversion
> >> >> > to blk_end_request causes it.
> >> >> 
> >> >> cdrom_newpc_intr apparently never sets rq->sense_len.
> >> >> 
> >> >
> >> > actually it does, see the code chunk around line 1188 in 2.6.25-rc2, for
> >> > example.
> >> 
> >> Yes, it does, but it always adds zero.
> >
> > yep, true. Does that fix your dvd burning problem?
> 
> Yes, sure.
> 
> Andreas.

Bart,

please apply the enclosed patch since it fixes dvd burning with growisofs on
Pioneer drives as reported by Andreas.

Thanks.

---
From: Andreas Schwab <schwab@suse.de>

Move counting of sense bytes into the transfer loop.

Signed-off-by: Andreas Schwab <schwab@suse.de>
Acked-by: Borislav Petkov <petkovbb@gmail.com>

---
 drivers/ide/ide-cd.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.25-rc3.orig/drivers/ide/ide-cd.c	2008-02-25 01:03:31.000000000 +0100
+++ linux-2.6.25-rc3/drivers/ide/ide-cd.c	2008-02-25 22:54:42.000000000 +0100
@@ -1182,11 +1182,10 @@ static ide_startstop_t cdrom_newpc_intr(
 			else
 				rq->data += blen;
 		}
+		if (!write && blk_sense_request(rq))
+			rq->sense_len += blen;
 	}
 
-	if (write && blk_sense_request(rq))
-		rq->sense_len += thislen;
-
 	/*
 	 * pad, if necessary
 	 */

-- 
Regards/Gruﬂ,
    Boris.
