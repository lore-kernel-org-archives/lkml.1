Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564AbZGNNWG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbZGNNWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 09:22:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753465AbZGNNWG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 09:22:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61095 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbZGNNWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 09:22:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: access_ok macor
Date: Tue, 14 Jul 2009 15:21:47 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-2-generic; KDE/4.2.96; x86_64; ; )
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>
References: <4A5C8068.6020203@monstr.eu>
In-Reply-To: <4A5C8068.6020203@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907141521.47719.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+Hw97Eejg++3xqJYSTmo/Aw5eWWE0Wr7LzziU
 BMwubBTAmFNLnhdjxex82peiLvdVC8WVrY3q/fq8RFsKdA5eYN
 vJKN4q6L8Vk78KEK61KMw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 14 July 2009, Michal Simek wrote:
> I found that I can setup text base in binutils/ld/emulparam/elf32mb_linux.sh
> 
> The problem which I have is that if I run socketpair, getsockname, getpeername LTP
> tests with invalid salen pointer there are addresses close to 0x0. Microblaze
> has no text there and the sigsegv fault is generated.

This sounds like a classic NULL pointer dereference that is handled correctly
by the kernel. The question is where the address came from.

> This fault could be fixed by changed access_ok macro where I check bottom limit
> at 0x1000 0000 too. After this change the LTP program not failed but I am not sure
> if is the right solution because none arch do it. All archs just check upper limit
> not lower.
> 
> What is the correct solution for it? Moving .text base to 0x0 or is there any other
> elegant solution?

Moving .text is not the right solution, because it only papers over real bugs.
access_ok() is also not the right place to check this, the only purpose it has
is to make sure that the argument is not a valid kernel address but either a
valid user address or possibly invalid address. Also, access_ok() is only used
together with the copy_from/to_user and get/put_user function families. These
need to catch invalid addresses with a fixup table entry in the kernel.

I briefly looked at your implementation but could not find any problems in
this area. Could you use gdb to find out whether the sigsegv happens in the
kernel at all, or in user space?

	Arnd <><
