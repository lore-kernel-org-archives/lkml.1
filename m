Return-Path: <linux-kernel-owner+w=401wt.eu-S1765113AbYBVTsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765113AbYBVTsh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 14:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757913AbYBVTs0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:48:26 -0500
Received: from nf-out-0910.google.com ([64.233.182.186]:3262 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757123AbYBVTsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:48:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id:from;
        b=T7Zx7vRsrIGoJwZMe9BLtCnbkdMwd05NvqhNB1nz46Z6AUdKeVVVymOMoo8m+piaAHXclgm1t9ni36sAQqhsMMGEP95tQLXqQtIwM+1vGnuCfrBxYTubgaszneGcGiPSDdqiQAigqwWa0wt6mMdXu8nU/eqb7hrX7peBCieU5C8=
To: "Chris Clayton" <chris2553@googlemail.com>
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Date: Fri, 22 Feb 2008 20:47:52 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com> <200802181911.32128.IvDoorn@gmail.com> <c6b1100b0802220746s3441d28cj92896618bbb57bde@mail.gmail.com>
In-Reply-To: <c6b1100b0802220746s3441d28cj92896618bbb57bde@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802222047.52312.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 February 2008, Chris Clayton wrote:
> Hi Ivo,
> 
> On 18/02/2008, Ivo van Doorn <ivdoorn@gmail.com> wrote:
> > Hi,
> >
> 
> [...]
> 
> > Above traces should be enough, but to determine where rt2x00 broke
> >  down approximatly I need to have a few test result on specific moments.
> >  Could you test the kernel with the following versions:
> >
> >  rt2x00 2.0.11   2d68de3efa62655d551092f5c787505735d561ad
> >  rt2x00 2.0.12   a3c7aa58df7df80aa05f166fe3e42482247164cf
> >  rt2x00 2.0.13   5a6012e105ae1664cd2841c33bf59fbdd8d4dbcc
> >
> >  Checking those out is simply a matter of:
> >  git branch 2.0.11 2d68de3efa62655d551092f5c787505735d561ad
> >  git checkout 2.0.11
> >
> 
> OK, we seem to be struggling a little, so I've built an installed git
> and cloned Linus' 2.6 tree. My wireless network dies after a few pings
> with rt2x00 2.0.11.
> 
> >  No further bisecting is needed, but with above tests I can at least
> >  narrow it down to find the cause of this issue.
> >
> 
> If you need me to bisect, just shout. Please be patient though, I'm
> exploring new territory here :-)

I don't think bisecting this will help a lot, the rt2x00 2.0.11 release
introduced software diversity. And that is already something I suspect
of being broken.

Unfortunately software diversity was a bugfix and fix in one,
the previous setup was broken for some hardware since the
lack of software diversity caused problems.

Could you check if below patch helps in any way?

Ivo

---

diff --git a/drivers/net/wireless/rt2x00/rt2x00config.c b/drivers/net/wireless/rt2x00/rt2x00config.c
index a1d8e33..6995912 100644
--- a/drivers/net/wireless/rt2x00/rt2x00config.c
+++ b/drivers/net/wireless/rt2x00/rt2x00config.c
@@ -122,6 +122,10 @@ void rt2x00lib_config_antenna(struct rt2x00_dev *rt2x00dev,
 	libconf.ant.rx = rx;
 	libconf.ant.tx = tx;
 
+	if (rx == rt2x00dev->link.ant.active.rx &&
+	    tx == rt2x00dev->link.ant.active.tx)
+		return;
+
 	/*
 	 * Antenna setup changes require the RX to be disabled,
 	 * else the changes will be ignored by the device.
diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 65a512f..4325c08 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -191,16 +191,16 @@ static void rt2x00lib_evaluate_antenna_sample(struct rt2x00_dev *rt2x00dev)
 		return;
 
 	if (rt2x00dev->link.ant.flags & ANTENNA_RX_DIVERSITY) {
-		if (sample_a > sample_b && rx == ANTENNA_B)
+		if (sample_a > sample_b)
 			rx = ANTENNA_A;
-		else if (rx == ANTENNA_A)
+		else
 			rx = ANTENNA_B;
 	}
 
 	if (rt2x00dev->link.ant.flags & ANTENNA_TX_DIVERSITY) {
-		if (sample_a > sample_b && tx == ANTENNA_B)
+		if (sample_a > sample_b)
 			tx = ANTENNA_A;
-		else if (tx == ANTENNA_A)
+		else
 			tx = ANTENNA_B;
 	}
 
@@ -257,7 +257,7 @@ static void rt2x00lib_evaluate_antenna(struct rt2x00_dev *rt2x00dev)
 
 	if (!(rt2x00dev->link.ant.flags & ANTENNA_RX_DIVERSITY) &&
 	    !(rt2x00dev->link.ant.flags & ANTENNA_TX_DIVERSITY)) {
-		rt2x00dev->link.ant.flags &= ~ANTENNA_MODE_SAMPLE;
+		rt2x00dev->link.ant.flags = 0;
 		return;
 	}
 

