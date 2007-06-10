Return-Path: <linux-kernel-owner+w=401wt.eu-S1757902AbXFJSeg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757902AbXFJSeg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 14:34:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbXFJSe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 14:34:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.177]:60547 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752637AbXFJSeZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 14:34:25 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?J=C3=B6rn_Engel?= <joern@lazybastard.org>
Subject: Re: [Patch 15/18] fs/logfs/super.c
Date: Sun, 10 Jun 2007 20:33:05 +0200
User-Agent: KMail/1.9.6
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mtd@lists.infradead.org, akpm@osdl.org,
       Sam Ravnborg <sam@ravnborg.org>, John Stoffel <john@stoffel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Jamie Lokier <jamie@shareable.org>,
       Artem Bityutskiy <dedekind@infradead.org>, CaT <cat@zip.com.au>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       David Weinehall <tao@acc.umu.se>, Willy Tarreau <w@1wt.eu>,
       Kyle Moffett <mrmacman_g4@mac.com>, Dongjun Shin <djshin90@gmail.com>,
       Pavel Machek <pavel@ucw.cz>, Bill Davidsen <davidsen@tmr.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Albert Cahalan <acahalan@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Roland Dreier <rdreier@cisco.com>,
       Ondrej Zajicek <santiago@crfreenet.org>,
       Ulisses Furquim <ulissesf@gmail.com>
References: <20070603183845.GA8952@lazybastard.org> <200706101827.50948.arnd@arndb.de> <20070610173828.GA32619@lazybastard.org>
In-Reply-To: <20070610173828.GA32619@lazybastard.org>
X-Face: >j"dOR3XO=^3iw?0`(E1w<L^(+[DJB_w&ik~>Z/&le9!.ok[JrI=S~VlsF~}"P\+jx.GT@=?utf-8?q?=0A=09-oaEG?=,9Ba>v;3>:kcw#yO5?B:l{(Ln.2)=?utf-8?q?=27=7Dfw07+4-=26=5E=7CScOpE=3F=5D=5EXdv=5B/zWkA7=60=25M!DxZ=0A=09?=
 =?utf-8?q?8MJ=2EU5?="hi+2yT(k`PF~Zt;tfT,i,JXf=x@eLP{7B:"GyA\=UnN)
 =?utf-8?q?=26=26qdaA=3A=7D-Y*=7D=3A3YvzV9=0A=09=7E=273a=7E7I=7CWQ=5D?=<50*%U-6Ewmxfzd<JV4tqSh>n/CK_E/ouMU(r?FAQG/ev^JyuX.%(By`"
 =?utf-8?q?L=5F=0A=09H=3Dbj?=)"y7*XOqz|SS"mrZ$`Q_syCd
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200706102033.11211.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/i/J3ygrv35UKigRBX5AymIq8ZnQ98Riu4MKg
 K71r01TN8TcTqVYZ6BNl4dLtmyVNQ4An1h4sm9rTzir/vhMAvK
 pq5Er8TWI3PzVVR1h6Etg==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 10 June 2007, Jörn Engel wrote:
> On Sun, 10 June 2007 18:27:49 +0200, Arnd Bergmann wrote:
> > On Sunday 03 June 2007, Jörn Engel wrote:

> > How about using submit_bio here instead of going to the page cache?
> > That would avoid doubling all the memory consumption here.
> 
> That may make sense, yes.  "May", because there is no simple mapping
> between physical data and logical data.  In ext3, everything is
> block-aligned, usually to 4KiB == PAGE_SIZE.  So the exact same content
> would exists in two pages.  In LogFS, data is compressed and
> byte-aligned.  A bdev page can contain several full objects that after
> uncompression get stored in one page each.

Then maybe the submit_bio logic should only be done for the ->write
path, not for ->read. The data that gets written out should already
be present in the page cache for the files, so there is not much point
having again, while you can see the read path as blockdev readahead:
When you read a physical block that contains a logical block, it's
likely to also contain part of another logical block that is going
to be read in the near future.

This way, you would also get exclusively clean pages in the block
device address_space, which can be easily discarded.

Also, maintaining correct ordering between write requests can be
done easier if you insert the bios directly, instead of waiting
for the lru writeback.

	Arnd <><
