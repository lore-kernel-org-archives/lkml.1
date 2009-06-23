Return-Path: <linux-kernel-owner+w=401wt.eu-S1757585AbZFWWHo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757585AbZFWWHo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 18:07:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751888AbZFWWHg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 18:07:36 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63872 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbZFWWHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 18:07:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 05/17] Blackfin: convert to generic checksum code
Date: Wed, 24 Jun 2009 00:06:09 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-9-generic; KDE/4.2.90; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
       Michal Simek <monstr@monstr.eu>, Paul Mundt <lethal@linux-sh.org>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org> <200906232314.18261.arnd@arndb.de> <8bd0f97a0906231453m308dc972mdf624545794f398e@mail.gmail.com>
In-Reply-To: <8bd0f97a0906231453m308dc972mdf624545794f398e@mail.gmail.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200906240006.10881.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18QtDl9K4A2lh2WF1ySkyTSXE5G731ek8g+wYk
 UPZLSdFtWldbjh2zahEiahj7YvPEqKBjly1qzwx1a5mieZuyyj
 ymEGA9HaEvV8haDxmgtDA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 June 2009, Mike Frysinger wrote:
> and this is an internal tester ... if we're going to let arches
> override it, then its function signature are pretty much set in stone.
> i agree we should test every checksum function, but i think only
> testing do_csum indirectly would be detrimental to the people who
> would want to use this -- arch maintainers looking to implement
> do_csum() themselves.  otherwise they need to step through the
> surrounding functions a bit to find the exact values given to
> do_csum() and the exact value expected back such that the calling
> function still works.  and every arch guy is going to do this same
> thing.

It depends on how we want to use it. If it's only for testing architecture
that have moved to the generic checksum code, that's fine. I was
thinking we could also use it for architectures that want to keep
their own code, but we don't have to.

> i'm a bit of a nub here wrt checksuming.  the test module i came up
> with by simply flooding my board and copying & pasting mismatched
> buffers ;).  are you saying the following should be OK ?
> -    if (tret != do_csum_data[i].ret) {
> +    if (tret != le16_to_cpu(do_csum_data[i].ret)) {

yes, that should work.

> unless there is a macro i could use that'd do the expansion at CPP
> time so i'd write the test data as:
> static struct do_csum_data __initdata do_csum_data[] = {
>         DO_CSUM_DATA(1, le16_to_cpu(0x0020)),
> ...

Ah, right that won't. I tested only on x86 (little-endian), so
le16_to_cpu() is an identity function that can be evaluated for
constants, but on big-endian that would break.

	Arnd <><
