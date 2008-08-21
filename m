Return-Path: <linux-kernel-owner+w=401wt.eu-S1760091AbYHUPOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760091AbYHUPOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 11:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756184AbYHUPOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 11:14:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52490 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987AbYHUPOh convert rfc822-to-8bit (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 11:14:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Jared Hulbert" <jaredeh@gmail.com>
Subject: Re: [PATCH 04/10] AXFS: axfs_inode.c
Date: Thu, 21 Aug 2008 17:12:26 +0200
User-Agent: KMail/1.9.9
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?utf-8?q?J=C3=B6rn?= Engel" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
References: <48AD00F0.5030403@gmail.com> <200808211417.14425.arnd@arndb.de> <6934efce0808210806r701f2e3bo677d2bd2da78faec@mail.gmail.com>
In-Reply-To: <6934efce0808210806r701f2e3bo677d2bd2da78faec@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808211712.27146.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/O7Ml5bw7VjnCfExrBsbq/fX3FoX/dhEEoQD4
 6WeO3uF/GPw3cQl8+cB+V9Igzsy2N4DAK06ZmmvBy/WpC6BGpJ
 HczXQmkICvhHmC9MVrecQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008, Jared Hulbert wrote:
> > Have you seen any benefit of the rwsem over a simple mutex? I would guess
> > that you can never even get into the situation where you get concurrent
> > readers since I haven't found a single down_read() in your code, only
> > downgrade_write()
> 
> We implemented a rwsem here because you can get concurrent readers.
> My understanding is that downgrade_write() puts the rewem into the
> same state as down_read().  Am I mistaken?

Your interpretation of downgrade_write is correct, but if every thread
always does

down_write();
serialized_code();
downgrade_write();
parallel_code();
up_read();

Then you still won't have any concurrency, because each thread trying
to down_write() will be blocked until the previous one has done its up_read(),
causing parallel_code() to be serialized as well.

In addition to that, I'd still consider it better to use a simple mutex
if parallel_code() is a much faster operation than serialized_code(), as it
is in your case, where only the memcpy is parallel and that is much slower
than the deflate.

	Arnd <><
