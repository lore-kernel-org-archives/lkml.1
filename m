Return-Path: <linux-kernel-owner+w=401wt.eu-S1755081AbYJXJgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbYJXJgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 05:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbYJXJg0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 05:36:26 -0400
Received: from web23506.mail.ird.yahoo.com ([87.248.115.34]:47960 "HELO
	web23506.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751991AbYJXJgZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 05:36:25 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=00CL8tn5w+6MEObHyULscb+RKvHqxANkB68CDfmgCSgH4r6yAyQMarcwTTw236tvKEzHEkWDGheKRuEjaSSgU8oW6YcX4mo1clMdreCijgV4+gTJtRsP8zptOhZiFIBFuPLuxcN0klueX+cGEKcIWJKHiPXp1xI7IVStH2sOHfg=;
X-YMail-OSG: E6BpdS4VM1lO1sPYSGqgwlEhG.Fmwst_Q9r9YQZqkWx5R38bilTRWCK6EE_pTEIt5UcyTkpqATm1s8TQHOZdq.sEupOyZNoyGpfMmJaOIXdzJJedQxouHEl6py4wcGPYMbZ.Mo0QtaBx56.19F1g9zqqMR7uIGKZSeuYnNE2r8zbSg--
X-Mailer: YahooMailWebService/0.7.247.3
Date: Fri, 24 Oct 2008 09:29:42 +0000 (GMT)
From: Michael Trimarchi <trimarchimichael@yahoo.it>
Reply-To: trimarchimichael@yahoo.it
Subject: MigoR and Scif Serial
To: Paul Mundt <lethal@linux-sh.org>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
       Michael Trimarchi <trimarchi@gandalf.sssup.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <800596.6344.qm@web23506.mail.ird.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I find some problem in MigoR board using scif serial device and console too.

Looking at the setup-Sh7722.c, the platform sci port data has the irqs
line equal to one interrupt. In the driver this line is multiplexed and
using for manage all the interrupt (error, transmit, receive, etc...) but
the sci_mpxed_interrupt check the wrong status for interrupt and break 
error. They are on a single bit. So modify the code like this, resolve
the issue.

 /* Error Interrupt */
 if ((ssr_status & 0x0080) && (scr_status & 0x08)) <-----
      sci_er_interrupt(irq, ptr);
 /* Break Interrupt */
 if ((ssr_status & 0x0010) && (scr_status & 0x08)) <-----
      sci_br_interrupt(irq, ptr);

Is there any reasons to multiplex the serial interrupt on sh7722?

Another question is:

It is correct to implement the tx_empty like this?

static unsigned int sci_tx_empty(struct uart_port *port)
{
        unsigned int ret = TIOCSER_TEMT;

        /* Detect for scif device */
        if (port->type == PORT_SCIF) {
                if (scif_txroom(port) == SCIF_TXROOM_MAX)
                        ret = TIOCSER_TEMT;
                else
                        ret = 0;
        }
        return ret;         
}

Regards Michael





      Scopri il blog di Yahoo! Mail:
Trucchi, novità e scrivi la tua opinione.
http://www.ymailblogit.com/blog
