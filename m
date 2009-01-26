Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbZAZVv6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbZAZVv6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 16:51:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752471AbZAZVvu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 16:51:50 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:50950 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbZAZVvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 16:51:49 -0500
Date: Mon, 26 Jan 2009 13:47:49 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, sgrubb@redhat.com, esandeen@redhat.com,
       sukadev@us.ibm.com, alan@lxorguk.ukuu.org.uk
Subject: Re: tty: tty_open can return to userspace holding tty_mutex
Message-ID: <20090126214748.GA6876@us.ibm.com>
References: <1233003761.9850.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1233003761.9850.14.camel@localhost.localdomain>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris [eparis@redhat.com] wrote:
| __tty_open could return (to userspace) holding the tty_mutex thanks to a
| regression introduced by 4a2b5fddd53b80efcb3266ee36e23b8de28e761a.  This was
| found by bisecting an fsfuzzer problem.  Admittedly I have no idea how it
| managed to tickle this 100% reliably, but it is clearly a regression and
| when hit leaves the box in a completely unusable state.  This patch lets
| the fsfuzzer test complete every time.

Good catch.


|     
| Signed-off-by: Eric Paris <eparis@redhat.com>

Acked-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>

| 
| ---
|  drivers/char/tty_io.c |    4 +++-
|  1 files changed, 3 insertions(+), 1 deletions(-)
| 
| diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
| index d33e5ab..bc84e12 100644
| --- a/drivers/char/tty_io.c
| +++ b/drivers/char/tty_io.c
| @@ -1817,8 +1817,10 @@ got_driver:
|  		/* check whether we're reopening an existing tty */
|  		tty = tty_driver_lookup_tty(driver, inode, index);
| 
| -		if (IS_ERR(tty))
| +		if (IS_ERR(tty)) {
| +			mutex_unlock(&tty_mutex);
|  			return PTR_ERR(tty);
| +		}
|  	}
| 
|  	if (tty) {
| 
