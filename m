Return-Path: <linux-kernel-owner+w=401wt.eu-S1758629AbXETUzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758629AbXETUzQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 16:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756351AbXETUzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 16:55:04 -0400
Received: from keetweej.vanheusden.com ([213.84.46.114]:49595 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756325AbXETUzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 16:55:01 -0400
Date: Sun, 20 May 2007 22:55:00 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Eric Dumazet <dada1@cosmosbay.com>, Andi Kleen <ak@suse.de>,
       Rik van Riel <riel@redhat.com>, righiandr@users.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: signals logged / [RFC] log out-of-virtual-memory events
Message-ID: <20070520205500.GJ22452@vanheusden.com>
References: <464C9D82.60105@redhat.com> <Pine.LNX.4.61.0705180825280.3231@yvahk01.tjqt.qr> <200705181347.14256.ak@suse.de> <Pine.LNX.4.61.0705190946430.9015@yvahk01.tjqt.qr> <20070520001418.GJ14578@vanheusden.com> <464FC6AA.2060805@cosmosbay.com> <20070520112111.GN14578@vanheusden.com> <20070520090809.4f42d71d@freepuppy> <20070520161159.GD22452@vanheusden.com> <Pine.LNX.4.61.0705202235430.13923@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Pine.LNX.4.61.0705202235430.13923@yvahk01.tjqt.qr>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Reply-By: Mon May 21 15:25:37 CEST 2007
X-Message-Flag: Want to extend your PGP web-of-trust? Coordinate a key-signing at www.biglumber.com
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> >> >  
> >> > +	if (unlikely(sig == SIGQUIT || sig == SIGILL  || sig == SIGTRAP ||
> >> > +	    sig == SIGABRT || sig == SIGBUS  || sig == SIGFPE  ||
> >> > +	    sig == SIGSEGV || sig == SIGXCPU || sig == SIGXFSZ ||
> >> > +	    sig == SIGSYS  || sig == SIGSTKFLT))
> >> > +	{
> >> > +		printk(KERN_WARNING "Sig %d send to %d owned by %d.%d (%s)\n",
> >> > +			sig, t->pid, t->uid, t->gid, t->comm);
> >> > +	}
> >> > +
> >> >  	/*
> >> >  	 * fast-pathed signals for kernel-internal things like SIGSTOP
> >> >  	 * or SIGKILL.
> >> Would turning that into a switch() generate better code.
> Yes, this time.
> 
> >Doubt it: in the worst case you still nee to check for each possibility.
> >Furthermore a.f.a.i.k. with switch you cannot do 'unlinkely()'.
> 
> With if(), it generates a ton of "CMP, JE" instructions.
> With switch(), I would assume gcc transforms it into using
> a jump table (aka "JMP [table+sig]")
> I tried it: with switch(), gcc transforms this into a
> bitmap comparison ("MOV eax, 1; SHL eax, sig; TEST eax, 0x830109f8"),
> which seems even cheaper than a jump table.

Ok, here's the new patch against 2.6.21.1:

Signed-off by Folkert van Heusden <folkert@vanheusden.com>

--- kernel/signal.c.org	2007-05-20 22:47:13.000000000 +0200
+++ kernel/signal.c	2007-05-20 22:54:17.000000000 +0200
@@ -739,6 +739,25 @@
 	struct sigqueue * q = NULL;
 	int ret = 0;
 
+	/* emit some logging for nasty signals
+	 * especially SIGSEGV and friends aught to be looked at when happening
+	 */
+	switch(sig) {
+	case SIGQUIT: 
+	case SIGILL: 
+	case SIGTRAP:
+	case SIGABRT: 
+	case SIGBUS: 
+	case SIGFPE:
+	case SIGSEGV: 
+	case SIGXCPU: 
+	case SIGXFSZ:
+	case SIGSYS: 
+	case SIGSTKFLT:
+		printk(KERN_WARNING "Sig %d send to %d owned by %d.%d (%s)\n",
+			sig, t -> pid, t -> uid, t -> gid, t -> comm);
+	}
+
 	/*
 	 * fast-pathed signals for kernel-internal things like SIGSTOP
 	 * or SIGKILL.

Folkert van Heusden

-- 
MultiTail è uno flexible tool per seguire di logfiles e effettuazione
di commissioni. Feltrare, provedere da colore, merge, 'diff-view',
etc. http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
