Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbYIXTkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbYIXTkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 15:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751878AbYIXTkh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 15:40:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:46648 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533AbYIXTkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 15:40:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cqXIFmQJXNyUGZMmaErMtLXQCBTTZanVZr7UVnsiL7jDMcKtmeMHY8vUOjOBM4Ns6T
         bltBLZOVmUcgmb99Kqg5m2kK6p9UNwCZjiS1CEyd5uutiL8mQSXBmaqzGoHX0GSa4SOA
         TXZvcrvSsaOjNKCOrrlonkiRRmQFZdD0WG1Mo=
Date: Wed, 24 Sep 2008 21:40:00 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-fbdev-devel@lists.sourceforge.net,
       Antonino Daplas <adaplas@gmail.com>
Subject: Re: [Linux-fbdev-devel] [PATCH 1/2] vgacon: optimize scrolling
Message-ID: <20080924193943.GA8544@joi>
References: <1222012809-5783-1-git-send-email-marcin.slusarz@gmail.com> <1222012809-5783-2-git-send-email-marcin.slusarz@gmail.com> <20080921203757.455ead71.krzysztof.h1@poczta.fm> <20080921212205.GA5740@joi> <20080923235918.114b5147.krzysztof.h1@poczta.fm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080923235918.114b5147.krzysztof.h1@poczta.fm>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 11:59:18PM +0200, Krzysztof Helt wrote:
> On Sun, 21 Sep 2008 23:22:17 +0200
> Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> 
> > On Sun, Sep 21, 2008 at 08:37:57PM +0200, Krzysztof Helt wrote:
> > > On Sun, 21 Sep 2008 18:00:08 +0200
> > > Marcin Slusarz <marcin.slusarz@gmail.com> wrote:
> > > 
> > > > Join multiple scr_memcpyw into 1-3 calls (usually 2).
> > > > (benchmarked average speedup: 1%)
> > > > 
> > > 
> > > The scr_memcpyw is an inline function so there is no real call here.
> > 
> > ... or it's defined to memcpy
> >  
> > > However, have you tested the patch with scroll range > 2 *  vgacon_scrollback_size?
> > >
> > > It seems that your patch only handles scrolling if it is not bigger than 2 * vgacon_scrollback_size.
> > 
> > No. count is always within range <0, c->vc_rows> (look how it's computed
> > just before this loop). Second copy is needed only when end of screen
> > crosses end/beginning of scrollback (it's a circular buffer).
> > 
> 
> This is not what I asked for. If the vgacon_scrollback_cnt is smaller then c->vc_rows it can happen.
> The answer to my question is that count is always < vgacon_scrollback_cnt (set earlier before 
> checking if it is in the <0,c->vc_rows> range).

Yep

> (...)
> 
> > > > +	if (count) {
> > > > +		int copysize;
> > > > +		count *= c->vc_size_row;
> > > > +		/* how much memory to end of buffer left? */
> > > > +		copysize = min(count, vgacon_scrollback_size - soff);
> > > > +		scr_memcpyw(d, vgacon_scrollback + soff, copysize);
> > > > +		d += copysize;
> > > > +		count -= copysize;
> > > > +		
> > > > +		if (count) {
> > > > +			copysize = min(count, vgacon_scrollback_size);
> 
> This line I got confused by. If the count is always smaller then
> the vgacon_scrollback_cnt before (thus the vgacon_scrollback_size 
> inside the if clause) this line always evaluates to copysize = count here.

You are right. I dropped this "call".
Thanks for a review.

---
Subject: [PATCH 1/2] vgacon: optimize scrolling

Join multiple scr_memcpyw into 1-3 calls (usually 2).
(benchmarked average speedup: 1%)

Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: Krzysztof Helt <krzysztof.h1@poczta.fm>
Cc: Antonino Daplas <adaplas@gmail.com>
Cc: linux-fbdev-devel@lists.sourceforge.net
---
 drivers/video/console/vgacon.c |   27 +++++++++++++++------------
 1 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/video/console/vgacon.c b/drivers/video/console/vgacon.c
index bd1f57b..29d1209 100644
--- a/drivers/video/console/vgacon.c
+++ b/drivers/video/console/vgacon.c
@@ -292,23 +292,26 @@ static int vgacon_scrolldelta(struct vc_data *c, int lines)
 	d = (void *) c->vc_origin;
 	s = (void *) c->vc_screenbuf;
 
-	while (count--) {
-		scr_memcpyw(d, vgacon_scrollback + soff, c->vc_size_row);
-		d += c->vc_size_row;
-		soff += c->vc_size_row;
-
-		if (soff >= vgacon_scrollback_size)
-			soff = 0;
+	if (count) {
+		int copysize;
+		count *= c->vc_size_row;
+		/* how much memory to end of buffer left? */
+		copysize = min(count, vgacon_scrollback_size - soff);
+		scr_memcpyw(d, vgacon_scrollback + soff, copysize);
+		d += copysize;
+		count -= copysize;
+
+		if (count) {
+			scr_memcpyw(d, vgacon_scrollback, count);
+			d += count;
+		}
 	}
 
 	if (diff == c->vc_rows) {
 		vgacon_cursor(c, CM_MOVE);
 	} else {
-		while (diff--) {
-			scr_memcpyw(d, s, c->vc_size_row);
-			d += c->vc_size_row;
-			s += c->vc_size_row;
-		}
+		if (diff)
+			scr_memcpyw(d, s, diff * c->vc_size_row);
 	}
 
 	return 1;
-- 
1.5.6.4

