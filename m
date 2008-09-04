Return-Path: <linux-kernel-owner+w=401wt.eu-S1757797AbYIDIid@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757797AbYIDIid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:38:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755939AbYIDIiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:38:21 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44591 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751671AbYIDIiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:38:20 -0400
Date: Thu, 4 Sep 2008 01:37:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: linux-next: Tree for September 3
Message-Id: <20080904013743.0ecc9ec5.akpm@linux-foundation.org>
In-Reply-To: <20080904012544.cabed847.akpm@linux-foundation.org>
References: <20080903191619.6b6b230e.sfr@canb.auug.org.au>
	<20080903214634.ea17ff53.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809032201510.3378@nehalem.linux-foundation.org>
	<20080903223318.84b6ce8b.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0809040045190.3378@nehalem.linux-foundation.org>
	<20080904012544.cabed847.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2008 01:25:44 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> can't complain about that, apart from the apparently-bogus "unable to
> apply power".

ooh look, I fixed something:

--- a/drivers/pcmcia/cs.c~a
+++ a/drivers/pcmcia/cs.c
@@ -477,6 +477,8 @@ static int socket_setup(struct pcmcia_so
 	 */
 	msleep(vcc_settle * 10);
 
+	msleep(100);
+
 	skt->ops->get_status(skt, &status);
 	if (!(status & SS_POWERON)) {
 		cs_err(skt, "unable to apply power.\n");
_

we seem not to be giving that card enough settling time.  Or is it
a characteristic of the controller?  

It's a module option, but google(linux "unable to apply power") gets
859 hits.  Maybe the default is too short..


btw, do we really need to spew all this?

pccard: card ejected from slot 0
3c59x 0000:07:00.0: restoring config space at offset 0xf (was 0xffffffff, writing 0x50a0115)
3c59x 0000:07:00.0: restoring config space at offset 0xe (was 0xffffffff, writing 0x0)
3c59x 0000:07:00.0: restoring config space at offset 0xd (was 0xffffffff, writing 0x50)
3c59x 0000:07:00.0: restoring config space at offset 0xc (was 0xffffffff, writing 0x0)
3c59x 0000:07:00.0: restoring config space at offset 0xb (was 0xffffffff, writing 0x5c5710b7)
3c59x 0000:07:00.0: restoring config space at offset 0xa (was 0xffffffff, writing 0x90)
3c59x 0000:07:00.0: restoring config space at offset 0x9 (was 0xffffffff, writing 0x0)
3c59x 0000:07:00.0: restoring config space at offset 0x8 (was 0xffffffff, writing 0x0)
3c59x 0000:07:00.0: restoring config space at offset 0x7 (was 0xffffffff, writing 0x0)
3c59x 0000:07:00.0: restoring config space at offset 0x6 (was 0xffffffff, writing 0x58000080)
3c59x 0000:07:00.0: restoring config space at offset 0x5 (was 0xffffffff, writing 0x58000000)
3c59x 0000:07:00.0: restoring config space at offset 0x4 (was 0xffffffff, writing 0x2401)
3c59x 0000:07:00.0: restoring config space at offset 0x3 (was 0xffffffff, writing 0x4000)
3c59x 0000:07:00.0: restoring config space at offset 0x2 (was 0xffffffff, writing 0x2000010)
3c59x 0000:07:00.0: restoring config space at offset 0x1 (was 0xffffffff, writing 0x2100007)
3c59x 0000:07:00.0: restoring config space at offset 0x0 (was 0xffffffff, writing 0x525710b7)

