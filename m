Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbXJHK0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbXJHK0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 06:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752917AbXJHK0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 06:26:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:45010 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735AbXJHK0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 06:26:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:x-enigmail-version:content-type:content-transfer-encoding;
        b=V2cpkrRZ6ii4i8BX6/TfM5Lxq5PtS4ffsCP157/fYi7WzM0AJ8Jo83pdcZQaZYY/1yEVi0Jgx1vQ3qNb1mJx6pTfKgB8SM0BMr9EnWuV+6ua0l739of+3/r1POXJ4DwgBDPC+ODeWDhLyj19C+zKxL7AzDYfLFIR319parMyiOE=
Message-ID: <470A05DF.5080405@gmail.com>
Date: Mon, 08 Oct 2007 12:26:39 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Paul Hardwick <p.hardwick@option.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: nozomi: ERESTARTSYS to userspace?
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

static int ntty_write(struct tty_struct *tty, const unsigned char *buffer,
                      int count)
{
        int rval = -EINVAL;
        struct nozomi *dc = get_dc_by_tty(tty);
        struct port *port = (struct port *)tty->driver_data;
        unsigned long flags;

        /* DBG1( "WRITEx: %d, index = %d", count, index); */

        if (!dc || !port)
                return -ENODEV;

        if (unlikely(down_trylock(&port->tty_sem))) {
                /*
                 * must test lock as tty layer wraps calls
                 * to this function with BKL
                 */
                dev_err(&dc->pdev->dev, "Would have deadlocked - "
                        "return ERESTARTSYS\n");
                return -ERESTARTSYS;
        }

The use of ERESTARTSYS seems bogus to me, no signal is pending and this flag
would reach userspace (that is not permitted), am I right?

--js
