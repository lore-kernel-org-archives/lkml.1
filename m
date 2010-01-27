Return-Path: <linux-kernel-owner+w=401wt.eu-S1755109Ab0A0OJK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755109Ab0A0OJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jan 2010 09:09:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755088Ab0A0OJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jan 2010 09:09:07 -0500
Received: from mail.perches.com ([173.55.12.10]:1500 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755078Ab0A0OJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jan 2010 09:09:03 -0500
Subject: Re: + drivers-block-floppyc-use-pr_level.patch added to -mm tree
From: Joe Perches <joe@perches.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mm-commits@vger.kernel.org, bzolnier@gmail.com, jens.axboe@oracle.com,
       marcin.slusarz@gmail.com, shemminger@vyatta.com
In-Reply-To: <4B600806.4010003@gmail.com>
References: <201001270037.o0R0bN6S032517@imap1.linux-foundation.org>
	 <4B600806.4010003@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Jan 2010 06:09:00 -0800
Message-ID: <1264601340.14552.55.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-01-27 at 10:31 +0100, Jiri Slaby wrote:
> On 01/27/2010 01:37 AM, akpm@linux-foundation.org wrote:
> > @@ -687,9 +687,7 @@ static void __reschedule_timeout(int dri
> >  		fd_timeout.expires = jiffies + UDP->timeout;
> >  	add_timer(&fd_timeout);
> >  	if (UDP->flags & FD_DEBUG) {
> > -		DPRINT("reschedule timeout ");
> > -		printk(message, marg);
> > -		printk("\n");
> > +		DPRINT("reschedule timeout %s %d\n", message, marg);
> 
> This is wrong.

I disagree.

It does add an always output decimal value to the DPRINT
instead of a mostly mismatched format and argument
	printk(message, marg).

Previous single matched output use of message/marg:

-	reschedule_timeout(MAXTIMEOUT, "request done %d", uptodate);
+	reschedule_timeout(MAXTIMEOUT, "request done", uptodate);

vs now:

$ grep reschedule_timeout drivers/block/floppy.c
static void __reschedule_timeout(int drive, const char *message, int marg)
static void reschedule_timeout(int drive, const char *message, int marg)
	__reschedule_timeout(drive, message, marg);
	__reschedule_timeout(drive, "lock fdc", 0);
	reschedule_timeout(current_reqD, "floppy start", 0);
	reschedule_timeout(MAXTIMEOUT, "do wakeup", 0);
	reschedule_timeout(MAXTIMEOUT, "request done", uptodate);
		reschedule_timeout(current_reqD, "redo fd request", 0);
	reschedule_timeout(MAXTIMEOUT, "floppy init", MAXTIMEOUT);

Arguably, that single use could be something like:

	char msg_buf[sizeof("request done ") + 20];
	snprintf(msg_buf, sizeof(msg_buf), "request_done %d", uptodate);
	reschedule_timeout(MAXTIMEOUT, msg_buf);

(uptodate should be 0, 1 or 2)

with the now unused marg argument removed from
reschedule_timeout and __reschedule_timeout.

