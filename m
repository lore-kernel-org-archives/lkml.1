Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab0BUTVe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 14:21:34 -0500
Received: from 81-174-11-161.static.ngi.it ([81.174.11.161]:34160 "EHLO
	mail.enneenne.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab0BUTVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 14:21:31 -0500
Date: Sun, 21 Feb 2010 20:21:01 +0100
From: Rodolfo Giometti <giometti@enneenne.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
       Dave Jones <davej@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
       Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
       Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Christoph Hellwig <hch@infradead.org>,
       Alexander Gordeev <lasaine@lvk.cs.msu.su>
Message-ID: <20100221192101.GF21778@enneenne.com>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
	Dave Jones <davej@redhat.com>, Sam Ravnborg <sam@ravnborg.org>,
	Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>,
	Kay Sievers <kay.sievers@vrfy.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	"H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
	Michael Kerrisk <mtk.manpages@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Alexander Gordeev <lasaine@lvk.cs.msu.su>
References: <1266313885-1195-1-git-send-email-giometti@linux.it>
 <1266313885-1195-2-git-send-email-giometti@linux.it>
 <1266313885-1195-3-git-send-email-giometti@linux.it>
 <1266313885-1195-4-git-send-email-giometti@linux.it>
 <1266313885-1195-5-git-send-email-giometti@linux.it>
 <1266313885-1195-6-git-send-email-giometti@linux.it>
 <1266313885-1195-7-git-send-email-giometti@linux.it>
 <20100219135359.a5c195ea.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100219135359.a5c195ea.akpm@linux-foundation.org>
Organization: GNU/Linux Device Drivers, Embedded Systems and Courses
X-PGP-Key: gpg --keyserver keyserver.linux.it --recv-keys D25A5633
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 192.168.32.37
X-SA-Exim-Mail-From: giometti@enneenne.com
Subject: Re: [PATCH 6/8] pps: serial clients support.
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on mail.enneenne.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 19, 2010 at 01:53:59PM -0800, Andrew Morton wrote:
> 
> hm.  The n_tty_open/close layering is a bit grubby but I guess we don't
> have a need to create anything more comprehensive at this stage.
> 
> A small stylistic thing: the code's a bit confusing at present because
> the names n_tty_open/n_tty_close are identical to the global functions
> over in n_tty.c.  A user of ctags will be tricked.  Also, the _way_ in
> which these function pointers are called:
> 
> 	ret = n_tty_open(tty);
> 
> make it look like the code is calling
> drivers/char/n_tty.c:n_tty_open().  Except it isn't.
> 
> So I think it's better to do it with
> 
> 	ret = (*n_tty_open)(tty);
> 
> to avoid misleading the reader.
> 
> And perhaps to rename these variables to avoid the duplication with the
> global functions.

It could be acceptable using functions
alias_n_tty_open()/alias_n_tty_close() modifying the code as follow?

diff --git a/drivers/pps/clients/pps-ldisc.c
b/drivers/pps/clients/pps-ldisc.c
index 59e6301..15c4622 100644
--- a/drivers/pps/clients/pps-ldisc.c
+++ b/drivers/pps/clients/pps-ldisc.c
@@ -53,7 +53,7 @@ static void pps_tty_dcd_change(struct tty_struct
*tty, unsigne
                        status ? "assert" : "clear", jiffies, id);
 }
 
-static int (*n_tty_open)(struct tty_struct *tty);
+static int (*alias_n_tty_open)(struct tty_struct *tty);
 
 static int pps_tty_open(struct tty_struct *tty)
 {
@@ -79,7 +79,7 @@ static int pps_tty_open(struct tty_struct *tty)
        tty->disc_data = (void *) ret;
 
        /* Should open N_TTY ldisc too */
-       ret = n_tty_open(tty);
+       ret = alias_n_tty_open(tty);
        if (ret < 0)
                pps_unregister_source((int) tty->disc_data);
 
@@ -88,14 +88,14 @@ static int pps_tty_open(struct tty_struct *tty)
        return 0;
 }
 
-static void (*n_tty_close)(struct tty_struct *tty);
+static void (*alias_n_tty_close)(struct tty_struct *tty);
 
 static void pps_tty_close(struct tty_struct *tty)
 {
        int id = (int) tty->disc_data;
 
        pps_unregister_source(id);
-       n_tty_close(tty);
+       alias_n_tty_close(tty);
 
        pr_info("PPS source #%d removed\n", id);
 }

Ciao,

Rodolfo

-- 

GNU/Linux Solutions                  e-mail: giometti@enneenne.com
Linux Device Driver                          giometti@linux.it
Embedded Systems                     phone:  +39 349 2432127
UNIX programming                     skype:  rodolfo.giometti
Freelance ICT Italia - Consulente ICT Italia - www.consulenti-ict.it
