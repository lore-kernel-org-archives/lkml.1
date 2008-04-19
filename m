Return-Path: <linux-kernel-owner+w=401wt.eu-S1761594AbYDSDFy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761594AbYDSDFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 23:05:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754181AbYDSDFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 23:05:47 -0400
Received: from web36703.mail.mud.yahoo.com ([209.191.85.37]:30682 "HELO
	web36703.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753847AbYDSDFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 23:05:46 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=Mw2bwrIYOz0fQ7nFsoU+l76sqDB4RRM+efT9LqgBIiwkz6nSxoulwjhEXDOcblylRm6q8+P0i5wecX7I1WFVJTnUb5BkgAMNCw2S2ucPOMub0SULcNKDvr3WXb70/2oIrDXjHeZHo/wjJDgT/ieMKVKljZZU+wCukCceZ2xcnOc=;
X-YMail-OSG: 1US_d1UVM1ni0Jn7GV015YmCgDMQ7xkawozr6hhlFeAmRFb.rFqOtfzGmdfTtSJsqEbeQZv7.Ytwzhh.Klhuoa10xkVjV6K8bW1vgajhR7Bz55PngOdTSKztGg--
Date: Fri, 18 Apr 2008 20:05:45 -0700 (PDT)
From: Alex Dubov <oakad@yahoo.com>
Subject: Re: Smartmedia/xd card support - request for comments
To: joern@logfs.org
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, ben@fluff.org
In-Reply-To: <20080418140054.GA6200@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Message-ID: <259878.79137.qm@web36703.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jörn Engel <joern@logfs.org> wrote:

> On Fri, 18 April 2008 01:47:12 -0700, Alex Dubov wrote:
> > 
> > First, with all the respect to Jorn, alauda driver can only be considered "proof of concept".
> It
> > does not try to abstract any smartmedia functionality.
> 
> "Proof of concept" is the wrong term.  The goal of
> drivers/mtd/nand/alauda.c is to get raw access to the flash.  It
> explicitly does not abstract anything because I don't want the
> abstraction.  I want a raw piece of flash, represented via mtd.  And I
> believe it does match those goals - modulo some bugs.
> 
> You seem to want something else.  I have a rough idea what that might
> be, nothing more.  Can you explain your goals to give us a better idea?

As you understand, both smartmedia media and hosts follow certain spec (publicly available here:
http://www.ssfdc.or.jp/spec/index_e.htm, basic registration required). xd card spec is almost
identical, adding some cosmetic features and restrictions (such as prohibition of single page
programming). This means, that smartmedia access protocol can be abstracted out in the
reader-independent way. You can seen in the xd_card_blk.c that it can operate both completely dumb
controllers, while taking protocol shortcuts (using host->caps) to accommodate smarter readers
(the only feature currently not there is adapter-side page copy - it can be easily added under
FBD_COPY clause in xd_card_trans_req). The backend itself (jmb38x_xd.c) should not concern itself
with details of smartmedia spec, as it will directly lead to code duplication among backends.
> 
> > No infrastructure exists for exporting and manipulation of metadata in userspace.
> 
> When using the raw mtd, it does.  After block device translation, it
> doesn't.

I meant here the ability of user to look and modify CIS page, as well as look at the current block
translation table.

> 
> Correct.  Erase() is the only callback-based function and every single
> driver implements it synchronous anyway.  Improving this situation is
> needed for mtd's own sake anyway.  Either that or replacing mtd with
> something else, likely the block device code.

Revamping the underlying architecture of mtd will break a lot of stuff in the process, doesn't it?

> > In case somebody is actually interested in looking at the code:
> > 
> > http://svn.berlios.de/wsvn/tifmxx/trunk/driver/#_trunk_driver_
> 
> Sure am.  You should use explicitly sized types in most of your data
> structures, like here:
> struct xd_card_extra {
>         unsigned int   reserved;
>         unsigned char  data_status;
>         unsigned char  block_status;
>         unsigned short addr1;
>         unsigned char  ecc_hi[3];
>         unsigned short addr2; /* this should be identical to addr1 */
>         unsigned char  ecc_lo[3];
> } __attribute__((packed));
> 
> And if you want to be pre-flamed, running things through checkpatch.pl
> lets you take the pain early.
> 

I was not moving to submit just yet. As it's not my first submission, I "prefetched" some time for
an usual flame war.



      ____________________________________________________________________________________
Be a better friend, newshound, and 
know-it-all with Yahoo! Mobile.  Try it now.  http://mobile.yahoo.com/;_ylt=Ahu06i62sR8HDtDypao8Wcj9tAcJ
