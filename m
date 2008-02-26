Return-Path: <linux-kernel-owner+w=401wt.eu-S1760576AbYBZDrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760576AbYBZDrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 22:47:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755256AbYBZDrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 22:47:11 -0500
Received: from n16.bullet.mail.mud.yahoo.com ([68.142.201.239]:20721 "HELO
	n16.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754567AbYBZDrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 22:47:10 -0500
X-Yahoo-Newman-Id: 95151.50459.bm@omp406.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type;
  b=02ggrToWgvo7HOyt4++08x5/SFbJI1LQrmAf3YcfzgzXMvBGw9pwaYaP2hVP7DWobF1v4KwofVYtp2lPaXz1oiMztz3rGvN6P9oTVvbQro2dYXAZ2D9B8znXhy8C4f1BgfI3C3cAEdPo8NbY1WInBdM5BqTdTdm5/D86YCAyvLg=  ;
X-YMail-OSG: 70V6ZVUVM1mUrjc.C0IrCLESKh9qgDhcyhDYt1dnlTR782oYo83UCGYe_mbmT6k0Bf0s.0byrQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Alexey Dobriyan <adobriyan@gmail.com>,
       "Kevin Coffman" <kwc@citi.umich.edu>
Subject: Re: 2.6.24-sha1: RIP  [<ffffffff802596c8>] iov_iter_advance+0x38/0x70
Date: Tue, 26 Feb 2008 14:46:56 +1100
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20080210140031.GA1754@martell.zuzino.mipt.ru> <20080219204711.GA1756@martell.zuzino.mipt.ru> <20080219220106.GB1756@martell.zuzino.mipt.ru>
In-Reply-To: <20080219220106.GB1756@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200802261446.57109.nickpiggin@yahoo.com.au>
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_xu4wHcO/cK2WXbS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_xu4wHcO/cK2WXbS
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wednesday 20 February 2008 09:01, Alexey Dobriyan wrote:
> On Tue, Feb 19, 2008 at 11:47:11PM +0300,  wrote:

> > > Are you reproducing it simply by running the
> > > ftest03 binary directly from the shell? How many times between oopses?
> > > It is multi-process but no threads, so races should be minimal down
> > > this path -- can you get an strace of the failing process?
>
> Speaking of multi-proceseness, changing MAXCHILD to 1, nchild to 1,
> AFAICS, generates one child which oopses the very same way (in parallel
> with generic LTP) But, lowering MAXIOVCNT to 8 generates no oops.

Thanks, I was able to reproduce quite easily with these settings.
I think I have the correct patch now (at least it isn't triggerable
any more here).

Thanks,
Nick

--Boundary-00=_xu4wHcO/cK2WXbS
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="iov-iter-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="iov-iter-fix.patch"

diff --git a/mm/filemap.c b/mm/filemap.c
index 5c74b68..2650073 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1750,14 +1750,18 @@ static void __iov_iter_advance_iov(struct iov_iter *i, size_t bytes)
 	} else {
 		const struct iovec *iov = i->iov;
 		size_t base = i->iov_offset;
+		size_t copied = 0;
 
 		/*
 		 * The !iov->iov_len check ensures we skip over unlikely
-		 * zero-length segments.
+		 * zero-length segments (without overruning the iovec).
 		 */
-		while (bytes || !iov->iov_len) {
-			int copy = min(bytes, iov->iov_len - base);
+		while (copied < bytes ||
+				unlikely(!iov->iov_len && copied < i->count)) {
+			int copy;
 
+			copy = min(bytes, iov->iov_len - base);
+			copied += copy;
 			bytes -= copy;
 			base += copy;
 			if (iov->iov_len == base) {

--Boundary-00=_xu4wHcO/cK2WXbS--

