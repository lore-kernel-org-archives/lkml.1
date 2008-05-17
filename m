Return-Path: <linux-kernel-owner+w=401wt.eu-S1760465AbYEQVPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760465AbYEQVPj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 17:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759447AbYEQVPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 17:15:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.179]:65423 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799AbYEQVP3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 17:15:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH, RFC] char dev BKL pushdown
Date: Sat, 17 May 2008 23:15:00 +0200
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
References: <16082.1210952646@vena.lwn.net>
In-Reply-To: <16082.1210952646@vena.lwn.net>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200805172315.02988.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/ZtLwPQKW9O6l7fucEBKY6A43A3miSTwb998l
 /KVSA2wpk/qfFDanYRtXJj0SWrelidx7+5rMgpRvoOPn3myCKP
 sBWs4W3LLaTR3LWRB3pWQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 16 May 2008, Jonathan Corbet wrote:

> ...and so that's what I've done.  My approach was to find every
> register_chrdev() and cdev_add() call, look at the associated
> file_operations, then go back to the open() function, if any.

Note that the majority of drivers use (grep suggests up to 165
of them) uses misc_register instead of register_chrdev/cdev_add.
Your patches are still correct, because you pushed the BKL into the
misc_open function, but there is an obvious next step in pushing
it further into the misc drivers.
There are probably a few more subsystems with minor number specific
open() functions, misc is just the obvious one.

> > ...and so that's what I've done.  My approach was to find every 
> register_chrdev() and cdev_add() call, look at the associated
> file_operations, then go back to the open() function, if any.  Unless it
> was almost immediately obvious to me that the function was either (1) so
> trivial as to not require locking (quite few of them are "return 0;"), or
> (2) clearly doing its own locking, I wrapped the code in the BKL.
> 
> Finally, I removed the BKL from chrdev_open().

In your current git tree, this change is no longer the final one, so
bisecting the series may cause other bugs. You should probably reorder
the patches at some point to avoid this.

	Arnd <><
