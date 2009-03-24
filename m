Return-Path: <linux-kernel-owner+w=401wt.eu-S1757022AbZCYAwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757022AbZCYAwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 20:52:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757066AbZCYAbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 20:31:04 -0400
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:25431 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757049AbZCYAbB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 20:31:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=XDqJmbyY5tisjO/8+h3wDzy8piximPwgUO+GiXElFCQLbHAtEGV++TT1wbtRgZUTVRUt6tr4r38mjF/YPdkRNt2ei4j6NpGagnKSxvB9w7DXuIhSKq7O3V+3bq9DUY5QRmzUh7XQlbw34EhThhU45Mqfi8A2wBq87ID6j7poej8=  ;
X-YMail-OSG: rmdYaH8VM1n7TmnqqhObMU1xiF2c3X7fZFbLqweY0IhbnAvCcuC5n_fNUxlHVIKiE_VTpvFtoGcqQU5FPWfY7oTUwnRUCOCibqqPnkJhjru6jTZQ5GSznkgv.jviD0FDMJzqpRYlb89zp11d53uJ6EJd
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 0/2] Add support for threaded interrupt handlers - V3
Date: Tue, 24 Mar 2009 16:38:11 -0700
User-Agent: KMail/1.9.10
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Hellwig <hch@infradead.org>,
       Arjan van de Veen <arjan@infradead.org>,
       Jon Masters <jonathan@jonmasters.org>,
       Sven Dietrich <sdietrich@suse.de>
References: <20090323172814.548471871@linutronix.de> <200903241444.44644.david-b@pacbell.net> <alpine.LFD.2.00.0903242252080.29264@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0903242252080.29264@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903241638.11724.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 March 2009, Thomas Gleixner wrote:
> On Tue, 24 Mar 2009, David Brownell wrote:
> > On Monday 23 March 2009, Thomas Gleixner wrote:
> > > I'm still looking into a clean solution for the threaded demultiplex
> > > handler case which was brought up by Dave to allow both the handling
> > > of the demultiplexed devices in the context of the demultiplexer
> > > interrupt thread and the wakeup of separate handler threads. But this
> > > is an orthogonal extension of the existing patch set and does not
> > > change the general design.
> > 
> > No comments on the patch I sent?
> 
> Looked at it briefly, but I still try to figure out what the best
> solution for this will be. As I said I'd like to support both
> variants:
> 
> 1) demux handlers run in the primary interrupt thread context
> 2) demux handlers kick their own handler threads

I have no need for the latter, at least in current systems.
The IRQs are neither frequent nor time-critical, else they'd
not be managed via I2C in the first place ... even high speed
I2C (these mostly use 2.6 Mbit/sec, not 100 Kbit/sec) isn't
as quick as accessing any kind of local PIC.


The simplest case, FWIW, is with chips like the mcp23s08
GPIO expanders, or their I2C siblings:  just one level of
dispatch needed.  The Linux driver for those chips doesn't
yet support its IRQs, primarily because genirq doesn't cope
with such stuff very well yet.  (You might want to think
about something a lot simpler than TWL4030-family PMICs!)


> > Or is that what you meant by "orthogonal"?  Admittedly that
> > patch sort of begs the question about which request_irq()
> > variant should be used for such demuxed IRQs; the "current"
> > assumption is that request_irq() suffices, but that could
> > be improved so the handle_threaded_irq() flow handler could
> > use the action->thread_fn not action->handler.
> 
> I don't want to special case that. See above.

What's a special case though?  If you're serious about
wanting to support more than one case, it's always going
to be possible to call some of them "special".  As in,
"threaded IRQs are a special case in genirq".  That should
not mean they don't get handled.

- Dave
