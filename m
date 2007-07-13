Return-Path: <linux-kernel-owner+w=401wt.eu-S935778AbXGMOcN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935778AbXGMOcN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 10:32:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759790AbXGMOb6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 10:31:58 -0400
Received: from web26902.mail.ukl.yahoo.com ([217.146.176.91]:32268 "HELO
	web26902.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754513AbXGMOb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 10:31:57 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Fri, 13 Jul 2007 10:31:56 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.fr;
  h=X-YMail-OSG:Received:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=ShgGujNsJIXZvozAALuhUtY+XcX89kneCCChfYvXBqVOfz+d159psJi6jGLqBSGzUkSq+6Oo77j3F1BIcCk+AN7XDdYYjrQpOaYNPRbBRPfaUHn8XcBjh8fSC6ef3gf4xdkLwgbareU71MDdxNMJKFNvFB2UjitjkuMU1Sox19U=;
X-YMail-OSG: dwNJiDQVM1mu9uOnBfVXC2_xXNKAFBrlhxvi1gCJiPwYcMvAxUwi7_b1.tqP8ndNPAJwJ9uGEN6qFTU347.CY94.DTzKBxUVL3ASN1gFSUVcJlZZ
Date: Fri, 13 Jul 2007 16:25:16 +0200 (CEST)
From: Etienne Lorrain <etienne_lorrain@yahoo.fr>
Subject: Re: x86 setup code rewrite in C - revised
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <526073.18540.qm@web26902.mail.ukl.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jul 2007, Linus Torvalds wrote:
> On Thu, 12 Jul 2007, Andrew Morton wrote:
> > 
> > This code has been in -mm since 11 May, as git-newsetup.patch.  It has
> > caused (for what it is) astonishingly few problems.  Maybe a couple of
> > build glitches and one runtime failure, all quickly fixed.
> > 
> > I'd say it's ready.
> 
> Ok. That makes it easy. I'll just merge it.
> 
> 		Linus

 Have fun, this code:
 - do not open the fast A20 gate before checking if the slow A20 gate is open or closed.
 - uses in asm("") inputs which may or may not be set by the compiler in the stack,
   after modifying the stack pointer in the asm block: at least has_eflag()
 - The VGA recalc has the same bug as the assembly version where a VGA write protected
   register is written (Overflow register) without setting the enable bit (see VGA docs).
 - Does not save and restore %ds when printing a char on the screen (%ds is destroyed
   only when the content of the screen scroll - only for some video cards)
 - Has a "dn" for outl() which sliped in instead of "dN"
 and probably few other problems - just seen those by reading the patches (the asm("")
 are inlined in the C code - I find it more difficult to check).

 Also, I do not know if "m" is right in here:
static inline u8 rdfs8(addr_t addr)
{
	u8 v;
	asm("movb %%fs:%1,%0" : "=r" (v) : "m" (*(u8 *)addr));
	return v;
}

  I may repeat me, but to find these kind of problems, it is very nice to have an ELF
 file to do a readelf/objdump -D -m i8086 (even after final link).

  Etienne.
http://gujin.org

I like that message in this context...
   http://marc.info/?l=linux-kernel&m=117077712515509&w=4


      _____________________________________________________________________________ 
Ne gardez plus qu'une seule adresse mail ! Copiez vos mails vers Yahoo! Mail 
