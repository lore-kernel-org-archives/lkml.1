Return-Path: <linux-kernel-owner+w=401wt.eu-S1752117AbZGWB60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbZGWB60 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 21:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751206AbZGWB6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 21:58:25 -0400
Received: from nschwqsrv01p.mx.bigpond.com ([61.9.189.231]:62578 "EHLO
	nschwqsrv01p.mx.bigpond.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193AbZGWB6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 21:58:24 -0400
Date: Thu, 23 Jul 2009 10:19:39 +0930
From: Alan Modra <amodra@bigpond.net.au>
To: Matthias Klose <doko@ubuntu.com>
Cc: binutils <binutils@sourceware.org>, Bastian Blank <waldi@debian.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Kiko Piris <kernel@pirispons.net>,
       Damien Wyart <damien.wyart@free.fr>, Greg KH <gregkh@suse.de>,
       Wolfgang Walter <wolfgang.walter@stwm.de>
Subject: Re: current binutils trunk fails to build bootable kernel image
	for some configurations
Message-ID: <20090723004939.GF13233@bubble.grove.modra.org>
Mail-Followup-To: Matthias Klose <doko@ubuntu.com>,
	binutils <binutils@sourceware.org>,
	Bastian Blank <waldi@debian.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Kiko Piris <kernel@pirispons.net>,
	Damien Wyart <damien.wyart@free.fr>, Greg KH <gregkh@suse.de>,
	Wolfgang Walter <wolfgang.walter@stwm.de>
References: <4A6746B9.9010603@ubuntu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090721204214.GA27015@wavehammer.waldi.eu.org> <4A6746B9.9010603@ubuntu.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-RPD-ScanID: Class unknown; VirusThreatLevel unknown, RefID str=0001.0A150201.4A67B3A4.0007,ss=1,fgs=0
X-SIH-MSG-ID: qhs6EN35TAD0zmRy0WWwOwRzyFrsq3B48Z4QWs1mqRMGT0XduMfOJ5LmY9kEnZ7k1y5MNhCBN2skY7zmXY/YiA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 01:04:57PM -0400, Matthias Klose wrote:
> this was reported as http://bugs.debian.org/537389, I currently don't 
> have much more information, besides that one of the Debian kernel 
> maintainers did identify
>
> 2009-07-11  Alan Modra  <amodra@bigpond.net.au>
>
>         * ldlang.c (insert_os_after): Don't tie assignments to non-alloc
>         output sections.
>
> this patch as the one causing the wrongly built kernel. However I don't 
> see this checkin mentioned on the ML.

The discussion happened on bug-binutils.
http://lists.gnu.org/archive/html/bug-binutils/2009-07/msg00067.html

> Bastian Blank did check that the 
> problem goes away with a binutils build from trunk and this patch 
> reverted. Some more analysis in http://lkml.org/lkml/2009/7/21/400

The biggest problem is that the kernel linker script doesn't mention
all sections, which means ld must choose a place for the unmentioned
sections (orphans).  Sometimes ld's placement isn't how a naive
programmer would expect.

In this case:

  . = ALIGN(PAGE_SIZE);
  .data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {

ld stuck an orphan section between the two statements.  Which meant
that the start of .data_nosave is not aligned (and since the end is
aligned by following statements, it means that .data_nosave also has
padding inserted).  It would be more robust to write:

  .data_nosave ALIGN(PAGE_SIZE) : AT(ADDR(.data_nosave) - LOAD_OFFSET) {

-- 
Alan Modra
Australia Development Lab, IBM
